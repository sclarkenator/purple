view: l2l_machine_downtime {
  sql_table_name: "PRODUCTION"."MACHINE_DOWNTIME"
    ;;

  dimension_group: down {
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
    sql: ${TABLE}."DOWN_DATE" ;;
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

  dimension: machine_id {
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension: minutes_available {
    type: number
    sql: ${TABLE}."MINUTES_AVAILABLE" ;;
  }

  dimension: minutes_down {
    type: number
    sql: ${TABLE}."MINUTES_DOWN" ;;
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
