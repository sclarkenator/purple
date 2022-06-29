view: first_order_flag {
  sql_table_name: analytics.heap.v_ecommerce_first_order_flag ;;

  dimension: pk {
    description: "Primary key for order lookup"
    primary_key: yes
    hidden:  yes
    type: string
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: new_flg {
    label: "     * New/Repeat Customer?"
    view_label: "Customer"
    description: "New or repeat for this email address? Source: looker.calculation"
    type: string
    sql: ${TABLE}.new_Flg ;;
  }

  dimension: order_num {
    label: "Order sequence number"
    view_label: "Customer"
    group_label: " Advanced"
    description: "Sequence of current order Source: looker.calculation"
    type: number
    sql: ${TABLE}.order_num ;;
  }
  measure: new_customer {
    view_label: "Customer"
    sql: ${pk};;
    filters: [new_flg: "NEW"]
    type: count_distinct
    value_format: "#,##0"
    hidden: yes
  }

  measure: repeat_customer {
    view_label: "Customer"
    sql: ${pk};;
    filters: [new_flg: "REPEAT"]
    type: count_distinct
    value_format: "#,##0"
    hidden: yes
  }

  dimension: email {
    view_label: "Email Address"
    description: "Email address of customer"
    sql: ${TABLE}.email ;;
    hidden: yes
  }
}
