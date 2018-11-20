view: inventory {
  sql_table_name: PRODUCTION.INVENTORY ;;

  dimension: item_location_date {
    hidden:  yes
    primary_key: yes
    sql:  ${item_id}||'-'||${location_id}||'-'||${TABLE}.created ;; }

  measure: available {
    label: "Total Available"
    description: "The aggregation of all items that are not commited to any order in NetSuite"
    type: sum
    sql: ${TABLE}.available ;; }

  measure: backordered {
    label: "Backordered"
    description: "The aggregation of items on Sales orders that do not have any inventory to commit in that warehouse."
    type: sum
    sql: ${TABLE}.backordered ;; }

  dimension_group: created {
    hidden: yes
    type: time
    description: "Date the Item was created in the table."
    timeframes: [ time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  measure: inbound {
    label: "Total Inbound"
    type: sum
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.inbound ;; }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: location_id {
    hidden:  yes
    type: number
    description: "Internal Netsuite Primary Key for the Warehouse locations"
    sql: ${TABLE}."LOCATION_ID" ;; }

  dimension: OUTBOUND {
    type: number
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    sql: ${TABLE}.OUTBOUND ;; }

  dimension: ON_ORDER {
    hidden: yes
    type: number
    sql: ${TABLE}.ON_ORDER ;; }

  measure: on_hand {
    label: "Total On Hand"
    description: "The quantity of an item physically in a warehouse."
    type: sum
    sql: ${TABLE}.ON_HAND ;; }

  measure: Total_on_order {
    label: "Totan On Order"
    description: "Items en route to the warehouse"
    type: sum
    sql: ${TABLE}.ON_ORDER ;; }

  measure: Total_INBOUND {
    label: "Total Inbound"
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    type: sum
    sql: ${TABLE}.INBOUND ;;}

  measure: TOTAL_OUTBOUND {
    label: "Total Outbound"
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    type: sum
    sql: ${TABLE}."OUTBOUND" ;; }

  measure: count {
    label: "Count of Occurances"
    type: count }

}
