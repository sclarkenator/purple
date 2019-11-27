view: warranty_order_line {
  sql_table_name: sales.warranty_order_line ;;

  dimension: item_order{
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

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
    group_label: " Advanced"
    label: "Line Memo"
    description: "The line level notes on the warranty order"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  measure: quantity {
    label: "Total Warranties Initiated (units)"
    description: "Units for which a warranty was created"
    type: sum
    sql_distinct_key: ${item_order} ;;
    #drill_fields: [sales_order_line.order_id,sales_order_line.created_date,warranty_order.created_date,item.model_name,item.size,item.product_name,warranty_reason.return_reason]
    sql: ${TABLE}.QUANTITY ;; }

  measure: quantity_complete {
    label: "Total Warranties Completed (units)"
    description: "Units from warranties where the warranty has been completed"
    type: sum
    filters: {
      field: warranty_order.status
      value: "Closed"
    }
    sql: ${TABLE}.QUANTITY ;;
  }

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
    #primary_key: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.WARRANTY_ORDER_ID ;; }

  measure: count {
    hidden:  yes
    type: count
    drill_fields: [warranty_order.warranty_order_id] }

}
