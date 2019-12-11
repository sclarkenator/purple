view: v_amazon_pay_to_netsuite {
  sql_table_name: ACCOUNTING.V_AMAZON_PAY_TO_NETSUITE ;;

  dimension: amazon_amount {
    type: number
    sql: ${TABLE}."AMAZON_AMOUNT" ;;
  }

  dimension: amazon_fee {
    type: number
    sql: ${TABLE}."AMAZON_FEE" ;;
  }

  dimension: amazon_net_amount {
    type: number
    sql: ${TABLE}."AMAZON_NET_AMOUNT" ;;
  }

  dimension: authorization {
    type: string
    sql: ${TABLE}."AUTHORIZATION" ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: netsuite_amount {
    type: string
    sql: ${TABLE}."NETSUITE_AMOUNT" ;;
  }

  dimension: netsuite_tranid {
    type: string
    sql: ${TABLE}."NETSUITE_TRANID" ;;
  }

  dimension: netsuite_transaction_id {
    type: number
    sql: ${TABLE}."NETSUITE_TRANSACTION_ID" ;;
  }

  dimension: order_reference_id {
    type: string
    sql: ${TABLE}."ORDER_REFERENCE_ID" ;;
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
    sql: ${TABLE}."POSTED" ;;
  }

  dimension: settlement_id {
    type: number
    sql: ${TABLE}."SETTLEMENT_ID" ;;
  }

  dimension: shopify_amount {
    type: number
    sql: ${TABLE}."SHOPIFY_AMOUNT" ;;
  }

  dimension: shopify_order_id {
    type: number
    sql: ${TABLE}."SHOPIFY_ORDER_ID" ;;
  }

  dimension: shopify_order_name {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_NAME" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [shopify_order_name]
  }
}
