view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  dimension: item_order{
    view_label: "Sales info"
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  measure: total_gross_Amt {
    view_label: "Sales info"
    label:  "Gross sales ($)"
    description:  "Total the customer paid, excluding tax and freight, in $K"
    type: sum
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: total_gross_Amt_non_rounded {
    view_label: "Sales info"
    label:  "Gross sales ($) Non-Rounded"
    description:  "Total the customer paid, excluding tax and freight, in $"
    type: sum
    value_format: "$#,##0.00"
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: gross_gross_Amt {
    view_label: "Sales info"
    hidden:  yes
    label:  "Gross-gross sales ($)"
    description:  "Total the customer paid plus value of discounts they received, excluding tax and freight"
    type: sum
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt + ${TABLE}.discount_amt ;;
  }

  measure: total_discounts {
    view_label: "Sales info"
    label:  "Total discounts ($)"
    description:  "Total of all applied discounts when order was placed"
    type: sum
    sql:  ${TABLE}.discount_amt ;;
  }

  measure: avg_days_to_fulfill {
    view_label: "Fulfillment details"
    description: "Average number of days between order and fulfillment"
    type:  average
    sql: datediff(day,${TABLE}.created,${TABLE}.fulfilled) ;;
  }

#  measure: med_days_to_fulfill {
#    view_label: "Sales info"
#    description: "Average number of days between order and fulfillment"
#    type:  median
#    sql: datediff(day,${TABLE}.created,${TABLE}.fulfilled) ;;
#  }

  measure: mf_fulfilled {
    view_label: "Fulfillment details"
    label: "MF SLA"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive to Mattress Firm on time"
    filters: {
      field: sales_order.customer_id
      value: "2662"
    }
    type: sum
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;;
  }

  measure: mf_units {
    view_label: "Fulfillment details"
    label: "MF SLA"
    hidden: yes
    description: "How many items are there on the order to be shipped?"
    filters: {
      field: sales_order.customer_id
      value: "2662"
    }
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: mf_on_time {
    view_label: "Fulfillment details"
    label: "MF shipped on-time"
    description: "Was the order shipped out by the required ship-by date to arrive to Mattress Firm on time"
    value_format_name: percent_0
    type: number
    sql: ${mf_fulfilled}/nullif(${mf_units},0) ;;
  }

  measure: fulfilled_in_SLA {
    view_label: "Fulfillment details"
    label: "WEST - Fulfillment SLA"
    hidden: yes
    description: "Was the order fulfilled from Purple West within 3 days of order (as per website)?"
    filters: {
      field: item.manna_fulfilled
      value: "No"
    }
    filters: {
      field: system
      value: "NETSUITE"
    }
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when datediff(day,${TABLE}.created,${TABLE}.fulfilled) < 5 then ${ordered_qty} else 0 end ;;
  }

  measure: manna_fulfilled_in_SLA {
    view_label: "Fulfillment details"
    label: "Manna - Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 10 days of order (as per website)?"
    filters: {
      field: item.manna_fulfilled
      value: "Yes"
      }
    filters: {
      field: system
      value: "NETSUITE"
      }
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when datediff(day,${TABLE}.created,${TABLE}.fulfilled) < 11 then ${ordered_qty} else 0 end ;;
  }

  measure: amazon_ca_sales {
    view_label: "Sales info"
    description: "used to generate the sales by channel report"
    label: "Amazon-CA gross"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: amazon_us_sales {
    view_label: "Sales info"
    description: "used to generate the sales by channel report"
    label: "Amazon-US gross"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_ca_sales {
    view_label: "Sales info"
    description: "used to generate the sales by channel report"
    label: "Shopify-CA sales"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_us_sales {
    view_label: "Sales info"
    description: "US Shopify gross sales as reported in Netsuite"
    label: "Shopify-US gross"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: SLA_eligible {
    view_label: "Fulfillment details"
    label: "WEST SLA eligible"
    hidden: yes
    description: "Was this line item available to fulfill (not cancelled) within the SLA window?"
     filters: {
      field: item.manna_fulfilled
      value: "No"
    }
    filters: {
      field: system
      value: "NETSUITE"
    }
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or ${cancelled_order.cancelled_date} > dateadd(d,3,${created_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: manna_SLA_eligible {
    view_label: "Fulfillment details"
    label: "Manna SLA eligible"
    hidden: yes
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
     filters: {
      field: item.manna_fulfilled
      value: "Yes"
    }
    filters: {
      field: system
      value: "NETSUITE"
    }
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or ${cancelled_order.cancelled_date} > dateadd(d,10,${created_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: SLA_achieved{
    label: "West SLA achievement"
    view_label: "Fulfillment details"
    description: "% of line items fulfilled by Purple West within 3 days of order"
    type: number
    value_format_name: percent_0
    sql: case when datediff(day,${created_date},current_date) < 4 then null else ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) end ;;
  }

  measure: manna_sla_achieved{
    label: "Manna SLA achievement"
    view_label: "Fulfillment details"
    description: "% of line items fulfilled by Manna within 10 days of order"
    type: number
    value_format_name: percent_0
    sql: case when datediff(day,${created_date},current_date) > 10 then ${manna_fulfilled_in_SLA}/nullif(${manna_SLA_eligible},0) else null end ;;
  }

measure: total_line_item {
    description: "Total line items to fulfill"
    view_label: "Sales info"
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
    drill_fields: [sales_order.order_id, created_date, item.product_line_name, total_units]
  }

  dimension: order_age_bucket {
    view_label: "Sales info"
    description: "Number of days between today and when order was placed"
    type:  tier
    tiers: [3,4,6,10,15,20]
    style: integer
    sql: datediff(day,${created_date},current_date) ;;
  }

  dimension: before_today_flag {
    label:  "before today flag"
    hidden: yes
    view_label:  "x - report filters"
    type: yesno
    sql: ${created_date}  < current_date ;;
  }

  dimension: yesterday_flag {
    label:  "Yesterday-sales"
    hidden:  yes
    view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;;
  }

  dimension: free_item {
    label: "Promo free item"
    description: "Was this item free with purchase of mattress"
    view_label:  "x - report filters"
    type: yesno
    sql: ((${gross_amt} = ${discount_amt}) and ${discount_amt} <> 0) or (${gross_amt} = 0 and ${discount_amt} > 30)  ;;
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
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;;
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
    sql: ${TABLE}.Created < current_date and month(${TABLE}.Created) = month(dateadd(day,-1,current_date)) and year(${TABLE}.Created) = year(current_date) ;;
  }

  dimension: MTD_fulfilled_flg{
    view_label:  "x - report filters"
    description: "This field is for formatting on MTD reports"
    type: yesno
    sql: ${TABLE}.fulfilled <= current_date and month(${TABLE}.fulfilled) = month(dateadd(day,-1,current_date)) and year(${TABLE}.fulfilled) = year(current_date) ;;
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
      month_num,
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

  dimension: day_of_week {
    hidden:  yes
    view_label: "Sales info"
    label:  "Day of week"
    description: "abbreviated day of week"
    type: string
    case: {
      when: {
        sql: ${created_day_of_week} = 'Sunday' ;;
        label: "Sun"
      }

      when: {
        sql: ${created_day_of_week} = 'Monday' ;;
        label: "Mon"
      }

      when: {
        sql: ${created_day_of_week} = 'Tuesday' ;;
        label: "Tue"
      }

      when: {
        sql: ${created_day_of_week} = 'Wednesday' ;;
        label: "Wed"
      }

      when: {
        sql: ${created_day_of_week} = 'Thursday' ;;
        label: "Thu"
      }

      when: {
        sql: ${created_day_of_week} = 'Friday' ;;
        label: "Fri"
      }

      when: {
        sql: ${created_day_of_week} = 'Saturday' ;;
        label: "Sat"
      }
    }
  }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 7 ;;
  }

  dimension: 30_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 30 ;;
  }

  dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 60 ;;
  }

  dimension: 90_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 90 ;;
  }

  measure: 7_day_sales {
    description: "7-day average daily units"
    view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes"
    }
    sql: ${ordered_qty}/7 ;;
  }

  measure: 30_day_sales {
    description: "30-day average daily units"
    view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 30_day_window
      value: "yes"
    }
    sql: ${ordered_qty}/30 ;;
  }

  measure: 60_day_sales {
    description: "60-day average daily units"
    view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes"
    }
    sql: ${ordered_qty}/60 ;;
  }

  measure: 90_day_sales {
    description: "90-day average daily units"
    view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 90_day_window
      value: "yes"
    }
    sql: ${ordered_qty}/90 ;;
  }

  dimension: rolling_7day {
    view_label:  "x - report filters"
    description: "Filter to show just most recent 7 completed days"
    type: yesno
    sql: ${created_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;
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
    view_label: "Fulfillment details"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
    type: time
    timeframes: [
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

  dimension: fulfillment_method {
    view_label: "Fulfillment details"
    hidden: no
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
    view_label: "Fulfillment details"
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
    fields: [order_id,item_id,created_date,fulfilled_date]
  }
}
