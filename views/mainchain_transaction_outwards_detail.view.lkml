view: mainchain_transaction_outwards_detail {
  sql_table_name: PRODUCTION.MAINCHAIN_TRANSACTION_OUTWARDS_DETAIL ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${tranid} || ${order_line_number} || ${sku_id} || ${units_despatched}  ;;
  }

  dimension: carrier {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: item_id {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: order_id {
    hidden: yes
    group_label: "MainChain"
    type: string
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    sql: ${TABLE}.order_id ;;
  }

  dimension: system {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}.system ;;
  }

  dimension: client {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."CLIENT" ;;
  }

  dimension: con_note_number {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."CON_NOTE_NUMBER" ;;
  }

  dimension: consignee_address {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."CONSIGNEE_ADDRESS" ;;
  }

  dimension: consignee_name {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."CONSIGNEE_NAME" ;;
  }

  dimension_group: finalised {
    label: "Mainchain Finalised"
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
    hidden: yes
    group_label: "MainChain"
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
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."LINE_VOLUME" ;;
  }

  dimension: line_weight {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."LINE_WEIGHT" ;;
  }

  dimension_group: modified {
    hidden: yes
    group_label: "MainChain"
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
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."ORDER_LINE_NUMBER" ;;
  }

  dimension: order_status {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."ORDER_STATUS" ;;
  }

  dimension_group: ordered {
    hidden: yes
    group_label: "MainChain"
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
    hidden: yes
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."PRICE" ;;
  }

  dimension: product_description {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."PRODUCT_DESCRIPTION" ;;
  }

  dimension: related_tranid {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: repcode {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."REPCODE" ;;
  }

  dimension_group: required {
    hidden: yes
    group_label: "MainChain"
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
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: text_box_94 {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."TEXT_BOX_94" ;;
  }

  dimension: text_box_96 {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."TEXT_BOX_96" ;;
  }

  dimension: text_box_98 {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."TEXT_BOX_98" ;;
  }

  dimension: total_warehouse_line_volume {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_LINE_VOLUME" ;;
  }

  dimension: total_warehouse_line_weight {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_LINE_WEIGHT" ;;
  }

  dimension: total_warehouse_units_despatched {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."TOTAL_WAREHOUSE_UNITS_DESPATCHED" ;;
  }

  dimension: tranid {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: unit_pack_type {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."UNIT_PACK_TYPE" ;;
  }

  dimension: units_despatched {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."UNITS_DESPATCHED" ;;
  }

  dimension: units_ordered {
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."UNITS_ORDERED" ;;
  }

  dimension: units_ordered_1 {
    hidden: yes
    group_label: "MainChain"
    type: number
    sql: ${TABLE}."UNITS_ORDERED_1" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    group_label: "MainChain"
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
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."URGENT" ;;
  }

  dimension: warehouse {
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."WAREHOUSE" ;;
  }

  dimension: warehouse_totals {
    hidden: yes
    group_label: "MainChain"
    type: string
    sql: ${TABLE}."WAREHOUSE_TOTALS" ;;
  }

  measure: total_units_despatched {
    group_label: "MainChain"
    type: sum
    sql: ${TABLE}."UNITS_DESPATCHED" ;;
  }

  measure: total_units_ordered {
    group_label: "MainChain"
    drill_fields: [sales_order.order_id, sales_order.tranid,sales_order_line.created_date,sales_order_line.SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, sales_order_line.location, sales_order.source, total_units_ordered]
    type: sum
    sql: ${TABLE}."UNITS_ORDERED" ;;
  }

  measure: total_units_ordered_1 {
    hidden: yes
    group_label: "MainChain"
    type: sum
    sql: ${TABLE}."UNITS_ORDERED_1" ;;
  }

  measure: distinct_tran {
    group_label: "MainChain"
    type: count_distinct
    sql: ${tranid} ;;
    drill_fields: [order_id,tranid,order_status,carrier,ordered_date,sku_id,units_despatched,units_ordered,con_note_number]
  }

  measure: count {
    group_label: "MainChain"
    type: count
    drill_fields: [consignee_name]
  }
}
