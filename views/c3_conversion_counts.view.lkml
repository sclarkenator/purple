view: c3_conversion_count {
  sql_table_name: ANALYTICS.MARKETING.V_c3_conversion_count ;;
  # derived_table: {
  #   sql:
  #     select order_id
  #       , max (sale_amount) as sale_amount
  #     from analytics.marketing.C3_CONVERSION
  #     group by 1
  #   ;;
  # }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
    primary_key: yes
  }


  dimension: sale_amount_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."SALE_AMOUNT" ;;
  }

  measure: influenced {
    type: sum
    sql: ${TABLE}.sale_amount ;;
  }

}
