view: retail_order_flag {
  sql_table_name: "RETAIL"."V_ORDER_FLAG"
    ;;

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;; }

  dimension: is_chat {
    type: yesno
    sql: ${TABLE}."IS_CHAT" ;;
  }

  dimension: is_draft {
    type: yesno
    sql: ${TABLE}."IS_DRAFT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
