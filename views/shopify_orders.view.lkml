view: shopify_orders {
  #sql_table_name: ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" ;;
  derived_table: {
    sql:  select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
      from analytics_stage.shopify_us_ft."ORDER"
      UNION
      select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
      from analytics_stage.shopify_ca_ft."ORDER"
      UNION
      select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
      from analytics_stage.shopify_outlet."ORDER";;
  }

  dimension: id {
    primary_key: yes
    label: "Shopify Order"
    hidden:  yes
    type: string
    sql: ${TABLE}.id ;;
  }

  measure: discounts {
    label: "Total Discounts"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_discounts ;;
  }

  measure: total_tax {
    label: "Total Tax Amount"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_tax ;;
  }

  measure: count {
    label: "Order Count"
    description: "How many unique orders were placed?"
    type: count
  }

  measure: gross_sales {
    label: "Gross Sales"
    description: "Gross product sales in Shopify"
    type: sum
    sql: ${TABLE}.subtotal_price ;;
  }

  measure: tax_dif {
    label: "Taxes Difference ($)"
    description: "Positive Value Difference between Shopify and Netsuite Taxes"
    type: sum
    sql: case when ${TABLE}.total_tax > ${sales_order.tax_amt} then ${TABLE}.total_tax - ${sales_order.tax_amt}
      else ${sales_order.tax_amt} - ${TABLE}.total_tax end ;;
  }

  dimension: order_ref {
    description: "Netsuite Reference ID"
    label: "Related_tranid"
    hidden:  yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: checkout_token {
    description: "checkout token linking shopify to heap, hotjar"
    label: "Checkout Token"
    hidden:  yes
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension: call_in_order_Flag {
    view_label: "Sales Order"
    #group_label: " Advanced"
    label: "     * Is Call center order"
    description: "Draft orders created by call center agents. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.user_id is not null and ${sales_order.showroom} = 'FALSE' ;;
  }

  dimension: tax_match {
    label: "Taxes Match"
    description: "Taxes between Shopify and Netsuite Match"
    type: yesno
    sql: ${TABLE}.total_tax = ${sales_order.tax_amt} ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
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
