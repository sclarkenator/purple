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
    description: "conversation duration from the first moement of connection until the conversation is closed in seconds."
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
      year,
      day_of_week,
      hour_of_day,
      minute30
    ]
    sql: CAST(${TABLE}.date AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: ended {
    label: "- Conversation Closed"
    description: "Time the conversation was closed."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      # quarter,
      year,
      day_of_week,
      hour_of_day,
      minute30
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
      year,
      day_of_week,
      hour_of_day,
      minute30
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

  measure: conversation_duration_avg {
    label: "Conversation Duration Avg"
    type: average
    value_format_name: decimal_0
    sql: ${conversation_duration} ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## COUNT MEASURES

  measure: consumers_active_count {
    label: "Active Consumers"
    group_label: "Count Metrics"
    type: count_distinct
    sql: ${visitor_id} ;;
  }

  measure: conversations_opened_count {
    label: "Conversations Opened"
    group_label: "Count Metrics"
    type: sum
    # type: count_distinct
    sql: case when ${conversation_dates_date}::date = ${started_date}::date then 1 else 0 end ;;
  }

  measure: conversations_ended_count {
    label: "Conversations Closed"
    group_label: "Count Metrics"
    type: sum
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DEVICE MEASURES

  measure: device_desktop_count {
    label: "Desktop Conv Count"
    group_label: "Device Metrics"
    type: count_distinct
    sql: case when ${device}  = 'DESKTOP'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: device_tablet_count {
    label: "Tablet Conv Count"
    group_label: "Device Metrics"
    type: count_distinct
    sql: case when ${device}  = 'TABLET'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: device_mobile_count {
    label: "Mobile Conv Count"
    group_label: "Device Metrics"
    type: count_distinct
    sql: case when ${device}  = 'MOBILE'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DEVICE MEASURES

  measure: mcs_positive_count {
    label: "MCS Positive Count"
    group_label: "MCS Metrics"
    type: count_distinct
    sql: case when ${alerted_mcs}  = 'Positive'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: mcs_neutral_count {
    label: "MCS Neutral Count"
    group_label: "MCS Metrics"
    type: count_distinct
    sql: case when ${alerted_mcs}  = 'Neutral'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: mcs_negative_count {
    label: "MCS Negative Count"
    group_label: "MCS Metrics"
    type: count_distinct
    sql: case when ${alerted_mcs}  = 'Negative'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: mcs_avg {
    label: "MCS Average"
    group_label: "MCS Metrics"
    type: average
    value_format_name: decimal_2
    sql: case when average(${mcs}) >= 33 then 'Positive'
      when average(${mcs}) <= -33 then 'Negative'
      when average(${mcs}) between -32 and 32 then 'Neutral' end ;;
  }
}
