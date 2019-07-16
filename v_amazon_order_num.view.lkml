view: v_amazon_order_num {
  sql_table_name: ACCOUNTING.V_AMAZON_ORDER_NUM ;;

  dimension: amazon_order_reference_id {
    type: string
    sql: ${TABLE}."AMAZON_ORDER_REFERENCE_ID" ;;
  }

  dimension: amazon_transaction_id {
    type: string
    sql: ${TABLE}."AMAZON_TRANSACTION_ID" ;;
  }

  dimension: currency_code {
    type: string
    sql: ${TABLE}."CURRENCY_CODE" ;;
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

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: net_transaction_amount {
    type: number
    sql: ${TABLE}."NET_TRANSACTION_AMOUNT" ;;
  }

  dimension: seller_order_id {
    type: string
    sql: ${TABLE}."SELLER_ORDER_ID" ;;
  }

  dimension: seller_reference_id {
    type: string
    sql: ${TABLE}."SELLER_REFERENCE_ID" ;;
  }

  dimension: settlement_id {
    type: number
    sql: ${TABLE}."SETTLEMENT_ID" ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}."STORE_NAME" ;;
  }

  dimension: total_transaction_fee {
    type: number
    sql: ${TABLE}."TOTAL_TRANSACTION_FEE" ;;
  }

  dimension: transaction_amount {
    type: number
    sql: ${TABLE}."TRANSACTION_AMOUNT" ;;
  }

  dimension: transaction_description {
    type: string
    sql: ${TABLE}."TRANSACTION_DESCRIPTION" ;;
  }

  dimension: transaction_fixed_fee {
    type: number
    sql: ${TABLE}."TRANSACTION_FIXED_FEE" ;;
  }

  dimension: transaction_percentage_fee {
    type: number
    sql: ${TABLE}."TRANSACTION_PERCENTAGE_FEE" ;;
  }

  dimension_group: transaction_posted {
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
    sql: ${TABLE}."TRANSACTION_POSTED" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [store_name, name]
  }
}
