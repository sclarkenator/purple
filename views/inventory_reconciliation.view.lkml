view: inventory_reconciliation {
  sql_table_name: HIGHJUMP.V_INVENTORY_RECONCILIATION ;;

  dimension: average_cost {
    type: number
    sql: ${TABLE}."AVERAGE_COST" ;;
  }

  dimension: difference {
    type: number
    sql: ${TABLE}."DIFFERENCE" ;;
  }

  dimension: hj_inventory {
    type: number
    sql: ${TABLE}."HJ_INVENTORY" ;;
  }

  dimension: impact {
    type: number
    sql: ${TABLE}."IMPACT" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: ns_inventory {
    type: number
    sql: ${TABLE}."NS_INVENTORY" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: wms_classification {
    type: string
    sql: ${TABLE}."WMS_CLASSIFICATION" ;;
  }

  measure: total_hj_inventory {
    type: sum
    sql: ${TABLE}."HJ_INVENTORY" ;;
  }

  measure: total_ns_inventory {
    type: sum
    sql: ${TABLE}."NS_INVENTORY" ;;
  }

  measure: total_difference {
    type: sum
    sql: ${TABLE}."DIFFERENCE" ;;
  }

  measure: total_impact {
    type: sum
    sql: ${TABLE}."IMPACT" ;;
  }

  measure: count {
    type: count
  }
}
