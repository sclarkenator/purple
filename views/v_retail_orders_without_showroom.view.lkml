view: v_retail_orders_without_showroom {
  sql_table_name: "CUSTOMER_CARE"."V_RETAIL_ORDERS_WITHOUT_SHOWROOM"
    ;;

  dimension: purple_showroom_name {
    type: string
    sql: ${TABLE}."PURPLE_SHOWROOM_NAME" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

}
