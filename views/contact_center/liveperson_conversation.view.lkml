view: liveperson_conversation {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

  sql_table_name: "LIVEPERSON"."CONVERSATION"
    ;;
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

  dimension: mcs {
    label: "MCS"
    description: "Range of Meaningful Conversation Score in a particular conversation (including the boundaries)."
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

  dimension_group: ended {
    label: "* Ended"
    description: "End-time of the conversation."
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
    sql: CAST(${TABLE}."ENDED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    label: "* Inserted"
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: started {
    label: "* Started"
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
    sql: CAST(${TABLE}."STARTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "* Updated"
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

  dimension: alerted_mcs_id {
    label: "Alerted MCS ID"
    description: "Alerted MCS ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."ALERTED_MCS" ;;
  }

  dimension: conversation_id {
    group_label: "* IDs"
    primary_key: yes
    type: string
    hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
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

  measure: count {
    type: count
    drill_fields: [conversation_id, conversation_message.count]
  }
}
