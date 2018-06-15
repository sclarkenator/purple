view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  measure: Total_net_sales {
    type: sum
    sql:  ${TABLE}.net_amt ;;
  }

  #measure: Hours_to_fulfill {
   # description: "Hours between order placed and order fulfilled"
    #type: average
    #sql:  datediff(hour,${TABLE}.fulfilled_Date,${TABLE}.created_Date) ;;
#  }

  measure: Total_units {
    type: sum
    sql:  ${TABLE}.ordered_qty ;;
  }

  measure: Total_discounts {
    description: "Total discounts applied at time of order"
    type: sum
    sql:  ${TABLE}.discount_amt ;;
  }

  dimension: item_order{
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
    view_label: "ID Fields"
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

 dimension_group: created {
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
  datatype: date
  sql: ${TABLE}.Created ;;
}

  dimension: department_id {
    view_label: "ID Fields"
    hidden: yes
    description: "Internal department IDs (accounting)"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;;
  }

  dimension: discount_amt {
    description:  "Amount of discount applied at initial order"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;;
  }

  dimension: discount_cancel_type {
      hidden: yes
      type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;;
  }

  dimension: discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;;
  }

  dimension: estimated_cost {
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;;
  }

  dimension: etail_order_line_id {
    view_label: "ID Fields"
    label: "Shopify order line ID"
    description: "You can use this ID to look up orders in Shopify"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension_group: fulfilled {
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
    datatype: date
    sql: ${TABLE}.FULFILLED ;;
  }

  dimension: fulfillment_method {
    hidden: yes
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    view_label: "ID Fields"
    type: number
    hidden: yes
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: location {
    label:  "Source warehouse"
    type: string
    sql: ${TABLE}.LOCATION ;;
  }

  dimension: net_amt {
    label: "Net sales"
    description: "Net sales is what the customer paid on initial order, net of discounts, excluding tax, freight or other fees"
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    view_label: "ID Fields"
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: ordered_qty {
    description: "Units purchased"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;;
  }

  dimension: pre_discount_amt {
    label: "Pre-discounted price"
    description: "Price of item before any discounts or promotions are applied"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;;
  }

  dimension: refund_link_id {
    view_label: "ID Fields"
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
    hidden: yes
    label: "Source system"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: zip {
    group_label: "Address"
    view_label: "Customer info"
    type: zipcode
    sql: substr(${TABLE}.ZIP,1,5) ;;
  }

}
