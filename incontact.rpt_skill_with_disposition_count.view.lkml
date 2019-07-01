view: rpt_skill_with_disposition_count {
  sql_table_name: CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT ;;

  dimension: abandon_time {
    type: number
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  dimension: acw_time {
    type: number
    sql: ${TABLE}."ACW_TIME" ;;
  }

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_inqueue_time {
    type: number
    sql: ${TABLE}."AVG_INQUEUE_TIME" ;;
  }

  dimension_group: captured {
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
    sql: ${TABLE}."CAPTURED" ;;
  }

  dimension: contact_info_from {
    type: string
    sql: ${TABLE}."CONTACT_INFO_FROM" ;;
  }

  dimension: contact_info_to {
    type: string
    sql: ${TABLE}."CONTACT_INFO_TO" ;;
  }

  dimension: disposition {
    type: string
    sql: ${TABLE}."DISPOSITION" ;;
  }

  dimension: handle_time {
    type: number
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  dimension: hold_time {
    type: number
    sql: ${TABLE}."HOLD_TIME" ;;
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: master_contact_id {
    type: number
    sql: ${TABLE}."MASTER_CONTACT_ID" ;;
  }

  dimension_group: reported {
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
    sql: ${TABLE}."REPORTED" ;;
  }

  dimension: skill {
    type: string
    sql: ${TABLE}."SKILL" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
