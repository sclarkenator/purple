view: mainchain_transaction_outwards_detail {
  sql_table_name: PRODUCTION.MAINCHAIN_TRANSACTION_OUTWARDS_DETAIL ;;


#primary key - tran id, order line number, sku id

  dimension: primary_key {
    hidden: yes
    sql: ${tranid} || ${order_line_number} || ${sku_id}  ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}.system ;;
  }

  dimension: client {
    type: string
    sql: ${TABLE}."CLIENT" ;;
  }

  dimension: con_note_number {
    type: string
    sql: ${TABLE}."CON_NOTE_NUMBER" ;;
  }

  dimension: consignee_address {
    type: string
    sql: ${TABLE}."CONSIGNEE_ADDRESS" ;;
  }

  dimension: consignee_name {
    type: string
    sql: ${TABLE}."CONSIGNEE_NAME" ;;
  }

  dimension_group: finalised {
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
    sql: ${TABLE}."FINALISED" ;;
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

  dimension: line_volume {
    type: number
    sql: ${TABLE}."LINE_VOLUME" ;;
  }

  dimension: line_weight {
    type: number
    sql: ${TABLE}."LINE_WEIGHT" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: order_line_number {
    type: string
    sql: ${TABLE}."ORDER_LINE_NUMBER" ;;
  }

  dimension: order_status {
    type: string
    sql: ${TABLE}."ORDER_STATUS" ;;
  }

  dimension_group: ordered {
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
    sql: ${TABLE}."ORDERED" ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}."PRICE" ;;
  }

  dimension: product_description {
    type: string
    sql: ${TABLE}."PRODUCT_DESCRIPTION" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: repcode {
    type: string
    sql: ${TABLE}."REPCODE" ;;
  }

  dimension_group: required {
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
    sql: ${TABLE}."REQUIRED" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: text_box_94 {
    type: string
    sql: ${TABLE}."TEXT_BOX_94" ;;
  }

  dimension: text_box_96 {
    type: string
    sql: ${TABLE}."TEXT_BOX_96" ;;
  }

  dimension: text_box_98 {
    type: string
    sql: ${TABLE}."TEXT_BOX_98" ;;
  }

  dimension: total_warehouse_line_volume {
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_LINE_VOLUME" ;;
  }

  dimension: total_warehouse_line_weight {
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_LINE_WEIGHT" ;;
  }

  dimension: total_warehouse_units_despatched {
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_UNITS_DESPATCHED" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: unit_pack_type {
    type: string
    sql: ${TABLE}."UNIT_PACK_TYPE" ;;
  }

  dimension: units_despatched {
    type: number
    sql: ${TABLE}."UNITS_DESPATCHED" ;;
  }

  dimension: units_ordered {
    type: number
    sql: ${TABLE}."UNITS_ORDERED" ;;
  }

  dimension: units_ordered_1 {
    type: number
    sql: ${TABLE}."UNITS_ORDERED_1" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: urgent {
    type: string
    sql: ${TABLE}."URGENT" ;;
  }

  dimension: warehouse {
    type: string
    sql: ${TABLE}."WAREHOUSE" ;;
  }

  dimension: warehouse_totals {
    type: string
    sql: ${TABLE}."WAREHOUSE_TOTALS" ;;
  }

  measure: total_units_despatched {
    type: sum
    sql: ${TABLE}."UNITS_DESPATCHED" ;;
  }

  measure: total_units_ordered {
    type: sum
    sql: ${TABLE}."UNITS_ORDERED" ;;
  }

  measure: total_units_ordered_1 {
    type: sum
    sql: ${TABLE}."UNITS_ORDERED_1" ;;
  }

  measure: distinct_tran {
    type: count_distinct
    sql: ${tranid} ;;
    drill_fields: [tranid,order_status,carrier,ordered_date,sku_id,units_despatched,units_ordered,con_note_number]
  }

  measure: count {
    type: count
    drill_fields: [consignee_name]
  }
}
