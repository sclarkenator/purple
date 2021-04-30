view: zendesk_chat_engagements {

  view_label: "Chat Engagement"
  sql_table_name: CUSTOMER_CARE.ZENDESK_CHAT_ENGAGEMENTS ;;

  dimension: engagement_id {  # PRIMARY KEY
    primary_key: yes
    label: "Engagement ID"
    group_label: "* ID Fields"
    type: string
    # hidden: yes
    sql: ${TABLE}.engagement_id ;;
  }


  ##############################################
  ##############################################
  ## DRILL DOWN SETS

  set: detail {
    fields: [agent_name, engagement_start_date, ticket_id]
  }


  ##############################################
  ##############################################
  ## NON-KEY ID DIMENSIONS

  dimension: zendesk_id {
    label: "Zendesk ID"
    group_label: "* ID Fields"
    description: "Zendesk ID for agent/user"
    type: number
    # hidden: yes
    sql: ${TABLE}.agent_id ;;
  }

  dimension: ticket_id {
    label: "Ticket ID"
    group_label: "* ID Fields"
    type: number
    # hidden: yes
    sql: ${TABLE}.zendesk_ticket_id ;;
  }

  dimension: chat_id {
    label: "Chat ID"
    group_label: "* ID Fields"
    type: string
    # hidden: yes
    sql: ${TABLE}.chat_id ;;
  }
  dimension: department_id {
    label: "Dept ID"
    group_label: "* ID Fields"
    description: "Department ID  "
    type: number
    # hidden: yes
    sql: ${TABLE}.department_id ;;
  }


  ##############################################
  ##############################################
  ## DATE DIMENSION GROUPS

  dimension_group: engagement_start {
    label: "Engagement Start"
    description: "Date/Time when engagement started"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.created AS TIMESTAMP_NTZ) ;;
  }


  ##############################################
  ##############################################
  ## GENERAL DIMENSIONS

  dimension: department_name {
    label: "Chat Dept Name"
    type: string
    sql:  ${TABLE}.department_name ;;
    drill_fields: [agent_name]
  }

  dimension: agent_name {
    label: "Agent Name"
    type: string
    # hidden: yes
    sql: ${TABLE}.agent_name ;;
    drill_fields: [detail*]
  }

  dimension: accepted {
    label: "Accepted"
    description: "Indicates that the agent accepted the engagement that was routed to them"
    type: yesno
    sql: ${TABLE}.accepted = TRUE ;;
  }

  dimension: assigned {
    label: "Assigned"
    description: "Indicates that an engagement was routed/assigned to the agent. Not all assigned engagements are accepted"
    type: yesno
    sql: ${TABLE}.assigned ;;
  }

  dimension: agent_messages {
    label: "Agent Messages"
    description: "Count of messages sent by agent"
    type: number
    sql: ${TABLE}.count_agent ;;
  }

  dimension: visitor_messages {
    label: "Visitor Messages"
    description: "Count of messages sent by visitor to agent"
    type: number
    sql:  ${TABLE}.count_visitor ;;
  }

  dimension: total_messages {
    label: "Total Messages"
    description: "Total messages exchanged between agent and visitor"
    type: number
    sql: ${TABLE}.count_total ;;
  }

  dimension: rating {
    label: "Chat Survey Rating"
    group_label: "Chat Surveys"
    description: "Rating from chat survey (Zendesk)"
    type: string
    sql: ${TABLE}.rating ;;
  }

  dimension: comment {
    label: "Chat Survey Comment"
    group_label: "Chat Surveys"
    description: "Comment from chat survey (Zendesk)"
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: handle_time {
    label: "Engagement Handle Time"
    group_label: "Engagement Duration Fields"
    description: "Duration of engagement in sec"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.duration ;;
  }

  dimension: response_time_avg {
    label: "Average Engagement Reply Time"
    group_label: "Engagement Duration Fields"
    description: "Average time taken for agent to respond to each visitors message during the engagement"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.response_time_avg ;;
  }

  dimension: response_time_first {
    label: "First Engagement Reply Time"
    group_label: "Engagement Duration Fields"
    description: "Time taken for the agent to respond to first customer message in the engagement"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.response_time_first ;;
  }

  dimension: skills_fulfilled {
    label: "Skills Fulfilled"
    description: "Indicates that the engagement was served by an agent with the required skill"
    type: yesno
    sql: ${TABLE}.skills_fulfilled = TRUE ;;
  }

  dimension: started_by {
    label: "Started By"
    description: "The way the chat engagement was started (Agent, Visitor or Transfer"
    type: string
    sql: ${TABLE}.started_by ;;
  }

  # OK TO DELETE?
  # dimension: skills_requested {
  #   label: "Skills Requested"
  #   description: "?????"
  #   type: yesno
  #   sql: ${TABLE}.skills_fulfilled = TRUE ;;
  # }

  # It appears that the response time max field is not being populated in snowflake
  # dimension: response_time_max {
  #   label: "Max Engagement Response Time"
  #   group_label: "Engagement Duration Fields"
  #   description: "Longest time taken to respond to any customer message"
  #   type: number
  #   value_format_name: decimal_2
  #   sql: ${TABLE}.response_time_max ;;
  # }


  ##############################################
  ##############################################
  ## MEASURES

  measure: duration_total {
    label: "Engagement Duration"
    description: "Sum of engagement duration in sec"
    type: sum
    value_format_name: decimal_0
    sql: ${handle_time} ;;
  }

  measure: duration_avg {
    label: "Average Engagement Duration"
    description: "Average of engagement duration in sec"
    type: average
    value_format_name: decimal_0
    sql: ${handle_time} ;;
  }

  measure: engagement_count {
    label: "Engagements"
    description: "Count of engagements. (Missed + Accepted + Self Assignments)"
    type: count_distinct
    sql: ${engagement_id};;
  }

  measure: assignment_count {
    label: "Assignments"
    description: "Count of system routed assignments, including missed. (Missed + Accepted Assignments)"
    type: sum
    sql: case when ${assigned} = true then 1 else 0 end ;;
  }

  measure: missed_count  {
    label: "Assignments Missed"
    description: "Count of engagements assigned/routed to the agent but were missed or not accepted.  These engamemnts have a 0 duration."
    type: sum
    sql: case when ${accepted} = false
      and ${assigned} = true then 1 else 0 end ;;
  }

  measure: accepted_count  {
    label: "Assignments Accepted"
    description: "Count of engagements which were assigned to an agent and accepted by the agent"
    type: sum
    sql: case when ${accepted} = true
      and ${assigned} = true then 1 else 0 end ;;
  }

  measure: self_assigned_count  {
    label: "Assignments Self-Assigned"
    description: "Count of engagements to which an agent assigned themselves."
    type: sum
    sql: case when ${assigned} = false then 1 else 0 end ;;
  }

  measure: assignment_acceptance_rate {
    label: "Assignment Acceptance Rate"
    description: "Accepted Engagements/Assigned Engagements"
    type: number
    value_format_name: percent_2
    sql: ${accepted_count} / nullif(${engagement_count}, 0) ;;
  }

  measure: rated_good_count {
    label: "Good Ratings"
    description: "Not connected to CSAT. These are Zendesk chat ratings"
    type: sum
    value_format_name: number
    hidden: yes
    sql:case when lower(${rating}) = 'good' then 1 end ;;
  }

  measure: rated_bad_count {
    label: "Bad Ratings"
    description: "Not connected to CSAT. These are Zendesk chat ratings"
    type: sum
    value_format_name: number
    hidden: yes
    sql:case when lower(${rating}) = 'bad' then 1 end ;;
  }

  measure: not_rated_count {
    label: "Not Rated"
    description: "Not connected to CSAT. These are Zendesk chat ratings"
    type: sum
    value_format_name: number
    hidden: yes
    sql:case when ${rating} is null then 1 else 0 end ;;
  }

  measure: rated_total_count {
    label: "Rated Count"
    description: "Count of all engagements that received a rating of 'good' or 'bad' at the end of the engagemtnt. Not related to CSAT"
    type: sum
    value_format_name: number
    hidden: yes
    sql:case when ${rating} is not null then 1 else 0 end ;;
  }

  measure: rated_good_percent {
    label: "Rated Good Pct"
    description: "Percent of rated engagements give a 'good' rating"
    type: number
    value_format_name: percent_2
    sql: ${rated_good_count} / nullif(${rated_total_count}, 0) ;;
  }

  measure: rated_bad_percent {
    label: "Rated Bad Pct"
    description: "Percent of rated engagements give a 'bad' rating"
    type: number
    value_format_name: percent_2
    sql: ${rated_bad_count} / nullif(${rated_total_count}, 0) ;;
  }

  measure: rated_total_percent {
    label: "Rated Pct"
    description: "Percent of engagements that were rated"
    type: number
    value_format_name: percent_2
    sql: ${rated_total_count} / nullif(${engagement_count}, 0);;
  }

  measure: messages_agent_sum {
    label: "Messages - Agent"
    description: "Total count of all agent messages"
    type: sum
    # hidden: yes
    sql: ${agent_messages} ;;
  }

  measure: messages_total_sum {
    label: "Messages - Total"
    description: "Total count of all agent and visitor messages"
    type: sum
    # hidden: yes
    sql: ${total_messages} ;;
  }

  measure: messages_visitor_sum {
    label: "Messages - Visitor"
    description: "Total count of all visitor messages"
    type: sum
    # hidden: yes
    sql: ${visitor_messages} ;;
  }

  measure: messages_agent_avg {
    label: "Messages - Agent Avg"
    description: "Average count of agent messages during an engagement"
    type: average
    value_format_name: decimal_2
    # hidden: yes
    sql: ${agent_messages} ;;
  }

  measure: messages_total_avg {
    label: "Messages - Total Avg"
    description: "Average count of all messages during an engagement"
    type: average
    value_format_name: decimal_2
    # hidden: yes
    sql: ${total_messages} ;;
  }

  measure: messages_visitor_avg {
    label: "Messages - Visitor Avg"
    description: "Average count of all visitor messages during an engagement"
    type: average
    value_format_name: decimal_2
    # hidden: yes
    sql: ${visitor_messages} ;;
  }
}
