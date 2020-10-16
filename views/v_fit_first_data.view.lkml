view: v_fit_first_data {
  sql_table_name: ACCOUNTING.V_FIT_FIRST_DATA ;;

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

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: gateway {
    type: string
    sql: ${TABLE}."GATEWAY" ;;
  }

  dimension: gateway_amount {
    type: number
    value_format: "0,###.##"
    sql: ${TABLE}."GATEWAY_AMOUNT" ;;
  }

  dimension: netsuite_amount {
    type: number
    value_format: "0,###.##"
    sql: ${TABLE}."NETSUITE_AMOUNT" ;;
  }

  dimension: netsuite_tran_id {
    type: string
    sql: ${TABLE}."NETSUITE_TRAN_ID" ;;
  }

  dimension: netsuite_transaction_id {
    type: string
    sql: ${TABLE}."NETSUITE_TRANSACTION_ID" ;;
  }

  dimension: netsuite_customer_id {
    type: string
    sql: ${TABLE}."NETSUITE_CUSTOMER_ID" ;;
  }

  dimension: po_id {
    type: string
    sql: ${TABLE}."PO_ID" ;;
  }

  dimension: secondary_id {
    type: string
    sql: ${TABLE}."SECONDARY_ID" ;;
  }

  dimension: shopify_order_id {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_ID" ;;
  }

  dimension: shopify_order_number {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_NUMBER" ;;
  }

  dimension: shopify_customer_id {
    type: number
    sql: ${TABLE}."SHOPIFY_CUSTOMER_ID" ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: diff {
    label: "Absolute Amount DIfference"
    description: "abs(gateway_amount - netsuite_amount)"
    type: sum
    value_format: "0,###.##"
    sql: abs(${gateway_amount} - ${netsuite_amount}) ;;
  }

}
