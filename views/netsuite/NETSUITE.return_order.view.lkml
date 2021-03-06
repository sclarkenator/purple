view: return_order {
  sql_table_name: SALES.RETURN_ORDER ;;

  dimension: primary_key
  {
    primary_key:  yes
    type: string
    sql: NVL(${TABLE}.return_order_id,0)||NVL(${TABLE}.order_id,0) ;;
    hidden:  yes
  }

  dimension: return_order_id {
    #label: "Return Order ID"
    #description:  "This is the return_order_id to search on in Netsuite. Source: netsuite.return_order"
    hidden: yes
    #primary_key: yes
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID ;; }

  dimension: assigned_to {
    hidden: yes
    type: string
    sql: ${TABLE}.ASSIGNED_TO ;; }

  dimension: channel_id {
    #label: "Returns Channel ID"
    #description: "Channel ID just on the returned orders. (1 = DTC, 2 = Wholesale). Source: netsuite.return_order"
    hidden: yes
    type: number
    sql: ${TABLE}.CHANNEL_ID ;; }

  dimension: yesterday_flag {
    #label:  "Yesterday-returns"
    #view_label:  "x - report filters"
    hidden:  yes
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;; }

  dimension_group: created {
    type: time
    label:  "   Return Intiated"
    description:"Date/time that RMA was initiated. Source: netsuite.return_order"
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.CREATED) ;; }

  dimension: created_date_filter {
    type: yesno
    label:  "   * Is Return Intiated (Yes/No)"
    description:"Date/time that RMA was initiated. Source: netsuite.return_order"

    sql: to_timestamp_ntz(${TABLE}.CREATED) is not NULL ;;}

  dimension_group: customer_receipt {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${"fulfillment".fulfilled_f_date} ;; }

  dimension: entity_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ENTITY_ID ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_receipt_condition_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ITEM_RECEIPT_CONDITION_ID ;; }

  dimension: last_modified {
    hidden: yes
    type: string
    sql: ${TABLE}.LAST_MODIFIED ;; }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: payment_method_reference_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PAYMENT_METHOD_REFERENCE_ID ;; }

  dimension: priority_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PRIORITY_ID ;; }

  dimension: related_tranid {
    hidden: yes
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension: replacement_order_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REPLACEMENT_ORDER_LINK_ID ;; }

  dimension: return_option_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.RETURN_OPTION_ID ;; }

  dimension: return_reason_id {
    hidden: yes
    type: number
    sql: ${TABLE}.return_reason_id ;; }

  dimension: return_ref_id {
    label:"RMA Number"
    group_label: " Advanced"
    description:  "RMA number of return (Return Ref ID). Source: netsuite.return_order"
    type: string
    sql: ${TABLE}.RETURN_REF_ID ;; }

  dimension_group: return_trial_expiry {
    label: "Return Trial Expiration"
    description: "When the trial return period expires. Generally 100 days from when customer RECEIVED order for mattresses. Source: netsuite.return_order"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.RETURN_TRIAL_EXPIRY_DATE ;; }

  dimension_group: rma_pickup {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.RMA_PICKUP_DATE ;; }

  dimension: rma_return_form_sent {
    hidden: yes
    type: string
    sql: ${TABLE}.RMA_RETURN_FORM_SENT ;; }

  dimension: rma_return_type {
    group_label: " Advanced"
    label:  "   Return Type"
    description: "Return type: Trial / Non-trial. Source: netsuite.return_order"
    type: string
    sql: ${TABLE}.RMA_RETURN_TYPE ;; }

  dimension: rma_stretchy_sheet_id {
    hidden: yes
    #description: "Does the customer say they've tried it with stretchy sheets?"
    type: number
    sql: ${TABLE}.RMA_STRETCHY_SHEET_ID ;; }

  dimension: rmawarranty_ticket_number {
    hidden: yes
    #description: "RMA number"
    type: string
    sql: ${TABLE}.RMAWARRANTY_TICKET_NUMBER ;; }

  dimension_group: ship_by {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIP_BY_DATE ;; }

  dimension_group: shipment_received {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIPMENT_RECEIVED ;; }

  dimension: shipping_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_ITEM_ID ;; }

  dimension: status {
    group_label: " Advanced"
    label: "   Status of Return"
    description: "Refunded, cancelled, in process, etc. Source: netsuite.return_order"
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: was_returned {
    group_label: " Advanced"
    label: "* Was Returned - Trial Return"
    description: "Indicates if a trial return was completed and refunded. Source:netsuite.return_order"
    type: yesno
    sql: ${TABLE}.STATUS = 'Refunded' and ${TABLE}.RMA_RETURN_TYPE = 'Trial' ;;
  }

  dimension: tracking_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRACKING_NUMBER ;; }

  dimension: transaction_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: warranty_order {
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY_ORDER ;; }

  dimension_group: return_completed {
    label: "   Return Completed"
    type: time
    hidden: no
    description: "Date the return was reimbused and fully completed. Source:netsuite.return_order"
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.return_completed ;; }

  dimension: return_completed {
    type: yesno
    hidden: no
    label: "   * Is Return Completed"
    description: "Date the return was reimbused and fully completed. Source:netsuite.return_order"
    sql: ${TABLE}.return_completed is not NULL ;; }

  measure: return_life {
    description: "Average Days between initiation of return and completion of return (order level). Source:looker.calculation"
    label: "Return Process Lifespan"
    type: average
    sql: datediff(day,${return_order.created_raw},${TABLE}.return_completed) ;;
  }

  measure: days_from_order_to_complete_return {
    type: average
    hidden: yes
    description: "Days from when the customer ordered to when a return was completed (refunded). Source: looker.calculation"
    sql: datediff('day', ${sales_order_line.created_raw}, ${TABLE}.return_completed) ;;
  }

  dimension: days_from_fulfillment_to_complete_return {
    type: number
    hidden: yes
    description: "Days from when the item was fulfilled to when a return was completed (refunded). Source: looker.calculation"
    sql: datediff('day', ${sales_order_line.fulfilled_raw}, ${TABLE}.return_completed) ;;
  }

  dimension: law_tag {
    type: date
    sql: ${TABLE}.LAW_TAG ;;
    hidden: yes
  }

  dimension: days_from_fulfillment_to_complete_return_buckets  {
    type: string
    group_label: " Advanced"
    description: "Source: looker.calculation"
    sql: case when datediff('day', ${sales_order_line.fulfilled_raw}, ${TABLE}.return_completed) <= 30 then '30 Days or Less'
            when datediff('day', ${sales_order_line.fulfilled_raw}, ${TABLE}.return_completed) <= 60 then '31-60 Days'
            when datediff('day', ${sales_order_line.fulfilled_raw}, ${TABLE}.return_completed) <= 100 then '61-100 Days'
            when datediff('day', ${sales_order_line.fulfilled_raw}, ${TABLE}.return_completed) > 100 then 'Over 100'
            end;;

  }

}
