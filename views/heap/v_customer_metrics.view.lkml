view: v_customer_metrics {
  sql_table_name: "HEAP"."V_CUSTOMER_METRICS"
    ;;

  dimension: visitor_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: add_to_cart {
    group_label: "Events"
    type: number
    sql: ${TABLE}."ADD_TO_CART" ;;
  }

  dimension: affiliate {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."AFFILIATE" ;;
  }

  dimension: audio {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."AUDIO" ;;
  }

  dimension: carousel_interaction {
    group_label: "Events"
    type: number
    sql: ${TABLE}."CAROUSEL_INTERACTION" ;;
  }

  dimension: core_events_submit_any_form {
    group_label: "Events"
    type: number
    sql: ${TABLE}."CORE_EVENTS_SUBMIT_ANY_FORM" ;;
  }

  dimension: desktop_sessions {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."DESKTOP_SESSIONS" ;;
  }

  dimension: direct_sessions {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."DIRECT_SESSIONS" ;;
  }

  dimension: display {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."DISPLAY" ;;
  }

  dimension: email {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: first_session_start {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."FIRST_SESSION_START_TIME" ;;
  }

  dimension: heap_ids {
    type: string
    hidden: yes
    sql: ${TABLE}."heap_ids" ;;
  }

  dimension: homeview {
    group_label: "Events"
    type: number
    sql: ${TABLE}."HOMEVIEW" ;;
  }

  dimension_group: last_add_to_cart {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_ADD_TO_CART" ;;
  }

  dimension_group: last_homeview {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_HOMEVIEW" ;;
  }

  dimension_group: last_purchase {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_PURCHASE" ;;
  }

  dimension_group: last_session_start {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_SESSION_START_TIME" ;;
  }

  dimension_group: last_zendesk_interaction {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_ZENDESK_INTERACTION" ;;
  }

  dimension: local {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."LOCAL" ;;
  }

  dimension: mobile_sessions {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."MOBILE_SESSIONS" ;;
  }

  dimension: native {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."NATIVE" ;;
  }

  dimension: pages_seat_cushions {
    label: "Page Views Seat Cushions"
    hidden: yes
    group_label: "Events"
    type: number
    sql: ${TABLE}."PAGES_SEAT_CUSHIONS" ;;
  }

  dimension: pageviews {
    group_label: "Session Metrics"
    label: "Page Views"
    type: number
    sql: ${TABLE}."PAGEVIEWS" ;;
  }


  dimension: referred_sessions {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."REFERRED_SESSIONS" ;;
  }

  dimension: returns_viewed_page_returns {
    label: "Viewed Returns Page"
    group_label: "Events"
    type: number
    sql: ${TABLE}."RETURNS_VIEWED_PAGE_RETURNS" ;;
  }

  dimension: reviews_interaction {
    group_label: "Events"
    type: number
    sql: ${TABLE}."REVIEWS_INTERACTION" ;;
  }

  dimension: search {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."SEARCH" ;;
  }

  dimension: session_count {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."SESSION_COUNT" ;;
  }

  dimension: sms {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."SMS" ;;
  }

  dimension: social {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."SOCIAL" ;;
  }

  dimension: splitit_interaction {
    group_label: "Events"
    type: number
    sql: ${TABLE}."SPLITIT_INTERACTION" ;;
  }

  dimension: store_finder_interaction {
    group_label: "Events"
    type: number
    sql: ${TABLE}."STORE_FINDER_INTERACTION" ;;
  }

  dimension: support_page_support_live_chat {
    group_label: "Events"
    type: number
    sql: ${TABLE}."SUPPORT_PAGE_SUPPORT_LIVE_CHAT" ;;
  }

  dimension: tablet_sessions {
    group_label: "Session Metrics"
    type: number
    sql: ${TABLE}."TABLET_SESSIONS" ;;
  }

  dimension: traditional {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."TRADITIONAL" ;;
  }

  dimension: video {
    group_label: "Medium"
    type: number
    sql: ${TABLE}."VIDEO" ;;
  }

  dimension: zendesk_web_widget {
    group_label: "Events"
    type: number
    sql: ${TABLE}."ZENDESK_WEB_WIDGET" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
