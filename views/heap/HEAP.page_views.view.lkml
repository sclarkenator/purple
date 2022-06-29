#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: heap_page_views {
  sql_table_name: analytics.heap.v_ecommerce_heap_page_views ;;


  dimension: session_id {
    hidden: no
    type: string
    description:  "Unique ID number for a session. Source: heap.session_page_flow.session_id"
    sql: ${TABLE}.session_id ;;
  }

  dimension: event_id {
    hidden: no
    type: string
    description:  "Unique ID number for an event. Source: heap.session_page_flow.event_id"
    sql: ${TABLE}.event_id ;;
  }

  dimension: session_id_and_event_time {
    hidden: yes
    primary_key: yes
    type: string
    sql:concat( ${TABLE}.session_id , ${TABLE}.event_time );;
  }

  dimension_group: session_time {
    description: "Time the Session Began. Source: heap.session_page_flow.session_time"
    hidden: no
    type: time
    timeframes: [raw, time,hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.session_time) ;;
  }

  dimension_group: event_time {
    label: "Pageview - Event Time"
    description: "Time the Visitor viewed a page. Source: heap.session_page_flow.event_time"
    type: time
    timeframes: [raw,time, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.event_time) ;;
  }

  measure: event_time_min {
    hidden: yes
    type: date_time
    sql: min(${event_time_raw}) ;;
    convert_tz: no
  }

  measure: event_time_max {
    hidden: yes
    type: date_time
    sql: max(${event_time_raw}) ;;
    convert_tz: no
  }

  measure: event_time_diff {
    hidden: yes
    type: number
    sql: datediff(minute,${event_time_min},${event_time_max}) ;;
  }

  measure: max_page_flow {
    hidden: yes
    type: number
    sql: max(${page_flow}) ;;
  }

  measure: min_page_flow {
    hidden: yes
    type: number
    sql: min(${page_flow}) ;;
  }

  dimension: title {
    description: "The page's title as displayed on its tab in the browser. Source: heap.session_page_flow.title"
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: page_flow {
    description: "Order of Page Visits within a session. Source: heap.session_page_flow.page_flow"
    type: string
    sql: ${TABLE}.page_flow ;;
  }

  dimension: pages_viewed {
    label: " Pages Viewed (dimension version)"
    description: "Number of pages viewed in a session. Source: heap.session_page_flow.count_pages_viewed"
    type: number
    sql: ${TABLE}.count_pages_viewed ;;
  }

  measure: page_view_count {
    label: " Pages Viewed (measure version)"
    description: "Average number of pages viewed in a session. Source: HEAP.session_page_flow"
    type: average
    value_format: "000.00"
    sql: ${TABLE}.count_pages_viewed ;;
  }

  dimension: bounced {
    label: "   * Bounced"
    description: "Yes: Only viewed 1 page. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.count_pages_viewed = 1 ;;
  }

  dimension: exit_page {
    label: "Exit Page"
    description: "Yes: Last page viewed before leaving the site. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.exit_page = 1 ;;
  }

  #verify exit_pages
  measure: Sum_exit_pages {
    type: count_distinct
    group_label: "Advanced"
    description: "Count of instances a specific page was exited from (meant to be used with 'Title' or 'Parsed Page URL'). Source: heap.session_page_flow.session_id"
    sql: ${session_id} ;;
    filters: [exit_page: "yes"]
    view_label: "Sessions" }

  measure: exit_rate {
    type: number
    value_format: "0.0%"
    group_label: "Advanced"
    description: "How often a view of a specific page is the last page viewed in a session (meant to be used with 'Title' or 'Parsed Page URL'). Source: Looker calculation"
    sql: ${Sum_exit_pages}/${count} ;;
    view_label: "Sessions"
  }

  dimension: query {
    label: "Query - tag string"
    group_label: "Advanced"
    description: "The landing page's whole tag string after purple.com. Source: heap.session_page_flow.query"
    view_label: "Sessions"
    type: string
    sql: ${TABLE}.query;;
  }

  dimension: g_clid {
    label: "Query - gclid"
    group_label: "Advanced"
    description: "The landing page's gclid string. Source: Looker calculation"
    hidden: yes
    view_label: "Sessions"
    type: string
    sql: split_part(split_part(${query}, 'gclid=',  2), '&', 1) ;;
  }

  dimension: utm_adset {
    label: "Query - utm_adset"
    group_label: "Advanced"
    description: "The landing page's gclid string. Source: Looker calculation"
    hidden: no
    view_label: "Sessions"
    type: string
    sql: split_part(split_part(${query}, 'utm_adset=',  2), '&', 1) ;;
  }
  dimension: utm_ad {
    label: "Query - utm_ad"
    group_label: "Advanced"
    description: "The landing page's gclid string. Source: Looker calculation"
    hidden: no
    view_label: "Sessions"
    type: string
    sql: split_part(split_part(${query}, 'utm_ad=',  2), '&', 1) ;;
  }
  dimension: path {
    label: "Parsed Page URL"
#    hidden: yes
    description: "The string after purple.com excluding tags. Source: heap.session_page_flow.path"
    type: string
    sql: ${TABLE}.path ;;
  }

  dimension: product_page {
    label: "Product grouping of page views"
#    hidden: yes
    description: "The string after purple.com excluding tags. Source: heap.session_page_flow.path"
    type: string
    sql: case when ${path} ilike '%blog%' then 'blog'
              when ${path} ilike '%harmony%' then 'pillow'
              when ${path} ilike '%mattress-prot%' then 'bedding'
              when ${path} ilike '%pillow%' then 'pillow'
              when ${path} ilike '%frame%' then 'base'
              when ${path} ilike '%sheets%' then 'bedding'
              when ${path} ilike '%mattress%' then 'mattress'
              when ${path} ilike '%seat-%' then 'seating'
              when ${path} ilike '%blanket%' then 'bedding'
              when ${path} ilike '%platform%' then 'base'
              when ${path} ilike '%royal%' then 'seating'
              when ${path} ilike '%bedding%' then 'bedding'
              when ${path} ilike '%pet-%' then 'pet'
              when ${path} ilike '%home-office%' then 'seating'
              else 'other' end ;;
  }

  measure: count {
    label: "Distinct sessions"
    description: "Use this measure to calculate pageview level conversions"
    hidden: no
    type: count_distinct
    sql: ${session_id};;
    view_label: "Heap Page Views" }

  measure: Sum_bounced_session {
    type: count_distinct
    description: "Count of Bounced (single page) sessions. Source: heap.session_page_flow.session_id"
    sql: ${session_id};;
    filters: [bounced: "yes"]
    view_label: "Sessions" }

  measure: Sum_non_bounced_session {
    description: "Count of Non-Bounced / Qualified (multiple page) sessions. Source: heap.session_page_flow.session_id"
    type: count_distinct
    sql: ${session_id};;
    filters: [bounced: "no"]
    view_label: "Sessions" }

  measure: Sum_non_bounced_session_ly {
    description: "Count of Non-Bounced / Qualified (multiple page) sessions Last Year. Source: heap.session_page_flow.session_id"
    type: count_distinct
    sql: ${session_id};;
    filters: [bounced: "no",session_time_date: "1 years ago",session_time_hour_of_day: "<= 2"]
    view_label: "Sessions"
    label: "Sum non Bounced Session LY"}

  measure: percent_qualified {
    description: "% of all sessions that consist of more than 1 page viewed. Source: looker.calculation"
    type: number
    sql: 1.0*${Sum_non_bounced_session}/NULLIF(${Sum_bounced_session}+${Sum_non_bounced_session},0) ;;
    value_format_name: percent_1
    }

measure: bounce_rate {
  description: "Percent of sessions where user only viewed one page and left the site"
  type: number
  sql: (${count}-${Sum_non_bounced_session})/NULLIF(${count},0);;
  value_format_name: percent_1
   }
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
