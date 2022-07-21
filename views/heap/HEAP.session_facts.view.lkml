#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: session_facts {
  derived_table: {
    sql: select * from analytics.heap.v_ecommerce_session_facts ;;

    datagroup_trigger: pdt_refresh_6am
  }

  dimension: session_unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_unique_id ;; }


  dimension: session_id {
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;; }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;; }

  dimension: session_sequence_number {
    label: "Session Sequence Number"
    group_label: "Advanced"
    description: "Session sequence number for a given customer. Source: looker calculation"
    type: number
    sql: ${TABLE}.session_sequence_number ;; }

  dimension: is_first_session {
    label: "    * Is First Session"
    description: "Yes/No value for if it is the first session. Source: looker calculation"
    type: yesno
    sql: ${session_sequence_number} = 1 ;; }

  dimension_group: session_start_time {
    label: "Session Start Time"
    description: "Source: looker calculation"
    type: time
    hidden: yes
    timeframes: [time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.session_start_time ;; }

  dimension_group: session_end_time {
    label: "Session End Time"
    description: "Source: looker calculation"
    type: time
    hidden: yes
    timeframes: [time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.session_end_time ;; }

  dimension: session_duration_minutes {
    group_label: "Advanced"
    label: "Session Durations (minutes)"
    description: "Source: looker calculation"
    type: number
    sql: ${TABLE}.session_duration_minutes ;;
    value_format_name: decimal_2 }

  dimension: duration_tier {
    label:  "Session Durations (minutes bucket)"
    group_label: "Advanced"
    description: "Minutes spent on site (0,1,5,10,15,20,25,30). Source: looker calculation"
    type: tier
    style:  integer
    tiers: [0,1,5,10,15,20,25,30]
    sql: ${TABLE}.duration_tier;;}

  dimension: event_count {
    group_label: "Advanced"
    label: "Event Count"
    description: "Source: looker calculation"
    type: number
    sql: ${TABLE}.all_events_count ;; }

  dimension: is_bounced {
    label: "Bounced - time"
    description: "Bounced (yes) if total time on site is < 2 seconds. Source: looker calculation"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_bounced ;; }

  measure: average_events_per_session {
    label: "Average Events per Session"
    description: "Source: looker calculation"
    type: average
    sql: ${event_count} ;;
    value_format_name: decimal_1 }

  measure: average_session_duration_minutes {
    label: "Average Session Duration (minutes)"
    description: "Source: looker calculation"
    type: average
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2 }

}
