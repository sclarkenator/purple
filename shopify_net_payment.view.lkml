view: shopify_net_payment {
  sql_table_name: CUSTOMER_CARE.SHOPIFY_NET_PAYMENT ;;

  dimension: amt_remaining {
    type: number
    sql: ${TABLE}."AMT_REMAINING" ;;
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: original_amount {
    type: number
    sql: ${TABLE}."ORIGINAL_AMOUNT" ;;
  }

  dimension: payement_method {
    type: string
    sql: ${TABLE}."PAYEMENT_METHOD" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
