view: fraud_warning_list {
  sql_table_name: CUSTOMER_CARE.FRAUD_WARNING_LIST ;;

  dimension: address_count {
    type: string
    sql: ${TABLE}."ADDRESS_COUNT" ;;
  }

  dimension: billing_address {
    type: string
    sql: ${TABLE}."BILLING_ADDRESS" ;;
  }

  dimension: financial_status {
    type: string
    sql: ${TABLE}."FINANCIAL_STATUS" ;;
  }

  dimension_group: order_created {
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
    sql: ${TABLE}."ORDER_CREATED" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
    html: <a href = "https://onpurple.myshopify.com/admin/orders/{{value}}" target="_blank"> {{value}} </a> ;;
  }

  dimension: order_name {
    type: string
    sql: ${TABLE}."ORDER_NAME" ;;
  }

  dimension: order_price {
    type: string
    sql: ${TABLE}."ORDER_PRICE" ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: shipped_to {
    type: string
    sql: ${TABLE}."SHIPPED_TO" ;;
  }

  dimension: shipping_address {
    type: string
    sql: ${TABLE}."SHIPPING_ADDRESS" ;;
  }

  dimension: shipping_zip {
    type: string
    sql: ${TABLE}."SHIPPING_ZIP" ;;
  }


}
