#-------------------------------------------------------------------
# Owner - Scott Clark
#-------------------------------------------------------------------

view: purchase_order {
  sql_table_name: PRODUCTION.PURCHASE_ORDER ;;

  dimension: purchase_order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.PURCHASE_ORDER_ID ;; }

  dimension: channel {
    label: "Channel ID"
    description: "1 = DTC, 2 = Wholesale"
    type: string
    sql: ${TABLE}.CHANNEL ;; }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.CREATED ;; }

  dimension: currency {
    label: "Currency"
    type: string
    sql: ${TABLE}.CURRENCY ;; }

  dimension: Container_count{
    type: string
    sql: ${TABLE}."container_count" ;;
    hidden: no
  }

  dimension: entity_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ENTITY_ID ;; }

  dimension: exchange_rate {
    label: "Exchange Rate"
    type: number
    sql: ${TABLE}.EXCHANGE_RATE ;; }

  dimension_group: insert_ts {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: location_id {
    type: number
    hidden: yes
    sql: ${TABLE}.LOCATION_ID ;; }

  dimension: Order_memo {
    label: "Memo"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension_group: modified {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.MODIFIED ;; }

  dimension: related_tranid {
    label: "Related Transaction ID"
    description: "This is the 'name' field in Shopify, related_tranid in Netsuite "
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension: requester {
    label: "Requester"
    type: string
    sql: ${TABLE}.REQUESTER ;; }

  dimension_group: required_ship_by {
    label: "Required Ship by"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.REQUIRED_SHIP_BY ;; }

  dimension_group: sales_effective {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SALES_EFFECTIVE ;; }

  dimension: status {
    label: "Status"
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: terms {
    label: "Terms"
    type: string
    sql: ${TABLE}.TERMS ;; }

  dimension_group: trandate {
    label: "Transaction Date"
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.TRANDATE ;; }

  dimension: tranid {
    label: "Document Number"
    description: "Transaction ID in Netsuite"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/accounting/transactions/purchord.nl?id={{ purchase_order_line.purchase_order_id._value }}" }
    sql: ${TABLE}.TRANID ;; }

  dimension: transaction_number {
    type: string
    hidden: yes
    sql: ${TABLE}.TRANSACTION_NUMBER ;; }

  dimension_group: update_ts {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.UPDATE_TS ;; }

  measure: Order_count {
    type: count
    drill_fields: [purchase_order_id, purchase_order_line.count] }

}
