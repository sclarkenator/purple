#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: heap_page_views {
  sql_table_name: analytics.heap.session_page_flow ;;


  dimension: session_id {
    hidden: no
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: event_id {
    hidden: no
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: session_id_and_event_time {
    hidden: yes
    primary_key: yes
    type: string
    sql:concat( ${TABLE}.session_id , ${TABLE}.event_time );;
  }

  dimension_group: session_time {
    description: "Time the Session Began"
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.session_time) ;;
  }

  dimension_group: event_time {
    label: "Pageview - Event Time"
    description: "Time the Visitor viewed a page"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.event_time) ;;
  }

  dimension: title {
    description: "Title of Web Page"
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: page_flow {
    description: "Order of Page Visits"
    type: string
    sql: ${TABLE}.page_flow ;;
  }

  dimension: pages_viewed {
    label: " Pages Viewed (dimension version)"
    description: "Number of pages viewed in a session"
    type: number
    sql: ${TABLE}.count_pages_viewed ;;
  }

  measure: page_view_count {
    label: " Pages Viewed (measure version)"
    description: "Number of pages viewed in a session"
    type: average
    sql: ${TABLE}.count_pages_viewed ;;
  }

  dimension: bounced {
    label: "   * Bounced"
    description: "Only viewed 1 page"
    type: yesno
    sql: ${TABLE}.count_pages_viewed = 1 ;;
  }

  dimension: exit_page {
    label: "Exit Page"
    description: "Last page viewed before leaving the site"
    type: yesno
    sql: ${TABLE}.exit_page = 1 ;;
  }

  dimension: query {
    label: "Query - tag string"
    group_label: "Advanced"
    description: "The landing page's whole tag string after purple.com"
    view_label: "Sessions"
    type: string
    sql: ${TABLE}.query;;
  }

  dimension: path {
    label: "Parsed Page URL"
#    hidden: yes
    description: "The string after purple.com excluding tags"
    type: string
    sql: ${TABLE}.path ;;
  }

  measure: Sum_bounced_session {
    type: sum_distinct
    sql: case when ${TABLE}.count_pages_viewed = 1 THEN 1 Else 0 End;;
    view_label: "Sessions" }

  measure: Sum_non_bounced_session {
    type: count_distinct
    sql: case when ${TABLE}.count_pages_viewed > 1 THEN ${session_id} End;;
    view_label: "Sessions" }

}


# below is the old view definition before 4/128/2020
# Archiving in case of errors with change to above definition


#view: heap_page_views {
#  derived_table: {
#    sql:
#      select session_id,
#        count(event_id) as pages_viewed
#      from analytics.heap.pageviews
#      --where time::date >=  '2019-06-16' and time::date <=  '2019-06-22'
#      group by session_id ;;

#    datagroup_trigger: pdt_refresh_6am

#  }

#  dimension: session_id {
#    primary_key: yes
#    hidden: yes
#    sql: ${TABLE}.session_id ;; }

#  measure: Sum_bounced_session {
#    type: sum_distinct
#    sql:
#    Case
#      When ${TABLE}.pages_viewed < 2 THEN 1 Else 0 End;;
#    view_label: "Sessions" }


# measure: Sum_non_bounced_session {
#    type: sum_distinct
#    sql:
#    Case
#      When ${TABLE}.pages_viewed >= 2 THEN 1 Else 0 End;;
#    view_label: "Sessions" }

#  dimension: pages_viewed {
#    label: " Pages Viewed"
#    description: "Pages viewed per session"
#    view_label: "Sessions"
#    type: number
#    sql: ${TABLE}.pages_viewed ;;}

#  dimension: bounced {
#    label: "   * Bounced"
#    description: "Only viewed 1 page"
#    view_label: "Sessions"
#    type: yesno
#    sql: ${TABLE}.pages_viewed < 2 ;;}

#  dimension: query {
#    label: "Query - tag string"
#    group_label: "Advanced"
#    description: "The whole tag string after purple.com."
#    view_label: "Sessions"
#    type: string
#    sql: ${TABLE}.query;;}

#query
# }
