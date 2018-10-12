view: inventory {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  dimension: item_location_date {
    hidden:  yes
    primary_key: yes
    sql:  ${item_id}||'-'||${location_id}||'-'||${TABLE}.created ;;
  }

  measure: available {
    type: sum
    description: "The aggregation of all items that are not commited to any order in NetSuite"
    sql: ${TABLE}."AVAILABLE" ;;
  }

  measure: backordered {
    type: sum
    description: "The aggregation of items on Sales orders that do not have any inventory to commit in that warehouse."
    sql: ${TABLE}."BACKORDERED" ;;
  }

  dimension_group: created {
    type: time
    description: "Date the Inventory Snapshot was created. This happens every 12 hours at 0300 and 1500."
    timeframes: [
      time,
      hour_of_day,
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
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}."INBOUND" ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location_id {
    type: number
    description: "Internal Netsuite Primary Key for the Warehouse locations"
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: OUTBOUND {
    type: number
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    sql: ${TABLE}."OUTBOUND" ;;
  }

  dimension: ON_ORDER {
    hidden: yes
    type: number
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: on_hand {
    description: "The quantity of an item physically in a warehouse."
    type: sum
    sql: ${TABLE}."ON_HAND" ;;
  }

  measure: Total_on_order {
    description: "Items en route to the warehouse"
    type: sum
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: Total_INBOUND {
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    type: sum
    sql: ${TABLE}."INBOUND" ;;
  }

  measure: TOTAL_OUTBOUND {
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    type: sum
    sql: ${TABLE}."OUTBOUND" ;;
  }
  measure: count {
    description: "The count of occurences."
    type: count
    drill_fields: []
  }
}
