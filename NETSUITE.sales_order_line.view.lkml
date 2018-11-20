view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  dimension: item_order{
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  measure: avg_cost {
    label:  "Avgerage Cost ($)"
    description:  "Average unit cost, only valid looking at item-level data"
    type: average
    value_format_name: decimal_2
    sql:  ${TABLE}.estimated_Cost ;; }

  measure: total_estimated_cost {
    label: "Estimated Costs ($)"
    description: "Estimated cost value from NetSuite for the cost of materials"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.estimated_Cost;; }

  measure: total_gross_Amt {
    label:  "Gross Sales ($0.k)"
    description:  "Total the customer paid, excluding tax and freight, in $K"
    type: sum
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt ;; }

  measure: total_gross_Amt_non_rounded {
    label:  "Gross Sales ($)"
    description:  "Total the customer paid, excluding tax and freight, in $"
    type: sum
    value_format: "$#,##0.00"
    sql:  ${TABLE}.gross_amt ;; }

  measure: gross_gross_Amt {
    hidden:  yes
    label:  "Gross-Gross Sales ($0.k)"
    description:  "Total the customer paid plus value of discounts they received, excluding tax and freight"
    type: sum
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt + ${TABLE}.discount_amt ;; }

  measure: total_discounts {
    label:  "Total Discounts ($)"
    description:  "Total of all applied discounts when order was placed"
    type: sum
    sql:  ${TABLE}.discount_amt ;; }

  measure: avg_days_to_fulfill {
    label: "Average Days to Fulfillment"
    description: "Average number of days between order and fulfillment"
    view_label: "Fulfillment"
    type:  average
    sql: datediff(day,${TABLE}.created,${TABLE}.fulfilled) ;; }

  measure: mf_fulfilled {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (old)"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive to Mattress Firm on time"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;; }

  measure: mf_units {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (units)"
    hidden: yes
    description: "How many items are there on the order to be shipped?"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;  }

  measure: mf_on_time {
    view_label: "Fulfillment"
    label: "Mattress Firm Shipped on Time (units%)"
    description: "Percent of units that  shipped out by the required ship-by date to arrive to Mattress Firm on time (mf fulfilled/mf units)"
    value_format_name: percent_0
    type: number
    sql: ${mf_fulfilled}/nullif(${mf_units},0) ;; }

  measure: whlsl_fulfilled {
    view_label: "Fulfillment"
    label: "Wholesale SLA (old)"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive on time"
    type: sum
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;; }

  measure: whlsl_units {
    view_label: "Fulfillment"
    label: "Wholesale SLA (units)"
    hidden: yes
    description: "How many items are there on the order to be shipped?"
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;; }

  measure: whlsl_on_time {
    view_label: "Fulfillment"
    label: "Wholesale Shipped on Time (unit%)"
    description: "Percent of units shipped out by the required ship-by date to arrive on time (Wholesale fulfilled/Wholesale units)"
    value_format_name: percent_0
    type: number
    sql: ${whlsl_fulfilled}/nullif(${whlsl_units},0) ;; }

  measure: fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "West Fulfillment SLA"
    hidden: yes
    description: "Was the order fulfilled from Purple West within 3 days of order (as per website)?"
    filters: {
      field: item.manna_fulfilled
      value: "No" }
    filters: {
      field: system
      value: "NETSUITE" }
    filters: {
      field: sales_order.channel_id
      value: "1" }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when ${TABLE}.fulfilled <= to_Date(dateadd(d,3,${TABLE}.created)) then ${ordered_qty} else 0 end ;; }

  measure: manna_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "Manna Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: item.manna_fulfilled
      value: "Yes" }
    filters: {
      field: system
      value: "NETSUITE" }
    filters: {
      field: sales_order.channel_id
      value: "1" }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when ${TABLE}.fulfilled <= to_Date(dateadd(d,14,${TABLE}.created)) then ${ordered_qty} else 0 end ;; }

  measure: amazon_ca_sales {
    label: "Amazon-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-CA' then ${TABLE}.gross_amt else 0 end ;; }

  measure: amazon_us_sales {
    label: "Amazon-US Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-US' then ${TABLE}.gross_amt else 0 end ;; }

  measure: shopify_ca_sales {
    label: "Shopify-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-CA' then ${TABLE}.gross_amt else 0 end ;; }

  measure: shopify_us_sales {
    label: "Shopify-US GrossAmount ($0.k)"
    description: "US Shopify gross sales as reported in Netsuite"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-US' then ${TABLE}.gross_amt else 0 end ;; }

  measure: unfulfilled_orders {
    label: "Unfulfilled Orders ($)"
    description: "Orders placed that have not been fulfilled"
    type: sum
    sql: case when ${fulfilled_date} is null and ${cancelled_order.cancelled_date} is null then ${gross_amt} else 0 end ;; }

  measure: unfulfilled_orders_units {
    label: "Unfulfilled Orders (units)"
    description: "Orders placed that have not been fulfilled"
    type: sum
    sql: case when ${fulfilled_date} is null and ${cancelled_order.cancelled_date} is null then ${ordered_qty} else 0 end ;; }

  measure: fulfilled_orders {
    label: "Fulfilled Orders ($)"
    description: "Orders placed that have been fulfilled"
    type: sum
    sql: case when ${fulfilled_date} is not null then ${gross_amt} else 0 end ;; }

  measure: fulfilled_orders_units {
    label: "Fulfilled Orders (units)"
    description: "Orders placed that have been fulfilled"
    type: sum
    sql: case when ${fulfilled_date} is not null then ${ordered_qty} else 0 end ;; }

  measure: SLA_eligible {
    label: "WEST SLA Eligible (3)"
    description: "Was this line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: item.manna_fulfilled
      value: "No" }
    filters: {
      field: system
      value: "NETSUITE" }
    filters: {
      field: sales_order.channel_id
      value: "1" }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_date(dateadd(d,3,${created_date})) then ${ordered_qty} else 0 end ;; }

  measure: manna_SLA_eligible {
    label: "Manna SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: item.manna_fulfilled
      value: "Yes" }
    filters: {
      field: system
      value: "NETSUITE" }
    filters: {
      field: sales_order.channel_id
      value: "1" }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_Date(dateadd(d,14,${created_date})) then ${ordered_qty} else 0 end ;; }

  measure: SLA_achieved{
    label: "West SLA Achievement (3 day %)"
    description: "Percent of line items fulfilled by Purple West within 3 days of order"
    view_label: "Fulfillment"
    type: number
    value_format_name: percent_0
    sql: case when datediff(day,${created_date},current_date) < 4 then null else ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) end ;; }

  measure: manna_sla_achieved{
    label: "Manna SLA Achievement (10 day %)"
    view_label: "Fulfillment"
    description: "Percent of line items fulfilled by Manna within 10 days of order"
    type: number
    value_format_name: percent_0
    sql: case when datediff(day,${created_date},current_date) > 10 then ${manna_fulfilled_in_SLA}/nullif(${manna_SLA_eligible},0) else null end ;; }

measure: total_line_item {
  label: "Total Line Items"
    description: "Total line items to fulfill"
    hidden: yes
    type: count_distinct
    sql:  ${item_order} ;; }

  measure: return_rate_units {
    label: "Return Rate (units%)"
    description: "Units returned/Units fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_1" }

  measure: return_rate_dollars {
    label: "Return Rate ($ %)"
    description: "Total $ returned / Total $ fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.total_gross_amt} / nullif(${total_gross_Amt},0) ;;
    value_format_name: "percent_1" }

  measure: total_units {
    label:  "Gross Sales (units)"
    description: "Total units purchased, before returns and cancellations"
    type: sum
    drill_fields: [order_id, created_date,  item.product_description, total_units]
    sql:  ${TABLE}.ordered_qty ;; }

  dimension: order_age_bucket {
    label: "Order Age (Bucket)"
    description: "Number of days between today and when order was placed (1,2,3,4,5,6,7,14)"
    type:  tier
    tiers: [1,2,3,4,5,6,7,14]
    style: integer
    sql: datediff(day,${created_date},current_date) ;; }


  dimension: manna_order_age_bucket {
    label: "Manna Order Age (Bucket)"
    description: "Number of days between today and when order was placed for Manna (7,14,21,28,35,42)"
    type:  tier
    tiers: [7,14,21,28,35,42]
    style: integer
    sql: datediff(day,${created_date},current_date) ;; }


  dimension: before_today_flag {
    label:  "Is Before Today"
    hidden: yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date}  < current_date ;; }

  dimension: yesterday_flag {
    label:  "Was Yesterday"
    hidden:  yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;; }

  dimension: free_item {
    label: "Is Promo Free Item"
    description: "Yes if this item is free" #with purchase of mattress
    type: yesno
    sql: ((${gross_amt} = ${discount_amt}) and ${discount_amt} <> 0) or (${gross_amt} = 0 and ${discount_amt} > 30)  ;; }

  dimension: order_system {
        type: string
    primary_key:  no
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: item_order_refund{
    type:  string
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: city {
    label: "City"
    group_label: "Customer Address"
    view_label: "Customer"
    hidden: yes
    type: string
    sql: ${TABLE}.CITY ;; }

  dimension: company_id {
    hidden: yes
    type: number
    sql: ${TABLE}.COMPANY_ID ;; }

  dimension: country {
    label: "Country"
    group_label: "Customer address"
    view_label: "Customer"
    hidden: yes
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;; }

  dimension: MTD_flg{
    label: "Is Before Today (mtd)"
    #view_label:  "x - report filters"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.Created < current_date and month(${TABLE}.Created) = month(dateadd(day,-1,current_date)) and year(${TABLE}.Created) = year(current_date) ;; }

  dimension: MTD_fulfilled_flg{
    label: "Is Before Today (mtd)"
    view_label: "Fulfillment"
    #view_label:  "x - report filters"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.fulfilled <= current_date and month(${TABLE}.fulfilled) = month(dateadd(day,-1,current_date)) and year(${TABLE}.fulfilled) = year(current_date) ;; }

  dimension_group: created {
    label: "Order"
    description:  "Time and date order was placed"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;; }

  dimension: day_of_week {
    hidden:  yes
    label:  "Day of Week"
    description: "Abbreviated day of week (Sun, Mon, Tue, etc)"
    type: string
    case: {
      when: { sql: ${created_day_of_week} = 'Sunday' ;; label: "Sun" }
      when: { sql: ${created_day_of_week} = 'Monday' ;; label: "Mon" }
      when: { sql: ${created_day_of_week} = 'Tuesday' ;;  label: "Tue" }
      when: { sql: ${created_day_of_week} = 'Wednesday' ;; label: "Wed" }
      when: { sql: ${created_day_of_week} = 'Thursday' ;; label: "Thu" }
      when: { sql: ${created_day_of_week} = 'Friday' ;; label: "Fri" }
      when: { sql: ${created_day_of_week} = 'Saturday' ;; label: "Sat" } } }

  parameter: timeframe_picker{
    label: "Date Granularity Sales"
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date" }

  dimension: dynamic_timeframe {
    type: date
    allow_fill: no
    sql:
      CASE
      When {% parameter timeframe_picker %} = 'Date' Then ${created_date}
      When {% parameter timeframe_picker %} = 'Week' Then ${created_week}
      When {% parameter timeframe_picker %} = 'Month'Then ${created_month}||'-01'
      END;; }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 7 ;; }

  dimension: 30_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 30 ;; }

  dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 60 ;; }

  dimension: 90_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 90 ;; }

  measure: 7_day_sales {
    label: "7 Day Average (units)"
    description: "Units ordered in the last 7 days /7"
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes" }
    sql: ${ordered_qty}/7 ;; }

  measure: 30_day_sales {
    label: "30 Day Average Sales (units)"
    description: "Units ordered in the last 30 days /30"
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 30_day_window
      value: "yes" }
    sql: ${ordered_qty}/30 ;; }

  measure: 60_day_sales {
    label: "60 Day Average Sales (units)"
    description: "Units ordered in the last 60 days /60"
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes" }
    sql: ${ordered_qty}/60 ;; }

  measure: 90_day_sales {
    label: "90 Day Average Sales (units)"
    description: "Units ordered in the last 90 days /90"
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 90_day_window
      value: "yes" }
    sql: ${ordered_qty}/90 ;; }

  dimension: rolling_7day {
    label: "Is in Last 7 Day"
    #view_label:  "x - report filters"
    hidden: yes
    description: "Filter to show just most recent 7 completed days"
    type: yesno
    sql: ${created_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;; }

  dimension:  4_week_filter {
    label: "Is in Last 4 Weeks"
    #view_label:  "x - report filters"
    hidden: yes
    type:  yesno
    sql: ${created_date} >=
      case when dayofweek(current_date) = 6 then dateadd(day,-27,current_date)
        when dayofweek(current_date) = 5 then dateadd(day,-26,current_date)
        when dayofweek(current_date) = 4 then dateadd(day,-25,current_date)
        when dayofweek(current_date) = 3 then dateadd(day,-24,current_date)
        when dayofweek(current_date) = 2 then dateadd(day,-23,current_date)
        when dayofweek(current_date) = 1 then dateadd(day,-22,current_date)
        else dateadd(day,-21,current_date) end   ;; }

  dimension: department_id {
    hidden: yes
    description: "Internal department IDs (accounting)"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;; }

  dimension: discount_amt {
    hidden: yes
    description:  "Amount of discount to individual items applied at initial order"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;; }

  dimension: discount_cancel_type {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;; }

  dimension: discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;; }

  dimension: estimated_cost {
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;; }

  dimension: etail_order_line_id {
    hidden:  yes
    label: "Shopify Order Line ID"
    description: "You can use this ID to look up orders in Shopify"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;; }

  dimension_group: fulfilled {
    view_label: "Fulfillment"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FULFILLED ;; }


  dimension: fulfillment_method {
    label: "Fulfillment Method"
    view_label: "Fulfillment"
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: location {
    label:  "Fulfillment Warehouse"
    description:  "Warehouse that order was fulfilled out of"
    view_label: "Fulfillment"
    type: string
    sql: ${TABLE}.LOCATION ;; }

  dimension: gross_amt {
    label: "Gross Sales ($)"
    description: "Gross sales is what the customer paid on initial order, net of discounts, excluding tax, freight or other fees"
    type: number
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_id {
    hidden: yes
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: ordered_qty {
    hidden: yes
    description: "Gross Sales (units)"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;; }

  dimension: pre_discount_amt {
    hidden:  yes
    label: "Pre-Discounted Price"
    description: "Price of item before any discounts or promotions are applied"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;; }

  dimension: refund_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;; }

  dimension: street_address {
    label: "Street Address"
    view_label: "Customer"
    group_label: "Customer Address"
    type: string
    sql: ${TABLE}.STREET_ADDRESS ;; }

  dimension: system {
    hidden: yes
    label: "Source System"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: tax_amt {
    type: number
    sql: ${TABLE}.TAX_AMT ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: zip {
    view_label: "Customer"
    group_label: "Customer Address"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: substr(${TABLE}.ZIP,1,5) ;; }

  dimension: carrier {
    view_label: "Fulfillment"
    label: "Pre-Fulfillment Expected Carrier"
    description: "From Netsuite sales order line, the carrier expected to deliver the item. May not be the actual carrier."
    hidden: yes
    type: string
    sql: ${TABLE}.CARRIER ;; }

  set: fulfill_details {
    fields: [order_id,item_id,created_date,fulfilled_date] }
}
