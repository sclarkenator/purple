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
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: from_bin {
    type: string
    sql: ${TABLE}."FROM_BIN" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: lot {
    type: string
    sql: ${TABLE}."LOT" ;;
  }

  dimension: pack_size {
    type: number
    sql: ${TABLE}."PACK_SIZE" ;;
  }

  measure: quantity {
    type: sum
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

  measure: unallocated {
    type: sum
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

  measure: count {
    type: count
    drill_fields: []
  }
}
