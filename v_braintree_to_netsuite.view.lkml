view: v_braintree_to_netsuite {
  sql_table_name: ACCOUNTING.V_BRAINTREE_TO_NETSUITE ;;

  dimension: braintree_order_id {
    type: string
    sql: ${TABLE}."BRAINTREE_ORDER_ID" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: disbursement {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DISBURSEMENT_DATE" ;;
  }

  dimension: disbursement_settlement_amount {
    type: number
    sql: ${TABLE}."DISBURSEMENT_SETTLEMENT_AMOUNT" ;;
  }

  dimension: disbursement_settlement_currency_exchange_rate {
    type: number
    sql: ${TABLE}."DISBURSEMENT_SETTLEMENT_CURRENCY_EXCHANGE_RATE" ;;
  }

  dimension: disbursement_settlement_currency_iso_code {
    type: string
    sql: ${TABLE}."DISBURSEMENT_SETTLEMENT_CURRENCY_ISO_CODE" ;;
  }

  dimension: netsuite_tranid {
    type: string
    sql: ${TABLE}."NETSUITE_TRANID" ;;
  }

  dimension: originating_amount {
    type: number
    sql: ${TABLE}."ORIGINATING_AMOUNT" ;;
  }

  dimension: originating_currency_iso_code {
    type: string
    sql: ${TABLE}."ORIGINATING_CURRENCY_ISO_CODE" ;;
  }

  dimension: shopify_order_number {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER_NUMBER" ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}."TRANSACTION_STATUS" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
