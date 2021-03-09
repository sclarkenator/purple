view: retail_orders_without_tags {
  sql_table_name: "RETAIL"."V_RETAIL_ORDERS_WITHOUT_TAGS"
    ;;

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

}
