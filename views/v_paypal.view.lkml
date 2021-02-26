view: v_paypal {
  sql_table_name: "ACCOUNTING"."V_PAYPAL"
    ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: invoice_id {
    type: string
    sql: ${TABLE}."INVOICE_ID" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension_group: posted {
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
    sql: CAST(${TABLE}."POSTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: reference_id {
    type: string
    sql: ${TABLE}."REFERENCE_ID" ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

}
