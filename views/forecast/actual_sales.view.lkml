view: actual_sales {
  derived_table: {
    publish_as_db_view: yes
    explore_source: sales_order_line {
      column: created_date {}
      column: ship_order_by_date { field: sales_order.ship_order_by_date}
      column: channel { field: sales_order.channel }
      column: source { field: sales_order.source }
      column: tranid { field: sales_order.tranid }
      column: firstname { field: customer_table.first_name }
      column: lastname { field: customer_table.last_name }
      column: companyname { field: customer_table.companyname }
      column: total_gross_Amt_non_rounded {}
      column: kit_item_id { field: item.kit_item_id }
      column: kit_sku_id { field: item.kit_sku_id }
      column: kit_total_units {}
      filters: {
        field: sales_order.channel
        value: ""
      }
      filters: {
        field: cancelled_order.is_cancelled
        value: "No"
      }
    }
    datagroup_trigger: pdt_refresh_6am
  }
  dimension: PK {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.created_date,${TABLE}.ship_order_by_date,${TABLE}.kit_item_id,${TABLE}.kit_sku_id, ${channel},${source},${TABLE}.tranid) ;;
  }
  dimension_group: created {
    hidden: yes
    label: "Sales Order     Order Date"
    description: "Time and date order was placed. Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created_date ;;
  }
  dimension_group: ship_order_by {
    hidden: yes
    label: "Fulfillment Ship by or Order Date"
    description: "Using ship by date unless blank then order date. Source: netsuite.sales_order"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.ship_order_by_date ;;
  }
  dimension: item_id {
    hidden: no
    label: "Product Item ID"
    description: "Source: netsuite.item"
    sql: ${TABLE}.kit_item_id ;;
  }
  dimension: sku_id {
    hidden: no
    label: "Product SKU ID"
    description: "SKU ID for item (XX-XX-XXXXXX). Source: netsuite.item"
    sql: ${TABLE}.kit_sku_id ;;
  }
  dimension: channel {
    hidden: yes
    label: "Sales Order Channel Filter"
  }
  dimension: tranid {
    hidden: yes
    label: "Transaction ID"
    group_label: " Advanced"
    description: "Netsuite's Sale Order Number
    Source: netsuite.sales_order"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{order_id._value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
    }
    type: string
    sql: ${TABLE}.TRANID ;;
  }
  dimension: first_name {
    hidden: yes
    group_label: "  Customer details"
    label: "First Name"
    description: "First name from netsuite. Source: netsuite.customers"
    type: string
    sql:  ${TABLE}.firstname;;
    required_access_grants:[can_view_pii]
  }
  dimension: last_name {
    hidden: yes
    group_label: "  Customer details"
    label: "Last Name"
    description: "Last name from netsuite. Source: netsuite.customers"
    type: string
    sql:  ${TABLE}.lastname ;;
    required_access_grants:[can_view_pii]
  }
  dimension: companyname {
    label: "Wholesale Customer Name"
    group_label: "  Wholesale"
    description: "Company Name from netsuite.
    Source:netsuite.customers"
    type: string
    sql: ${TABLE}.companyname ;;
  }
  dimension: full_name {
    hidden: yes
    group_label: " Advanced"
    label: "Customer Name"
    description: "Merging first and last name from netsuite then coalesce to company name. Source: netsuite.customers"
    type: string
    sql:  NVL(initcap(lower(${TABLE}.firstname))||' '||initcap(lower(${TABLE}.lastname)),${TABLE}.companyname);;
    required_access_grants:[can_view_pii]
  }
  dimension: gross_Amt_non_rounded {
    hidden: yes
    type: number
    sql:  ${TABLE}.total_gross_Amt_non_rounded ;;
  }
  dimension: units {
    hidden: yes
    type: number
    sql:  ${TABLE}.kit_total_units ;;
  }
  dimension: source {
    description: "System where order was placed. Source:netsuite.sales_order"
  }
  measure: total_gross_Amt_non_rounded {
    group_label: "Gross Sales"
    label:  "Gross Sales ($)"
    description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
    type: sum
    value_format: "$#,##0"
    sql:  ${gross_Amt_non_rounded} ;;
  }
  measure: total_gross_Amt_amazon {
    group_label: "Gross Sales"
    label:  "Gross Sales ($) Amazon"
    description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
    filters: [source: "Amazon-FBM-US, Amazon-FBA-US, Amazon-FBA-CA"]
    type: sum
    value_format: "$#,##0"
    sql:  ${gross_Amt_non_rounded} ;;
  }
  measure: total_gross_Amt_dtc {
    group_label: "Gross Sales"
    label:  "Gross Sales ($) DTC"
    description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
    filters: [channel: "DTC"]
    type: sum
    value_format: "$#,##0"
    sql:  ${gross_Amt_non_rounded} ;;
  }
  measure: total_gross_Amt_retail {
    group_label: "Gross Sales"
    label:  "Gross Sales ($) Retail"
    description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
    filters: [channel: "Owned Retail"]
    type: sum
    value_format: "$#,##0"
    sql:  ${gross_Amt_non_rounded} ;;
  }
  measure: total_gross_Amt_wholesale {
    group_label: "Gross Sales"
    label:  "Gross Sales ($) Wholesale"
    description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
    filters: [channel: "Wholesale"]
    type: sum
    value_format: "$#,##0"
    sql:  ${gross_Amt_non_rounded} ;;
  }
  measure: total_units {
    group_label: "Gross Sales"
    label:  "Gross Sales (units)"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    type: sum
    sql:  ${units} ;;
    drill_fields: [actual_sales.order_details]
  }
  measure: total_units_amazon {
    group_label: "Gross Sales"
    label:  "Gross Sales (units) Amazon"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    filters: [source: "Amazon-FBM-US, Amazon-FBA-US, Amazon-FBA-CA"]
    type: sum
    sql:  ${units} ;;
    drill_fields: [actual_sales.order_details_amazon]
  }
  measure: total_units_dtc {
    group_label: "Gross Sales"
    label:  "Gross Sales (units) DTC"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    filters: [channel: "DTC"]
    type: sum
    sql:  ${units} ;;
    drill_fields: [actual_sales.order_details_dtc]
  }
  measure: total_units_retail {
    group_label: "Gross Sales"
    label:  "Gross Sales (units) Owned Retail"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    filters: [channel: "Owned Retail"]
    type: sum
    sql:  ${units} ;;
    drill_fields: [actual_sales.order_details_owned_retail]
  }
  measure: total_units_wholesale {
    group_label: "Gross Sales"
    label:  "Gross Sales (units) Wholesale"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    filters: [channel: "Wholesale"]
    type: sum
    sql:  ${units} ;;
    drill_fields: [actual_sales.order_details_wholesale]
  }
  measure: total_sku_ids {
    hidden: yes
    type: count_distinct
    sql: ${sku_id} ;;
  }
  set: order_details {
    fields:[ship_order_by_date,created_date,tranid,full_name,units,gross_Amt_non_rounded]
  }
  set: order_details_amazon {
    fields:[ship_order_by_date,created_date,tranid,full_name,total_units_amazon,total_gross_Amt_amazon]
  }
  set: order_details_dtc {
    fields:[ship_order_by_date,created_date,tranid,full_name,total_units_dtc,total_gross_Amt_dtc]
  }
  set: order_details_owned_retail {
    fields:[ship_order_by_date,created_date,tranid,full_name,total_units_retail,total_gross_Amt_retail]
  }
  set: order_details_wholesale {
    fields:[ship_order_by_date,created_date,tranid,full_name,total_units_wholesale,total_gross_Amt_amazon]
  }
}
