#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: session_facts {
  derived_table: {
    sql: SELECT
        all_events.session_id || '-' || all_events.user_id AS session_unique_id,
        all_events.session_id,
        user_id,
        row_number() over( partition by user_id order by min(all_events.time)) as session_sequence_number,
        min(all_events.time) AS session_start_time,
        max(all_events.time) AS session_end_time,
        COUNT(distinct(all_events.session_id || '-' || all_events.user_id)) AS all_events_count
      FROM heap.all_events AS all_events
      GROUP BY 1,2,3  ;;

    sql_trigger_value: SELECT FLOOR((DATE_PART('EPOCH_SECOND', CURRENT_TIMESTAMP) - 60*60*7)/(60*60*24)) ;;
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
    type: number
    sql: ${TABLE}.session_sequence_number ;; }

  dimension: is_first_session {
    label: "Is First Session"
    description: "Yes/No value for if it is the first session"
    type: yesno
    sql: ${session_sequence_number} = 1 ;; }

  dimension_group: session_start_time {
    label: "Session Start Time"
    type: time
    timeframes: [time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.session_start_time ;; }

  dimension_group: session_end_time {
    label: "Session End Time"
    type: time
    timeframes: [time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.session_end_time ;; }

  dimension: session_duration_minutes {
    label: "Session Durations (minutes)"
    type: number
    sql: extract(epoch from (${TABLE}.session_end_time - ${TABLE}.session_start_time))/60 ;;
    value_format_name: decimal_2 }

  dimension: duration_tier {
    label:  "Session Durations (minutes bucket)"
    description: "Minutes spent on site (0,1,5,10,15,20,25,30)"
    type: tier
    style:  integer
    tiers: [0,1,5,10,15,20,25,30]
    sql: case when datediff('seconds',session_start_time,session_end_time) < 10 then '-1'::int
          else datediff('minutes',session_start_time,session_end_time)::int  end;;}

  dimension: event_count {
    label: "Event Count"
    type: number
    sql: ${TABLE}.all_events_count ;; }

  dimension: is_bounced {
    label: "Bounced - time"
    description: "Bounced (yes) if total time on site is < 2 seconds"
    hidden:  yes
    type: yesno
    sql: datediff('seconds',session_start_time,session_end_time) < 1 ;; }

  measure: average_events_per_session {
    label: "Average Events per Session"
    type: average
    sql: ${event_count} ;;
    value_format_name: decimal_1 }

  measure: average_session_duration_minutes {
    label: "Average Session Duration (minutes)"
    type: average
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2 }

}
