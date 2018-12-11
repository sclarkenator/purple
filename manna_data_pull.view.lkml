view: manna_data_pull {
  sql_table_name: CSV_UPLOADS.MANNA_DATA_PULL ;;

  dimension: bol_wo_prefix {
    type: string
    sql: ${TABLE}."BOL_WO_PREFIX" ;;
  }

  dimension: customer_city {
    type: string
    sql: ${TABLE}."CUSTOMER_CITY" ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: customer_state {
    type: string
    sql: ${TABLE}."CUSTOMER_STATE" ;;
  }

  dimension: customer_zip {
    type: string
    sql: ${TABLE}."CUSTOMER_ZIP" ;;
  }

  dimension: dc_location {
    type: string
    sql: ${TABLE}."DC_LOCATION" ;;
  }

  dimension_group: invoice {
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
    sql: ${TABLE}."INVOICE_DATE" ;;
  }

  dimension: manna_bol {
    type: string
    sql: ${TABLE}."MANNA_BOL" ;;
  }

  dimension: milestone_type {
    type: string
    sql: ${TABLE}."MILESTONE_TYPE" ;;
  }

  dimension: service_type_code {
    type: string
    sql: ${TABLE}."SERVICE_TYPE_CODE" ;;
  }

  dimension: shopify_order {
    type: string
    sql: ${TABLE}."SHOPIFY_ORDER" ;;
  }

  dimension: st_type {
    type: string
    sql: ${TABLE}."ST_TYPE" ;;
  }

  measure: total_actual_weight {
    type: sum
    sql: ${TABLE}."TOTAL_ACTUAL_WEIGHT" ;;
  }

  measure: total_charges {
    type: sum
    sql: ${TABLE}."TOTAL_CHARGES" ;;
  }

  measure: total_dim_weight {
    type: sum
    sql: ${TABLE}."TOTAL_DIM_WEIGHT" ;;
  }

  measure: total_pieces {
    type: sum
    sql: ${TABLE}."TOTAL_PIECES" ;;
  }

  dimension_group: transaction_delivery {
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
    sql: ${TABLE}."TRANSACTION_DELIVERY" ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension_group: transaction_ready {
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
    sql: ${TABLE}."TRANSACTION_READY" ;;
  }

  dimension_group: transaction_schedule {
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
    sql: ${TABLE}."TRANSACTION_SCHEDULE" ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_name]
  }
}
