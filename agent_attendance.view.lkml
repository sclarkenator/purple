view: agent_attendance {
  sql_table_name: CUSTOMER_CARE.AGENT_ATTENDANCE ;;

  dimension: agent_id {
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}."AGENT_NAME" ;;
  }

  dimension: attendance_points {
    type: number
    sql: ${TABLE}."ATTENDANCE_POINTS" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}
