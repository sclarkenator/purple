view: warranty_timeline {
  sql_table_name: ACCOUNTING.WARRANTY_TIMELINE ;;

  dimension_group: fulfilled {
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
    sql: ${TABLE}."FULFILLED" ;;
  }

  dimension: fulfillment_id {
    type: number
    sql: ${TABLE}."FULFILLMENT_ID" ;;
  }

  dimension: fulfillment_tranid {
    type: number
    value_format_name: id
    sql: ${TABLE}."FULFILLMENT_TRANID" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension_group: original_created {
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
    sql: ${TABLE}."ORIGINAL_CREATED" ;;
  }

  dimension: original_order_id {
    type: number
    sql: ${TABLE}."ORIGINAL_ORDER_ID" ;;
  }

  dimension: original_tranid {
    type: string
    sql: ${TABLE}."ORIGINAL_TRANID" ;;
  }

  dimension: qty_fulfilled {
    type: number
    sql: ${TABLE}."QTY_FULFILLED" ;;
  }

  dimension_group: rma_created {
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
    sql: ${TABLE}."RMA_CREATED" ;;
  }

  dimension: rma_order_id {
    type: number
    sql: ${TABLE}."RMA_ORDER_ID" ;;
  }

  dimension: rma_ref_id {
    type: string
    sql: ${TABLE}."RMA_REF_ID" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: warranty {
    type: string
    sql: ${TABLE}."WARRANTY" ;;
  }

  dimension_group: warranty_created {
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
    sql: ${TABLE}."WARRANTY_CREATED" ;;
  }

  dimension: warranty_order_id {
    type: number
    sql: ${TABLE}."WARRANTY_ORDER_ID" ;;
  }

  dimension: warranty_tranid {
    type: string
    sql: ${TABLE}."WARRANTY_TRANID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
