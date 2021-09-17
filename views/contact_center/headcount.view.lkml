view: headcount {
  ## Provides headcount of agents and supervisors which can be broken out by various characteristics
  ## such as team_lead, employement_type, etc.

  derived_table: {
    sql:
      select concat(d.date::date, a.incontact_id) as pk
        ,d.date::date as date
        ,a.incontact_id as incontact_id
        ,ltrim(rtrim(a.name)) as agent_name
        ,ltrim(rtrim(a.employee_type)) as employee_type
        ,ltrim(rtrim(a.team_type)) as team_type
        ,case
            when employee_type is null and team_name is null then 'Other'
            //when lower(a.name) like '%analy%' then 'Non-Agent'
            // when a.name like '%API%' then 'Non-Agent'
            //when a.name like 'Administrator%' then 'Non-Agent'
            //when t.agent_name is null then 'Non-Agent'
            //when t.incontact_id in (2612421, 7173618, 2612594) then 'Non-Agent'
            when t.team_name is not null then ltrim(rtrim(t.team_name))
            end as team_name
        ,to_boolean(trim(rtrim(a.supervisor))) as is_supervisor
        ,to_boolean(a.retail) as is_retail
        ,to_boolean(case when a.inactive is null then true else false end) as is_active
        ,a.inactive::date as inactive_date
        ,a.hired::date as hire_date
        ,a.terminated::date as term_date
        ,a.created::date as created_date

      from util.warehouse_date d

        left join customer_care.agent_lkp a
          on a.created::date <= d.date
          and nvl(a.inactive::date,current_date::date) >= d.date

        left join customer_care.team_lead_name t
          on a.incontact_id = t.incontact_id
          and d.date between t.start_date::date and t.end_date::date

      where d.date between '2019-01-01' and current_date
    ;;
  }

  set: agent_data {
    fields: [agent_name, incontact_id, team_group, team_type, team_name, employee_type]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL FIELDS

  dimension: agent_name {
    # hidden: yes
    sql: ${TABLE}.agent_name ;;
  }

  dimension: created_date {
    label: "Created Date"
    description: "Date the agent's InContact ID was created."
    # hidden: yes
    sql: ${TABLE}.created_date ;;
  }

  dimension_group: date {
    label: "* Headcount" ## Date
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
  }

  dimension: employee_type {
    label: "Employee Type"
    group_label: "* Current Grouping"
    description: "Is agent currently a temp or Purple employee."
    type: string
    sql: ${TABLE}.employee_type ;;
  }

  dimension_group: end {
    label: "* End Date"
    description: "Returns lesser value between term  and inactive dates."
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: case when ${term_date} is null then ${inactive_date}
      else ${term_date} end ;;
  }

  dimension: hire_date {
    label: "Hired"
    type: date
    # hidden: yes
    sql: ${TABLE}.hire_date::date ;;
  }

  dimension: inactive_date {
    label: "Inactive Date"
    description: "Date the agent's InContact ID was made inactive."
    # hidden: yes
    sql: ${TABLE}.inactive_date ;;
  }

  dimension: is_active {
    label: "Is Active"
    group_label: "* Flags"
    description: "Is the agent currently an active agent (not disabled)."
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_retail {
    label: "Is Retail"
    group_label: "* Flags"
    description: "Does agent currently work in a retail location."
    type: yesno
    sql: ${TABLE}.is_retail ;;
  }

  dimension: is_supervisor {
    label: "Is Supervisor"
    group_label: "* Flags"
    description: "Is agent currently a supervisor."
    type: yesno
    sql: ${TABLE}.is_supervisor ;;
  }

  dimension: last_update{
    label: "Last Update"
    description: "Last date when a record was updated in the agent_lkp table."
    type: date
    sql: select max(update_ts) from customer_care.agent_lkp ;;
  }

  dimension: start_date {
    label: "Start Date"
    description: "Returns greater value between created and hire dates."
    type: date
    # hidden: yes
    sql: case when ${hire_date} is not null then ${created_date}
      else ${hire_date} end ;;
  }

  dimension: team_group {
    label: "Team Group"
    group_label: "* Current Grouping"
    description: "The current Team Group for each agent."
    type: string
    sql: case when lower(${team_type}) in ('admin', 'wfm', 'QA') then 'Admin'
      when ${team_type} is null then 'Other'
      when lower(${team_type}) in ('training', 'sales')
        or ${team_type} is null then ${team_type}
      else 'Customer Care' end ;;
  }

  dimension: team_name {
    label: "Team Lead Name"
    group_label: "* Current Grouping"
    description: "Current Team Lead's name on given date."
    type: string
    sql: ltrim(rtrim(${TABLE}.team_name)) ;;
  }

  dimension: team_name_historic {
    label: "Team Lead Name (H)"
    group_label: "* Historic Grouping"
    description: "Historic Team Lead's name on given date."
    type: string
    sql: ltrim(rtrim(${TABLE}.team_name_historic)) ;;
  }

  dimension: team_type {
    label: "Team Type"
    group_label: "* Current Grouping"
    description: "Current team type."
    type: string
    sql: ltrim(rtrim(${TABLE}.team_type)) ;;
  }

  dimension: term_date {
    label: "Termed"
    description: "Last day of employment at Purple."
    type: date
    # hidden: yes
    sql: ${TABLE}.term_date::date ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## ID FIELDS

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.pk ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: headcount {
    label: "Headcount"
    type: count_distinct
    sql: case when ${start_date} > ${date_date} then null
      when ${end_date} is null then ${incontact_id}
      when ${end_date} >= ${date_date} then ${incontact_id} end ;;
    drill_fields: [agent_data*, is_supervisor]
    link: {
      label: "View Headcount Detail"
      url: "https://purple.looker.com/looks/5760"
    }
  }

  measure: hired_count {
    label: "Hired Count"
    type: count_distinct
    sql: case when ${date_date} = ${start_date} then ${incontact_id} else null end ;;
    drill_fields: [agent_data*, start_date, is_supervisor]
    link: {
      label: "View Headcount Detail"
      url: "https://purple.looker.com/looks/5760"
    }
  }

  measure: term_count {
    label: "Termed Count"
    type: count_distinct
    sql: case when ${date_date} = ${end_date} then ${incontact_id} end ;;
    drill_fields: [agent_data*, end_date, is_supervisor]
    link: {
      label: "View Headcount Detail"
      url: "https://purple.looker.com/looks/5760"
    }
  }


}
