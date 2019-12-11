view: warranty_order {
  sql_table_name: SALES.WARRANTY_ORDER ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: NVL(${TABLE}.order_id,0)||${TABLE}.warranty_order_id||${TABLE}.replacement_order_id ;;
  }

  dimension: warranty_order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_ORDER_ID ;;}

  dimension: assigned_to {
    hidden: yes
    type: string
    sql: ${TABLE}.ASSIGNED_TO ;; }

  dimension: channel_id {
    label: "Channel ID"
    hidden: yes
    description: "1 = DTC, 2 = Wholesale"
    type: number
    sql: ${TABLE}.CHANNEL_ID ;; }

  dimension: is_warrantied {
    label: "     * Is Warrantied"
    description: "Warranty order has been created"
    type: yesno
    sql: ${TABLE}.CREATED is not null ;;
  }

  dimension_group: created {
    type: time
    label: "   Warranty "
    description: "Warranty Created"
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CREATED ;; }

  dimension_group: insert_ts {
    hidden:  yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: memo {
    group_label: " Advanced"
    label: "Header Memo"
    description: "The header level notes on the warranty order"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: related_tranid {
    hidden: no
    group_label: " Advanced"
    label: "Related Transaction ID"
    description: "The related transaction ID"
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension: replacement_order_id {
    hidden: no
    group_label: " Advanced"
    type: number
    description: "Order Id for the replacement item"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    sql: ${TABLE}.REPLACEMENT_ORDER_ID ;; }

  dimension: rmawarranty_ticket_number {
    hidden: yes
    type: string
    sql: ${TABLE}.RMAWARRANTY_TICKET_NUMBER ;; }

  dimension: status {
    label: "  Status"
    description: "Warrenty status (Cancelled, Closed, Refunded, etc). Closed means the warranty was completed."
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: transaction_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;; }

  dimension_group: update_ts {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: warranty_reason_code_id {
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_REASON_CODE_ID ;; }

  dimension: warranty_ref_id {
    label: "RMA Number"
    group_label: " Advanced"
    description: "RMA number for warranty"
    type: string
    sql: ${TABLE}.WARRANTY_REF_ID ;; }

  dimension: warranty_type {
    label: "  Warranty Type"
    description: "Material or Non Material"
    type: string
    sql: ${TABLE}.WARRANTY_TYPE ;;  }

  dimension: customer_receipt {
    group_label: " Advanced"
    label: "Customer Receipt"
    description: "Date the Customer received a bed"
    type: date
    sql: ${TABLE}.CUSTOMER_RECEIPT ;; }

  measure: days_between {
    group_label: " Advanced"
    label: "Warranty Window"
    description: "Average number of days between Customer Receipt and Warranty Created dates"
    type: average
    sql: datediff(day,${TABLE}.customer_receipt,${TABLE}.created) ;; }

}
