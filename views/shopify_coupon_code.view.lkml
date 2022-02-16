view: shopify_coupon_code {
  sql_table_name: CUSTOMER_CARE.V_SHOPIFY_COUPON_CODE ;;

  dimension: coupon_code {
    type: string
    sql: ${TABLE}."COUPON_CODE" ;;
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

  dimension: pre_discount_total {
    type: number
    sql: ${TABLE}."PRE_DISCOUNT_TOTAL" ;;
  }

  dimension: order_total {
    type: number
    sql: ${TABLE}."ORDER_TOTAL" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
    primary_key: yes
  }

  dimension: order_name {
    type: string
    sql: ${TABLE}."ORDER_NAME" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
