view: cancelled_order {
  sql_table_name: SALES.CANCELLED_ORDER ;;

  measure: units_cancelled {
    label: "      Cancelled Orders (units)"
    description: "Total individual units cancelled"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.cancelled_qty  ;; }

  measure: orders_cancelled {
    label: "      Cancelled Orders (count)"
    description: "Count (#) of distinct orders with at least 1 item cancelled"
    drill_fields: [sales_order_line.sales_order_details*]
    type: count_distinct
    sql: ${order_id} ;; }

  measure: orders_cancelled_and_refunded {
    label: "Cancelled and Refunded Orders (count)"
    description: "Count (#) of distinct orders with at least 1 item cancelled where a refund has been given"
    type: count_distinct
    filters: {
      field: refunded
      value: "Yes"
    }
    sql: ${order_id} ;;
    hidden:yes}

  measure: amt_cancelled {
    label:  "      Cancelled Orders ($)"
    description: "Total USD amount of cancelled order, excluding taxes"
    drill_fields: [sales_order_line.sales_order_details*]
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  dimension: is_cancelled {
    label:  "     * Is Cancelled"
    description: "Whether the order was cancelled"
    type: yesno
    sql: ${cancelled_date} is not NULL ;; }

  measure: amt_cancelled_and_refunded {
    label:  "Total Cancellations Completed ($)"
    hidden: yes
    description: "Total USD amount of cancelled order, excluding taxes, where a refund has been given"
    type: sum
    value_format: "$#,##0.00"
    filters: {
      field: refunded
      value: "Yes"
    }
    sql: ${TABLE}.gross_amt ;; }

  measure: qty_cancelled_and_refunded {
    label:  "Total Cancellations Completed (units)"
    description: "Total quantity of cancelled units where a refund has been given"
    type: sum
    hidden: yes
    filters: {
      field: refunded
      value: "Yes"
    }
    sql: ${TABLE}.cancelled_qty ;; }

  dimension: days_since_cancellation_buckets {
    description: "Rolling date bins, to compare cancellations at different time intervals"
    sql: case when ${cancelled_date} <= dateadd('day', -1, current_date()) and ${cancelled_date} > dateadd('day', -31, current_date())
            then '30 Days'
          when ${cancelled_date} <= dateadd('day', -31, current_date()) and ${cancelled_date} > dateadd('day', -61, current_date())
            then '30-60 Days'
          when ${cancelled_date} <= dateadd('day', -61, current_date())
            then '60+ Days'
          else 'Today' end
        ;;
    hidden: yes
  }

  dimension: yesterday_flag {
    hidden: yes
    label:  "Cancelled Yesterday"
    description: "Yes if the order was cancelled yesterday"
    type: yesno
    sql: ${cancelled_date} = dateadd(d,-1,current_date) ;; }

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
    type: string
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${cancelled_date},dateadd(d,-1,current_date)) < 7 ;; }

 dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${cancelled_date},dateadd(d,-1,current_date)) < 60 ;; }

  measure: 7_day_sales {
    hidden: yes
    description: "7-day average daily cancelled $"
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes"
    }
    sql: ${gross_amt}/7 ;; }

  measure: 60_day_sales {
    hidden: yes
    label: "Total 60 Day Cancelled Sales"
    #description: "60-day average daily cancelled $"
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes"
    }
    sql: ${gross_amt}/60 ;; }

  dimension_group: cancelled {
    label: "   Cancelled"
    description: "Date order was cancelled. Cancelled time is available for full-order cancellations."
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.CANCELLED) ;; }

  dimension: cancelled_order_type {
    group_label: "Advanced"
    view_label: "Cancellations"
    label:  "Cancellation Type"
    description:  "Full order or partial order"
    type: string
    sql: ${TABLE}.CANCELLED_ORDER_TYPE ;; }

  dimension: cancelled_qty {
    hidden:  yes
    type: number
    sql: ${TABLE}.CANCELLED_QTY ;; }

  dimension: channel_id {
    label: "Cancelled Channel ID"
    description: "Channel ID for orders that have been cancelled"
    hidden:  yes
    type: number
    sql: ${TABLE}.CHANNEL_ID ;; }

  dimension: full_cancelled_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.FULL_CANCELLED_TS ;; }

  dimension: insert_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_id {
    type: number
    #hidden: yes
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: gross_amt {
    label:  "Total Cancelled ($)"
    description: "Total $ returned to customer, excluding shipping and freight"
    type:  number
    group_label: "Advanced"
    sql: ${TABLE}.gross_amt ;;}

  dimension: gross_amt_tier {
    label:  "Total Cancelled (bucket)"
    description: "Total $ returned to customer, excluding shipping and freight (0,1,100,500,1000,1500,2000,2500,3000,3500,4000,4500,5000)"
    type: tier
    style:  integer
    group_label: "Advanced"
    tiers: [0,1,100,500,1000,1500,2000,2500,3000,3500,4000,4500,5000]
    sql: ${TABLE}.gross_amt ;;}

  dimension: order_id {
    #hidden:  yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: refunded {
    description: "Yes if cancellation was completed and customer's money was refunded"
    type: string
    sql: ${TABLE}.REFUNDED ;;
    hidden:yes}

  dimension: revenue_item {
    label:"Is Revenue Item"
    hidden: yes
    description:  "Yes for all product-specific refunds. No to just capture non-product (recycle-fee, freight, etc)"
    type: string
    sql: ${TABLE}.REVENUE_ITEM ;;
  }

  dimension: shopify_cancel_reason_id {
    label: "Cancellation Reason"
    hidden:  yes
    type: number
    sql: ${TABLE}.SHOPIFY_CANCEL_REASON_ID ;; }

  dimension: shopify_discount_code {
    hidden:  yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;; }

  dimension: system {
    #hidden:  yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: update_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

}
