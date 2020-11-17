view: heap_ca_purchase {
  sql_table_name: heap_canada.heap.purchase ;;

  dimension: session_id {
    #primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;; }

  dimension: session_unique_id {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${session_id} || '-' || ${user_id} ;;
  }

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;; }

  dimension_group: time {
    label: "Purchase"
    description: "Source: HEAP_CANADA.purchase"
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year, hour_of_day, minute,hour]
    sql: ${TABLE}.time ;; }

  measure: dollars {
    label: "Gross Amount"
    value_format: "#,#00.00"
    type: sum
    sql: ${TABLE}.dollars ;;
  }
}
