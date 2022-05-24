view: labor_hours {
  sql_table_name: "WORKDAY"."LABOR_HOURS";;


dimension: employee_department_location_clock {
  hidden: yes
  primary_key: yes
  sql: ${employee_id}||'-'||${department}||'-'||${location}||'-'||${clocked_in_raw};;
}

  dimension_group: clocked_in {
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
    sql: CAST(${TABLE}."CLOCKED_IN" AS TIMESTAMP_NTZ) ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: employee_id {
    hidden: yes
    type: number
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: status {
    type:  string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  measure: employee_count {
    type: count_distinct
    sql: ${TABLE}."EMPLOYEE_ID"  ;;
  }

  measure: total_hours {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."HOURS" ;;
  }

  measure: average_hours {
    type: average
    value_format: "0.0"
    sql: ${TABLE}."HOURS" ;;
  }

  measure: wages_paid {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."WAGES_PAID" ;;
  }

  measure: average_wages_paid {
    type: average
    value_format: "$#,##0.00"
    sql: ${TABLE}."WAGES_PAID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
