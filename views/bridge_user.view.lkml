view: bridge_user {
  sql_table_name: "HR"."BRIDGE_USER"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: domain_id {
    type: number
    sql: ${TABLE}."DOMAIN_ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}."FULL_NAME" ;;
  }

  dimension_group: hire {
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
    sql: ${TABLE}."HIRE_DATE" ;;
  }

  dimension: hris_id {
    type: number
    sql: ${TABLE}."HRIS_ID" ;;
  }


  dimension: is_manager {
    type: yesno
    sql: ${TABLE}."IS_MANAGER" ;;
  }

  dimension: job_title {
    type: string
    sql: ${TABLE}."JOB_TITLE" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension_group: logged_in {
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
    sql: CAST(${TABLE}."LOGGED_IN_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: roles {
    type: string
    sql: ${TABLE}."ROLES" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, full_name]
  }
}
