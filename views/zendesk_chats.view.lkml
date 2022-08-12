include: "/views/_period_comparison.view.lkml"
view: zendesk_chats {
  extends: [_period_comparison]
  derived_table: {
    sql:
    select distinct z.*,
      case when department_name='Sales Chat' then 'Sales Chat'
        when department_name='Support Chat' then 'Support Chat'
        when agent_lkp.team_type='Sales' then 'Sales Chat'
        when agent_lkp.team_type='Chat' then 'Support Chat'
        when agent_lkp.team_type='SRT' then 'Support Chat'
        else 'Sales Chat'
        end as dept_clean
    from (
      select *
      from "CUSTOMER_CARE"."ZENDESK_CHATS" z
      )z
      left join customer_care.agent_lkp agent_lkp
          on z.agent_ids::string = agent_lkp.zendesk_id::string
    ;;
    }

  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: to_timestamp(${TABLE}."CREATED") ;;
  }


  dimension: agent_id {
    type: string
    group_label: "Advanced - Chats"
    description: "Zendesk Agent IDs of all agents who were assigned the chat"
    sql: ${TABLE}."AGENT_IDS" ;;
    hidden: yes
  }

  dimension: agent_names {
    type: string
    group_label: "Advanced - Chats"
    label: "Agents Assigned"
    description: "Names of all agents assigned to the chat session"
    sql: ${TABLE}."AGENT_NAMES" ;;
  }

  dimension: history {
    type: string
    group_label: "Advanced - Chats"
    description: "Text of chat and web page info"
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
    description: "ID number for chat session"
    sql: ${TABLE}."CHAT_ID" ;;
  }

  dimension: count_agent {
    type: number
    group_label: "Advanced - Chats"
    label: "Chat Messages - Agents"
    description: "Count of messages from all Agents serving the chat."
    sql: ${TABLE}."COUNT_AGENT" ;;
  }

  dimension: count_total {
    type: number
    group_label: "Advanced - Chats"
    label: "Chat Messages - Total"
    description: "Total number of messages in chat session"
    sql: ${TABLE}."COUNT_TOTAL" ;;
  }

  dimension: count_visitor {
    type: number
    group_label: "Advanced - Chats"
    label: "Chat Messages - Visitor"
    description: "Count of messages from Visitor."
    sql: ${TABLE}."COUNT_VISITOR" ;;
  }

  dimension_group:created {
    type: time
    timeframes: [date,week,month,quarter,year,hour_of_day,month_name,time, minute30, day_of_week]
    #convert_tz: yes
    datatype: datetime
    ##group_label: "Advanced - Chats"
    label: "  Chat"
    description: "Start Time of Chat (MT)"
    sql: to_timestamp(${TABLE}."CREATED") ;;
  }


  dimension_group:end_time {
    type: time
    timeframes: [date,week,month,quarter,year,hour_of_day,month_name,time, minute30]
    #convert_tz: yes
    datatype: datetime
    ##group_label: "Advanced - Chats"
    label: "Chat End"
    description: "End Time of Chat (MT)"
    sql: to_timestamp(${TABLE}."SESSION_END") ;;
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
    description: "Department that first served the chat"
    sql: ${TABLE}."DEPARTMENT_NAME" ;;
  }

  dimension: department_name_clean {
    type: string
    ##group_label: "Advanced - Chats"
    label: "   Department Name Clean"
    description: "Calculation to attribute as many chats to the appropriate workgroup until the NULL issue is corrected in Zendesk."
    sql: ${TABLE}.dept_clean ;;
  }

  dimension: duration {
    type: number
    group_label: "Advanced - Chats"
    label: "Chat Duration"
    description: "Chat Duration (seconds). Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."DURATION" ;;
  }

  ## End Timestamp is causing errors. Created Date field using Session End Time
  dimension: end_timestamp {
    type: date_time
    group_label: "Advanced - Chats"
    description: "When the chat ended. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."END_TIMESTAMP" ;;
    hidden: yes
  }

  dimension: missed {
    type: string
    ##group_label: "Advanced - Chats"
    label: "   * Missed Chat? (T/F)"
    description: "F indicates a Chat Served. T indicates a Chat Missed."
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
    description: "Who started the chat. Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."STARTED_BY" ;;
  }

  dimension: tags {
    type: string
    group_label: "Advanced - Chats"
    description: "Tags associated with the chat"
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: triggered {
    type: string
    group_label: "Advanced - Chats"
    description: "T/F indicator whether a system trigger was fired during the chat session"
    sql: ${TABLE}."TRIGGERED" ;;
  }

  dimension: triggered_response {
    type: string
    group_label: "Advanced - Chats"
    description: "Automated triggered response - T/F"
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
    description: "T/F indicator whether the chat was unread"
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

  # The data in this field looks like internal notes of some sort. Need to validate where this is pulling from. AngieM
  dimension: visitor_notes {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_NOTES" ;;
    hidden: yes
  }

  dimension: visitor_phone {
    type: string
    group_label: "Advanced - Chats"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."VISITOR_PHONE" ;;
  }

  dimension: session_city {
    type: string
    group_label: "Advanced - Chats"
    description: "City that the visitor was chatting from"
    sql: ${TABLE}."SESSION_CITY" ;;
  }

  dimension: session_region {
    type: string
    group_label: "Advanced - Chats"
    description: "State or region that the visitor was chatting from"
    sql: ${TABLE}."SESSION_REGION" ;;
  }

  dimension: session_country {
    type: string
    group_label: "Advanced - Chats"
    description: "Country that the visitor was chatting from"
    sql: ${TABLE}."SESSION_COUNTRY_NAME" ;;
  }


  dimension: zendesk_ticket_id {
    type: string
    #group_label: "Advanced - Chats"
    label: "Ticket ID"
    description: "Source: zendesk_chats.zendesk_chats"
    sql: ${TABLE}."ZENDESK_TICKET_ID" ;;
  }

  measure: count {
    type: count
    group_label: "Advanced - Chats"
    label: "Chats"
    description: "The number of Chat Sessions"
    drill_fields: [visitor_name, department_name]
  }
  measure: agent_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Chat Agent Messages"
    description: "Count of messages sent by agent(s) during the chat session"
    sql: ${count_agent} ;;
  }
  measure: total_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Chat Total Messages"
    description: "Count of all messages sent during a chat session"
    sql: ${count_total} ;;
  }
  measure: visitor_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Chat Visitor Messages"
    description: "Count of messages sent by the visitor during the chat session"
    sql: ${count_visitor} ;;
  }
    measure: missed_messages {
    type: sum
    group_label: "Advanced - Chats"
    label: "Chats Missed"
    description: "Count of chats where the visitor ends the chat without an agent response"
    sql: case when ${missed} = 'true' then 1 else 0 end ;;
  }
  measure: served_chats {
    type: count_distinct
    group_label: "Advanced - Chats"
    label: "Chats Served"
    description: "Count of chats served by agents"
    sql: ${zendesk_ticket_id} ;;
    filters: [missed: "false"]
  }
  measure: served_chats_old {
    type: sum
    group_label: "Advanced - Chats"
    label: "Chats Served Old"
    description: "Count of chats served by agents"
    sql: case when ${missed} = 'false' then 1 else 0 end ;;
  }
  measure: duration_total {
    type: sum
    group_label: "Advanced - Chats"
    label: "Duration - Total"
    value_format_name: decimal_0
    description: "The time duration from the first to the last chat message in seconds"
    sql:  ${duration} ;;
  }
  measure: duration_avg {
    type: average
    group_label: "Advanced - Chats"
    label: "Duration - Average"
    description: "The average chat duration from the first to the last chat message in seconds"
    value_format_name: decimal_2
    sql:  ${duration} ;;
  }
  measure: first_reply {
    type: average
    group_label: "Advanced - Chats"
    label: "Reply Time - First"
    value_format_name: decimal_2
    description: "The average time for the first response from an agent in seconds"
    sql:  ${response_time_first} ;;
  }
  ## The max reply metric is not working properly. When aggregating, the values go to 99 or 995 rather than the actual max value, or throw an error. .
  measure: max_reply {
    type: number
    group_label: "Advanced - Chats"
    label: "Reply Time - Max"
    value_format_name: decimal_0
    description: "The maximum time any visitor waited for the first response from an agent in seconds"
    sql:  MAX((${response_time_max}) ;;
    hidden: yes
  }
  measure: avg_reply {
    type: median
    group_label: "Advanced - Chats"
    label: "Reply Time - Median Avg"
    value_format_name: decimal_2
    description: "The median of the ticket average response time. Essentially,the middle value of all of the average response times in seconds"
    sql:  ${response_time_avg} ;;
  }

}
