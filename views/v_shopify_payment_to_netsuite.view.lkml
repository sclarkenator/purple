view: v_shopify_payment_to_netsuite {
  sql_table_name: ACCOUNTING.V_SHOPIFY_PAYMENT_TO_NETSUITE ;;

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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: netsuite_total_amount {
    type: string
    sql: ${TABLE}."NETSUITE_TOTAL_AMOUNT" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: shopify_financial_status {
    type: string
    sql: ${TABLE}."SHOPIFY_FINANCIAL_STATUS" ;;
  }

  dimension: shopify_order_amount {
    type: number
    sql: ${TABLE}."SHOPIFY_ORDER_AMOUNT" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_payment_amount {
    type: number
    sql: ${TABLE}."TRANSACTION_PAYMENT_AMOUNT" ;;
  }

  dimension: transaction_payment_fee {
    type: number
    sql: ${TABLE}."TRANSACTION_PAYMENT_FEE" ;;
  }

  dimension: transaction_payment_net {
    type: number
    sql: ${TABLE}."TRANSACTION_PAYMENT_NET" ;;
  }

  dimension: transaction_payout_status {
    type: string
    sql: ${TABLE}."TRANSACTION_PAYOUT_STATUS" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${order_id}, ${created_date}) ;;
    hidden: yes
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
