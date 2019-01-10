view: project_report {
  sql_table_name: ENGINEERING.PROJECT_REPORT ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."PROJECT_ID" ||  ${TABLE}."REPORTING_DATE" ;;
  }

  dimension: actual_spend {
    type: number
    hidden: yes
    sql: ${TABLE}."ACTUAL_SPEND" ;;
  }

  dimension: forecasted_spend {
    type: number
    hidden: yes
    sql: ${TABLE}."FORECASTED_SPEND" ;;
  }

  measure: sum_actual_spend {
    label: "Total Actual Spend"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."ACTUAL_SPEND" ;;
  }

  measure: sum_forecasted_spend {
    label: "Total Forecasted Spend"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."FORECASTED_SPEND" ;;
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

  dimension: progress_dimension {
    type: number
    hidden: yes
    value_format: "0\%"
    sql: ${TABLE}."PROGRESS" ;;
  }

  measure: progress {
    label: "Progress to Completion (%)"
    type: average
    value_format: "0\%"
    sql: ${TABLE}."PROGRESS" ;;
  }

  dimension: project_id {
    type: string
    hidden: yes
    sql: ${TABLE}."PROJECT_ID" ;;
  }

  dimension_group: reporting {
    type: time
    timeframes: [
      raw,
      ##date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REPORTING_DATE" ;;
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
