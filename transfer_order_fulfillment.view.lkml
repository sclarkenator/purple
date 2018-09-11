view: transfer_order_fulfillment {
  sql_table_name: PRODUCTION.TRANSFER_ORDER_FULFILLMENT ;;

  dimension: transfer_order_fulfillment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."TRANSFER_ORDER_FULFILLMENT_ID" ;;
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

  dimension: quantity_fulfilled {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: tranid {
    type: number
    value_format_name: id
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transfer_order_id {
    type: number
    sql: ${TABLE}."TRANSFER_ORDER_ID" ;;
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
    drill_fields: [transfer_order_fulfillment_id]
  }
  measure: Total_quantity_fulfilled {
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
    }
}
