view: warranty_order_line {
  sql_table_name: sales.warranty_order_line ;;

  dimension_group: closed {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CLOSED ;; }

  dimension_group: created_ts {
    hidden: yes
    type: time
    timeframes:[raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.CREATED_TS ;; }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: memo {
    label: "Memo"
    description: "The order level notes on the warranty order"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  measure: quantity {
    label: "Total Units"
    type: sum
    sql: ${TABLE}.QUANTITY ;; }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: warranty_order_id {
    hidden: yes
    primary_key: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.WARRANTY_ORDER_ID ;; }

  measure: count {
    type: count
    drill_fields: [warranty_order.warranty_order_id] }

}
