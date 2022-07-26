# view: c3_conversion_count {
#   Deprecated on 7/26 after discussion with Savannah G. We terminated our relationship with the agency, C3 over a year ago.
#   # sql_table_name: ANALYTICS.MARKETING.V_C3_CONVERSION_COUNT ;;
#   derived_table: {
#     sql:
#       select order_id
#         , max (sale_amount) as sale_amount
#       from analytics.marketing.C3_CONVERSION
#       group by 1
#     ;;
#   }

#   dimension: order_id {
#     type: number
#     hidden: yes
#     sql: ${TABLE}."ORDER_ID" ;;
#     primary_key: yes
#   }


#   dimension: sale_amount_dim {
#     type: number
#     hidden: yes
#     sql: ${TABLE}."SALE_AMOUNT" ;;
#   }

#   measure: influenced {
#     type: sum
#     sql: ${TABLE}.sale_amount ;;
#   }

# }
