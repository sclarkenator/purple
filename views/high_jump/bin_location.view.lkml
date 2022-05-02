view: bin_location {
  sql_table_name: "HIGHJUMP"."BIN_LOCATION"
    ;;

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${sku}||'-'||${bin_label} ;;
  }

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

  measure: quantity_unfiltered {
    type: sum
    hidden: no
    label: "HJ - Quantity (Unfiltered)"
    description: "Includes all Zones"
    value_format: "#,##0"
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

  measure: quantity {
    type: sum
    label: "HJ - Quantity"
    description: "Excludes Zones from HJ related to quality, ee store, and waste management"
    value_format: "#,##0"
    sql: CASE WHEN (${zone} IN ('1', '2', '3', '4', 'A', 'B', 'C', 'G', 'I', 'K', 'M', 'N', 'O', 'P', 'R', 'S', '5', '6', 'X', 'Y', 'Z')) THEN ${TABLE}."QUANTITY"
      ELSE 0 END;;
  }


  measure: unallocated {
    type: sum
    label: "HJ - Unallocated"
    description: "Excludes Zones from HJ related to quality, ee store, and waste management"
    value_format: "#,##0"
    sql: CASE WHEN (${zone} IN ('1', '2', '3', '4', 'A', 'B', 'C', 'G', 'I', 'K', 'M', 'N', 'O', 'P', 'R', 'S', '5', '6', 'X', 'Y', 'Z')) THEN ${TABLE}."UNALLOCATED"
              ELSE 0 END;;
  }

  measure: unallocated_unfiltered{
    type: sum
    label: "HJ - Unallocated (Unfiltered)"
    description: "Includes all Zones"
    value_format: "#,##0"
    sql: ${TABLE}."UNALLOCATED";;
  }

  dimension: user {
    type: string
    sql: ${TABLE}."USER" ;;
  }

  dimension: warehouse_id {
    type: number
    sql: ${TABLE}."WAREHOUSE_ID" ;;
  }

  dimension: warehouse_name {
    type: string
    sql: CASE WHEN ${TABLE}."WAREHOUSE_ID" = '4' THEN '100-Purple West'
              WHEN ${TABLE}."WAREHOUSE_ID" = '5' THEN '150-Alpine'
              WHEN ${TABLE}."WAREHOUSE_ID" = '12' THEN '109-West Quality Hold Sub W/H'
              WHEN ${TABLE}."WAREHOUSE_ID" = '17' THEN '900 - Employee Store'
              WHEN ${TABLE}."WAREHOUSE_ID" = '62' THEN '013-PRODUCT DESTRUCTION'
              WHEN ${TABLE}."WAREHOUSE_ID" = '66' THEN '100-INTERNAL'
              WHEN ${TABLE}."WAREHOUSE_ID" = '71' THEN '100 Purple West : Depot'
              WHEN ${TABLE}."WAREHOUSE_ID" = '111' THEN '200-Purple South'
              WHEN ${TABLE}."WAREHOUSE_ID" = '115' THEN '115-Retail Openings'
              WHEN ${TABLE}."WAREHOUSE_ID" = '154' THEN '209-South Quality Hold Sub W/H'
              ELSE 'Other' END
              ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}."ZONE" ;;
  }

}
