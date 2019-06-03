view: shopify_coupon_code {
  sql_table_name: CUSTOMER_CARE.SHOPIFY_COUPON_CODE ;;

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

  dimension: order_total {
    type: number
    sql: ${TABLE}."ORDER_TOTAL" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
