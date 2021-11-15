## REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

view: liveperson_conversation {

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
        ,mcs.name as alerted_mcs_name
      from util.warehouse_date dt

        join liveperson.conversation c
            on dt.date::date between c.started::date and c.ended::date

        left join liveperson.skill s
            on c.last_skill_id = s.skill_id

        left join liveperson.alerted_mcs_subtype mcs
            on c.alerted_mcs = mcs.subtype_id
      ;;
    }

  drill_fields: [conversation_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: alerted_mcs {
    label: "Alerted MCS"
    group_label: "* Conversation Metrics"
    description: "Alerted MCS of the conversation up until the most recent message."
    type: string
    sql: ${TABLE}.alerted_mcs_name ;;
  }

  dimension: browser {
    label: "Browser"
    group_label: "* Conversation Source Data"
    description: "The browser or hosted application of the engagement."
    type: string
    sql: ${TABLE}."BROWSER" ;;
  }

  dimension: close_reason {
    label: "Close Reason"
    group_label: "* Conversation Status"
    description: "Reason for closing the conversation. (by agent / consumer / system)"
    type: string
    sql: case when ${TABLE}.close_reason = 'TIMEOUT' then 'SYSTEM'
        else ${TABLE}.close_reason end ;;
  }

  dimension: close_reason_description {
    label: "Close Reason Description"
    group_label: "* Conversation Status"
    description: "Reason for closing the conversation. (brand auto close / manual close)."
    type: string
    # hidden: yes
    sql: ${TABLE}.close_reason_description ;;
  }

  dimension: conversation_duration {
    label: "Conversation Duration"
    group_label: "* Conversation Metrics"
    description: "Conversation duration from the first moment of connection until the conversation is closed in seconds."
    type: number
    value_format_name: decimal_0
    sql: datediff(seconds, ${started_time}, ${ended_time}) ;;
  }

  dimension: device {
    label: "Device"
    group_label: "* Conversation Source Data"
    description: "Type of device from which the conversation was initially opened."
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: duration_seconds {
    label: "Duration"
    group_label: "* Conversation Metrics"
    description: "Contact duration in seconds."
    type: number
    sql: ${TABLE}."DURATION_SECONDS" ;;
  }

  dimension: engagement_source {
    label: "Engagement Source"
    group_label: "* Conversation Source Data"
    description: "The source of the campaign's engagement e.g. WEB_SITE, SOCIAL_MEDIA, etc."
    type: string
    sql: ${TABLE}.campaign_engagement_source ;;
  }

  dimension: first_conversation {
    label: "First Conversation"
    group_label: "* Conversation Status"
    description: "Whether it is the consumer's first conversation."
    type: yesno
    sql: ${TABLE}."FIRST_CONVERSATION" ;;
  }

  dimension: full_dialog_status {
    label: "Full Dialog Status"
    group_label: "* Conversation Status"
    type: string
    # hidden: yes
    sql: ${TABLE}."FULL_DIALOG_STATUS" ;;
  }

  dimension: last_queue_state {
    label: "Last Queue State"
    group_label: "* Conversation Status"
    description: "The queue state of the conversation. Valid values: IN_QUEUE,ACTIVE"
    type: string
    sql: ${TABLE}."LAST_QUEUE_STATE" ;;
  }

  dimension: last_skill {
    label: "Last Skill"
    group_label: "* Conversation Status"
    description: "Last assigned skill in conversation"
    type: string
    sql: ${TABLE}.last_skill ;;
  }

  dimension: mcs {
    label: "MCS Score"
    group_label: "* Conversation Metrics"
    description: "Meaningful Conversation Score (MCS - an automated, real time measurement of consumer sentiment) for closed conversations, including unassigned conversations. This metric is attributed only to the last assigned agent in the conversation."
    type: number
    sql: ${TABLE}."MCS" ;;
  }

  dimension: partial {
    label: "Partial"
    group_label: "* Conversation Status"
    description: "Indicates whether the conversation's data is partial.  Responses my be truncated under certain circumstances."
    type: yesno
    sql: ${TABLE}."PARTIAL" ;;
  }

  dimension: repeat_conversation {
    label: "Repeat Conversation"
    group_label: "* Conversation Status"
    description: "Whether it is the consumer's first conversation."
    type: yesno
    sql: if ${TABLE}."FIRST_CONVERSATION" = true then false else true end  ;;
  }

  dimension: source {
    label: "Source"
    group_label: "* Conversation Source Data"
    description: "Origin  from which the conversation was initially opened (Facebook, App etc.)."
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    label: "Status"
    group_label: "* Conversation Status"
    description: "Latest status of the conversation."
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## CAMPAIGN DIMENSIONS

  dimension: behavior_system_default {
    label: "Behavior System Default"
    group_label: "* Campaign Data"
    description: "Indicates whether behavioral targeting rule is the default one."
    type: yesno
    # hidden: yes
    sql: ${TABLE}."CAMPAIGN_BEHAVIOR_SYSTEM_DEFAULT" ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    group_label: "* Campaign Data"
    description: "Name of the campaign."
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension: engagement_name {
    label: "Engagement Name"
    group_label: "* Campaign Data"
    description: "Name of the campaign's engagement."
    type: string
    sql: ${TABLE}.campaign_engagement_name ;;
  }

  dimension: engagement_type {
    label: "Engagement Type"
    group_label: "* Campaign Data"
    description: "Engagement's application type name."
    type: string
    sql: case when ${campaign_name} ilike '%proactive%' then 'Proactive' else 'Passive' end ;;
  }

  dimension: goal_name {
    label: "Goal Name"
    group_label: "* Campaign Data"
    description: "Name of the campaign's goal."
    type: string
    # hidden: yes
    sql: ${TABLE}.campaign_goal_name ;;
  }

  dimension: lob_name {
    label: "LOB Name"
    group_label: "* Campaign Data"
    description: "Name of the line of business of the campaign."
    type: string
    # hidden: yes
    sql: ${TABLE}.campaign_lob_name ;;
  }

  dimension: location_name {
    label: "Location Name"
    group_label: "* Campaign Data"
    description: "Describes the engagement display location."
    type: string
    sql: ${TABLE}.campaign_location_name ;;
  }

  dimension: profile_system_default {
    label: "Profile System Default"
    group_label: "* Campaign Data"
    description: "Indicates whether behavioral targeting rule is the default one."
    type: yesno
    sql: ${TABLE}.campaign_profile_system_default ;;
  }

  # dimension: source {
  #   label: "Source Name"
  #   group_label: "* Campaign Data"
  #   type: string
  #   sql: ${TABLE}."SOURCE" ;;
  # }

  dimension: visitor_behavior_name {
    label: "Visitor Behavor"
    group_label: "* Campaign Data"
    description: "Name of the behavioral targeting rule defined for the campaign's engagement (in case engagememt id is available)."
    type: string
    sql: ${TABLE}.campaign_visitor_behavior_name ;;
  }

  dimension: visitor_profile_name {
    label: "Visitor Profile Name"
    group_label: "* Campaign Data"
    description: "Name of the visitor profile defined for the campaign."
    type: string
    sql: ${TABLE}.campaign_visitor_profile_name ;;
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
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
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
      date
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
    hidden: yes
    sql: CAST(${TABLE}."STARTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "- Conversation Updated"
    description: "TS when conversation record was updated in database."
    type: time
    timeframes: [
      raw,
      time,
      date
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
    sql: concat(${conversation_id}, ${conversation_dates_date});;
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
    # hidden: yes
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
    # hidden: yes
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
  ## COUNT MEASURES

  measure: consumers_active_count {
    label: "Active Consumers"
    group_label: "Count Metrics"
    type: count_distinct
    sql: ${visitor_id} ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## CONVERSATION MEASURES

  measure: conversation_duration_avg {
    label: "Conversation Duration Avg"
    description: "Conversation length in minutes."
    group_label: "Conversation Metrics"
    type: average
    value_format_name: decimal_0
    sql: ${conversation_duration}/60 ;;
  }

  measure: conversation_first_conversation_average {
    label: "First Conversation Pct"
    group_label: "Conversation Metrics"
    type: number
    value_format_name: percent_1
    sql: sum(case when ${first_conversation} = true and ${conversation_dates_date}::date = ${ended_date}::date then 1 end)
      / nullifzero(sum(case when ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end)) ;;

    # html:
    #   <ul>
    #     <li> Percentage: {{conversation_first_conversation_average._rendered_value}} </li>
    #     <li> First Conversation: {{first_conversation_count._rendered_value}}</li>
    #     <li> Repeat Conversation: {{repeat_conversation_count._rendered_value}}</li>
    #   </ul> ;;
  }

  measure: first_conversation_count {
    label: "First Conversation Count"
    group_label: "Conversation Metrics"
    description: "Count of conversations that ARE flagged as a first conversation."
    # group_label: "Conversation Metrics"
    type: sum
    sql: case when ${first_conversation} = true
        and ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  }

  measure: repeat_conversation_count {
    label: "Repeat Conversation Count"
    group_label: "Conversation Metrics"
    description: "Count of conversations that ARE NOT flagged as a first conversation."
    # group_label: "Conversation Metrics"
    type: sum
    sql: case when ${first_conversation} = false
        and ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  }

  measure: conversations_opened_count {
    label: "Conversations Opened"
    group_label: "Conversation Metrics"
    type: sum
    # type: count_distinct
    sql: case when ${conversation_dates_date}::date = ${started_date}::date then 1 else 0 end ;;
  }

  measure: conversations_ended_count {
    label: "Closed Conversations"
    # group_label: "Conversation Metrics"
    description: "Count of closed conversations.  This is typically the primary measure used in counting conversations."
    # group_label: "Conversation Metrics"
    type: sum
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date then 1 end ;;
  }

  measure: closed_conversation_pct {
    label: "Closed Conversations Pct"
    group_label: "Conversation Closure Metrics"
    type: percent_of_total
    sql: ${conversations_ended_count} ;;
  }

  # measure: conversations_closed_manually_count {
  #   label: "Conversations Closed Manually"
  #   type: sum
  #   value_format_name: decimal_0
  #   sql: case when ${conversation_dates_date}::date = ${ended_date}::date
  #     and ${close_reason_description} = 'MANUAL_CLOSE' then 1 end ;;
  # }

  # measure: conversations_closed_auto_count {
  #   label: "Conversations Auto Closed"
  #   type: sum
  #   value_format_name: decimal_0
  #   sql: case when ${conversation_dates_date}::date = ${ended_date}::date
  #     and ${close_reason_description} = 'BRAND_AUTO_CLOSE' then 1 end ;;
  # }

  measure: conversations_closed_by_agent_count {
    label: "Closed By Agent"
    group_label: "Conversation Closure Metrics"
    type: sum
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'AGENT' then 1 end ;;
  }

  measure: conversations_closed_by_consumer_count {
    label: "Closed By Consumer"
    group_label: "Conversation Closure Metrics"
    type: sum
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'CONSUMER' then 1 end ;;
  }

  measure: conversations_closed_by_system_count {
    label: "Closed by System"
    group_label: "Conversation Closure Metrics"
    type: sum
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'TIMEOUT' then 1 end ;;
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
  ## MCS MEASURES

  measure: mcs_avg {
    label: "MCS Average Score"
    group_label: "MCS Metrics"
    type: average
    value_format_name: decimal_2
    sql: ${mcs} ;;
  }

  measure: mcs_negative_count {
    label: "MCS Negative Count"
    group_label: "MCS Metrics"
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${alerted_mcs} = 'Negative'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: mcs_neutral_count {
    label: "MCS Neutral Count"
    group_label: "MCS Metrics"
    description: "Count of MCS conversations that "
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${alerted_mcs} = 'Neutral'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }

  measure: mcs_positive_count {
    label: "MCS Positive Count"
    group_label: "MCS Metrics"
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${alerted_mcs} = 'Positive'
      and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  }
}
