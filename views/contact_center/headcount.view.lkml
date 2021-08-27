view: headcount {
  derived_table: {
    sql:
      select cast(d.date as date) as date
        ,a.incontact_id as incontact_id
        ,ltrim(rtrim(a.name)) as agent_name
        ,ltrim(rtrim(a.employee_type)) as employee_type
        ,ltrim(rtrim(a.team_type)) as team_type
        ,case
            when lower(a.name) like '%wfm%' then 'Non-Agent'
            when lower(a.name) like '%analy%' then 'Non-Agent'
            when a.name like '%API%' then 'Non-Agent'
            when a.name like 'Administrator%' then 'Non-Agent'
            when t.agent_name is null then 'Non-Agent'
            when t.incontact_id in (2612421, 7173618, 2612594) then 'Non-Agent'
            when t.team_name is not null then ltrim(rtrim(t.team_name))
            end as team_name
        ,ltrim(rtrim(a.supervisor)) as is_supervisor
        ,a.retail as is_retail
        ,case when a.inactive is null then true else false end as is_active
        ,a.inactive as inactive_date
        ,a.hired as hire_date
        ,a.terminated as term_date

      from util.warehouse_date d

        left join customer_care.agent_lkp a
          on a.created::date <= d.date
          and nvl(a.inactive::date,current_date::date) >= d.date

        left join customer_care.team_lead_name t
          on a.incontact_id = t.incontact_id
          and d.date between t.start_date and t.end_date

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
    hidden: yes
    sql: ${TABLE}.agent_name ;;
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
    sql: cast(${TABLE}.date as date) ;;
  }

  dimension: employee_type {
    label: "Employee Type"
    group_label: "* Current Grouping"
    description: "Is agent currently a temp or Purple employee."
    type: string
    sql: ${TABLE}.employee_type ;;
  }

  dimension: hire_date {
    label: "Hire Date"
    type: date
    hidden: yes
    sql: ${TABLE}.hire.date ;;
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

  dimension: team_group {
    label: "Team Group"
    group_label: "* Current Grouping"
    description: "The current Team Group for each agent."
    type: string
    sql: case when lower(${team_type}) in ('admin', 'wfm') then 'Admin'
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

  ##########################################################################################
  ##########################################################################################
  ## ID FIELDS

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: concat(${TABLE}.date, ${TABLE}.incontact_id) ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    group_label: "* IDs"
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: headcount {
    label: "Headcount"
    type: count_distinct
    drill_fields: [agent_data*]
    sql: ${incontact_id} ;;
  }
}
