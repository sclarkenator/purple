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

  dimension: container_count{
    type: string
    sql: ${TABLE}."CONTAINER_COUNT" ;;
    hidden: no}

  dimension: entity_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ENTITY_ID ;; }

  dimension: finals_ship_location {
    label: "Final Ship Location"
    type: number
    sql: ${TABLE}."FINAL_SHIP_LOCATION" ;; }

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

  dimension: first_due_date {
    type: date
    hidden: yes
    sql: case
        when ${TABLE}.terms = '0' then ${TABLE}.created
        when ${TABLE}.terms = '0% down, 100% 45 days after ETD' then dateadd(day, 45, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '1% 10 Net 30' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '2% 10 Net 30' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '30% down, 70% 60 days after ETD' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30% down, 70% before shipping' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '2% 10 Net 10' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30%down/70%atshipdate' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30% ship, 70% net 30 after ship' then ${TABLE}.created
        when ${TABLE}.terms = '30%dwn,60%preship10%postinstall' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50% down bal on deli' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50%down/50% pre ship' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50%down/50%before shipment' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = 'Due on receipt' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = 'Net 10' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 35' then dateadd(day, 15, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 30' then dateadd(day, 30, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 45' then dateadd(day, 45, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 60' then dateadd(day, 60, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Prepaid' then ${TABLE}.created
        when ${TABLE}.terms = '- None -' then ${TABLE}.created
        when ${TABLE}.terms = '20% down 80 % at shi' then ${TABLE}.created
        when ${TABLE}.terms = '30% Down, Net 60' then ${TABLE}.created
        when ${TABLE}.terms = '30% down/70% NET 30' then ${TABLE}.created
        when ${TABLE}.terms = '40% Down, 60% Pre-Ship' then ${TABLE}.created
        when ${TABLE}.terms = 'Net 7' then dateadd(day, 7, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 20' then dateadd(day, 20, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '1/3 dep. 1/3 at ship 1/3 net 30' then dateadd(day, 7, ${TABLE}.required_ship_by)
        else dateadd(day, 7, ${TABLE}.required_ship_by)  end ;;
  }

  dimension: second_due_date {
    type: date
    hidden: yes
    sql: case
        when ${TABLE}.terms = '0' then ${TABLE}.created
        when ${TABLE}.terms = '0% down, 100% 45 days after ETD' then dateadd(day, 45, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '1% 10 Net 30' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '2% 10 Net 30' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '30% down, 70% 60 days after ETD' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30% down, 70% before shipping' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '2% 10 Net 10' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30%down/70%atshipdate' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30% ship, 70% net 30 after ship' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '30%dwn,60%preship10%postinstall' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50% down bal on deli' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50%down/50% pre ship' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = '50%down/50%before shipment' then dateadd(day, 7, ${TABLE}.created)
        when ${TABLE}.terms = 'Due on receipt' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = 'Net 10' then dateadd(day, 10, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 35' then dateadd(day, 15, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 30' then dateadd(day, 30, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 45' then dateadd(day, 45, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Net 60' then dateadd(day, 60, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = 'Prepaid' then ${TABLE}.created
        when ${TABLE}.terms = '- None -' then ${TABLE}.created
        when ${TABLE}.terms = '20% down 80 % at shi' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = '30% Down, Net 60' then dateadd(day, 30, ${TABLE}.required_ship_by)
        when ${TABLE}.terms = '30% down/70% NET 30' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = '40% Down, 60% Pre-Ship' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = 'Net 7' then ${TABLE}.created
        when ${TABLE}.terms = 'Net 20' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = '1/3 dep. 1/3 at ship 1/3 net 30' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = '25% Dwn, 65% PreShip, 10% CMPLT' then ${TABLE}.required_ship_by
        when ${TABLE}.terms = '1/2% 10, Net 30' then dateadd(day, 10, ${TABLE}.required_ship_by)
        else dateadd(day, 30, ${TABLE}.required_ship_by)  end ;;
  }

  measure: Order_count {
    type: count
    drill_fields: [purchase_order_id, purchase_order_line.count] }

}
