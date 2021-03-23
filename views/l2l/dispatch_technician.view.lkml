view: dispatch_technician {
  sql_table_name: "L2L"."DISPATCH_TECHNICIAN"
    ;;
  drill_fields: [dispatch_technician_id]

  dimension: dispatch_technician_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}."DISPATCH_TECHNICIAN_ID" ;;
  }

  dimension_group: assigned {
    hidden: yes
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
    sql: ${TABLE}."ASSIGNED" ;;
  }

  dimension: assigned_by {
    hidden: yes
    type: string
    sql: ${TABLE}."ASSIGNED_BY" ;;
  }

  dimension_group: completed {
    hidden: yes
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
    sql: ${TABLE}."COMPLETED" ;;
  }

  dimension: dispatch_id {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_ID" ;;
  }

  dimension: dispatch_number {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension: external_id {
    hidden: yes
    type: string
    sql: ${TABLE}."EXTERNAL_ID" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: marked_completed_by {
    hidden: yes
    type: string
    sql: ${TABLE}."MARKED_COMPLETED_BY" ;;
  }

  dimension: resource_cost {
    hidden: yes
    type: number
    sql: ${TABLE}."RESOURCE_COST" ;;
  }

  dimension: resource_rate {
    hidden: yes
    type: number
    sql: ${TABLE}."RESOURCE_RATE" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension: technician {
    hidden: yes
    type: number
    sql: ${TABLE}."TECHNICIAN" ;;
  }

  dimension: technician_id {
    hidden: yes
    type: string
    sql: ${TABLE}."TECHNICIAN_ID" ;;
  }

  dimension: technician_name {
    hidden: yes
    type: string
    sql: ${TABLE}."TECHNICIAN_NAME" ;;
  }

  dimension: trade {
    hidden: yes
    type: number
    sql: ${TABLE}."TRADE" ;;
  }

  dimension: tradecode {
    hidden: yes
    type: string
    sql: ${TABLE}."TRADECODE" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: resource_time_dim {
    hidden: yes
    type: number
    sql: timediff(minutes,${assigned_raw},${completed_raw}) ;;
  }

  measure: resource_time {
    type: sum
    description: "To be used with Dispatched Date; Source: Looker Calculation"
    value_format: "#,##0.00"
    sql: ${resource_time_dim}/60 ;;
  }

  measure: count {
    type: count
    drill_fields: [dispatch_technician_id, technician_name]
  }
}
