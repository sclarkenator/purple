view: v_paypal_order_num {
  sql_table_name: ACCOUNTING.V_PAYPAL_ORDER_NUM ;;

  dimension: customer_name {
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: fee_amount {
    type: number
    sql: ${TABLE}."FEE_AMOUNT" ;;
  }

  dimension: gross_amount {
    type: number
    sql: ${TABLE}."GROSS_AMOUNT" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: invoice_number {
    type: string
    sql: ${TABLE}."INVOICE_NUMBER" ;;
  }

  dimension: net_amount {
    type: number
    sql: ${TABLE}."NET_AMOUNT" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: reference_txn_id {
    type: string
    sql: ${TABLE}."REFERENCE_TXN_ID" ;;
  }

  dimension: transaction_authorization {
    type: string
    sql: ${TABLE}."TRANSACTION_AUTHORIZATION" ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}."TRANSACTION_STATUS" ;;
  }

  dimension_group: transaction_ts {
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
    sql: ${TABLE}."TRANSACTION_TS" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_name]
  }
}
