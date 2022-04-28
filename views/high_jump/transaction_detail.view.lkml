view: transaction_detail {
  sql_table_name: "HIGHJUMP"."TRANSACTION_DETAIL"
    ;;

  dimension: bin_label {
    type: string
    sql: ${TABLE}."BIN_LABEL" ;;
  }

  dimension: cartons {
    type: number
    sql: ${TABLE}."CARTONS" ;;
  }

  dimension: cost_price {
    type: number
    sql: ${TABLE}."COST_PRICE" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: extra3 {
    type: number
    sql: ${TABLE}."EXTRA3" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_type {
    type: string
    sql: ${TABLE}."ITEM_TYPE" ;;
  }

  dimension: line_number {
    type: number
    sql: ${TABLE}."LINE_NUMBER" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: p_unit_measure {
    type: number
    sql: ${TABLE}."P_UNIT_MEASURE" ;;
  }

  dimension: po_number {
    type: string
    label: "PO Number"
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension: po_number_ext {
    type: string
    label: "PO Number Ext."
    sql: ${TABLE}."PO_NUMBER_EXT" ;;
  }

  dimension: product_class {
    type: string
    sql: ${TABLE}."PRODUCT_CLASS" ;;
  }

  dimension: product_description {
    type: string
    sql: ${TABLE}."PRODUCT_DESCRIPTION" ;;
  }

  measure: quantity_received {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."QUANTITY_RECEIVED" ;;
  }

  dimension: rma_code {
    type: number
    sql: ${TABLE}."RMA_CODE" ;;
  }

  dimension: row_id {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: status_code {
    type: string
    sql: ${TABLE}."STATUS_CODE" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: receiving_user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: wave {
    type: number
    sql: ${TABLE}."WAVE" ;;
  }

}
