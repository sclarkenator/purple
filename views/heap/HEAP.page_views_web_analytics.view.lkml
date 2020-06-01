view: heap_page_views_web_analytics {

   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: select
        user_id,session_id,event_id,time as event_time
      from analytics.heap.pageviews
      group by 1,2,3,4
       ;;
   }

  # dimension: user_id {
  #   hidden: no
  #   type: string
  #   sql: ${TABLE}.user_id ;;
  # }

  # dimension: session_id {
  #   hidden: no
  #   type: string
  #   sql: ${TABLE}.session_id ;;
  # }

  # dimension: event_id {
  #   hidden: no
  #   type: string
  #   sql: ${TABLE}.event_id ;;
  # }

  dimension: session_id_and_event_time {
    hidden: yes
    primary_key: yes
    type: string
    sql:concat( ${TABLE}.session_id , ${TABLE}.event_time );;
  }

#   dimension_group: session_time {
#     description: "Time the Session Began"
#     hidden: yes
#     type: time
#     timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
#     convert_tz: no
#     datatype: timestamp
#     sql: to_timestamp_ntz(${TABLE}.session_time) ;;
#   }

  dimension_group: event_time {
    label: "Pageview - Event Time"
    description: "Time the Visitor viewed a page"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.event_time) ;;
  }

  parameter: primary_metric_name {
    type: unquoted
    default_value: "pageviews"
    allowed_value: {
      value: "event_id"
      label: "Pageviews"
    }
    allowed_value: {
      value: "user_id"
      label: "Users"
    }
    allowed_value: {
      value: "session_id"
      label: "Sessions"
    }
    allowed_value: {
      value: "pages_per_session"
      label: "Pages/Session"
    }
    allowed_value: {
      value: "pct_new_visitor"
      label: "% New Visitor"
    }

  }

  parameter: second_metric_name {
    type: unquoted
    allowed_value: {
      value: "event_id"
      label: "Pageviews"
    }
    allowed_value: {
      value: "user_id"
      label: "Users"
    }
    allowed_value: {
      value: "session_id"
      label: "Sessions"
    }
    allowed_value: {
      value: "pages_per_session"
      label: "Pages/Session"
    }
    allowed_value: {
      value: "pct_new_visitor"
      label: "% New Visitor"
    }
  }

  measure: event_id {
    label: "Pageviews"
    type: sum
  }
  measure: session_id {
    label: "Sessions"
    type: sum
  }
  measure: pages_per_session {

    type: number
    value_format_name: decimal_2
    sql: ${event_id}/${session_id} ;;
  }

  measure: primary_metric {
    sql: ${TABLE}.{% parameter primary_metric_name %};;
    type: count_distinct
    label_from_parameter: primary_metric_name
  }
  measure: second_metric {
    sql: ${TABLE}.{% parameter second_metric_name %};;
    type: count_distinct
    label_from_parameter: second_metric_name
  }

}
