view: project_config {
  sql_table_name: ENGINEERING.PROJECT_CONFIG ;;

  dimension: project_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."PROJECT_ID" ;;
  }

  dimension: budget_amt {
    hidden: yes
    type: number
    value_format: "$#,##0.##"
    sql: ${TABLE}."BUDGET_AMT" ;;
  }

  dimension: duration_in_days_dimension {
    type: number
    sql: ${TABLE}."DURATION_IN_DAYS" ;;
  }

  measure: duration_in_days {
    type: sum
    sql: ${TABLE}."DURATION_IN_DAYS" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."START_DATE" ;;
  }

  measure: count {
    label: "Project Count"
    type: count
    drill_fields: [project_id, name]
  }

  measure: total_budget {
    type:  sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}."BUDGET_AMT" ;;
  }
}
