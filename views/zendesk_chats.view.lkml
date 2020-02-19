view: zendesk_chats {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_CHATS"
    ;;

  dimension: agent_id {
    type: string
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: chat_id {
    type: string
    description: "ID number for chat conversation"
    sql: ${TABLE}."CHAT_ID" ;;
  }

  dimension: count_agent {
    type: string
    label: "Total Agent Messages"
    group_label: "Advanced"
    description: "Count of Messages from Agent"
    sql: ${TABLE}."COUNT_AGENT" ;;
  }

  dimension: count_total {
    type: number
    label: "Total Messages"
    description: "Total number of messages in conversation"
    sql: ${TABLE}."COUNT_TOTAL" ;;
  }

  dimension: count_visitor {
    type: number
    group_label: "Advanced"
    description: "Count of Messages from Visitor"
    sql: ${TABLE}."COUNT_VISITOR" ;;
  }

  dimension_group:created {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    label: "  Chat Time"
    description: "Start Time of Chat (MT)"
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: department_id {
    type: string
    hidden: yes
    sql: ${TABLE}."DEPARTMENT_ID" ;;
  }

  dimension: department_name {
    type: string
    label: "Chat Reason"
    sql: ${TABLE}."DEPARTMENT_NAME" ;;
  }

  dimension: duration {
    type: number
    group_label: "Advanced"
    description: "Chat Duration (seconds)"
    sql: ${TABLE}."DURATION" ;;
  }

  dimension: end_timestamp {
    type: date_time
    group_label: "Advanced"
    sql: ${TABLE}."END_TIMESTAMP" ;;
  }

  dimension: missed {
    type: string
    label: "   * Missed Chat"
    description: "T/F; T if a chat was missed"
      sql: ${TABLE}.MISSED ;;
  }

  dimension: response_time_avg {
    type: number
    description: "Average time to respond (seconds)"
    sql: ${TABLE}."RESPONSE_TIME_AVG" ;;
  }

  dimension: response_time_first {
    type: number
    description: "Seconds to first response"
    sql: ${TABLE}."RESPONSE_TIME_FIRST" ;;
  }

  dimension: response_time_max {
    type: number
    description: "Longest time to respond (seconds)"
    sql: ${TABLE}."RESPONSE_TIME_MAX" ;;
  }

  dimension: started_by {
    type: string
    group_label: "Advanced"
    description: "Who initiated the chat"
    sql: ${TABLE}."STARTED_BY" ;;
  }

  dimension: tags {
    type: string
    description: "Topics Discussed"
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: triggered {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."TRIGGERED" ;;
  }

  dimension: triggered_response {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."TRIGGERED_RESPONSE" ;;
  }

  dimension: type {
    type: string
    hidden: yes
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: unread {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."UNREAD" ;;
  }

  dimension: visitor_email {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."VISITOR_EMAIL" ;;
  }

  dimension: visitor_id {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: visitor_name {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."VISITOR_NAME" ;;
  }

  dimension: visitor_notes {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."VISITOR_NOTES" ;;
  }

  dimension: visitor_phone {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."VISITOR_PHONE" ;;
  }

  dimension: zendesk_ticket_id {
    type: string
    sql: ${TABLE}."ZENDESK_TICKET_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [visitor_name, department_name]
  }
  measure: agent_messages {
    type: sum
    label: "Count of Agent Messages"
    sql: ${count_agent} ;;
  }
  measure: total_messages {
    type: sum
    label: "Count of Total Messages"
    sql: ${count_total} ;;
  }
  measure: visitor_messages {
    type: sum
    label: "Count of Visitor Messages"
    sql: ${count_visitor} ;;
  }
  measure: missed_messages {
    type: sum
    label: "Count of Missed Chats"
    sql: case when ${missed} = 'T' then 1 else 0 end ;;
  }

}
