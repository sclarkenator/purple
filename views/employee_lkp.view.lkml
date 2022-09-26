view: employee_lkp {
  sql_table_name: "CUSTOMER_CARE"."EMPLOYEE_LKP"
    ;;

  dimension: purple_employee_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."PURPLE_EMPLOYEE_ID" ;;
  }

  set: agents_minimal_grouping {
    fields: [
      name,
      team_group,
      team_type,
      boss_name,
      incontact_id,
      is_active,
      retail,
      is_supervisor
    ]
  }

  dimension_group: birthday {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."BIRTHDAY" ;;
  }

  dimension: boss_name {
    type: string
    sql: ${TABLE}."BOSS_NAME" ;;
  }

  dimension: boss_workday_id {
    type: string
    sql: ${TABLE}."BOSS_WORKDAY_ID" ;;
  }

  dimension: business_title {
    type: string
    sql: ${TABLE}."BUSINESS_TITLE" ;;
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}."COST_CENTER" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED";;
  }

  dimension_group: end {
    label: "- End"
    description: "Termination Date if not null, else Inactive Date. (Customer Care)"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    sql: case when ${terminated_date} is not null then ${terminated_date}
      else ${inactive_date} end;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: employee_type {
    type: string
    sql: ${TABLE}."EMPLOYEE_TYPE" ;;
  }

  dimension: employment_type {
    type: string
    sql: ${TABLE}."EMPLOYMENT_TYPE" ;;
  }

  dimension: exempt_non_exempt {
    type: string
    sql: ${TABLE}."EXEMPT_NON_EXEMPT" ;;
  }

  dimension: exempt_sal {
    type: string
    sql: ${TABLE}."EXEMPT_SAL" ;;
  }

  dimension_group: hired {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."HIRED" ;;
  }

  dimension: home_address {
    type: string
    sql: ${TABLE}."HOME_ADDRESS" ;;
  }

  dimension: home_city {
    type: string
    sql: ${TABLE}."HOME_CITY" ;;
  }

  dimension: home_state {
    type: string
    sql: ${TABLE}."HOME_STATE" ;;
  }

  dimension: home_zip_code {
    type: string
    sql: ${TABLE}."HOME_ZIP_CODE" ;;
  }

  dimension_group: inactive {
    description: "Date agent became inactive. Source: incontact.agent_lkp"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: timestamp
    sql: ${TABLE}.inactive ;;
  }


  dimension: incontact_id {
    type: number
    sql: ${TABLE}."INCONTACT_ID" ;;
  }

  dimension_group: insert_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: is_active {
    type: yesno
    description: "Whether or not this agent is active in the Customer Care system."
    sql: ${terminated_date} is null;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: management_level {
    type: string
    sql: ${TABLE}."MANAGEMENT_LEVEL" ;;
  }

  dimension_group: mentor {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."MENTOR" ;;
  }

  dimension: name {
    description: "The name of this agent. Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.name ;;
  }

  dimension: preferred_first_name {
    type: string
    sql: ${TABLE}."PREFERRED_FIRST_NAME" ;;
  }

  dimension_group: purple_with_purpose {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PURPLE_WITH_PURPOSE" ;;
  }

  dimension: retail {
    type: yesno
    sql: ${TABLE}."RETAIL" ;;
  }

  dimension: salary_hourly {
    type: string
    sql: ${TABLE}."SALARY_HOURLY" ;;
  }

  dimension_group: service_recovery_team {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SERVICE_RECOVERY_TEAM" ;;
  }

  dimension: shopify_id {
    type: number
    sql: ${TABLE}."SHOPIFY_ID" ;;
  }

  dimension: shopify_id_pos {
    type: number
    value_format_name: id
    sql: ${TABLE}."SHOPIFY_ID_POS" ;;
  }

  dimension_group: start {
    label: "- Start"
    description: "Hire Date if not null, else Created Date."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    sql: case when ${hired_date} is not null then ${hired_date}
      else ${created_date} end;;
  }

  dimension: is_supervisor {
    type: yesno
    sql: ${TABLE}."SUPERVISOR" ;;
  }

  dimension: team_group {
    label: "Team Group"
    description: "The current Team Group for each agent."
    type: string
    # sql: ${TABLE}.team_group ;;
    sql: case when employee_type is null and ${TABLE}.boss_name is null then 'Other'
      when ${TABLE}.team_type in ('Admin', 'WFM', 'QA', 'CX', 'Spec Proj') then 'Admin'
      when ${TABLE}.team_type in ('Training', 'Sales') then ${TABLE}.team_type
      when ${TABLE}.team_type in ('Account Executive') then 'Sales'
      else 'Customer Care' end ;;
  }

  dimension: team_type {
    type: string
    sql: case when ${TABLE}."RETAIL" in ('TRUE') then 'Retail'
      else ${TABLE}."TEAM_TYPE" end;;
  }

  dimension: tenure {
    label: "Tenure by Month"
    group_label: "* Tenure Metrics"
    description: "Agent tenure in months."
    type: number
    value_format_name: decimal_0
    sql: case when not (${TABLE}.employee_type is null and ${TABLE}.boss_name is null) then datediff(month, ${start_date}, current_date) end ;;
  }

  measure: tenure_average {
    label: "Tenure Average"
    description: "Average tenure in months."
    type: average
    value_format_name: decimal_1
    sql: ${tenure} ;;
    link: {
      label: "View Tenure Detail"
      url: "https://purple.looker.com/looks/5759"
    }
    link: {
      label: "Go To Headcount Dashboard"
      url: "https://purple.looker.com/dashboards-next/4502?Headcount%20Date=today&Team%20Type=&Employee%20Type=&Team%20Lead%20Name=-Other&Team%20Group="
    }
  }

  dimension: tenure_buckets {
    label: "Tenure Bucket by Month"
    group_label: "* Tenure Metrics"
    type: tier
    style: integer
    tiers: [0, 4, 7, 10]
    sql: ${tenure} ;;
  }

  dimension_group: terminated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."TERMINATED";;
  }

  dimension: termination {
    type: yesno
    sql: ${TABLE}."TERMINATION" ;;
  }

  dimension: termination_reason {
    type: string
    sql: ${TABLE}."TERMINATION_REASON" ;;
  }

  dimension_group: update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: workday_id {
    type: string
    sql: ${TABLE}."WORKDAY_ID" ;;
  }

  dimension: zendesk_chat {
    type: yesno
    sql: ${TABLE}."ZENDESK_CHAT" ;;
  }

  dimension: zendesk_id {
    type: number
    sql: ${TABLE}."ZENDESK_ID" ;;
  }

  dimension: zendesk_sell_user_id {
    type: number
    sql: ${TABLE}."ZENDESK_SELL_USER_ID" ;;
  }

  measure: count {
    hidden: no
    type: count
    drill_fields: [boss_name, preferred_first_name, name]
  }
}
