view: hour_assumptions {
  sql_table_name: "CSV_UPLOADS"."HOUR_ASSUMPTIONS"
    ;;

  dimension: average {
    hidden: yes
    description: "Average of middle 80% percent of an average day's sales each hour"
    type: number
    sql: ${TABLE}."AVERAGE" ;;
  }

  dimension: hour {
    description: "Hour of day"
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."HOUR" ;;
  }

  dimension: lower {
    hidden: yes
    description: "10th percentile of an average day's sales each hour (no large promos)"
    type: number
    sql: ${TABLE}."LOWER" ;;
  }

  dimension: upper {
    hidden: yes
    description: "90th percentile of an average day's sales each hour (no large promos)"
    type: number
    sql: ${TABLE}."UPPER" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
