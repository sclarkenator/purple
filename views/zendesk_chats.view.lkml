view: zendesk_chats {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_CHATS"
    ;;

  dimension: agent_id {
    type: string
    group_label: "Advanced - Chats"
    description: "Zendesk Agent ID. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: agent_names {
    type: string
    group_label: "Advanced - Chats"
    description: "Zendesk Agent ID. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."AGENT_NAMES" ;;
  }

  dimension: history {
    type: string
    group_label: "Advanced - Chats"
    description: "Text of chat. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."HISTORY" ;;
  }

  dimension: return_warranty_flag{
    type: string
    group_label: "Flags - History"
    description: "1/0 if history contains mention of warranty or return. Source: zendesk_chats.zendesk_chats"
    sql:case when ${history} ilike '%warranty%'
               OR ${history} ilike '%return%'
               then 1 else 0 end
    ;;
  }

  dimension: bases_platform_flag{
    type: string
    group_label: "Flags - History"
    description: "1/0 if history contains mention of platform, base, frame, or foundation. Source: zendesk_chats.zendesk_chats"
    sql:case when ${history} ilike '%platform%'
               OR ${history} ilike '%base%'
               OR ${history} ilike '%frame%'
               OR ${history} ilike '%foundation%'
               then 1 else 0 end
    ;;
  }


  dimension: chat_id {
    type: string
    primary_key: yes
    group_label: "Advanced - Chats"
    description: "ID number for chat conversation. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."CHAT_ID" ;;
  }

  dimension: count_agent {
    type: string
    group_label: "Advanced - Chats"
    label: "Total Agent Messages"
    description: "Count of Messages from Agent. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."COUNT_AGENT" ;;
  }

  dimension: count_total {
    type: number
    group_label: "Advanced - Chats"
    label: "Total Messages"
    description: "Total number of messages in conversation. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."COUNT_TOTAL" ;;
  }

  dimension: count_visitor {
    type: number
    group_label: "Advanced - Chats"
    description: "Count of Messages from Visitor. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."COUNT_VISITOR" ;;
  }

  dimension_group:created {
    type: time
    timeframes: [date,week,month,quarter,year,hour_of_day]
    convert_tz: yes
    datatype: datetime
    ##group_label: "Advanced - Chats"
    label: "  Chat"
    description: "Start Time of Chat (MT). Source: zendesk_chats.zendesk_chats"
    sql: to_timestamp(${TABLE}."CREATED") ;;
  }

  dimension: department_id {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    hidden: yes
    sql: ${TABLE}."DEPARTMENT_ID" ;;
  }

  dimension: department_name {
    type: string
    ##group_label: "Advanced - Chats"
    label: "   Department Name"
    description: "Department who took the chat. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."DEPARTMENT_NAME" ;;
  }

  dimension: duration {
    type: number
    group_label: "Advanced - Chats"
    description: "Chat Duration (seconds). Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."DURATION" ;;
  }

  dimension: end_timestamp {
    type: date_time
    group_label: "Advanced - Chats"
    description: "When the chat ended. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."END_TIMESTAMP" ;;
  }

  dimension: missed {
    type: string
    ##group_label: "Advanced - Chats"
    label: "   * Missed Chat? (T/F)"
    description: "T if a chat was missed. Source: zendesk_chats.zendesk_chats"
      sql: ${TABLE}.MISSED ;;
  }

  dimension: response_time_avg {
    type: number
    group_label: "Advanced - Chats"
    description: "Average time to respond (seconds). Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."RESPONSE_TIME_AVG" ;;
  }

  dimension: response_time_first {
    type: number
    group_label: "Advanced - Chats"
    description: "Seconds to first response. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."RESPONSE_TIME_FIRST" ;;
  }

  dimension: response_time_max {
    type: number
    group_label: "Advanced - Chats"
    description: "Longest time to respond (seconds). Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."RESPONSE_TIME_MAX" ;;
  }

  dimension: started_by {
    type: string
    group_label: "Advanced - Chats"
    description: "Who initiated the chat. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."STARTED_BY" ;;
  }

  dimension: tags {
    type: string
    group_label: "Advanced - Chats"
    description: "Topics Discussed. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: triggered {
    type: string
    group_label: "Advanced - Chats"
    description: "What triggered the chat. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."TRIGGERED" ;;
  }

  dimension: triggered_response {
    type: string
    group_label: "Advanced - Chats"
    description: "Automated triggered response. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."TRIGGERED_RESPONSE" ;;
  }

  dimension: type {
    type: string
    hidden: yes
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: unread {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."UNREAD" ;;
  }

  dimension: visitor_email {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_EMAIL" ;;
  }

  dimension: visitor_id {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: visitor_name {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_NAME" ;;
  }

  dimension: visitor_notes {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_NOTES" ;;
  }

  dimension: visitor_phone {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_PHONE" ;;
  }

  dimension: zendesk_ticket_id {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."ZENDESK_TICKET_ID" ;;
  }

  measure: count {
    type: count
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    drill_fields: [visitor_name, department_name]
  }
  measure: agent_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Count of Agent Messages"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${count_agent} ;;
  }
  measure: total_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Count of Total Messages"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${count_total} ;;
  }
  measure: visitor_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Count of Visitor Messages"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${count_visitor} ;;
  }
  measure: missed_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Count of Missed Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: case when ${missed} = 'T' then 1 else 0 end ;;
  }

}
