view: v_fedex_to_xpo {
  sql_table_name: SHIPPING.V_FEDEX_TO_XPO ;;

  dimension_group: fedex_delivered {
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
    sql: ${TABLE}."FEDEX_DELIVERED" ;;
  }

  dimension: fedex_status {
    type: string
    sql: ${TABLE}."FEDEX_STATUS" ;;
  }

  dimension_group: fulfillment_created {
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
    sql: ${TABLE}."FULFILLMENT_CREATED" ;;
  }

  dimension: fulfillment_id {
    type: number
    sql: ${TABLE}."FULFILLMENT_ID" ;;
  }

  dimension: fulfillment_quantity {
    type: number
    sql: ${TABLE}."FULFILLMENT_QUANTITY" ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: scheduled_delivery {
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
    sql: ${TABLE}."SCHEDULED_DELIVERY" ;;
  }

  dimension: shipping_cost {
    type: number
    sql: ${TABLE}."SHIPPING_COST" ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}."TRACKING_NUMBER" ;;
  }

  dimension_group: xpo_delivered {
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
    sql: ${TABLE}."XPO_DELIVERED" ;;
  }

  dimension_group: xpo_item_received {
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
    sql: ${TABLE}."XPO_ITEM_RECEIVED" ;;
  }

  dimension_group: xpo_notice {
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
    sql: ${TABLE}."XPO_NOTICE" ;;
  }

  dimension: xpo_shipment_number {
    type: string
    sql: ${TABLE}."XPO_SHIPMENT_NUMBER" ;;
  }

  dimension_group: xpo_shipped {
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
    sql: ${TABLE}."XPO_SHIPPED" ;;
  }

  dimension: xpo_status {
    type: string
    sql: ${TABLE}."XPO_STATUS" ;;
  }

  dimension: status {
    type:  string
    sql: ${TABLE}.status ;;
  }

  dimension: last_mile_hub {
    type:  string
    sql: ${TABLE}."LAST_MILE_HUB" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
