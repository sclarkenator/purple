view: shopify_orders {
  sql_table_name: ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" ;;

  measure: discounts {
    label: "Total discounts"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_discounts ;;
  }

  measure: gross_sales {
    label: "Gross sales"
    description: "Gross product sales in Shopify"
    type: sum
    sql: ${TABLE}.total_discounts ;;
  }

  dimension: order_ref {
    description: "Netsuite reference ID"
    label: "Related_tranid"
    primary_key: yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: call_in_order_Flag {
    label: "Draft order"
    description: "Draft orders created by call center agents"
    type: yesno
    sql: ${TABLE}.source_name = "shopify_draft_order" ;;
  }

  dimension_group: created_at  {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }
}
