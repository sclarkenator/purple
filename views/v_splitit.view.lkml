view: v_splitit {
  sql_table_name: ANALYTICS.ACCOUNTING.V_SPLITIT
    ;;

  dimension: account_name {
    type: string
    sql: ${TABLE}."ACCOUNT_NAME" ;;
  }

  measure: amount {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: auth_no {
    type: string
    sql: ${TABLE}."AUTH_NO" ;;
  }

  dimension: card_number {
    type: string
    sql: ${TABLE}."CARD_NUMBER" ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}."CARD_TYPE" ;;
  }

  dimension: cardholder_name {
    type: string
    sql: ${TABLE}."CARDHOLDER_NAME" ;;
  }

  dimension: cust_ref_num {
    type: string
    sql: ${TABLE}."CUST_REF_NUM" ;;
  }

  dimension: expiry {
    type: number
    sql: ${TABLE}."EXPIRY" ;;
  }

  dimension: gateway {
    type: string
    sql: ${TABLE}."GATEWAY" ;;
  }

  dimension: installment_plan {
    type: string
    sql: ${TABLE}."INSTALLMENT_PLAN" ;;
  }

  dimension: merchant_code {
    type: string
    sql: ${TABLE}."MERCHANT_CODE" ;;
  }

  dimension: merchant_name {
    type: string
    sql: ${TABLE}."MERCHANT_NAME" ;;
  }

  dimension: ref_num {
    type: string
    sql: ${TABLE}."REF_NUM" ;;
  }

  dimension: reference_3 {
    type: string
    sql: ${TABLE}."REFERENCE_3" ;;
  }

  dimension: shopify_order_number {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_NUMBER" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tag {
    type: string
    sql: ${TABLE}."TAG" ;;
  }

  dimension: terminal_name {
    type: string
    sql: ${TABLE}."TERMINAL_NAME" ;;
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
    sql: CAST(${TABLE}."TIME" AS TIMESTAMP_NTZ) ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [account_name, terminal_name, cardholder_name, merchant_name]
  }
}
