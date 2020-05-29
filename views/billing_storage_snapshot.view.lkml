view: billing_storage_snapshot {
  sql_table_name: "HIGHJUMP"."BILLING_STORAGE_SNAPSHOT"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: billing_zone {
    label: ""
    description: "
      Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."BILLING_ZONE" ;;
  }

  dimension: bin_name {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."BIN_NAME" ;;
  }

  dimension: created_by {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }


  dimension_group: effective {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."EFFECTIVE") ;;
  }

  dimension: hold_status {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."HOLD_STATUS" ;;
  }

  dimension: internal_object_id {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."INTERNAL_OBJECT_ID" ;;
  }

  dimension: warehouse_location {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension_group: receipt {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
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
    sql: CAST(${TABLE}."RECEIPT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: row_id {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: sku_id {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: uom2 {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: string
    sql: ${TABLE}."UOM2" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: gross_weight {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: sum
    sql: ${TABLE}."GROSS_WEIGHT" ;;
  }

  measure: qty {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: sum
    sql: ${TABLE}."QTY" ;;
  }

  measure: cubic_volume {
    label: ""
    description: "
    Source: highjump.billing_storage_snapshot"
    type: sum
    sql: ${TABLE}."CUBIC_VOLUME" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, bin_name]
  }
}
