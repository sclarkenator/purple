include: "/views/_period_comparison.view.lkml"
view: sales_base {
  derived_table: {
    explore_source: sales_order_line {
      column: is_cancelled { field: cancelled_order.is_cancelled }
      column: is_fulfilled {}
      column: category_name { field: item.category_name }
      column: line_raw { field: item.line_raw }
      column: model_raw { field: item.model_raw }
      column: product_description_raw { field: item.product_description_raw }
      column: sku_id { field: item.sku_id }
      column: return_completed { field: return_order.return_completed }
      column: is_warrantied { field: warranty_order_line.is_warrantied }
      column: payment_method_flag { field: sales_order.payment_method_flag }
      column: call_in_order_Flag { field: shopify_orders.call_in_order_Flag }
      column: created_date {}
      column: order_id { field: sales_order.order_id }
      column: channel2 { field: sales_order.channel2 }
      column: store_name { field: v_purple_showroom.location_name }
      column: free_item {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      column: gross_margin {}
      column: adj_gross_amt {}
      column: mattress_flg { field: order_flag.mattress_flg }
      column: pillow_flg { field: order_flag.pillow_flg }
      column: sheets_flg { field: order_flag.sheets_flg }
      column: cushion_flg { field: order_flag.cushion_flg }
      filters: { field: sales_order.channel_id value: "1,2,5" }
    }
    datagroup_trigger: pdt_refresh_6am
  }

  extends: [_period_comparison]

  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: is_cancelled {
    group_label: "  Filters"
    type: yesno
  }
  dimension: is_fulfilled {
    group_label: "  Filters"
    type: yesno
  }
  dimension: return_completed {
    label: "Is Returned"
    group_label: "  Filters"
    type: yesno
  }
  dimension: is_warrantied {
    group_label: "  Filters"
    type: yesno
  }
  dimension: payment_method_flag {
    label: "Is Financed"
    group_label: "  Filters"
    type: yesno
  }
  dimension: call_in_order_Flag {
    label: "Is Inside Sales Order"
    group_label: "  Filters"
    type: yesno
  }
  dimension: free_item {
    label: "Is Free Item (zero dollar)"
    group_label: "  Filters"
    type: yesno
  }
  dimension: mattress_flg {
    group_label: "  Order Flag"
    type: yesno
  }
  dimension: pillow_flg {
    group_label: "  Order Flag"
    type: yesno
  }
  dimension: sheets_flg {
    group_label: "  Order Flag"
    type: yesno
  }
  dimension: cushion_flg {
    group_label: "  Order Flag"
    type: yesno
  }
  dimension: category_name {
    label: "1. Category"
    group_label: "  Product Hierarchy"
    type: string
  }
  dimension: line_raw {
    label: "2. Line"
    group_label: "  Product Hierarchy"
    type: string
  }
  dimension: model_raw {
    label: "3. Model"
    group_label: "  Product Hierarchy"
    type: string
  }
  dimension: product_description_raw {
    label: "4. Name (product description)"
    group_label: "  Product Hierarchy"
    type: string
  }
  dimension: sku_id {
    label: "5. SKU"
    group_label: "  Product Hierarchy"
    type: string
  }
  dimension_group: order {
    group_label: "   Order Date"
    hidden:  no
    type:  time
    timeframes: [ date,week,month,quarter,year    ]
    convert_tz: no
    datatype: date
    sql:  ${TABLE}.created_date ;;
  }
  dimension: order_id {
    type: string
  }
  dimension: channel2 {
    label: "Channel"
    type:string
    sql: ${TABLE}.channel2 ;;
  }
  dimension: store_name {
    label: "Retail Store Location"
    type: string
    sql: ${TABLE}.store_name ;;
  }
  measure: gross_amt {
    label: "  Gross Sales ($)"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.total_gross_Amt_non_rounded ;;
  }
  measure: total_units {
    label: "  Gross Units (#)"
    value_format: "#,##0"
    type: sum
  }
  measure: orders {
    label: "  Orders"
    description: "Count of Distinct Orders"
    value_format: "#,##0"
    type: count_distinct
    sql: ${order_id} ;;
  }
  measure: gross_margin {
    label: " Margin ($)"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.gross_margin ;;
  }
  measure: adj_gross_amt {
    label: " Adjust Gross Sales ($)"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.adj_gross_amt ;;
  }
  measure: gm_rate {
    label: " Margin Rate"
    value_format: "0.0%"
    type: number
    sql: case when ${adj_gross_amt} > 0 then ${gross_margin}/${adj_gross_amt} end ;;
  }
  measure: aov {
    label: "AOV"
    description: "Average Order Value (gross sales/orders)"
    value_format: "$#,##0"
    type: number
    sql: ${gross_amt}/${orders} ;;
  }
  measure: amov {
    label: "AMOV"
    description: "Average Mattress Order Value (mattress orders: gross sales/orders)"
    value_format: "$#,##0"
    type: number
    sql: sum(${TABLE}.total_gross_Amt_non_rounded * case when ${mattress_flg} then 1 else 0 end)/ sum(case when ${mattress_flg} then 1 else 0 end) ;;
  }

}
