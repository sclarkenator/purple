view: hour_assumptions {
  sql_table_name: "CSV_UPLOADS"."HOUR_ASSUMPTIONS"
    ;;

  dimension: average {
    description: "Average of middle 80% percent of an average day's sales each hour"
    type: number
    sql: ${TABLE}."AVERAGE" ;;
  }

  dimension: hour {
    description: "Hour of day"
    primary_key: yes
    type: number
    sql: ${TABLE}."HOUR" ;;
  }

  dimension: lower {
    description: "10th percentile of an average day's sales each hour (no large promos)"
    type: number
    sql: ${TABLE}."LOWER" ;;
  }

  dimension: upper {
    description: "90th percentile of an average day's sales each hour (no large promos)"
    type: number
    sql: ${TABLE}."UPPER" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
