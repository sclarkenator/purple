view: agent_lkp {
  sql_table_name: customer_care.agent_lkp ;;

  dimension: incontact_id {
    description: "The InContact ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.incontact_id ;;
    primary_key: yes
  }

  #dimension: incontact_team_id {
  #  description: "The InContact team ID for this agent"
  #  type:  number
  #  sql: ${TABLE}.incontact_team_id ;;
  #}

  dimension: zendesk_id {
    description: "The ZenDesk ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: zendesk_sell_id {
    description: "The ZenDesk Sell ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.zendesk_sell_user_id ;;
  }

  dimension: shopify_id {
    description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.shopify_id ;;
  }

  dimension: shopify_id_pos {
    description: "The Shopify POS ID for Retail agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.shopify_id_pos ;;
  }

  dimension: workday_id {
    description: "The Workday ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.workday_id  ;;
  }

  dimension: retail {
    hidden: no
    label: " * Is Retail Agent. Source: incontact.agent_lkp"
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

  #dimension: team_id {
  #  description: "The Team ID for this agent"
  #  type:  number
  #  sql: ${TABLE}.team_id ;;
  #}

  #dimension: team_lead_id {
  #  description: "The ID for this agent's team lead"
  #  type:  number
  #  sql: ${TABLE}.team_lead_id ;;
  #}

  dimension: email {
    description: "The email address for this agent. Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    description: "The name of this agent. Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.name ;;
  }

  dimension: is_supervisor {
    description: "Whether or not this agent is a supervisor. Source: incontact.agent_lkp"
    type: yesno
    sql: ${TABLE}.supervisor ;;
  }

  dimension_group: inactive {
    description: "Date agent became inactive. Source: incontact.agent_lkp"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: timestamp
    sql: ${TABLE}.inactive ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;; }

  dimension: insert_ts {
    hidden: yes
    type:  date_time
    sql: ${TABLE}.insert_ts ;;
  }

  dimension: team_type {
    description: "Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.team_type ;;
  }

  dimension: employee_type {
    description: "Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.employee_type ;;
  }

  dimension_group: purple_with_purpose {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.purple_with_purpose ;;
  }

  dimension_group: mentor {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.mentor ;;
  }

  dimension_group: service_recovery_team {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.service_recovery_team ;;
  }

  dimension_group: hire {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.hired ;;
  }

  dimension_group: termination {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.terminated ;;
  }

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
