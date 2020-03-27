view: buildable_quantity {
  sql_table_name: "PRODUCTION"."BUILDABLE_QUANTITY"
    ;;

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  measure: buildable_units {
    type: sum
    description: "The total number of completed finished goods"
    sql: ${TABLE}."BUILDABLE_UNITS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
