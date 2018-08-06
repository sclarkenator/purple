view: order_flag {

derived_table: {
  sql: SELECT ORDER_ID
            ,case when MATTRESS_FLG >0 then 1 else 0 end mattress_flg
            ,case when CUSHION_FLG >0 then 1 else 0 end cushion_flg
            ,case when SHEETS_FLG >0 then 1 else 0 end sheets_flg
            ,case when PROTECTOR_FLG >0 then 1 else 0 end protector_flg
            ,case when BASE_FLG >0 then 1 else 0 end base_flg
            ,case when PILLOW_FLG >0 then 1 else 0 end pillow_flg
            ,CASE WHEN MATTRESS_ORDERED > 1 THEN 1 ELSE 0 END MM_FLG
      FROM(
          select order_id
                  ,sum(case when product_line_name = 'MATTRESS' THEN 1 ELSE 0 END) MATTRESS_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'CUSHION' THEN 1 ELSE 0 END) CUSHION_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'M.PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'MATTRESS' THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
          from sales_order_line sol
          left join item on item.item_id = sol.item_id
          GROUP BY 1) ;;
    }

  measure: mattress_orders {
    label: "Total orders w/ a mattress"
    description: "Flag if there was a mattress in the order"
    type:  sum
    sql:  ${TABLE}.mattress_flg ;;
  }

  measure: cushion_orders {
    label: "Total orders w/ a cushion"
    description: "Flag if there was a cushion in the order"
    type:  sum
    sql:  ${TABLE}.cushion_flg ;;
  }

  measure: sheets_orders {
    label: "Total orders w/ sheets"
    description: "Flag if there were sheets in the order"
    type:  sum
    sql:  ${TABLE}.sheets_flg ;;
  }

  measure: protector_orders {
    label: "Total orders w/ a mattress protector"
    description: "Flag if there was a mattress protector in the order"
    type:  sum
    sql:  ${TABLE}.protector_flg ;;
  }

  measure: pillow_orders {
    label: "Total orders w/ a pillow"
    description: "Flag of there was a pillow in the order"
    type:  sum
    sql:  ${TABLE}.pillow_flg ;;
  }

  measure: base_orders {
    label: "Total orders w/ a base"
    description: "Flag of there was a base in the order"
    type:  sum
    sql:  ${TABLE}.base_flg ;;
  }

  measure: mm_orders {
    label: "Total orders w/ multiple mattresses"
    description: "Flag of there was more than 1 mattress in the order"
    type:  sum
    sql:  ${TABLE}.mm_flg ;;
  }

  dimension: mattress_flg {
    label: "Mattress order"
    description: "Was there a mattress in this order"
    type:  number
    sql: ${TABLE}.mattress_flg ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;;
  }

  dimension: mm_orders_flg {
    label: "Total orders w/ multiple mattresses"
    description: "Flag of there was more than 1 mattress in the order"
    type:  number
    sql:  ${TABLE}.mm_flg ;;
  }

}
