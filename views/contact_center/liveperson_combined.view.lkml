view: liveperson_combined {
  view_label: "Conversation Data"
  derived_table: {
    sql:
      select
        d.date as activity_date,
        c.conversation_id,
        c.interaction_context_id,
        c.campaign_visitor_profile_id,
        c.session_id,
        c.started,
        c.ended,
        c.duration_seconds,
        c.source,
        c.mcs,
        c.status,
        c.full_dialog_status,
        c.last_queue_state,
        c.first_conversation,
        c.partial,
        c.device,
        c.browser,
        c.campaign_engagement_source,
        c.close_reason,
        c.close_reason_description,
        c.browser_version,
        c.operating_system,
        c.operating_system_version,
        c.time_zone,
        c.language,
        c.ip_address,
        c.campaign_name,
        upper(c.campaign_engagement_name) as campaign_engagement_name,
        c.campaign_goal_name,
        c.campaign_location_name,
        c.campaign_visitor_behavior_name,
        c.campaign_visitor_profile_name,
        c.campaign_lob_name,
        c.campaign_behavior_system_default,
        c.campaign_profile_system_default,
        upper(s.name) as last_skill,
        upper(mcs.name) as alerted_mcs,
        a.name as agent_name,
        a.supervisor as is_supervisor,
        a.is_active,
        a.retail as is_retail,
        a.team_lead,
        a.team_type,
        a.employee_type,
        a.location
        -- vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv enable when added to SQL database
        -- c.art,
        -- c.artc,
        -- c.arth,
        -- c.arta,
        -- c.artac,
        -- c.artah,
        -- c.ttfah,
        -- c.ttfrah,
        -- c.ttfrh,
        -- c.ttfab,
        -- c.ttfrab,
        -- c.ttfrb,
        -- c.ttfrs,
        -- c.ttfra,
        -- c.ttfr,
        -- c.participants,
        -- c.interactions,
        -- c.transfers,
        -- c.messages,
        -- c.responses
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ enable when added to SQL database

      from liveperson.conversation c

        join util.warehouse_date d
            on d.date::date between c.started::date and ifnull(c.ended, current_date())::date

        left join (
          select distinct
            a.*,
            c.team_name as team_lead,
            case when a.inactive is null and a.terminated is null then true else false end as is_active,
            la.agent_id as liveperson_id

        from analytics.customer_care.agent_lkp a

        left join (
            select *,
                rank()over(partition by incontact_id order by end_date desc) as rnk
            from analytics.customer_care.team_lead_name
            where team_name is not null
            ) c
            on a.incontact_id = c.incontact_id
            and c.rnk = 1

            left join liveperson.agent la
                on a.zendesk_id = la.employee_id
                or a.incontact_id = la.employee_id
            ) a
            on c.last_agent_id = a.liveperson_id

        left join liveperson.skill s
            on c.last_skill_id = s.skill_id

        left join liveperson.alerted_mcs_subtype mcs
            on c.alerted_mcs = mcs.subtype_id
            ;;
        }


  ##########################################################################################
  ##########################################################################################
  ## CONVERSATION AGENT DATA cj

  dimension: agent_employee_type {
    label: "Employee Type"
    description: "Last agent employment type."
    group_label: "Last Agent Data"
    type: string
    sql: ${TABLE}.employee_type ;;
  }

  dimension: agent_is_supervisor {
    label: "Is Supervisor"
    description: "Is last agent flagged as a supervisor in InContact."
    group_label: "Last Agent Data"
    type: yesno
    sql: ${TABLE}.is_supervisor ;;
  }

  dimension: agent_is_active {
    label: "Is Active"
    description: "Is last agent flagged as active in InContact."
    group_label: "Last Agent Data"
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: agent_is_retail {
    label: "Is Retail"
    description: "Is last agent flagged as retail in InContact."
    group_label: "Last Agent Data"
    type: yesno
    sql: ${TABLE}.is_retail ;;
  }

  dimension: agent_location {
    label: "Agent Location"
    description: "Last agent's location."
    group_label: "Last Agent Data"
    type: string
    hidden: yes # Hide until this dimension is in use
    sql: ${TABLE}.location ;;
  }

  dimension: agent_name {
    label: "Agent Name"
    description: "Name of last active agent."
    group_label: "Last Agent Data"
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: agent_team_lead {
    label: "Team Lead"
    description: "Last agent's team lead's name."
    group_label: "Last Agent Data"
    type: string
    sql: ${TABLE}.team_lead ;;
  }

  dimension: agent_team_type {
    label: "Team Type"
    description: "Last agent's team type name."
    group_label: "Last Agent Data"
    type: string
    sql: ${TABLE}.team_type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: alerted_mcs {
    label: "Alerted MCS"
    group_label: "Conversation Metrics"
    description: "Alerted MCS of the conversation up until the most recent message."
    type: string
    sql: ${TABLE}.alerted_mcs ;;
  }

  dimension: browser {
    label: "Browser"
    group_label: "Conversation Source Data"
    description: "The browser or hosted application of the engagement."
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: close_reason {
    label: "Close Reason"
    group_label: "Conversation Status"
    description: "Reason for closing the conversation. (by agent / consumer / system)"
    type: string
    sql: case when ${TABLE}.close_reason = 'TIMEOUT' then 'SYSTEM'
      else ${TABLE}.close_reason end ;;
  }

  dimension: close_reason_description {
    label: "Close Reason Description"
    group_label: "Conversation Status"
    description: "Reason for closing the conversation. (brand auto close / manual close)."
    type: string
    # hidden: yes
    sql: ${TABLE}.close_reason_description ;;
  }

  dimension: conversation_duration_seconds {
    label: "Duration Sec"
    group_label: "Conversation Metrics"
    description: "Conversation duration from the first moment of connection until the conversation is closed in seconds."
    type: number
    value_format_name: decimal_0
    hidden: yes
    sql: ${TABLE}.duration_seconds ;;
  }

  dimension: conversation_duration_minutes {
    label: "Duration Min"
    group_label: "Conversation Metrics"
    description: "Conversation duration from the first moment of connection until the conversation is closed in minutes."
    type: number
    value_format_name: decimal_2
    sql: ${conversation_duration_seconds}/60 ;;
  }

  dimension: device {
    label: "Device"
    group_label: "Conversation Source Data"
    description: "Type of device from which the conversation was initially opened."
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: engagement_source {
    label: "Engagement Source"
    group_label: "Conversation Source Data"
    description: "The source of the campaign's engagement e.g. WEB_SITE, SOCIAL_MEDIA, etc."
    type: string
    sql: ${TABLE}.campaign_engagement_source ;;
  }

  dimension: first_conversation {
    label: "First Conversation"
    group_label: "Conversation Status"
    description: "Is this the consumer's first conversation."
    type: yesno
    sql: ${TABLE}.first_conversation ;;
  }

  dimension: full_dialog_status {
    label: "Full Dialog Status"
    group_label: "Conversation Status"
    type: string
    # hidden: yes
    sql: ${TABLE}.full_dialog_status ;;
  }

  dimension: last_queue_state {
    label: "Last Queue State"
    group_label: "Conversation Status"
    description: "The queue state of the conversation. Valid values: IN_QUEUE,ACTIVE"
    type: string
    sql: ${TABLE}.last_queue_state ;;
  }

  dimension: last_skill {
    label: "Last Skill"
    group_label: "Conversation Status"
    description: "Last assigned skill in conversation"
    type: string
    sql: ${TABLE}.last_skill ;;
  }

  dimension: mcs {
    label: "MCS Score"
    group_label: "Conversation Metrics"
    description: "Meaningful Conversation Score (MCS - an automated, real time measurement of consumer sentiment) for closed conversations, including unassigned conversations. This metric is attributed only to the last assigned agent in the conversation."
    type: number
    sql: ${TABLE}.mcs ;;
  }

  dimension: partial {
    label: "Partial"
    group_label: "Conversation Status"
    description: "Indicates whether the conversation's data is partial.  Responses my be truncated under certain circumstances."
    type: yesno
    sql: ${TABLE}.partial ;;
  }

  dimension: repeat_conversation {
    label: "Repeat Conversation"
    group_label: "Conversation Status"
    description: "Whether it is the consumer's first conversation."
    type: yesno
    sql: case when ${first_conversation} = true then false else true end  ;;
  }

  dimension: source {
    label: "Source"
    group_label: "Conversation Source Data"
    description: "Origin  from which the conversation was initially opened (Facebook, App etc.)."
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    label: "Status"
    group_label: "Conversation Status"
    description: "Latest status of the conversation."
    type: string
    sql: ${TABLE}.status ;;
  }

  ## vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv enable when added to SQL database

  # dimension: participants {
  #   label: "Participants"
  #   group_item_label: "Conversation Metrics"
  #   description: "Count of participants that acted on the conversation"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: ${TABLE}.participants ;;
  # }

  # dimension: interactions {
  #   label: "Interactions"
  #   group_item_label: "Conversation Metrics"
  #   description: "Count of non-system agents that interacted on the conversation"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: ${TABLE}.interactions ;;
  # }

  # dimension: transfers {
  #   label: "Transfers"
  #   group_item_label: "Conversation Metrics"
  #   description: "Count of transfers after assignment in the conversation"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: ${TABLE}.transfers ;;
  # }

  # dimension: messages {
  #   label: "Messages"
  #   group_item_label: "Conversation Metrics"
  #   description: "Count of messages exchanged during the conversation"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: ${TABLE}.messages ;;
  # }

  # dimension: responses {
  #   label: "Responses"
  #   group_item_label: "Conversation Metrics"
  #   description: "Count of back and forth exchanges that took place in the conversation"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: ${TABLE}.responses ;;
  # }

  # ##########################################################################################
  # ##########################################################################################
  # ## DURATION METRIC DIMENSIONS

  # dimension: art {
  #   label: "ART"
  #   group_label: "Duration Dimensions"
  #   description: "Average Response Time in seconds"
  #   type: number
  #   sql: ${TABLE}.art ;;
  # }

  # dimension: artc {
  #   label: "ARTC"
  #   group_label: "Duration Dimensions"
  #   description: "Average Consumer Response Time in seconds"
  #   type: number
  #   sql: ${TABLE}.artc ;;
  # }

  # dimension: arth {
  #   label: "ARTH"
  #   group_label: "Duration Dimensions"
  #   description: "Average Human Agent Response Time in seconds"
  #   type: number
  #   sql: ${TABLE}.arth ;;
  # }

  # dimension: arta {
  #   label: "ARTA"
  #   group_label: "Duration Dimensions"
  #   description: "Average Response Time after Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.arta ;;
  # }

  # dimension: artac {
  #   label: "ARTAC"
  #   group_label: "Duration Dimensions"
  #   description: "Average Consumer Response Time after Assignmenbt in seconds"
  #   type: number
  #   sql: ${TABLE}.artac ;;
  # }

  # dimension: artah {
  #   label: "ARTAH"
  #   group_label: "Duration Dimensions"
  #   description: "Average Human Agent Response Time after Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.artah ;;
  # }

  # dimension: ttfah {
  #   label: "TTFAH"
  #   group_label: "Duration Dimensions"
  #   description: "Time to First Human Agent Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfah ;;
  # }

  # dimension: ttfrah {
  #   label: "TTFRAH"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First Human Response After Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfrah ;;
  # }

  # dimension: ttfrh {
  #   label: "TTFRH"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First Human Response in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfrh ;;
  # }

  # dimension: ttfab {
  #   label: "TTFAB"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First Bot Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfab ;;
  # }

  # dimension: ttfrab {
  #   label: "TTFRAB"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First Bot Response after Assignment in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfrab ;;
  # }

  # dimension: ttfrb {
  #   label: "TTFRB"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First Bot Response in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfrb ;;
  # }

  # dimension: ttfrs {
  #   label: "TTFRS"
  #   group_label: "Duration Dimensions"
  #   description: "Time To First System Response in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfrs ;;
  # }

  # dimension: ttfra {
  #   label: "TTFRA"
  #   group_label: "Duration Dimensions"
  #   description: "Average first response time measured as avg of TTFRAH, TTFRAB, TTFRS in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfra ;;
  # }

  # dimension: ttfr {
  #   label: "TTFR"
  #   group_label: "Duration Dimensions"
  #   description: "Calculated as the lesser of TTFRH, TTFRB, TTFRS in seconds"
  #   type: number
  #   sql: ${TABLE}.ttfr ;;
  # }

  ## ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ enable when added to SQL database

  ##########################################################################################
  ##########################################################################################
  ## CAMPAIGN DIMENSIONS

  dimension: behavior_system_default {
    label: "Behavior System Default"
    group_label: "Campaign Data"
    description: "Indicates whether behavioral targeting rule is the default one."
    type: yesno
    # hidden: yes
    sql: ${TABLE}.campaign_behavior_system_default ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    group_label: "Campaign Data"
    description: "Name of the campaign."
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: engagement_name {
    label: "Engagement Name"
    group_label: "Campaign Data"
    description: "Name of the campaign's engagement."
    type: string
    sql: ${TABLE}.campaign_engagement_name ;;
  }

  dimension: engagement_type {
    label: "Engagement Type"
    group_label: "Campaign Data"
    description: "Engagement's application type name."
    type: string
    sql: case when ${campaign_name} ilike '%proactive%' then 'Proactive' else 'Passive' end ;;
  }

  dimension: goal_name {
    label: "Goal Name"
    group_label: "Campaign Data"
    description: "Name of the campaign's goal."
    type: string
    # hidden: yes
    sql: ${TABLE}.campaign_goal_name ;;
  }

  dimension: lob_name {
    label: "LOB Name"
    group_label: "Campaign Data"
    description: "Name of the line of business of the campaign."
    type: string
    hidden: yes
    sql: ${TABLE}.campaign_lob_name ;;
  }

  dimension: location_name {
    label: "Location Name"
    group_label: "Campaign Data"
    description: "Describes the engagement display location."
    type: string
    sql: ${TABLE}.campaign_location_name ;;
  }

  dimension: profile_system_default {
    label: "Profile System Default"
    group_label: "Campaign Data"
    description: "Indicates whether behavioral targeting rule is the default one."
    type: yesno
    sql: ${TABLE}.campaign_profile_system_default ;;
  }

  # dimension: source {
  #   label: "Source Name"
  #   group_label: "Campaign Data"
  #   type: string
  #   sql: ${TABLE}."SOURCE" ;;
  # }

  dimension: visitor_behavior_name {
    label: "Visitor Behavor"
    group_label: "Campaign Data"
    description: "Name of the behavioral targeting rule defined for the campaign's engagement (in case engagememt id is available)."
    type: string
    sql: ${TABLE}.campaign_visitor_behavior_name ;;
  }

  dimension: visitor_profile_name {
    label: "Visitor Profile Name"
    group_label: "Campaign Data"
    description: "Name of the visitor profile defined for the campaign."
    type: string
    sql: ${TABLE}.campaign_visitor_profile_name ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: conversation_dates {
    label: "Active Conversation"
    description: "Reflects conversation dates from start to end dates."
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      week,
      # month,
      quarter,
      year,
      day_of_week
    ]
    sql: CAST(${TABLE}.activity_date AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: ended {
    label: "Conversation Closed"
    description: "Time the conversation was closed."
    view_label: "Dates"
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
    sql: CAST(${TABLE}.ended AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: started {
    label: "Conversation Started"
    description: "Start-time of the conversation."
    view_label: "Dates"
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
    sql: CAST(${TABLE}.started AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: concat(${conversation_id}, ${conversation_dates_date});;
  }

  dimension: conversation_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.conversation_id ;;
  }

  dimension: visitor_id {
    label: "Visitor ID"
    type: string
    sql: ${TABLE}.visitor_id ;;
    hidden: yes
  }

  ##########################################################################################
  ##########################################################################################
  ## CONVERSATION RELATED MEASURES

  measure: conversations_closed_by_agent_count {
    label: "Closed By Agent"
    group_label: "Conversation Closure Metrics"
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'AGENT' then ${conversation_id} end ;;
  }

  measure: conversations_closed_by_consumer_count {
    label: "Closed By Consumer"
    group_label: "Conversation Closure Metrics"
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'CONSUMER' then ${conversation_id} end ;;
  }

  measure: conversations_closed_by_system_count {
    label: "Closed by System"
    group_label: "Conversation Closure Metrics"
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date
      and ${close_reason} = 'SYSTEM' then ${conversation_id} end ;;
  }

  measure: conversations_ended_count {
    label: "Closed Conversations"
    # group_label: "Conversation Metrics"
    description: "Count of closed conversations.  This is typically the primary measure used in counting conversations."
    group_label: "Conversation Closure Metrics"
    type: count_distinct
    sql: case when ${conversation_dates_date}::date = ${ended_date}::date then ${conversation_id} end ;;
  }

  measure: conversations_opened_count {
    label: "Opened Conversations"
    group_label: "Conversation Metrics"
    # type: sum
    type: count_distinct
    sql: case when ${conversation_dates_date}::date = ${started_date}::date then ${conversation_id} end ;;
  }
}
