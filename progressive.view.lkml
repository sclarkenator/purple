view: progressive {
  sql_table_name: FINANCE.PROGRESSIVE ;;

  dimension: lease_id {
    type: number
    sql: ${TABLE}."LEASE_ID" ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}."STORE_ID" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: funded {
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
    sql: ${TABLE}."FUNDED" ;;
  }

  dimension: identifier {
    type: string
    sql: ${TABLE}."IDENTIFIER" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: approval_limit {
    label:  "Approval Limit ($)"
    description:  "Total amount approved (but not necessarily funded)"
    type: sum
    value_format: "$#,##0"
    sql:  ${TABLE}.approval_limit ;;
  }

  measure: funded_amt {
    label:  "Funded Amount ($)"
    description:  "Total amount actually funded"
    type: sum
    value_format: "$#,##0"
    sql:  ${TABLE}.funded_amt ;;
  }
}
