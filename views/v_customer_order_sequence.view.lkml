view: v_customer_order_sequence {
  sql_table_name: "CUSTOMER"."V_CUSTOMER_ORDER_SEQUENCE"
    ;;

  dimension: categories_purchased {
    label: " Categories Purchased"
    type: string
    sql: ${TABLE}."CATEGORIES_PURCHASED" ;;
  }

  dimension: models_purchased {
    label: " Models Purchased"
    type: string
    sql: ${TABLE}."MODELS_PURCHASED" ;;
  }

  dimension: coupon_code {
    type: string
    sql: ${TABLE}."COUPON_CODE" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
    hidden: yes
  }

  dimension: gross_amt {
    label: "Order Total"
    type: number
    sql: ${TABLE}."GROSS_AMT" ;;
  }

  dimension_group: order {
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
    sql: CAST(${TABLE}."ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
    primary_key: yes
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}."ORDER_SEQUENCE" ;;
  }

  dimension: last_order {
    type: yesno
    sql: ${TABLE}."LAST_ORDER" ;;
    hidden: yes
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}."PAYMENT_METHOD" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: storefront {
    type: string
    sql: ${TABLE}."STOREFRONT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
