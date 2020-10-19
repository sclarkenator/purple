view: v_financed_retail {
  sql_table_name: "SALES"."V_FINANCED_RETAIL"
    ;;

  dimension: etail_order_id {
    hidden: yes
    type: string
    sql: ${TABLE}."ETAIL_ORDER_ID" ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    primary_key: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: retail_financed_order {
    label: "     * Is Retail Financed"
    description: "Source: shopify_pos.v_financed_retail"
    hidden: yes
    type: yesno
    sql: ${TABLE}."ORDER_ID" is not null  ;;
  }

}
