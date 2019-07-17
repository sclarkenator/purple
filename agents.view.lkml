view: agent_lkp {
  sql_table_name: customer_care.agent_lkp ;;

  dimension: incontact_id {
    description: "The InContact ID for this agent"
    type:  number
    sql: ${TABLE}.incontact_id ;;
  }

  dimension: zendesk_id {
    description: "The ZenDesk ID for this agent"
    type:  number
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: shopify_id {
    description: "The Shopify ID for this agent"
    type:  number
    sql: ${TABLE}.shopify_id ;;
  }

  dimension: team_id {
    description: "The Team ID for this agent"
    type:  number
    sql: ${TABLE}.team_id ;;
  }

  dimension: email {
    description: "The email address for this agent"
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    description: "The name of this agent"
    type:  string
    sql: ${TABLE}.name ;;
  }

  dimension: is_super {
    description: "Whether or not this agent is a supervisor"
    type: yesno
    sql: ${TABLE}.supervisor ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;; }


  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: agents {
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
