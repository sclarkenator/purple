view: cancelled_order {
  sql_table_name: SALES.CANCELLED_ORDER ;;

  measure: units_cancelled {
    label: "Total cancelled (units)"
    description: "Total individual units cancelled"
    type:  sum
    sql:  ${TABLE}.cancelled_qty  ;; }

  measure: orders_cancelled {
    label: "Count of Orders Cancelled"
    description: "Count (#) of distinct orders with at least 1 item cancelled"
    type: count_distinct
    sql: ${order_id} ;; }

  measure: amt_cancelled {
    label:  "Total cancelled ($)"
    description: "Total USD amount of cancelled order, excluding taxes"
    type: sum
    sql: ${TABLE}.gross_amt ;; }

  dimension: yesterday_flag {
    hidden: yes
    label:  "Cancelled Yesterday"
    description: "Yes/No on if the order was cancelled yesterday"
    type: yesno
    sql: ${cancelled_date} = dateadd(d,-1,current_date) ;; }

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
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
    label: "Cancelled"
    description: "Date order was cancelled. Cancelled time is available for full-order cancellations."
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.CANCELLED) ;; }

  dimension: cancelled_order_type {
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
    hidden: yes
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: gross_amt {
    label:  "Total Cancelled ($)"
    description: "Total $ returned to customer (excluding shipping and freight)"
    type: number
    sql: ${TABLE}.gross_amt ;;}

  dimension: order_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: refunded {
    hidden: yes
    type: string
    sql: ${TABLE}.REFUNDED ;; }

  dimension: revenue_item {
    label:"Is Revenue Item"
    description:  "Yes/No; Yes for all product-specific refunds. No to just capture non-product (recycle-fee, freight, etc)"
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
    hidden:  yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: update_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

}
