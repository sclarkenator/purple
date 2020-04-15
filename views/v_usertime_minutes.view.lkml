view: v_usertime_minutes {
  sql_table_name: "L2L"."V_USERTIME_MINUTES"
    ;;

  dimension: user_name {
    type: string
    sql: ${TABLE}."USER_NAME" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension_group: start_hour {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."START_HOUR" ;;
  }

  dimension_group: started {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."STARTED" ;;
  }

  dimension_group: ended {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."ENDED" ;;
  }

  measure: head_count {
    type: count_distinct
    sql: ${TABLE}.user_name || ${started_date} ;;
  }

  measure: minutes_worked {
    type: sum
    sql: ${TABLE}."MINUTES_WORKED" ;;
  }

  measure: count {
    type: count
    drill_fields: [user_name]
  }
}
