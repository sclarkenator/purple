include: "/views/_period_comparison.view.lkml"
######################################################
#   Activities
#   https://purple.looker.com/dashboards-next/4155
######################################################
view: ndt_activities {
  derived_table: {
    explore_source: cc_activities {
      column: activity_date {}
      column: agent_name {}
      column: agent_email {}
      column: activity_type {}
      column: count {}
      filters: { field: cc_activities.missed value: "No" }
      filters: { field: cc_activities.activity_date value: "2 years"  }
      filters: { field: cc_activities.team_clean value: "sales" }
    }
  }
  dimension: activity_date { type: date }
  dimension: agent_name {}
  dimension: agent_email {}
  dimension: activity_type {}
  dimension: count {
    type: number
  }
}
######################################################
#   Deals
#   https://purple.looker.com/dashboards-next/4155
######################################################
view: ndt_deals {
  derived_table: {
    explore_source: cc_deals {
      column: created_date {}
      column: agent {}
      column: agent_email {}
      column: source_clean {}
      column: count {}
      filters: { field: cc_deals.created_date value: "2 years"  }
    }
  }
  dimension: created_date { type: date }
  dimension: agent {}
  dimension: agent_email {}
  dimension: source_clean {}
  dimension: count { type: number }
}
######################################################
#   Orders
#   https://purple.looker.com/dashboards-next/4155
######################################################
view: ndt_is_orders {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: merged_name { field: agent_name.merged_name }
      column: email_2 { field: agent_name.email_2 }
      column: source_clean { field: cc_deals.source_clean }
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      column: total_orders { field: sales_order.total_orders }
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: sales_order.is_exchange_upgrade_warranty value: "No" }
      filters: { field: zendesk_sell.inside_sales_order value: "Yes" }
      filters: { field: sales_order_line.created_date value: "2 years" }
      filters: { field: sales_order.gross_amt value: ">0"}
    }
  }
  dimension: created_date { type: date }
  dimension: merged_name { type: string }
  dimension: email_2 { type: string }
  dimension: source_clean { type:string }
  dimension: total_gross_Amt_non_rounded { type: number }
  dimension: total_units { type: number }
  dimension: total_orders { type: number }
}

# view: ndt_is_orders {
#   derived_table: {
#     explore_source: cc_deals {
#       column: created_date { field: sales_order_line_base.created_date }
#       column: agent {}
#       column: agent_email {}
#       column: source_clean {}
#       column: count {}
#       column: total_gross_Amt_non_rounded { field: sales_order_line_base.total_gross_Amt_non_rounded }
#       filters: { field: sales_order_line_base.created_date value: "2 years"  }
#     }
#   }
#   dimension: created_date { type: date }
#   dimension: agent {}
#   dimension: agent_email {}
#   dimension: source_clean {}
#   dimension: count { type: number }
#   dimension: total_gross_Amt_non_rounded { type: number }
# }
######################################################
#   FINAL TABLE
######################################################
view: cc_traffic {
  derived_table: {
    sql:
    select
      'Activities' as metric_type
      , a.activity_date::date as merged
      , a.agent_name as agent
      , a.agent_email
      , a.activity_type as source_clean
      , a.count
      , null as gross_sales
    from ${ndt_activities.SQL_TABLE_NAME} a
    union all
    select
      'SQLs' as metric_type
      , a.created_date::date
      , a.agent
      , a.agent_email
      , a.source_clean
      , a.count
      , null as gross_sales
    from ${ndt_deals.SQL_TABLE_NAME} a
    union all
    select
      'Orders' as metric_type
      , a.created_date::date
      , a.merged_name
      , email_2
      , a.source_clean
      , a.total_orders
      , total_gross_Amt_non_rounded
    from ${ndt_is_orders.SQL_TABLE_NAME} a
    ;;
  }
  extends: [_period_comparison]

  ### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [raw,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${TABLE}.merged);;
  }

  dimension_group: merged {
    type: time
    timeframes: [date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.merged  ;;
  }

  dimension: agent {
    type: string
    sql: ${TABLE}.agent ;;
  }

  dimension: agent_email {
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: source_clean {
    label: "Source"
    type: string
    sql: ${TABLE}.source_clean ;;
  }

  dimension: metric_type {
    type: string
    sql: ${TABLE}.metric_type ;;
  }

  measure: count {
    hidden: yes
    type: sum
    sql: ${TABLE}.count ;;
  }

  measure: sales {
    type: sum
    value_format_name: usd
    sql: ${TABLE}.gross_sales ;;
  }

  measure: order_count {
    type: sum
    sql: ${TABLE}.count ;;
    filters: [metric_type: "Orders"]
    drill_fields:[period, merged_date, order_count]
  }

  measure: activities_count {
    type: sum
    sql: ${TABLE}.count ;;
    filters: [metric_type: "Activities"]
  }

  measure: SQL_count {
    type: sum
    sql: ${TABLE}.count ;;
    filters: [metric_type: "SQLs"]
  }

  measure: is_cvr {
    label: "Conversion Rate"
    description: "% of all IS orders over IS activities. Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${order_count})/NULLIF(${activities_count},0) ;;
  }
  measure: close_rate {
    label: "Close Rate"
    description: "% of all IS orders over IS activities. Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${order_count})/NULLIF(${SQL_count},0) ;;
  }

  measure: aov {
    label: "AOV"
    description: "IS Average Order Value = IS Sales over IS Orders"
    type: number
    value_format_name: usd
    sql: (${sales})/NULLIF(${order_count},0);;
  }
}
