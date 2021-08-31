view: l2l_machine_downtime {
  sql_table_name: "L2L"."MACHINE_DOWNTIME"
    ;;

  dimension_group: down {
    description: "Date(s) a Machine is Down; Source: l2l.machine_downtime"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DOWN_DATE" ;;
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."MACHINE_ID" || ${TABLE}."DOWN_DATE" ;;
  }

  dimension: machine_id {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  measure: minutes_available {
    description: "Total number of minutes a Machine is Available; Source: l2l.machine_downtime"
    type: sum
    hidden: yes
    sql: ${TABLE}."MINUTES_AVAILABLE" ;;
  }

  measure: minutes_down {
    description: "Total number of mintues a Machine is Down; Source: l2l.machine_downtime"
    type: sum
    sql: ${TABLE}."MINUTES_DOWN" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter,year]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter,year]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

}
