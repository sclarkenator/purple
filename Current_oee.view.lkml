view: current_oee {
  sql_table_name: PRODUCTION.OEE ;;

  measure: available_pcnt {
    type: sum
    value_format: "0.0%"
    sql: ${TABLE}."OPERATING_TIME"/${TABLE}."MINUTES_AVAILABLE" ;;
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

  measure: Overall_OEE {
    type: sum
    value_format: "0.0%"
    sql: (${quality_pcnt}*${available_pcnt}*${performance_pcnt} ;;}

  measure: performance_pcnt {
    type: sum
    value_format: "0.0%"
    sql: (${TABLE}."TOTAL_PRODUCED"/nullif(${TABLE}."OPERATING_TIME",0))/${TABLE}."CYCLE_TIME" ;;
  }

  measure: quality_pcnt {
    type: sum
    value_format: "0.0%"
    sql: (${TABLE}."TOTAL_PRODUCED"-${TABLE}."SCRAP_REGRIND_PRODUCED")/${TABLE}."TOTAL_PRODUCED" ;;
  }

  measure: cycle_time {
    type: average
    sql: ${TABLE}."CYCLE_TIME" ;;
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
