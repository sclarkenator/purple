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
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/accounting/transactions/purchord.nl?id={{ purchase_order_line.purchase_order_id._value }}" }
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
    hidden: yes
    #This is the transaction date
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

  measure: first_amount_due {
    type: sum
    hidden: yes
    sql: case
        when purchase_order.terms = '0' then ${TABLE}.amount
        when purchase_order.terms = '0% down, 100% 45 days after ETD' then ${TABLE}.amount
        when purchase_order.terms = '1% 10 Net 30' then ${TABLE}.amount*0.99
        when purchase_order.terms = '2% 10 Net 30' then ${TABLE}.amount*0.98
        when purchase_order.terms = '30% down, 70% 60 days after ETD' then ${TABLE}.amount*0.3
        when purchase_order.terms = '30% down, 70% before shipping' then ${TABLE}.amount*0.3
        when purchase_order.terms = '2% 10 Net 10' then ${TABLE}.amount*0.3
        when purchase_order.terms = '30%down/70%atshipdate' then ${TABLE}.amount*0.3
        when purchase_order.terms = '30% ship, 70% net 30 after ship' then ${TABLE}.amount*0.3
        when purchase_order.terms = '30%dwn,60%preship10%postinstall' then ${TABLE}.amount*0.3
        when purchase_order.terms = '50% down bal on deli' then ${TABLE}.amount*0.5
        when purchase_order.terms = '50%down/50% pre ship' then ${TABLE}.amount*0.5
        when purchase_order.terms = '50%down/50%before shipment' then ${TABLE}.amount*0.5
        when purchase_order.terms = 'Due on receipt' then ${TABLE}.amount
        when purchase_order.terms = 'Net 10' then ${TABLE}.amount
        when purchase_order.terms = 'Net 35' then ${TABLE}.amount
        when purchase_order.terms = 'Net 30' then ${TABLE}.amount
        when purchase_order.terms = 'Net 45' then ${TABLE}.amount
        when purchase_order.terms = 'Net 60' then ${TABLE}.amount
        when purchase_order.terms = 'Prepaid' then ${TABLE}.amount
        when purchase_order.terms = '- None -' then ${TABLE}.amount
        when purchase_order.terms = '20% down 80 % at shi' then ${TABLE}.amount*0.2
        when purchase_order.terms = '30% Down, Net 60' then ${TABLE}.amount*0.3
        when purchase_order.terms = '30% down/70% NET 30' then ${TABLE}.amount*0.3
        when purchase_order.terms = '40% Down, 60% Pre-Ship' then ${TABLE}.amount*0.4
        when purchase_order.terms = 'Net 7' then ${TABLE}.amount
        when purchase_order.terms = 'Net 20' then ${TABLE}.amount
        when purchase_order.terms = '1/3 dep. 1/3 at ship 1/3 net 30' then ${TABLE}.amount*0.33
        when purchase_order.terms = '25% Dwn, 65% PreShip, 10% CMPLT' then ${TABLE}.amount*0.25
        else ${TABLE}.amount*0.95 end ;;
  }

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
