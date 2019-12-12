view: transfer_order_line {
  sql_table_name: PRODUCTION.TRANSFER_ORDER_LINE ;;


  dimension: pk {
    type: string
    sql: ${TABLE}."ACCOUNT_ID" ||  ${TABLE}."TRANSFER_ORDER_ID" ||  ${TABLE}."ITEM_ID" ;;
    primary_key: yes
    hidden:  yes
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: amount_received {
    type: number
    sql: ${TABLE}."AMOUNT_RECEIVED" ;;
  }

  dimension: amount_shipped {
    type: number
    sql: ${TABLE}."AMOUNT_SHIPPED" ;;
  }

  dimension: committed_qty {
    type: number
    sql: ${TABLE}."COMMITTED_QTY" ;;
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: expected_receipt {
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
    sql: ${TABLE}."EXPECTED_RECEIPT" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_unit_price {
    type: number
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  dimension: line_memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: packed_qty {
    type: number
    sql: ${TABLE}."PACKED_QTY" ;;
  }

  dimension: picked_qty {
    type: number
    sql: ${TABLE}."PICKED_QTY" ;;
  }

  dimension: received_qty {
    type: number
    sql: ${TABLE}."RECEIVED_QTY" ;;
  }

  dimension_group: shipment_received {
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
    sql: ${TABLE}."SHIPMENT_RECEIVED" ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED" ;;
  }

  dimension: transfer_order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."TRANSFER_ORDER_ID" ;;
  }

  dimension: transfer_order_item_line {
    type: number
    sql: ${TABLE}."TRANSFER_ORDER_ITEM_LINE" ;;
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}."UNIT_OF_MEASURE" ;;
  }

  dimension_group: update_ts {
    type: time
    hidden: yes
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: line_count {
    type: count
    drill_fields: [transfer_order_item_line]
  }

  measure: total_amount_received {
    type: sum
    sql: ${TABLE}."AMOUNT_RECEIVED" ;;
  }

  measure: total_amount_shipped {
    type: sum
    sql: ${TABLE}."AMOUNT_SHIPPED" ;;
  }

  measure: total_committed_qty {
    type: sum
    sql: ${TABLE}."COMMITTED_QTY" ;;
  }

  measure: total_item_count {
    type: sum
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  measure: total_item_unit_price {
    type: sum
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  measure: total_packed_qty {
    type: sum
    sql: ${TABLE}."PACKED_QTY" ;;
  }

  measure: total_picked_qty {
    type: sum
    sql: ${TABLE}."PICKED_QTY" ;;
  }

  measure: total_received_qty {
    type: sum
    sql: ${TABLE}."RECEIVED_QTY" ;;
  }



}