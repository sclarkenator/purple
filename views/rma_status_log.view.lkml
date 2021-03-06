view: rma_status_log {
  sql_table_name: CUSTOMER_CARE.V_RMA_STATUS_LOG ;;

  dimension: amount {
    label: "  Amount"
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: cancelled {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CANCELLED" ;;
  }

  dimension_group: closed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CLOSED" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: partially_received {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PARTIALLY_RECEIVED" ;;
  }

  dimension_group: pending_approval {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PENDING_APPROVAL" ;;
  }

  dimension_group: pending_receipt {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PENDING_RECEIPT" ;;
  }

  dimension_group: pending_refund {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PENDING_REFUND" ;;
  }

  dimension_group: pending_refund_partially_received {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PENDING_REFUND_PARTIALLY_RECEIVED" ;;
  }

  dimension: item_id {
    type: string
    label: "  Item Id"
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension_group: refunded {
    group_label: "   Refunded Date"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REFUNDED" ;;
  }

  dimension: related_tranid {
    group_label: " Advanced"
    type: string
    primary_key: yes
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: return_order_id {
    type: number
    group_label: " Advanced"
    sql: ${TABLE}."RETURN_ORDER_ID" ;;
  }

  dimension: rma_return_type {
    label: "  RMA Return Type"
    type: string
    sql: ${TABLE}."RMA_RETURN_TYPE" ;;
  }

  dimension: tranid {
    type: string
    group_label: " Advanced"
    sql: ${TABLE}."TRANID" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
