view: max_machine_capacity {
  sql_table_name: PRODUCTION.MAX_MACHINE_CAPACITY ;;

  dimension_group: date {
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
    sql: ${TABLE}."DATE" ;;
  }

  dimension: max_1_capacity {
    type: number
    sql: ${TABLE}."MAX_1_CAPACITY" ;;
  }

  dimension: max_2_capacity {
    type: number
    sql: ${TABLE}."MAX_2_CAPACITY" ;;
  }

  dimension: max_3_capacity {
    type: number
    sql: ${TABLE}."MAX_3_CAPACITY" ;;
  }

  dimension: max_4_capacity {
    type: number
    sql: ${TABLE}."MAX_4_CAPACITY" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

  measure: total_max_machine_capacity {
    type: sum
    description: "Total Capacity of all Max machines"
    sql: ${TABLE}."MAX_1_CAPACITY" + ${TABLE}."MAX_2_CAPACITY" + ${TABLE}."MAX_3_CAPACITY"  +${TABLE}."MAX_4_CAPACITY" ;;
  }
}
