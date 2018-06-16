view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  measure: total_net_sales {
    view_label: "Order info"
    type: sum
    sql:  ${TABLE}.net_amt ;;
  }

  measure: Hours_to_fulfill {
    view_label: "Order info"
    description: "Hours between order placed and order fulfilled"
    drill_fields: [fulfill_details*]
    type: average
    sql:  datediff(hour,${TABLE}.created,${TABLE}.fulfilled) ;;
  }

  measure: return_rate {
    view_label: "Order info"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_2"
  }

  measure: total_units {
    view_label: "Order info"
    type: sum
    sql:  ${TABLE}.ordered_qty ;;
  }

  measure: Total_discounts {
    view_label: "Order info"
    description: "Total discounts applied at time of order"
    type: sum
    sql:  ${TABLE}.discount_amt ;;
  }

  measure: count_lines {
    view_label: "Order info"
    type: count
    drill_fields: [fulfill_details*]

  }

  dimension: item_order{
    view_label: "Order info"
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id ;;
  }

  dimension: city {
    group_label: "Address"
    view_label: "Customer info"
    hidden: yes
    type: string
    sql: ${TABLE}.CITY ;;
  }

  dimension: company_id {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.COMPANY_ID ;;
  }

  dimension: country {
    group_label: "Address"
    view_label: "Customer info"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
  }

dimension: MTD_flg{
  view_label: "Order info"
  type: yesno
  sql: ${TABLE}.Created <= current_date and month(${TABLE}.Created) = month(current_date) and year(${TABLE}.Created) = year(current_date) ;;
}

dimension: month {
  view_label: "Order info"
  label:  "Month order was placed"
    type:  date_month_name
    sql: ${TABLE}.created ;;
}


dimension_group: created {
  view_label: "Order info"
  label: "Order"
  description:  "Time and date order was placed"
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
  sql: to_timestamp_ntz(${TABLE}.Created) ;;
}

  dimension: department_id {
    view_label: "Order info"
    hidden: yes
    description: "Internal department IDs (accounting)"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;;
  }

  dimension: discount_amt {
    view_label: "Order info"
    description:  "Amount of discount applied at initial order"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;;
  }

  dimension: discount_cancel_type {
    view_label: "Order info"
    hidden: yes
      type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;;
  }

  dimension: discount_code {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;;
  }

  dimension: estimated_cost {
    view_label: "Order info"
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;;
  }

  dimension: etail_order_line_id {
    view_label: "Order info"
    label: "Shopify order line ID"
    description: "You can use this ID to look up orders in Shopify"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension_group: fulfilled {
    view_label: "Order info"
    description:  "Date order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
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
    sql: to_timestamp_ntz(${TABLE}.FULFILLED) ;;
  }

  dimension: mattress_trial_period {
    view_label: "Order info"
    type: tier
    tiers: [30,60,90,120]
    style: integer
    sql: datediff(day,${TABLE}.fulfilled,current_Date) ;;
  }

  dimension: fulfillment_method {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;;
  }

  dimension: insert_ts {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    view_label: "Order info"
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: location {
    view_label: "Order info"
    label:  "Source warehouse"
    type: string
    sql: ${TABLE}.LOCATION ;;
  }

  dimension: net_amt {
    view_label: "Order info"
    label: "Net sales"
    description: "Net sales is what the customer paid on initial order, net of discounts, excluding tax, freight or other fees"
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    view_label: "Order info"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: ordered_qty {
    view_label: "Order info"
    description: "Units purchased"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;;
  }

  dimension: pre_discount_amt {
    view_label: "Order info"
    label: "Pre-discounted price"
    description: "Price of item before any discounts or promotions are applied"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;;
  }

  dimension: refund_link_id {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;;
  }

  dimension: state {
    view_label: "Customer info"
    group_label: "Address"
    type: string
    sql: ${TABLE}.STATE ;;
  }

  dimension: street_address {
    view_label: "Customer info"
    group_label: "Address"
    hidden: yes
    type: string
    sql: ${TABLE}.STREET_ADDRESS ;;
  }

  dimension: system {
    view_label: "Order info"
    hidden: yes
    label: "Source system"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension: update_ts {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: zip {
    view_label: "Customer info"
    group_label: "Address"
    type: zipcode
    sql: substr(${TABLE}.ZIP,1,5) ;;
  }

  set: fulfill_details {
    fields: [order_id,company_id,created_date,fulfilled_date]
  }
}
