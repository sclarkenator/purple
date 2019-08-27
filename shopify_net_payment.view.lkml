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
    link: {
      label: "Shopify"
      url: "https://onpurple.myshopify.com/admin/orders/{{order_id._value}}"}
    sql: ${TABLE}."ORDER_ID" ;;
    primary_key: yes
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

  measure: count {
    type: count
    drill_fields: []
  }
}
