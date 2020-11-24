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

  dimension_group: updated {
    hidden: no
    type: time
    description: "Date the Item was created in the table."
    timeframes: [ time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.updated ;; }

  measure: inbound {
    label: "Total Inbound"
    type: sum
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.inbound ;; }

  measure: PENDING_RECEIPT {
    label: "Total Pending Receipt"
    type: sum
    hidden:  no
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.PENDING_RECEIPT ;; }

  measure: PENDING_FULFILLMENT {
    label: "Total Total Pending Fulfillment"
    type: sum
    hidden:  no
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.PENDING_FULFILLMENT ;; }

  measure: NetSuite_Stocklevel {
    label: "NetSuite preferred Stock Level"
    type: sum
    hidden:  no
    description: "The aggregation of item stock levels per item per warehouse."
    sql: ${TABLE}.PREFERRED_STOCK_LEVEL ;; }

  dimension: Average_Cost {
    hidden: no
    type: number
    sql: ${TABLE}.AVERAGE_COST ;; }

  measure: Total_Average_Cost {
    hidden: no
    type: sum
    sql: ${TABLE}.AVERAGE_COST ;; }

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

  measure: last_sync_date {
    group_label: " Sync"
    type: date
    label: "Sync date"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}

  measure: last_sync_time {
    group_label: " Sync"
    type: date_time_of_day
    label: "Sync time"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}

  measure: last_sync_timestamp {
    group_label: " Sync"
    label: "Sync timestamp"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}


  measure: on_hand {
    label: "Total On Hand"
    description: "The quantity of an item physically in a warehouse."
    type: sum
    sql: ${TABLE}.ON_HAND ;; }

  measure: Total_on_order {
    label: "Total On Order"
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

  parameter: see_data_by {
    type: unquoted
    hidden: yes
    allowed_value: {
      label: "Warehouse Location"
      value: "warehouse_location"
    }
    allowed_value: {
      label: "Category"
      value: "category"
    }
    allowed_value: {
      label: "Line"
      value: "line"
    }
    allowed_value: {
      label: "Model"
      value: "model"
    }
    allowed_value: {
      label: "Product Name"
      value: "name"
    }
    allowed_value: {
      label: "SKU"
      value: "sku"
    }
  }

  dimension: see_data {
    label: "See Data By"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'warehouse_location' %}
      ${warehouse_location.location_name}
    {% elsif see_data_by._parameter_value == 'category' %}
      ${item.category_name}
    {% elsif see_data_by._parameter_value == 'line' %}
      ${item.line_raw}
    {% elsif see_data_by._parameter_value == 'model' %}
      ${item.model_raw}
    {% elsif see_data_by._parameter_value == 'name' %}
      ${item.product_description_raw}
    {% elsif see_data_by._parameter_value == 'sku' %}
      ${item.sku_id}
    {% else %}
      ${warehouse_location.location_name}
    {% endif %};;
  }

}
