view: fraud_warning_list {
  derived_table: {
    sql:
      select
        order_id, reason, order_created, order_name, shipped_to, billing_address,
        shipping_address, shipping_zip, address_count, financial_status, order_price,
        case
          when order_name ilike '%ca%' then 'https://purple-ca.myshopify.com/admin/orders/' || order_id
          else 'https://onpurple.myshopify.com/admin/orders/' || order_id
        end as hyper_link
      from analytics.customer_care.fraud_warning_list;;
  }

  dimension: hyper_link {
    type: string
    sql: ${TABLE}."HYPER_LINK" ;;
  }

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
    html: <a href = "{{hyper_link}}" target="_blank"> {{value}} </a> ;;
    primary_key: yes
  }

  dimension: order_name {
    type: string
    sql: ${TABLE}."ORDER_NAME" ;;
    html: <a href = "{{hyper_link}}" target="_blank"> {{value}} </a> ;;
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
