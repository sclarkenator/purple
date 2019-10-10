view: fulfillment_snowflake {
  sql_table_name: SALES.FULFILLMENT ;;
  drill_fields: [fulfillment_id]

  dimension: fulfillment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."FULFILLMENT_ID" ;;
  }

  dimension: bundle_quantity {
    type: number
    sql: ${TABLE}."BUNDLE_QUANTITY" ;;
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: fulfilled {
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
    sql: ${TABLE}."FULFILLED" ;;
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

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: parent_item_id {
    type: number
    sql: ${TABLE}."PARENT_ITEM_ID" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: shipping {
    type: number
    sql: ${TABLE}."SHIPPING" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension: tracking_numbers {
    type: string
    sql: ${TABLE}."TRACKING_NUMBERS" ;;
  }

  dimension: tranid {
    type: number
    value_format_name: id
    sql: ${TABLE}."TRANID" ;;
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

  measure: count {
    type: count
    drill_fields: [fulfillment_id]
  }
}
