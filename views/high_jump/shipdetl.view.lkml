view: shipdetl {
  sql_table_name: "HIGHJUMP"."SHIPDETL"
    ;;

  dimension: bin_label {
    type: string
    sql: ${TABLE}."BIN_LABEL" ;;
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: fifo {
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
    sql: ${TABLE}."FIFO" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_type {
    type: string
    sql: ${TABLE}."ITEM_TYPE" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: order_seq {
    type: string
    sql: ${TABLE}."ORDER_SEQ" ;;
  }

  dimension: pack_slip {
    type: string
    sql: ${TABLE}."PACK_SLIP" ;;
  }

  dimension: po_num {
    type: string
    sql: ${TABLE}."PO_NUM" ;;
  }

  dimension: product_description {
    type: string
    sql: ${TABLE}."PRODUCT_DESCRIPTION" ;;
  }

  dimension: purge {
    type: yesno
    sql: ${TABLE}."PURGE" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: quantity_original {
    type: number
    sql: ${TABLE}."QUANTITY_ORIGINAL" ;;
  }

  dimension: quantity_to_pick {
    type: number
    sql: ${TABLE}."QUANTITY_TO_PICK" ;;
  }

  dimension: row_id {
    type: string
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: sell_price {
    type: number
    sql: ${TABLE}."SELL_PRICE" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tot_label {
    type: number
    sql: ${TABLE}."TOT_LABEL" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}."ZONE" ;;
  }

}
