view: refund {
  sql_table_name: SALES.REFUND ;;

  dimension: refund_id {
    label: "Refund ID"
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.REFUND_ID ;; }

  dimension_group: created {
    label: "Refund Created"
    type: time
    timeframes: [ raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.CREATED) ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: modified {
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;; }

  dimension: order_id {
    hidden: yes
    label: "Sales Order ID"
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: product_refunded_amt {
    label: "Product Refund Amount"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.PRODUCT_REFUNDED_AMT ;; }

  dimension: recycle_fee_refunded_amt {
    label: "Recycle Fee Refund Amount"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.RECYCLE_FEE_REFUNDED_AMT ;; }

  dimension: return_order_id {
    hidden: yes
    label: "Return ID"
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID ;; }

  dimension: shipping_refunded_amt {
    label: "Shipping Refund Amount"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.SHIPPING_REFUNDED_AMT ;; }

  dimension: system {
    hidden: yes
    label: "Source System"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: tax_refunded_amt {
    label: "Tax Refund Amount"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.TAX_REFUNDED_AMT ;; }

  dimension: trandate {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANDATE ;; }

  dimension: tranid {
    label: "Transaction ID"
    description: "Internal Netsuite ID"
    type: number
    value_format_name: id
    sql: ${TABLE}.TRANID ;; }

  dimension: update_ts {
    type: string
    hidden: yes
    sql: ${TABLE}.UPDATE_TS ;; }

  measure: count {
    type: count
    drill_fields: [refund_id] }

  measure: product_refunds {
    label: "Total Product Refunds"
    description: "Sum of products refunded excluding taxes, shipping, and recycling fees"
    type: sum
    drill_fields: [product_refunded_amt]
    sql:  ${TABLE}.PRODUCT_REFUNDED_AMT ;; }

  measure: tax_refunds {
    label: "Total Tax Refunds"
    description: "Sum of taxes refunded"
    type: sum
    drill_fields: [tax_refunded_amt]
    sql:  ${TABLE}.TAX_REFUNDED_AMT ;; }

  measure: shipping_refunds {
    label: "Total Shipping Refunds"
    description: "Sum of shipping costs refunded"
    type: sum
    drill_fields: [shipping_refunded_amt]
    sql:  ${TABLE}."SHIPPING_REFUNDED_AMT" ;; }

  measure: recycle_fee_refunds {
    label: "Total Recycle Fee Refunds"
    description: "Sum of recycling fees refunded"
    type: sum
    drill_fields: [recycle_fee_refunded_amt]
    sql:  ${TABLE}.RECYCLE_FEE_REFUNDED_AMT ;; }

}
