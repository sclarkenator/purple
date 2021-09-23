view: highjump_fulfillment {
  sql_table_name: "HIGHJUMP"."HIGHJUMP_FULFILLMENT"
    ;;

  dimension: bill_address {
    type: string
    sql: ${TABLE}."BILL_ADDRESS" ;;
  }

  dimension: bill_address2 {
    type: string
    sql: ${TABLE}."BILL_ADDRESS2" ;;
  }

  dimension: bill_city {
    type: string
    sql: ${TABLE}."BILL_CITY" ;;
  }

  dimension: bill_country {
    type: string
    sql: ${TABLE}."BILL_COUNTRY" ;;
  }

  dimension: bill_name {
    type: string
    sql: ${TABLE}."BILL_NAME" ;;
  }

  dimension: bill_state {
    type: string
    sql: ${TABLE}."BILL_STATE" ;;
  }

  dimension: bill_zip {
    type: string
    sql: ${TABLE}."BILL_ZIP" ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}."CARRIER" ;;
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

  dimension: dimensions {
    type: string
    sql: ${TABLE}."DIMENSIONS" ;;
  }

  dimension: error_message {
    type: string
    sql: ${TABLE}."ERROR_MESSAGE" ;;
  }

  dimension: man_number {
    type: string
    sql: ${TABLE}."MAN_NUMBER" ;;
  }

  dimension: order_num {
    type: string
    sql: ${TABLE}."ORDER_NUM" ;;
  }

  dimension: package_id {
    type: number
    sql: ${TABLE}."PACKAGE_ID" ;;
  }

  dimension: packslip {
    type: string
    sql: ${TABLE}."PACKSLIP" ;;
  }

  dimension: pickup_number {
    type: string
    sql: ${TABLE}."PICKUP_NUMBER" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
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

  dimension: row_id {
    type: string
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: ship_address {
    type: string
    sql: ${TABLE}."SHIP_ADDRESS" ;;
  }

  dimension: ship_address2 {
    type: string
    sql: ${TABLE}."SHIP_ADDRESS2" ;;
  }

  dimension: ship_city {
    type: string
    sql: ${TABLE}."SHIP_CITY" ;;
  }

  dimension: ship_country {
    type: string
    sql: ${TABLE}."SHIP_COUNTRY" ;;
  }

  dimension: ship_name {
    type: string
    sql: ${TABLE}."SHIP_NAME" ;;
  }

  dimension: ship_number {
    type: string
    sql: ${TABLE}."SHIP_NUMBER" ;;
  }

  dimension: ship_servc_code {
    type: string
    sql: ${TABLE}."SHIP_SERVC_CODE" ;;
  }

  dimension: ship_state {
    type: string
    sql: ${TABLE}."SHIP_STATE" ;;
  }

  dimension: ship_zip {
    type: string
    sql: ${TABLE}."SHIP_ZIP" ;;
  }

  dimension_group: shipped {
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
    sql: CAST(${TABLE}."SHIPPED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: shipping_charges {
    type: number
    sql: ${TABLE}."SHIPPING_CHARGES" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: source_order_number {
    type: string
    sql: ${TABLE}."SOURCE_ORDER_NUMBER" ;;
  }

  dimension_group: stored {
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
    sql: ${TABLE}."STORED" ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}."TRACKING_NUMBER" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}."WEIGHT" ;;
  }

}
