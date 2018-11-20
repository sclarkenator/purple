#-------------------------------------------------------------------
# Owner - Scott Clark
#-------------------------------------------------------------------

view: purchase_order_line {
  sql_table_name: PRODUCTION.PURCHASE_ORDER_LINE ;;

dimension: Primary_key{
  primary_key: yes
  hidden: yes
  type: string
  sql: ${TABLE}."PURCHASE_ORDER_ID"||'L'||${TABLE}."PURCHASE_ORDER_LINE_ID" ;; }

  dimension: purchase_order_line_id {
    label: "Purchase Order Line ID"
    type: number
    sql: ${TABLE}.PURCHASE_ORDER_LINE_ID ;; }

  dimension: account_id {
    label: "Account ID"
    type: number
    sql: ${TABLE}.ACCOUNT_ID ;; }

  dimension: amount {
    label: "Amount"
    type: number
    sql: ${TABLE}.AMOUNT ;; }

  dimension_group: closed {
    label: "Closed"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CLOSED ;; }

  dimension: company_id {
    label: "Company ID"
    type: number
    sql: ${TABLE}.COMPANY_ID ;; }

  dimension: department_id {
    label: "Department ID"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;; }

  dimension_group: due {
    label: "Due"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DUE ;; }

  dimension_group: estimated_arrival {
    label: "Estimated Arrival"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ESTIMATED_ARRIVAL ;; }

  dimension_group: insert_ts {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_count {
    label: "Item Count"
    type: number
    sql: ${TABLE}.ITEM_COUNT ;; }

  dimension: item_id {
    label: "Item ID"
    description: "Internal Netsuite ID"
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: item_unit_price {
    label: "Item Unit Price"
    type: number
    sql: ${TABLE}.ITEM_UNIT_PRICE ;; }

  dimension: line_memo {
    label: "Memo"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: number_billed {
    label: "Number Billed"
    type: number
    sql: ${TABLE}.NUMBER_BILLED ;; }

  dimension: part_number_print {
    label: "Part Number Print"
    type: string
    sql: ${TABLE}.PART_NUMBER_PRINT ;; }

  dimension: product_line {
    label: "Product Line"
    type: string
    sql: ${TABLE}.PRODUCT_LINE ;; }

  dimension: project {
    label: "Project"
    type: string
    sql: ${TABLE}.PROJECT ;; }

  dimension: purchase_order_id {
    label: "Order ID"
    description: "Internal Netsuite ID"
    type: number
    sql: ${TABLE}.PURCHASE_ORDER_ID ;; }

  dimension: quantity_received {
    label: "Quantity Received"
    type: number
    sql: ${TABLE}.QUANTITY_RECEIVED_IN_SHIPMENT ;; }

  dimension: required_ship_by {
    label: "Required Ship by"
    type: date
    sql: ${TABLE}.REQUIRED_SHIP_BY ;; }

  dimension_group: shipment_received {
    label: "Shipment Received"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIPMENT_RECEIVED ;; }

  dimension_group: shipped {
    label: "Shipped"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIPPED ;; }

  dimension: unit_of_measurement {
    label: "Unit of Measurement"
    type: string
    sql: ${TABLE}.UNIT_OF_MEASUREMENT ;; }

  dimension_group: update_ts {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.UPDATE_TS ;; }

  measure: line_count {
    label: "Line Count"
    type: count
    drill_fields: [purchase_order_line_id, purchase_order.purchase_order_id] }

  measure: total_amount {
    label: "Total Amount ($)"
    type: sum
    sql: ${TABLE}.AMOUNT ;; }

  measure: Total_quantity_received {
    label: "Total Quantity Received (units)"
    description: "Quantity of what is dynamic on what it's totaling based on Unit of Measure"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.QUANTITY_RECEIVED_IN_SHIPMENT ;;
  }
  measure: Total_billed {
    label: "Total Billed ($)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.NUMBER_BILLED ;; }

  measure: Average_item_unit_price {
    label: "Average Item Unit Price ($)"
    type: average
    value_format: "$0.00"
    sql: ${TABLE}.ITEM_UNIT_PRICE ;; }

  measure: Total_item_count {
    label: "Total Item Count (units)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."ITEM_COUNT" ;; }

  measure: Total_open_quantity {
    label: "Total Open (units)"
    type: sum
    description: "Of the total item count, how many have not been received"
    value_format: "#,##0"
    sql: case when ${TABLE}."QUANTITY_RECEIVED_IN_SHIPMENT" is null then ${TABLE}."ITEM_COUNT"
          else ${TABLE}."ITEM_COUNT" - ${TABLE}."QUANTITY_RECEIVED_IN_SHIPMENT" end ;; }

}
