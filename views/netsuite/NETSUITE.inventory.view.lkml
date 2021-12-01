view: inventory {
  sql_table_name: PRODUCTION.INVENTORY ;;

  dimension: item_location_date {
    hidden:  yes
    primary_key: yes
    sql:  ${item_id}||'-'||${location_id}||'-'||${TABLE}.created ;; }

  measure: on_hand {
    label: "  On Hand"
    description: "The quantity of an item physically in a warehouse."
    type: sum
    sql: ${TABLE}.ON_HAND ;; }

  dimension: unit_standard_cost {
    group_label: " Advanced"
    hidden: yes
    label: "Unit Standard Cost"
    description: "Source:netsuite.item_standard_cost"
    type:  number
    value_format: "$#,##0.00"
    sql: ${standard_cost.standard_cost} ;;
  }

  measure: total_standard_cost {
    label: "Total Standard Cost (On Hand)"
    description: "Total Cost (cost per unit * number of units) for On Hand Units. Source:netsuite.sales_order_line"
    type:  sum
    value_format: "$#,##0"
    sql:  ${TABLE}.on_hand * ${unit_standard_cost} ;;
  }

  measure: open_orders {
    label: "  Open orders"
    description: "Total unfulfilled units ordered across all channels in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.open_order,0)  ;; }

  measure: dtc_open_orders {
    group_label: "Open order channel"
    label: "DTC"
    description: "Total unfulfilled units ordered for DTC in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.dtc_open_order,0)  ;; }

  measure: wholesale_open_orders {
    group_label: "Open order channel"
    label: "Wholesale"
    description: "Total unfulfilled units ordered for wholesale in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.wholesale_open_order,0)  ;; }

  measure: retail_open_orders {
    group_label: "Open order channel"
    label: "Retail"
    description: "Total unfulfilled units ordered for Retail in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.retail_open_order,0)  ;; }

  measure: available {
    label: " Available"
    description: "The sum of surplus items in all warehouses less open orders"
    type: sum
    sql: case when ${TABLE}.calculated_available is null then ${TABLE}.available else nvl(${TABLE}.calculated_available,0) end  ;; }

  measure: backordered {
    label: " Backordered"
    description: "On-hand - open orders where open orders > on hand, aggregated from the location-level"
    type: sum
    sql: nvl(${TABLE}.calculated_backordered,0)*-1 ;; }

  dimension: standard_cost {
    group_label: " Advanced"
    label: "Unit Standard Cost"
    description: "Source:Inventory snapshot table"
    type:  number
    value_format: "$#,##0.00"
    sql: ${TABLE}.standard_cost ;;
  }

  measure: nets_available {
    group_label: "Netsuite_values"
    label: "Total Available"
    description: "The aggregation of all items that are not commited to any order in NetSuite"
    type: sum
    sql: ${TABLE}.available ;; }

  measure: backordered_1 {
    group_label: "Netsuite_values"
    label: "Backordered"
    description: "The aggregation of items on Sales orders that do not have any inventory to commit in that warehouse."
    type: sum
    sql: ${TABLE}.backordered ;; }

  dimension_group: updated {
    hidden: yes
    type: time
    description: "Date the Item was created in the table."
    timeframes: [ time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.updated ;; }

  measure: inbound {
    group_label: "Netsuite_values"
    label: "Total Inbound"
    type: sum
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.inbound ;; }

  measure: PENDING_RECEIPT {
    group_label: "Netsuite_values"
    label: "Total Pending Receipt"
    type: sum
    hidden:  no
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.PENDING_RECEIPT ;; }

  measure: PENDING_FULFILLMENT {
    group_label: "Netsuite_values"
    label: "Total Total Pending Fulfillment"
    type: sum
    hidden:  no
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    sql: ${TABLE}.PENDING_FULFILLMENT ;; }

  measure: NetSuite_Stocklevel {
    group_label: "Netsuite_values"
    label: "NetSuite preferred Stock Level"
    type: sum
    hidden:  no
    description: "The aggregation of item stock levels per item per warehouse."
    sql: ${TABLE}.PREFERRED_STOCK_LEVEL ;; }

  dimension: Average_Cost {
    hidden: yes
    type: number
    sql: ${TABLE}.AVERAGE_COST ;; }

  measure: Total_Average_Cost {
    hidden: yes
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
    group_label: "Netsuite_values"
    type: number
    hidden:  yes
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    sql: ${TABLE}.OUTBOUND ;; }

  dimension: ON_ORDER {
    group_label: "Netsuite_values"
    hidden: yes
    type: number
    sql: ${TABLE}.ON_ORDER ;; }

  measure: last_sync_date {
    hidden: yes
    group_label: " Sync"
    type: date
    label: "Sync date"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}

  measure: last_sync_time {
    hidden: yes
    group_label: " Sync"
    type: date_time_of_day
    label: "Sync time"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}

  measure: last_sync_timestamp {
    hidden: yes
    group_label: " Sync"
    label: "Sync timestamp"
    description: "Date table was last refreshed"
    sql: max(${TABLE}.updated) ;;}

  measure: Total_on_order {
    group_label: "Netsuite_values"
    label: "Total On Order"
    description: "Items en route to the warehouse"
    type: sum
    sql: ${TABLE}.ON_ORDER ;; }

  measure: Total_INBOUND {
    group_label: "Netsuite_values"
    label: "Total Inbound"
    description: "The aggregation of all items on Transfer Orders commited or fulfilled headed to the warehouse."
    type: sum
    sql: ${TABLE}.INBOUND ;;}

  measure: TOTAL_OUTBOUND {
    group_label: "Netsuite_values"
    label: "Total Outbound"
    description: "The aggregation of all items on Transfer Orders fulfilled headed away from the warehouse."
    type: sum
    sql: ${TABLE}."OUTBOUND" ;; }

  measure: count {
    hidden: yes
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
