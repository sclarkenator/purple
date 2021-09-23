view: bin_location {
  sql_table_name: "HIGHJUMP"."BIN_LOCATION"
    ;;

  dimension: bin_label {
    type: string
    sql: ${TABLE}."BIN_LABEL" ;;
  }

  dimension: bin_type {
    type: string
    sql: ${TABLE}."BIN_TYPE" ;;
  }

  dimension: counted {
    type: number
    sql: ${TABLE}."COUNTED" ;;
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

  dimension: from_bin {
    type: string
    sql: ${TABLE}."FROM_BIN" ;;
  }

  dimension: lot {
    type: string
    sql: ${TABLE}."LOT" ;;
  }

  dimension: pack_size {
    type: number
    sql: ${TABLE}."PACK_SIZE" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: return_bin {
    type: string
    sql: ${TABLE}."RETURN_BIN" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: unallocated {
    type: number
    sql: ${TABLE}."UNALLOCATED" ;;
  }

  dimension: user {
    type: string
    sql: ${TABLE}."USER" ;;
  }

  dimension: warehouse_id {
    type: number
    sql: ${TABLE}."WAREHOUSE_ID" ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}."ZONE" ;;
  }

}
