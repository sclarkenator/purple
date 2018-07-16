view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  measure: total_gross_Amt {
    view_label: "Sales info"
    label:  "Gross sales ($)"
    description:  "Total the customer paid, excluding tax and freight"
    type: sum
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: fulfilled_in_SLA {
    view_label: "Sales info"
    hidden: no
    description: "Was order fulfilled within 5 days?"
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when datediff(day,${TABLE}.created,${TABLE}.fulfilled) < 6 and (${cancelled_order.cancelled_date} is null or datediff(day,${TABLE}.created,${cancelled_order.cancelled_date}) > 5) then 1 else 0 end ;;
  }

  measure: SLA_eligible {
    view_label: "Sales info"
    hidden: no
    description: "Was this line item cancelled within the SLA window?"
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or ${cancelled_order.cancelled_date} < dateadd(d,5,${created_date}) then 1 else 0 end ;;

  }

  measure: SLA_achieved{
    label: "SLA achieved"
    view_label: "Sales info"
    description: "% of line items fulfilled within 5 days of order"
    type: number
    value_format_name: percent_0
    sql: ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) ;;
  }

  dimension: sla_filter {
    label: "30-day SLA filter"
    view_label: "x - report filters"
    description: "Filter to keep days within SLA window suppressed in visualization"
    type: yesno
    sql: ${created_date} < dateadd(day,-5,current_date) and ${created_date} > dateadd(day,-35,current_date);;
  }

  measure: total_line_item {
    description: "Total line items to fulfill"
    hidden: yes
    type: count_distinct
    sql:  ${item_order} ;;
  }

  measure: return_rate_units {
    view_label: "Returns info"
    label: "Return rate (units)"
    description: "Units returned/Units fulfilled"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_1"
  }

  measure: return_rate_dollars {
    view_label: "Returns info"
    label: "Return rate ($)"
    description: "Total $ returned / Total $ fulfilled"
    type: number
    sql: ${return_order_line.total_gross_amt} / nullif(${total_gross_Amt},0) ;;
    value_format_name: "percent_1"
  }

  measure: total_units {
    view_label: "Sales info"
    label:  "Gross sales (units)"
    description: "Total units purchased, before returns and cancellations"
    type: sum
    sql:  ${TABLE}.ordered_qty ;;
  }

  measure: Total_discounts {
    view_label: "Sales info"
    description: "Total discounts applied at time of order"
    type: sum
    sql:  ${TABLE}.discount_amt ;;
  }

  dimension: before_today_flag {
    label:  "before today flag"
    view_label:  "x - report filters"
    type: yesno
    sql: ${created_date}  < current_date ;;
  }

  dimension: yesterday_flag {
    label:  "Yesterday-sales"
    view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;;
  }

  dimension: item_order{
    view_label: "Sales info"
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: order_system {
    view_label: "Sales info"
    type: string
    primary_key:  no
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: item_order_refund{
    type:  string
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||${TABLE}.refund_link_id||'-'||${TABLE}.system ;;
  }

  dimension: city {
    group_label: "Customer address"
    view_label: "Customer info"
    hidden: yes
    type: string
    sql: ${TABLE}.CITY ;;
  }

  dimension: company_id {
    view_label: "Sales info"
    hidden: yes
    type: number
    sql: ${TABLE}.COMPANY_ID ;;
  }

  dimension: country {
    group_label: "Customer address"
    view_label: "Customer info"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
  }

  dimension: MTD_flg{
    view_label:  "x - report filters"
    description: "This field is for formatting on MTD reports"
    type: yesno
    sql: ${TABLE}.Created <= current_date and month(${TABLE}.Created) = month(current_date) and year(${TABLE}.Created) = year(current_date) ;;
  }

  dimension: MTD_fulfilled_flg{
    view_label:  "x - report filters"
    description: "This field is for formatting on MTD reports"
    type: yesno
    sql: ${TABLE}.fulfilled <= current_date and month(${TABLE}.fulfilled) = month(current_date) and year(${TABLE}.fulfilled) = year(current_date) ;;
  }

  dimension_group: created {
    view_label: "Sales info"
    label: "Order"
    description:  "Time and date order was placed"
    type: time
    timeframes: [
      hour_of_day,
      day_of_month,
      month_name,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;;
  }

  dimension: rolling_7day {
    view_label:  "x - report filters"
    description: "Filter to show just most recent 7 completed days"
    type: yesno
    sql: ${created_date} between dateadd(d,-8,current_date) and dateadd(d,-1,current_date)  ;;
  }

  dimension:  4_week_filter {
    view_label:  "x - report filters"
    type:  yesno
    sql: ${created_date} >=
                case when dayofweek(current_date) = 6 then dateadd(day,-27,current_date)
                 when dayofweek(current_date) = 5 then dateadd(day,-26,current_date)
                 when dayofweek(current_date) = 4 then dateadd(day,-25,current_date)
                 when dayofweek(current_date) = 3 then dateadd(day,-24,current_date)
                 when dayofweek(current_date) = 2 then dateadd(day,-23,current_date)
                 when dayofweek(current_date) = 1 then dateadd(day,-22,current_date)
                 else dateadd(day,-21,current_date) end   ;;
        }

  dimension: department_id {
    view_label: "Sales info"
    hidden: yes
    description: "Internal department IDs (accounting)"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;;
  }

  dimension: discount_amt {
    view_label: "Sales info"
    hidden: yes
    description:  "Amount of discount to individual items applied at initial order"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;;
  }

  dimension: discount_cancel_type {
    view_label: "Sales info"
    hidden: yes
      type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;;
  }

  dimension: discount_code {
    view_label: "Sales info"
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;;
  }

  dimension: estimated_cost {
    view_label: "Sales info"
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;;
  }

  dimension: etail_order_line_id {
    hidden:  yes
    view_label: "Sales info"
    label: "Shopify order line ID"
    description: "You can use this ID to look up orders in Shopify"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension_group: fulfilled {
    view_label: "Sales info"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
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
    view_label: "Sales info"
    description:  "Aging buckets for trial return period"
    hidden: yes
    type: tier
    tiers: [30,60,90,120]
    style: integer
    sql: datediff(day,${TABLE}.fulfilled,current_Date) ;;
  }

  dimension: fulfillment_method {
    view_label: "Sales info"
    hidden: yes
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;;
  }

  dimension: insert_ts {
    view_label: "Sales info"
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    hidden:  yes
    view_label: "Sales info"
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: location {
    view_label: "Sales info"
    label:  "Fulfillment warehouse"
    description:  "Warehouse that order was fulfilled out of"
    type: string
    sql: ${TABLE}.LOCATION ;;
  }

  dimension: gross_amt {
    hidden: no
    view_label: "Sales info"
    label: "Gross sales ($)"
    description: "Gross sales is what the customer paid on initial order, net of discounts, excluding tax, freight or other fees"
    type: number
    sql: ${TABLE}.gross_amt ;;
  }

  dimension: order_id {
    hidden: yes
    view_label: "Sales info"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: ordered_qty {
    hidden: yes
    view_label: "Sales info"
    description: "Gross sales (units)"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;;
  }

  dimension: pre_discount_amt {
    hidden:  yes
    view_label: "Sales info"
    label: "Pre-discounted price"
    description: "Price of item before any discounts or promotions are applied"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;;
  }

  dimension: refund_link_id {
    view_label: "Sales info"
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;;
  }

  dimension: state {
    view_label: "Customer info"
    group_label: "Customer address"
    map_layer_name: us_states
    type: string
    sql: ${sf_zipcode_facts.state} ;;
  }

  dimension: street_address {
    view_label: "Customer info"
    group_label: "Customer address"
    type: string
    sql: ${TABLE}.STREET_ADDRESS ;;
  }

  dimension: system {
    view_label: "Sales info"
    hidden: yes
    label: "Source system"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    view_label: "Sales info"
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension: update_ts {
    view_label: "Sales info"
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: zip {
    view_label: "Customer info"
    group_label: "Customer address"
    type: zipcode
    sql: substr(${TABLE}.ZIP,1,5) ;;
  }

  set: fulfill_details {
    fields: [order_id,company_id,created_date,fulfilled_date]
  }
}
