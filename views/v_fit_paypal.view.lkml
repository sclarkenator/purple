view: v_fit_paypal {
  sql_table_name: ACCOUNTING.V_FIT_PAYPAL ;;

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

  dimension: fee {
    type: number
    sql: ${TABLE}."FEE" ;;
  }

  dimension: gateway {
    type: string
    sql: ${TABLE}."GATEWAY" ;;
  }

  dimension: gateway_amount {
    type: number
    sql: ${TABLE}."GATEWAY_AMOUNT" ;;
  }

  dimension: in_netsuite {
    type: yesno
    sql: ${TABLE}."IN_NETSUITE" ;;
  }

  dimension: in_etail {
    type: yesno
    sql: ${TABLE}."IN_ETAIL" ;;
  }

  dimension: netsuite_amount {
    type: number
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

  dimension: other_id {
    type: string
    sql: ${TABLE}."OTHER_ID" ;;
  }

  dimension: po_id {
    type: string
    sql: ${TABLE}."PO_ID" ;;
  }

  dimension: same_amount {
    type: yesno
    sql: ${TABLE}."SAME_AMOUNT" ;;
  }

  dimension: same_transaction_count {
    type: yesno
    sql: ${TABLE}."SAME_TRANSACTION_COUNT" ;;
  }

  dimension: secondary_id {
    type: string
    sql: ${TABLE}."SECONDARY_ID" ;;
  }

  dimension: etail_order_id {
    type: number
    sql: ${TABLE}."ETAIL_ORDER_ID" ;;
  }

  dimension: etail_order_number {
    type: string
    sql: ${TABLE}."ETAIL_ORDER_NUMBER" ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}."TRANSACTION_ID" ;;
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
