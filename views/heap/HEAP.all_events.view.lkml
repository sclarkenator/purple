#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: all_events {
  # derived_table: {
  #   sql: select * from heap.all_events;;
  #   datagroup_trigger: pdt_refresh_6am
  # }
  sql_table_name: HEAP.ALL_EVENTS ;;

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;;
    }

  dimension: event_table_name {
    label: "Event Table Name"
    type: string
    sql: ${TABLE}.event_table_name ;; }

  dimension: event_table_name_bucket {
    label: "Event Table Name Bucket"
    hidden: yes
    type: string
    sql: case when ${event_table_name} = 'homepage' then 'Homepage'
          when ${event_table_name} = 'mattresses' or ${event_table_name} = 'mattresses_hybrid' or ${event_table_name} = 'mattresses_hybrid_premier' or ${event_table_name} = 'products_mattresses_purple_bed'
            or ${event_table_name} = 'products_viewed_page_either_mattress_lp' or ${event_table_name} = 'products_viewed_page_new_mattress' then 'Mattress'
          when ${event_table_name} ilike '%compare%' then 'Compare Page'
          when ${event_table_name} ilike '%pdp%' then 'PDP'
          when ${event_table_name} ilike '%buy%' then 'Buy'
          when ${event_table_name} ilike '%cart%' then 'Add to Cart'
          when ${event_table_name} = 'checkout_view_checkout_page' then 'Checkout-Page'
          when ${event_table_name} = 'checkout_submit_customer_info' then 'Checkout-Customer Info'
          when ${event_table_name} = 'checkout_step_1_continue_to_shipping_step_1_continue_to_shipping' then 'Checkout-Shipping'
          when ${event_table_name} = 'checkout_step_2_continue_to_payment' then 'Checkout-Payment'
          when ${event_table_name} = 'checkout_step_3_complete' then 'Checkout-Complete'
          end ;; }

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

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${session_id},${event_table_name}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
