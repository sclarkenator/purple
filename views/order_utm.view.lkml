view: order_utm {
  sql_table_name: ANALYTICS.MARKETING.V_ORDER_UTM ;;
# derived_table: {
#   sql:
#         select s.created
#       , s.order_id
#       , s.SYSTEM
#       , s.email
#       , gross_amt
#       , e.utm_medium
#       , e.utm_source
#       , e.utm_term
#     from sales.sales_order s
#     left join marketing.ecommerce e on e.order_number = s.related_tranid
#     --where s.created > '2020-11-01' and e.session_id is not null
#     ;;
# }

  # 7/6/2021 - unhid created date for use in cordial_activity explore. -Stevie
  dimension: created {
    type: date_time
    # hidden: yes
    sql: ${TABLE}.created ;;
  }

  dimension: order_id {
    type: string
    # primary_key: yes
    sql: ${TABLE}.order_id ;;
  }

  # Added on 12/10 to join first_order_flag view - Mason
  dimension: SYSTEM {
    type: string
    hidden: yes
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: pk {
    description: "Primary key for order lookup"
    primary_key: yes
    hidden:  yes
    type: string
    sql: ${TABLE}.primary_key;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: utm_term {
    type: string
    sql: ${TABLE}.utm_term ;;
  }

  measure: gross_amt {
    type: sum
    sql: ${TABLE}.gross_amt  ;;
  }

  measure: orders {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }

}
