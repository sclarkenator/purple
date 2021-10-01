view: liveperson_conversation {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

  view_label: "LivePerson Conversations"
  # sql_table_name: "
  derived_table: {
    sql:
      select
        dt.date::date as date
        ,c.started::date as start_date
        ,c.ended::date as end_date
        ,s.name as last_skill
        ,c.*
      from util.warehouse_date dt
        join liveperson.conversation c
            on dt.date::date between c.started::date and c.ended::date
        join liveperson.skill s
            on c.last_skill_id = s.skill_id ;;
    }
  drill_fields: [conversation_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: alerted_mcs {
    label: "Alerted MCS"
    description: "Divides the MCS score into 3 groups: Positive, Neutral, Negative."
    type: string
    sql: case when ${alerted_mcs_id} = -1 then 'Negative'
      when ${alerted_mcs_id} = 0 then 'Neutral'
      when ${alerted_mcs_id} = 1 then 'Positive'
      end;;
  }

  dimension: browser {
    label: "Browser"
    description: "The browser or hosted application of the engagement."
    type: string
    sql: ${TABLE}."BROWSER" ;;
  }

  dimension: conversation_duration{
    label: "Conversation Duration"
    description: "conversation duration from the first moement of connection until the contact is ended in seconds."
    type: number
    value_format_name: decimal_0
    sql: datediff(seconds, ${started_time}, ${ended_time}) ;;
  }

  dimension: device {
    label: "Device"
    description: "Type of device from which the conversation was initially opened."
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: duration_seconds {
    label: "Duration"
    description: "Contact duration in seconds."
    type: number
    sql: ${TABLE}."DURATION_SECONDS" ;;
  }

  dimension: engagementsource {
    label: "Engagement Source"
    description: "The source of the campaign's engagement e.g. WEB_SITE, SOCIAL_MEDIA, etc."
    type: string
    sql: ${TABLE}."ENGAGEMENTSOURCE" ;;
  }

  dimension: first_conversation {
    label: "First Conversation"
    description: "Whether it is the consumer's first conversation."
    type: yesno
    sql: ${TABLE}."FIRST_CONVERSATION" ;;
  }

  dimension: full_dialog_status {
    label: "Full Dialog Status"

    type: string
    sql: ${TABLE}."FULL_DIALOG_STATUS" ;;
  }

  dimension: last_queue_state {
    label: "Last Queue State"
    description: "The queue state of the conversation. Valid values: IN_QUEUE,ACTIVE"
    type: string
    sql: ${TABLE}."LAST_QUEUE_STATE" ;;
  }

  dimension: last_skill {
    label: "Last Skill"
    description: "Last assigned skill in conversation"
    type: string
    sql: ${TABLE}.last_skill ;;
  }

  dimension: mcs {
    label: "MCS"
    description: "Meaningful Conversation Score (MCS - an automated, real time measurement of consumer sentiment) for closed conversations, including unassigned conversations. This metric is attributed only to the last assigned agent in the conversation."
    type: number
    sql: ${TABLE}."MCS" ;;
  }

  dimension: partial {
    label: "Partial"
    description: "Indicates whether the conversation's data is partial.  Responses my be truncated under certain circumstances."
    type: yesno
    sql: ${TABLE}."PARTIAL" ;;
  }

  dimension: source {
    label: "Source"
    description: "Origin  from which the conversation was initially opened (Facebook, App etc.)."
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    label: "Status"
    description: "Latest status of the conversation."
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: conversation_dates {
    label: "- Active Conversation"
    description: "Reflects conversation dates from start to end dates."
    type: time
    timeframes: [
      raw,
      # time,
      date,
      week,
      month,
      # quarter,
      year
    ]
    sql: CAST(${TABLE}.date AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: ended {
    label: "- Conversation Ended"
    description: "End-time of the conversation."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      # quarter,
      year
    ]
    # hidden: yes
    sql: CAST(${TABLE}."ENDED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    label: "- Conversation Inserted"
    description: "TS when conversation record was inserted in database."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: started {
    label: "- Conversation Started"
    description: "Start-time of the conversation."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    # hidden: yes
    sql: CAST(${TABLE}."STARTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "- Conversation Updated"
    description: "TS when conversation record was updated in database."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    group_label: "* IDs"
    primary_key: yes
    type: string
    hidden: yes
    sql: concat(${TABLE}."CONVERSATION_ID", ${conversation_dates_date});;
  }

  dimension: alerted_mcs_id {
    label: "Alerted MCS ID"
    group_label: "* IDs"
    description: "Alerted MCS ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."ALERTED_MCS" ;;
  }

  dimension: campaign_engagement_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."CAMPAIGN_ENGAGEMENT_ID" ;;
  }

  dimension: campaign_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: conversation_id {
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: goal_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."GOAL_ID" ;;
  }

  dimension: interaction_context_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."INTERACTION_CONTEXT_ID" ;;
  }

  dimension: last_agent_group_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."LAST_AGENT_GROUP_ID" ;;
  }

  dimension: last_agent_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."LAST_AGENT_ID" ;;
  }

  dimension: last_skill_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."LAST_SKILL_ID" ;;
  }

  dimension: lob_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."LOB_ID" ;;
  }

  dimension: location_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: session_id {
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: visitor_behavior_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."VISITOR_BEHAVIOR_ID" ;;
  }

  dimension: visitor_id {
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: visitor_profile_id {
    group_label: "* IDs"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."VISITOR_PROFILE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: conversations_opened_count {
    label: "Conversations Opened Count"
    type: sum
    # type: count_distinct
    sql: case when ${conversation_dates_date}::date = ${started_date}::date then 1 else 0 end ;;
  }

  measure: conversations_ended_count {
    label: "Conversations Ended Count"
    type: sum
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  }

  measure: mcs_avg {
    label: "MCS Average"
    type: average
    value_format_name: decimal_2
    sql: case when average(${mcs}) >= 33 then 'Positive'
      when average(${mcs}) <= -33 then 'Negative'
      when average(${mcs}) between -32 and 32 then 'Neutral' end ;;
  }

  measure: conversation_duration_avg {
    label: "Converrsation Duration Avg"
    type: average
    value_format_name: decimal_0
    sql: ${conversation_duration} ;;
  }

  # measure: consumers_active {
  #   label: "Active Consumers"
  #   type: count_distinct
  #   sql: ${visitor_id} ;;
  #   where:
  # }

  # measure: conversation_percentage { # USE TABLE CALCULATIONS FOR PERCENTAGE OF CONVERSATIONS
  #   label: "Conversation Percentage"
  #   type: percent_of_total
  #   sql: count(distinct ${conversation_id}) ;;
  # }
}
