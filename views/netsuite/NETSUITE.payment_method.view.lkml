view: payment_method {
  sql_table_name: SALES.PAYMENT_METHOD ;;

  dimension: payment_method_id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}.PAYMENT_METHOD_ID ;; }

  dimension: payment_method {
    label: "Payment Method"
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;; }

  measure: count {
    type: count
    drill_fields: [payment_method_id, payment_method, refund_line.count] }

}
