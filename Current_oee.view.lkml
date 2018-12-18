view: current_oee {
  sql_table_name: PRODUCTION.OEE ;;

  dimension: available_rate {
    type: string
    sql: ${TABLE}."AVAILABLE_RATE" ;;
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

  dimension: machine_id {
    type: string
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  measure:: minutes_available {
    type: sum
    sql: ${TABLE}."MINUTES_AVAILABLE" ;;
  }

  measure: minutes_down {
    type: sum
    sql: ${TABLE}."MINUTES_DOWN" ;;
  }

  dimension_group: Date {
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
    sql: ${TABLE}."OEE_DATE" ;;
  }

  measure: operating_time {
    type: sum
    sql: ${TABLE}."OPERATING_TIME" ;;
  }

  measure: performance_pcnt {
    type: average
    sql: ${TABLE}."PERFORMANCE_PCNT" ;;
  }

  measure: quality_pcnt {
    type: average
    sql: ${TABLE}."QUALITY_PCNT" ;;
  }

  measure: scrap_regrind_produced {
    type: sum
    sql: ${TABLE}."SCRAP_REGRIND_PRODUCED" ;;
  }

  measure: total_produced {
    type: sum
    sql: ${TABLE}."TOTAL_PRODUCED" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
