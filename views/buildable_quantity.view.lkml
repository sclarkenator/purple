view: buildable_quantity {
  sql_table_name: "PRODUCTION"."BUILDABLE_QUANTITY"
    ;;

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  measure: buildable_units {
    type: sum
    sql: ${TABLE}."BUILDABLE_UNITS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
