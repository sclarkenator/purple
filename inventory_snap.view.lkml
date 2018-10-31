view: inventory_history {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  measure: available {
    type: sum
    sql: ${TABLE}."AVAILABLE" ;;
  }

  measure: average_cost {
    type: sum
    sql: ${TABLE}."AVERAGE_COST" ;;
  }

  measure: backordered {
    type: sum
    sql: ${TABLE}."BACKORDERED" ;;
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

  measure: inbound {
    type: sum
    sql: ${TABLE}."INBOUND" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  measure: on_hand {
    type: sum
    sql: ${TABLE}."ON_HAND" ;;
  }

  measure: on_order {
    type: sum
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: outbound {
    type: sum
    sql: ${TABLE}."OUTBOUND" ;;
  }

  dimension: preferred_stock_level {
    type: number
    sql: ${TABLE}."PREFERRED_STOCK_LEVEL" ;;
  }


}
