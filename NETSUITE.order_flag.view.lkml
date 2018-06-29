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
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME = 'MATTRESS PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
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
}
# view: netsuite_order_summary {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
