view: rpt_skill_with_disposition_count {
  sql_table_name: CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT ;;

  dimension: abandon_time {
    type: number
    hidden: yes
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  dimension: acw_time {
    type: number
    hidden: yes
    sql: ${TABLE}."ACW_TIME" ;;
  }

  dimension: agent {
    type: string
    hidden: yes #unhide this for agent based tables, I'm just using this view for disposition things right now
    primary_key: yes
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_inqueue_time {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_INQUEUE_TIME" ;;
  }

  dimension_group: captured {
    type: time
    hidden: yes
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
    sql: lower(${TABLE}."DISPOSITION") ;; ## remove the lower() if we standardize naming and capitalization in snowflake between this and zendesk data
  }

  dimension: handle_time {
    type: number
    hidden: yes
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  dimension: hold_time {
    type: number
    hidden: yes
    sql: ${TABLE}."HOLD_TIME" ;;
  }

  dimension_group: insert_ts {
    type: time
    hidden: yes
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


  measure: avg_abandon_time {
    type: average
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  measure: avg_acw_time {
    type: number
    sql: ${TABLE}."ACW_TIME" ;;
  }

  measure: avg_handle_time {
    type: number
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  measure: avg_hold_time {
    type: number
    sql: ${TABLE}."HOLD_TIME" ;;
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
