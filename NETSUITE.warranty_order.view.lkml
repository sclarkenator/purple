view: warranty_order {
  sql_table_name: SALES.WARRANTY_ORDER ;;

  dimension: warranty_order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_ORDER_ID ;;}

  dimension: assigned_to {
    hidden: yes
    type: string
    sql: ${TABLE}.ASSIGNED_TO ;; }

  dimension: channel_id {
    label: "Channel ID"
    description: "1 = DTC, 2 = Wholesale"
    type: number
    sql: ${TABLE}.CHANNEL_ID ;; }

  dimension_group: created {
    type: time
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
    label: "Memo"
    description: "The order level notes on the warranty order"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: related_tranid {
    hidden: yes
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension: replacement_order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REPLACEMENT_ORDER_ID ;; }

  dimension: rmawarranty_ticket_number {
    hidden: yes
    type: string
    sql: ${TABLE}.RMAWARRANTY_TICKET_NUMBER ;; }

  dimension: status {
    label: "Status"
    description: "Warrenty status (Cancelled, Closed, Refunded, etc)"
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
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: warranty_reason_code_id {
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_REASON_CODE_ID ;; }

  dimension: warranty_ref_id {
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY_REF_ID ;; }

  dimension: warranty_type {
    label: "Warranty Type"
    description: "Material or Non Material"
    type: string
    sql: ${TABLE}.WARRANTY_TYPE ;;  }

}
