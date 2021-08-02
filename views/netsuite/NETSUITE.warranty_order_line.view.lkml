view: warranty_order_line {
  sql_table_name: sales.warranty_order_line ;;

  dimension: primary_key {
    type: string
    primary_key:  yes
    hidden: yes
    sql: NVL(${TABLE}.item_id,'0')||'-'||NVL(${TABLE}.warranty_order_id,'0')||'-'||NVL(${TABLE}.system,'-')||NVL(${TABLE}.created_ts,'0') ;; }

  dimension: is_warrantied {
    label: "     * Is Warrantied"
    description: "Warranty order has been created for a product. Source: netsuite.warranty_order_line"
    type: yesno
    sql: ${TABLE}.CREATED_TS is not null ;;
  }

  dimension: item_order{
    type: string
    hidden: yes
    sql: NVL(${TABLE}.item_id,'0')||'-'||NVL(${TABLE}.order_id,'0')||'-'||NVL(${TABLE}.system,'-');; }

  dimension_group: closed {
    hidden: no
    label: "   Warranty Closed"
    description: "The Date the Warranty was Closed. Source:netsuite.warranty_order_line"
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
    description: "The line level notes on the warranty order. Source:netsuite.warranty_order_line"
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  measure: quantity {
    group_label: " Advanced"
    label: "Total Warranties Initiated (units)"
    description: "Units for which a warranty was created. Source:netsuite.warranty_order_line"
    type: sum
    #drill_fields: [sales_order_line.order_id,sales_order_line.created_date,warranty_order.created_date,item.model_name,item.size,item.product_name,warranty_reason.return_reason]
    sql: ${TABLE}.QUANTITY ;; }

  measure: quantity_complete {
    group_label: " Advanced"
    label: "Total Warranties Completed (units)"
    description: "Units from warranties where the warranty has been completed. Source:netsuite.warranty_order_line"
    type: sum
##    filters: {
##      field: warranty_order.status
##      value: "Closed"}
    sql: case when ${closed_date} is not null then ${TABLE}.QUANTITY else 0 end ;;
  }

  measure: quantity_complete_sales {
    group_label: " Advanced"
    label: "Total Warranties Completed ($)"
    value_format: "$#,##0"
    description: "Units from warranties where the warranty has been completed. Source:netsuite.warranty_order_line"
    type: sum
    sql_distinct_key: ${primary_key} ;;
##    filters: {
##      field: warranty.status
##      value: "Closed"}
    sql: (case when ${closed_date} is not null then ${TABLE}.QUANTITY else 0 end) *${sales_order_line.gross_amt} ;;
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
    sql: ${TABLE}.WARRANTY_ORDER_ID ;; }

  dimension: warranty_reason_code_id {
    hidden: yes
    type: number
    sql: ${TABLE}.warranty_reason_code_id ;; }

  measure: count {
    hidden:  yes
    type: count
    drill_fields: [warranty_order.warranty_order_id] }

}
