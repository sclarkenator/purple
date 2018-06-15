view: return_order {
  sql_table_name: SALES.RETURN_ORDER ;;

  dimension: return_order_id {
    description:  "This is the return_order_id to search on in Netsuite"
    primary_key: yes
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID ;;
  }

  dimension: assigned_to {
    hidden: yes
    type: string
    sql: ${TABLE}.ASSIGNED_TO ;;
  }

  dimension: channel_id {
  #hidden: yes
  description: "1 - DTC, 2 - Wholesale"
    type: number
    sql: ${TABLE}.CHANNEL_ID ;;
  }

  dimension: created_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED_TS ;;
  }

  dimension_group: customer_receipt {
    hidden: yes
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
    sql: ${TABLE}.CUSTOMER_RECEIPT_DATE ;;
  }

  dimension: entity_id {
    type: number
    sql: ${TABLE}.ENTITY_ID ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_receipt_condition_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ITEM_RECEIPT_CONDITION_ID ;;
  }

  dimension: last_modified {
    hidden: yes
    type: string
    sql: ${TABLE}.LAST_MODIFIED ;;
  }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: payment_method_reference_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PAYMENT_METHOD_REFERENCE_ID ;;
  }

  dimension: priority_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PRIORITY_ID ;;
  }

  dimension: related_tranid {
    hidden: yes
    type: string
    sql: ${TABLE}.RELATED_TRANID ;;
  }

  dimension: replacement_order_link_id {
    type: number
    sql: ${TABLE}.REPLACEMENT_ORDER_LINK_ID ;;
  }

  dimension: return_option_id {
    type: number
    sql: ${TABLE}.RETURN_OPTION_ID ;;
  }

  dimension: return_reason_id {
    hidden: yes
    type: number
    sql: ${TABLE}.return_reason_id ;;
  }

  dimension: return_ref_id {
    hidden: yes
    type: string
    sql: ${TABLE}.RETURN_REF_ID ;;
  }

  dimension_group: return_trial_expiry {
    description: "100 days from when customer RECEIVED order for mattresses"
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
    sql: ${TABLE}.RETURN_TRIAL_EXPIRY_DATE ;;
  }

  dimension_group: rma_pickup {
    hidden: yes
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
    sql: ${TABLE}.RMA_PICKUP_DATE ;;
  }

  dimension: rma_return_form_sent {
    hidden: yes
    type: string
    sql: ${TABLE}.RMA_RETURN_FORM_SENT ;;
  }

  dimension: rma_return_type {
    description: "Return type: Trial / Non-trial"
    label:  "Trial return?"
    type: string
    sql: ${TABLE}.RMA_RETURN_TYPE ;;
  }

  dimension: rma_stretchy_sheet_id {
    description: "Does the customer say they've tried it with stretchy sheets?"
    type: number
    sql: ${TABLE}.RMA_STRETCHY_SHEET_ID ;;
  }

  dimension: rmawarranty_ticket_number {
    description: "RMA number"
    type: string
    sql: ${TABLE}.RMAWARRANTY_TICKET_NUMBER ;;
  }

  dimension_group: ship_by {
    hidden: yes
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
    sql: ${TABLE}.SHIP_BY_DATE ;;
  }

  dimension_group: shipment_received {
    hidden: yes
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
    sql: ${TABLE}.SHIPMENT_RECEIVED ;;
  }

  dimension: shipping_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_ITEM_ID ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: tracking_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRACKING_NUMBER ;;
  }

  dimension: transaction_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: warranty_order {
    type: string
    sql: ${TABLE}.WARRANTY_ORDER ;;
  }

  measure: count {
    type: count
    drill_fields: [return_order_id, return_order_line.count]
  }
}
