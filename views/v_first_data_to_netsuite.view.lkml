view: v_first_data_to_netsuite {
  sql_table_name: ACCOUNTING.V_FIRST_DATA_TO_NETSUITE ;;

  dimension: netsuite_tranids {
    type: string
    sql: ${TABLE}."NETSUITE_TRANIDS" ;;
  }

  dimension: netsuite_transaction_ids {
    type: string
    sql: ${TABLE}."NETSUITE_TRANSACTION_IDS" ;;
  }

  dimension: shopify_amount {
    type: number
    sql: ${TABLE}."SHOPIFY_AMOUNT" ;;
  }

  dimension: shopify_currency {
    type: string
    sql: ${TABLE}."SHOPIFY_CURRENCY" ;;
  }

  dimension: shopify_order_id {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_ID" ;;
  }

  dimension: shopify_price {
    type: number
    sql: ${TABLE}."SHOPIFY_PRICE" ;;
  }

  dimension: shopify_tax {
    type: number
    sql: ${TABLE}."SHOPIFY_TAX" ;;
  }

  dimension: shopify_type {
    type: string
    sql: ${TABLE}."SHOPIFY_TYPE" ;;
  }

  dimension: transaction_amount {
    type: number
    sql: ${TABLE}."TRANSACTION_AMOUNT" ;;
  }

  dimension: transaction_auth_no {
    type: string
    sql: ${TABLE}."TRANSACTION_AUTH_NO" ;;
  }

  dimension: transaction_cardholder_name {
    type: string
    sql: ${TABLE}."TRANSACTION_CARDHOLDER_NAME" ;;
  }

  dimension_group: transaction_created {
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
    sql: ${TABLE}."TRANSACTION_CREATED_AT" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_order_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ORDER_ID" ;;
  }

  dimension: transaction_ref_num {
    type: string
    sql: ${TABLE}."TRANSACTION_REF_NUM" ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}."TRANSACTION_STATUS" ;;
  }

  measure: count {
    type: count
    drill_fields: [transaction_cardholder_name]
  }
}
