view: sessions_in_tests {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select session_id
        , visitor_id
        , max(timestamp) session_end_date
        , count(distinct experiments) experiment_count
        -- , case when count(distinct(experiments)) = 0 then FALSE
        --     when count(distinct(experiments)) > 0 then TRUE
        --     else null end as in_test
        , max(revenue) session_revenue
    from optimizely.conversion
    group by session_id, visitor_id
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: session_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: visitor_id {
    type: number
    sql: ${TABLE}.visitor_id ;;
  }

  dimension_group: session_end_date {
    type: time
    label: "Session"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_end_date ;;
  }

  dimension: experiment_count {
    type: number
    description: "Number of experiments this session was a part of"
    sql: ${TABLE}.experiment_count ;;
  }

  dimension: in_test {
    type: yesno
    description: "If the session was included in any experiments"
    sql: case when ${TABLE}.experiment_count = 0 then FALSE
             when ${TABLE}.experiment_count > 0 then TRUE
             else null end ;;
  }

  measure: session_revenue {
    type: sum
    label: "Revenue (directional)"
    value_format_name: usd
    description: "Revenue from the session. Note this will average the revenue from a session with multiple checkouts within a session. Use it as directional."
    sql: ${TABLE}.session_revenue ;;
  }

  dimension_group: most_recent_purchase {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  measure: session_count {
    description: "Number of sessions"
    type: count
  }

  measure: visitor_count {
    description: "Number of unique visitor_id's"
    type: count_distinct
    sql: ${TABLE}.visitor_id ;;
  }
}
