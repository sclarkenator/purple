view: return_order_line {
  sql_table_name: SALES.RETURN_ORDER_LINE ;;

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  measure: units_returned {
    group_label: "Return Amounts"
    label: "Total Returns (units)"
    description: "Total individual items returned"
    type: sum
    sql: ${TABLE}.return_qty ;; }

  measure: trial_units_returned {
    group_label: "Return Amounts"
    label: "Total Trial Returns (units)"
    description: "Total individual items returned as a trial return"
    type: sum
    filters: {
      field: return_order.rma_return_type
      value: "Trial" }
    sql: ${TABLE}.return_qty ;; }

  measure: average_gross_return {
    label: "Average Gross Returns"
    type: average
    sql: ${TABLE}.gross_amt ;; }

  measure: total_gross_amt {
    group_label: "Return Amounts"
    label:  "Total Returns ($0.k)"
    description: "Total $ returned, excluding tax and freight"
    type: sum
    value_format: "0,\" K\""
    sql: ${TABLE}.gross_amt ;; }

  measure: days_between {
    label: "Average Days Between"
    description: "Average number of days between fulfillment and return"
    type: average
    sql: datediff(day,${return_order.customer_receipt_date},${return_order.created_raw}) ;; }

  dimension: days_between_dimension {
    label: "Return Window (days)"
    description: "How many days until product return was initiated?"
    type: number
    sql: datediff(day,${return_order.customer_receipt_date},${return_order.created_raw}) ;; }

  dimension: days_between_buckets {
    label: "Return Aging Buckets (30)"
    description: "What aging bucket the order was returned in (30,60,90,120)"
    type: tier
    style: integer
    tiers: [30,60,90,120]
    sql: datediff(day,${return_order.customer_receipt_date},${return_order.created_raw}) ;; }

  dimension: days_between_week_buckets{
    label: "Return Aging Buckets (7)"
    description: "What aging bucket the order was returned in (7,14,21,28,35,42,49,56)"
    type: tier
    style: integer
    tiers: [7,14,21,28,35,42,49,56]
    sql: datediff(day,${return_order.customer_receipt_date},${return_order.created_raw})   ;; }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${return_order.created_raw},dateadd(d,-1,current_date)) < 7 ;; }

  dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${return_order.created_raw},dateadd(d,-1,current_date)) < 60 ;;
  }

  measure: 7_day_sales {
    hidden: yes
    #label: "7 Day Sales ($)"
    #description: "7 day average daily cancelled $"
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes" }
    sql: ${gross_amt}/7 ;; }

  measure: 60_day_sales {
    hidden:  yes
    #description: "60-day average daily cancelled $"
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes" }
    sql: ${gross_amt}/60 ;; }

  dimension: allow_discount_removal {
    hidden: yes
    type: string
    sql: ${TABLE}.ALLOW_DISCOUNT_REMOVAL ;; }

  dimension: auto_invoice_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}.AUTO_INVOICE_TYPE_ID ;; }

  dimension_group: closed {
    hidden:  yes
    label: "Return"
    type: time
    timeframes: [ raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CLOSED ;; }

  dimension: cost_estimate_type {
    hidden: yes
    type: string
    sql: ${TABLE}.COST_ESTIMATE_TYPE ;; }

  dimension: created_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED_TS ;; }

  dimension: department_id {
    hidden: yes
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: item_received {
    hidden: yes
    type: string
    sql: ${TABLE}.ITEM_RECEIVED ;; }

  dimension: line_shipping_method_id {
    hidden: yes
    type: number
    sql: ${TABLE}.LINE_SHIPPING_METHOD_ID ;; }

  dimension: location_id {
    hidden: yes
    type: number
    sql: ${TABLE}.LOCATION_ID ;; }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: gross_amt {
    label: "Gross Amount ($)"
    description: "Net amount ($) being returned"
    type: number
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: price_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PRICE_TYPE_ID ;; }

  dimension: product_line_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PRODUCT_LINE_ID ;; }

  dimension: quantity_received_in_shipment {
    #label: "Received quantity"
    hidden:  yes
    type: number
    sql: ${TABLE}.QUANTITY_RECEIVED_IN_SHIPMENT ;; }

  dimension: return_order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID ;; }

  dimension: return_qty {
    label: "Quantity Returned (units)"
    description:  "Total units returned"
    type: number
    sql: ${TABLE}.RETURN_QTY ;; }

  dimension: revenue_item {
    label: "Is Revenue Item"
    description: "Yes if return amount tied to a revenue item"
    type: yesno
    sql: ${TABLE}.REVENUE_ITEM ;; }

  dimension_group: shipment_received {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIPMENT_RECEIVED ;; }

  dimension: transaction_discount_line {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_DISCOUNT_LINE ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      return_order.return_order_id,
      item.item_id,
      item.model_name,
      item.category_name,
      item.sub_category_name,
      item.product_line_name,
      product_line.product_line_id] }

}
