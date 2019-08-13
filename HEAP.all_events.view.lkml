#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: all_events {
  sql_table_name: heap.all_events ;;

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: event_table_name {
    label: "Event Table Name"
    type: string
    sql: ${TABLE}.event_table_name ;; }

  dimension: session_id {
    hidden: yes
    type: number
    sql: ${TABLE}.session_id ;; }

  dimension_group: time {
    type: time
    timeframes:  [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.TIME ;; }

  dimension: last_30{
    label: "z - Last 30 Days"
    group_label: "Time Date"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.TIME > dateadd(day,-30,current_date);; }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;; }

  measure: count {
    type: count }

}
