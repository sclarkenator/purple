view: return_order {
  sql_table_name: SALES.RETURN_ORDER ;;

  dimension: return_order_id {
    description:  "This is the return_order_id to search on in Netsuite"
    hidden: yes
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
    label: "Returns channel ID"
    description: "Channel ID just on the returned orders. 1 - DTC, 2 - Wholesale"
    hidden: yes
    type: number
    sql: ${TABLE}.CHANNEL_ID ;;
    }

  dimension_group: created {
    type: time
    label:  "Return"
    description:"Date/time that RMA was initiated"
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
    sql: to_timestamp_ntz(${TABLE}.CREATED) ;;
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
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}.REPLACEMENT_ORDER_LINK_ID ;;
  }

  dimension: return_option_id {
    description: "How customer chooses to dispose/return item"
    type: number
    sql: ${TABLE}.RETURN_OPTION_ID ;;
  }

  dimension: return_reason_id {
    hidden: yes
    type: number
    sql: ${TABLE}.return_reason_id ;;
  }

  dimension: return_ref_id {
    label:"RMA number"
    description:  "RMA number of return"
    type: string
    sql: ${TABLE}.RETURN_REF_ID ;;
  }

  dimension_group: return_trial_expiry {
    description: "100 days from when customer RECEIVED order for mattresses"
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
    hidden: yes
    description: "Does the customer say they've tried it with stretchy sheets?"
    type: number
    sql: ${TABLE}.RMA_STRETCHY_SHEET_ID ;;
  }

  dimension: rmawarranty_ticket_number {
    hidden: yes
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
    label: "Status of return"
    description: "Refunded, cancelled, in process, etc."
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
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY_ORDER ;;
  }

}
