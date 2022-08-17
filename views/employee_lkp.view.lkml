view: employee_lkp {
  sql_table_name: "CUSTOMER_CARE"."EMPLOYEE_LKP"
    ;;

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
    sql: ${TABLE}.CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
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
    type: string
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

  dimension: purple_employee_id {
    type: number
    sql: ${TABLE}."PURPLE_EMPLOYEE_ID" ;;
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

  dimension: is_supervisor {
    type: yesno
    sql: ${TABLE}."SUPERVISOR" ;;
  }

  dimension: team_type {
    type: string
    sql: ${TABLE}."TEAM_TYPE" ;;
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
    sql: ${TABLE}."TERMINATED" ;;
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
    hidden: yes
    type: count
    drill_fields: [boss_name, preferred_first_name, name]
  }
}
