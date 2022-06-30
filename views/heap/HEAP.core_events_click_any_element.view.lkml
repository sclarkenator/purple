view: core_events_click_any_element {
  sql_table_name: ANALYTICS.HEAP.V_core_events_click_any_element ;;

  dimension: PK {
    type: string
    primary_key: yes
    group_label: "Click Events"
    hidden: yes
    #sql:  ${TABLE}.user_id||${TABLE}.session_id||${TABLE}.event_id;;
    sql:  ${TABLE}.pk ;;
  }

  dimension: user_id {
    group_label: "Click Events"
    description: "Unique ID for each user that has ordered"
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_id {
    group_label: "Click Events"
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;;
  }

  dimension: session_id {
    group_label: "Click Events"
    hidden:yes
    type: number
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: time {
    group_label: "Click Events"
    description: "Source: heap.core_events_click_any_element"
    hidden: yes
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.time ;;
  }

  dimension: path {
    group_label: "Click Events"
    label: "Click Event Path"
    description: "Source: heap.core_events_click_any_element"
    type: string
    sql: ${TABLE}.path ;;
  }

  dimension: href {
    group_label: "Click Events"
    description: "Source: heap.core_events_click_any_element"
    type: string
    sql: ${TABLE}.href ;;
  }

  dimension: target_text {
    group_label: "Click Events"
    description: "Source: heap.core_events_click_any_element"
    type: string
    sql: ${TABLE}.target_text ;;
  }
}
