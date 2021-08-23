view: headcount {
  derived_table: {
    sql:
      select cast(d.date as date) as date
        ,a.incontact_id as incontact_id
        ,a.name as agent_name
        ,a.employee_type
        ,a.team_type as team_type
        ,case when c.team_name is not null then c.team_name
            when lower(a.name) like '%wfm%' then 'Non-Agent'
            when lower(a.name) like '%analy%' then 'Non-Agent'
            when a.name like '%API%' then 'Non-Agent'
            when a.name like 'Administrator%' then 'Non-Agent'
            when c.agent_name is null then 'Non-Agent'
            when c.incontact_id in (2612421, 7173618,2612594) then 'Non-Agent'
            end as team_name
        ,a.supervisor as is_supervisor
        ,a.retail as is_retail
        ,case when a.inactive is null then true else false end as is_active
        ,a.inactive as inactive_date
        ,a.hired as hire_date
        ,a.terminated as term_date
        --VVV HISTORIC DATA VVV
        ,case when t.team_name is not null then t.team_name
            when lower(a.name) like '%wfm%' then 'Non-Agent'
            when lower(a.name) like '%analy%' then 'Non-Agent'
            when a.name like '%API%' then 'Non-Agent'
            when a.name like 'Administrator%' then 'Non-Agent'
            when t.agent_name is null then 'Non-Agent'
            when t.incontact_id in (2612421, 7173618,2612594) then 'Non-Agent'
            end as team_name_historic

      from util.warehouse_date d

        left join customer_care.agent_lkp a
          on a.created::date <= d.date
          and nvl(a.inactive::date,current_date::date) > d.date

        left join customer_care.team_lead_name t
          on a.incontact_id = t.incontact_id
          and d.date between t.start_date and t.end_date

        left join customer_care.team_lead_name c
          on a.incontact_id = c.incontact_id
          and c.start_date <= cast(getdate() as date)
          and c.end_date >= cast(getdate() as date)


      where d.date between '2019-01-01' and current_date
    ;;
  }

  set: agent_data {
    fields: [incontact_id, agent_name, team_type, team_name]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL FIELDS

  dimension: agent_name {
    hidden: yes
    sql: ${TABLE}.agent_name ;;
  }

  dimension_group: date {
    label: "Headcount"
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

  dimension: team_name {
    label: "Team Lead Name"
    group_label: "* Current Grouping"
    description: "Current Team Lead's name on given date."
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: team_name_historic {
    label: "Team Lead Name (H)"
    group_label: "* Historic Grouping"
    description: "Historic Team Lead's name on given date."
    type: string
    sql: ${TABLE}.team_name_historic ;;
  }

  dimension: team_type {
    label: "Team Type"
    group_label: "* Current Grouping"
    description: "Current team type."
    type: string
    sql: ${TABLE}.team_type ;;
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
    type: count
    drill_fields: [agent_data*]
  }
}
