view: shopify_orders {
  sql_table_name: ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" ;;

  measure: discounts {
    label: "Total discounts"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_discounts ;;
  }

  measure: count {
    label: "Order count"
    description: "How many unique orders were placed?"
    type: count
  }

  measure: gross_sales {
    label: "Gross sales"
    description: "Gross product sales in Shopify"
    type: sum
    sql: ${TABLE}.subtotal_price ;;
  }

  dimension: order_ref {
    description: "Netsuite reference ID"
    label: "Related_tranid"
    hidden:  yes
    primary_key: yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: checkout_token {
    description: "checkout token linking shopify to heap, hotjar"
    label: "Checkout token"
    hidden:  yes
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension: call_in_order_Flag {
    view_label: "Sales Header"
    label: "Draft order"
    description: "Draft orders created by call center agents"
    type: yesno
    sql: ${TABLE}.source_name = 'shopify_draft_order' ;;
  }

  dimension_group: created_at  {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }
}
