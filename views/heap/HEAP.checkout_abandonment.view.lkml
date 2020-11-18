view: heap_checkout_abandonment {
  derived_table: {
    explore_source: ecommerce {
      column: user_id { field: heap_all_events_subset.user_id }
      column: session_id { field: heap_page_views.session_id }
      column: event_time_date { field: heap_page_views.event_time_date }
      column: event_time_min { field: heap_page_views.event_time_min }
      column: event_time_max { field: heap_page_views.event_time_max }
      column: event_time_diff { field: heap_page_views.event_time_diff }
      column: ordered { field: ecommerce1.ordered }
      column: max_page_flow { field: heap_page_views.max_page_flow }
      column: min_page_flow { field: heap_page_views.min_page_flow }
      filters: {
        field: heap_page_views.event_time_date
        value: ""
      }
      filters: {
        field: heap_page_views.path
        value: "%checkouts%"
      }
    }
  }
  dimension: user_id {
    label: "Sessions User ID"
    description: "ID number for each user. Source: looker calculation"
  }
  dimension: session_id {
    description: "Unique ID number for a session. Source: heap.session_page_flow.session_id"
  }
  dimension_group: event_time_date {
    label: "Heap Page Views Pageview - Event Time Date"
    description: "Time the Visitor viewed a page. Source: heap.session_page_flow.event_time"
    hidden: no
    type: time
    timeframes: [raw,hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
  }
  dimension: event_time_min {
    type: number
  }
  dimension: event_time_max {
    type: number
  }
  dimension: event_time_diff {
    type: number
  }
  dimension: ordered {}
  dimension: max_page_flow {}
  dimension: min_page_flow {}
  measure: avg_time_to_purchase {
    description: "Average time to purchase in minutes."
    value_format: "#0.00"
    type: average
    sql: ${event_time_diff} ;;
  }
  measure: avg_max_page_flow {
    type: average
    value_format: "#0"
    sql: ${max_page_flow} ;;
  }
  measure: avg_min_page_flow {
    value_format: "#0"
    type: average
    sql: ${min_page_flow} ;;
  }
  measure: count_users {
    label: "Total Users"
    type: count_distinct
    sql: ${user_id} ;;
  }
  measure: purchase_users {
    type: count_distinct
    filters: [ordered: "purchase"]
    sql: ${user_id} ;;
  }
  measure: no_purchase_users {
    type: count_distinct
    filters: [ordered: "no_purchase"]
    sql: ${user_id} ;;
  }
  measure: percent_purchased {
    type: number
    value_format: "#0.00%"
    sql: ${purchase_users}/${count_users} ;;
  }
  measure: percent_no_purchased {
    type: number
    value_format: "#0.00%"
    sql: ${no_purchase_users}/${count_users} ;;
  }
}
