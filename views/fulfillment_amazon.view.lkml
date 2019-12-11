view: fulfillment_amazon {
  sql_table_name: SALES.FULFILLMENT_AMAZON ;;

  dimension: amazon_order_id {
    type: number
    sql: ${TABLE}."AMAZON_ORDER_ID" ;;
  }

  dimension: amazon_order_item_id {
    type: string
    sql: ${TABLE}."AMAZON_ORDER_ITEM_ID" ;;
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

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: shipment_id {
    type: string
    sql: ${TABLE}."SHIPMENT_ID" ;;
  }

  dimension: shipment_item_id {
    type: string
    sql: ${TABLE}."SHIPMENT_ITEM_ID" ;;
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
    drill_fields: []
  }
}
