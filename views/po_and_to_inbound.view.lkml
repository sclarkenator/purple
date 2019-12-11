view: po_and_to_inbound {
  sql_table_name: HIGHJUMP.po_and_to_inbound ;;

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: hj_ordered_units {
    type: number
    sql: ${TABLE}."HJ_ORDERED_UNITS" ;;
  }

  dimension: hj_received_units {
    type: number
    sql: ${TABLE}."HJ_RECEIVED_UNITS" ;;
  }

  dimension: item {
    type: string
    sql: ${TABLE}."ITEM" ;;
  }

  dimension: ns_ordered_units {
    type: number
    sql: ${TABLE}."NS_ORDERED_UNITS" ;;
  }

  dimension: ns_received_units {
    type: number
    sql: ${TABLE}."NS_RECEIVED_UNITS" ;;
  }

  dimension: ordered_qty_variance {
    type: number
    sql: ${TABLE}."ORDERED_QTY_VARIANCE" ;;
  }

  dimension: received_qty_variance {
    type: number
    sql: ${TABLE}."RECEIVED_QTY_VARIANCE" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension: vendor {
    type: string
    sql: ${TABLE}."VENDOR" ;;
  }

  dimension: hj_created {
    type: date
    sql: ${TABLE}.hj_created ;;
  }

  dimension: ns_created {
    type: date
    sql: ${TABLE}.ns_created ;;
  }

  measure: total_hj_ordered_units {
    type: sum
    sql: ${TABLE}."HJ_ORDERED_UNITS" ;;
  }

  measure: total_hj_received_units {
    type: sum
    sql: ${TABLE}."HJ_RECEIVED_UNITS" ;;
  }

  measure: total_ns_ordered_units {
    type: sum
    sql: ${TABLE}."NS_ORDERED_UNITS" ;;
  }

  measure: total_ns_received_units {
    type: sum
    sql: ${TABLE}."NS_RECEIVED_UNITS" ;;
  }

  measure: total_ordered_qty_variance {
    type: sum
    sql: ${TABLE}."ORDERED_QTY_VARIANCE" ;;
  }

  measure: total_received_qty_variance {
    type: sum
    sql: ${TABLE}."RECEIVED_QTY_VARIANCE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
