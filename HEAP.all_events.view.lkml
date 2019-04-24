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
    #label: "??"
    type: time
    timeframes:  [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.time ;; }

  dimension: last_30{
    label: "z - Last 30 Days"
    group_label: "Time Date"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.time > dateadd(day,-30,current_date);; }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;; }

  measure: count {
    type: count
    drill_fields: [detail*] }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      event_table_name,
      users.user_id,
      users.author_name,
      users.out_of_stock_product_name,
      users.customer_service_agent_name,
      users.last_products_bought_product_3_name,
      users.last_products_bought_product_2_name,
      users.abandoned_product_3_name,
      users.abandoned_product_2_name,
      users.abandoned_product_1_name,
      users.last_products_bought_product_1_name,
      users.first_conversion_event_name,
      users.recent_conversion_event_name,
      users.hs_email_last_email_name,
      users.lastname,
      users.firstname,
      users.talkable_campaign_name,
      users.full_name,
      sessions.session_id,
      sessions.app_name] }
}
