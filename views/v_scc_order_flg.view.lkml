view: v_scc_order_flg {
  sql_table_name: "WHOLESALE"."V_SCC_ORDER_FLG"
    ;;

  dimension: mattresses {
    hidden: yes
    type: number
    sql: ${TABLE}."MATTRESSES" ;;
  }

  dimension: order_id {
    hidden:  yes
    primary_key: yes
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  measure: has_mattress {
    type:  sum
    sql: case when ${mattresses} > 0 Then 1 END;;
  }

  measure: no_mattress {
    type: sum
    sql: case when ${mattresses} = 0 OR ${mattresses} IS NULL THEN 1 END  ;;
  }

  measure: mattress_sales {
    type: sum
    sql:  case when ${mattresses} > 0 Then ${TABLE}.order_sales END ;;
  }

  measure: non_mattress_sales {
    type: sum
    sql: case when ${mattresses} = 0 OR ${mattresses} IS NULL Then ${TABLE}.order_sales END ;;
  }

  dimension: has_mattress_dim {
    type: yesno
    sql: ${mattresses} > 0;;
  }
}
