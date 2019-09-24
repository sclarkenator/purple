view: return_order_line {
  sql_table_name: (SELECT * FROM SALES.RETURN_ORDER_LINE WHERE system != 'SHOPIFY-US') ;;

  dimension: item_order{
    #primary_key:  yes
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

  measure: total_trial_returns_completed {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Trial Returns Completed (units)"
    description: "Trial returns completed and reimbursed"
    filters: {
      field: return_order.rma_return_type
      value: "Trial"}
    filters: {
      field: return_order.status
      value: "Refunded"}
    sql: ${TABLE}.return_qty ;;
    drill_fields: [return_order.return_ref_id, return_order.order_id, sales_order.created, return_order.created_date, return_order.return_completed]}

  measure: total_returns_completed_units {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Returns Completed (units)"
    description: "Trial returns completed and reimbursed"
    filters: {
      field: return_order.status
      value: "Refunded"}
    sql: ${TABLE}.return_qty ;;
    drill_fields: [return_order.return_ref_id, return_order.order_id, sales_order.created, return_order.created_date, return_order.return_completed]}

  measure: total_returns_completed_dollars {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Returns Completed ($)"
    description: "Returns completed and reimbursed, Trial and Non-trial"
    value_format: "$#,##0"
    filters: {
      field: return_order.status
      value: "Refunded"}
    sql: ${TABLE}.gross_amt ;;
    drill_fields: [return_order.return_ref_id, return_order.order_id, sales_order.created, return_order.created_date, return_order.return_completed]}

  measure: total_trial_returns_completed_dollars {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Trial Returns Completed ($)"
    description: "Trial returns completed and reimbursed"
    value_format: "$#,##0"
    filters: {
      field: return_order.rma_return_type
      value: "Trial"}
    filters: {
      field: return_order.status
      value: "Refunded"}
    sql: ${TABLE}.gross_amt ;;
    drill_fields: [return_order.return_ref_id, return_order.order_id, sales_order.created, return_order.created_date, return_order.return_completed]}

  measure: total_non_trial_returns_completed_dollars {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Non-trial Returns Completed ($)"
    description: "Non-trial returns completed and reimbursed"
    value_format: "$#,##0"
    filters: {
      field: return_order.rma_return_type
      value: "Non Trial"}
    filters: {
      field: return_order.status
      value: "Refunded"}
    sql: ${TABLE}.gross_amt ;;
    drill_fields: [return_order.return_ref_id, return_order.order_id, sales_order.created, return_order.created_date, return_order.return_completed]}


  measure: total_trial_returns_completed_within_60_days {
    type: sum
    hidden: no
    group_label: "Return Amounts"
    label: "Total Trial Returns Completed within 60 Days (units)"
    description: "Trial returns completed within 60 days of fulfillment"
    ##sql: case when ${return_order.status} = "Refunded"
    ##      and ${return_order.rma_return_type} = "Trial"
    ##      and ${return_order.days_from_fulfillment_to_complete_return} <=60 then ${TABLE}.return_qty
    ##    else 0 end;;
    filters: {
      field: return_order.rma_return_type
      value: "Trial"}
    filters: {
      field: return_order.status
      value: "Refunded"}
    filters: {
      field: return_order.days_from_fulfillment_to_complete_return
      value: "<=60"}
    sql: ${TABLE}.return_qty ;;
  }

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

  measure: total_gross_amt_1 {
    group_label: "Return Amounts"
    label:  "Total Returns ($)"
    description: "Total $ returned, excluding tax and freight"
    type: sum
    value_format: "$#,##0"
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
    group_label: "Return Aging Buckets"
    label: "30"
    description: "What aging bucket the order was returned in (30,60,90,120)"
    type: tier
    style: integer
    tiers: [30,60,90,120]
    sql: datediff(day,${fulfillment.fulfilled_F_date},${return_order.created_raw}) ;; }

  dimension: days_between_buckets_extended{
    group_label: "Return Aging Buckets"
    label: "60"
    description: "What aging bucket the order was returned in (60,120,180,240,300,360)"
    type: tier
    style: integer
    tiers: [60,120,180,240,300,360]
    sql: datediff(day,${fulfillment.fulfilled_F_date},${return_order.created_raw}) ;; }

  dimension: days_between_week_buckets{
    group_label: "Return Aging Buckets"
    label: "07"
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

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID||${TABLE}.item_id ;; }

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
    label: "Return Shipment Recieved"
    description: "Date when the returned item was recieved by Purple"
    #hidden: yes
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

#   measure: total_restocked {
#     type: sum
#     label: "Total Restocked (units)"
#     description: "Number of units returned and added back to inventory"
# #     filters: {
# #       field: receipt_restock.do_restock
# #       value: "Yes"
# #     }
#     sql: case when ${receipt_restock.do_restock} = 'Yes' then ${receipt_restock.item_count}
#           else 0 end;;
#   }

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
