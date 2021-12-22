view: liveperson_combined {
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
        -- m.*

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
        # left join (
        #     select
        #         m.conversation_id as conversation_id_m,
        #         m.message_id,
        #         m.audience,
        #         m.device,
        #         m.message,
        #         -- m.participant_id,
        #         m.sent_by,
        #         m.seq,
        #         m.created,
        #         case when m.participant_id::string in ('3263325330', '3566812330') then 'Bot'
        #             when m.participant_id::string in ('3293544230', '3511734130') then 'Virtual Assistant'
        #             when a.name is null then full_name
        #             else a.name end as agent_name_m,
        #         a.supervisor as is_supervisor_m,
        #         a.is_active as is_active_m,
        #         a.retail as is_retail_m,
        #         a.team_lead as team_lead_m,
        #         a.team_type as team_type_m,
        #         a.employee_type as employee_type_m,
        #         a.location as location_m,
        #         p.name as consumer_name_m

        #     from liveperson.conversation_message m

        #         join util.warehouse_date d
        #             on d.date::date = m.created::date

        #         left join (
        #             select distinct
        #                 a.*,
        #                 c.team_name as team_lead,
        #                 case when a.inactive is null
        #                     and a.terminated is null then true else false end as is_active,
        #                 la.agent_id as liveperson_id,
        #                 la.full_name

        #             from liveperson.agent la

        #                 left join customer_care.agent_lkp a
        #                     on a.zendesk_id = la.employee_id
        #                     or a.incontact_id = la.employee_id

        #                 left join (
        #                     select *,
        #                         rank()over(partition by incontact_id order by end_date desc) as rnk
        #                     from analytics.customer_care.team_lead_name
        #                     where team_name is not null
        #                     ) c
        #                     on a.incontact_id = c.incontact_id
        #                     and c.rnk = 1
        #             ) a
        #             on m.sent_by = 'Agent'
        #             and m.participant_id = a.liveperson_id::string

        #         left join liveperson.consumer_participant p
        #             on m.participant_id = p.participant_id
        #       ) m
        #       on c.conversation_id = m.conversation_id_m
        #       and d.date = m.created::date
        #     ;;
  }
  view_label: "Conversation Data"

  # ##########################################################################################
  # ##########################################################################################
  # ## MESSAGE DATA cj

  # dimension: message_id  {
  #   label: "Message ID"
  #   description: "Distinct Message ID"
  #   view_label: "Message Data"
  #   type: string
  #   sql: ${TABLE}.message_id ;;
  # }

  # dimension: sent_by  {
  #   label: "Message Sent By"
  #   description: "Who sent message."
  #   view_label: "Message Data"
  #   type: string
  #   sql: ${TABLE}.sent_by ;;
  # }

  # ##########################################################################################
  # ##########################################################################################
  # ## MESSAGE MEASURES cj

  # measure: message_count {
  #   label: "Message Count"
  #   description: "Count of distinct messages"
  #   view_label: "Message Data"
  #   type: count_distinct
  #   sql: ${TABLE}.message_id ;;
  # }

  # measure: message_from_agent_count {
  #   label: "Message Count"
  #   description: "Count of distinct messages"
  #   view_label: "Message Data"
  #   type: count_distinct
  #   sql: case${TABLE}.message_id ;;
  # }

  # measure: message_from_consumer_count {
  #   label: "Message Count"
  #   description: "Count of distinct messages"
  #   view_label: "Message Data"
  #   type: count_distinct
  #   sql: ${TABLE}.message_id ;;
  # }

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
    sql: ${TABLE}${visitor_id} ;;
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




  # measure: consumers_active_count {
  #   label: "Active Consumers Count"
  #   group_label: "Count Metrics"
  #   type: count_distinct
  #   sql: ${visitor_id} ;;
  # }

  # measure: conversation_duration_avg {
  #   label: "Conversation Duration Avg"
  #   description: "Conversation length in minutes."
  #   group_label: "Conversation Metrics"
  #   type: average
  #   value_format_name: decimal_0
  #   sql: ${conversation_duration_minutes} ;;
  # }

  # measure: conversation_first_conversation_average {
  #   label: "First Conversation Pct"
  #   group_label: "Conversation Metrics"
  #   type: number
  #   value_format_name: percent_1
  #   sql: sum(case when ${first_conversation} = true and ${conversation_dates_date}::date = ${ended_date}::date then 1 end)
  #     / nullifzero(sum(case when ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end)) ;;
  # }

  # measure: first_conversation_closed_count {
  #   label: "First Conversation Closed Count"
  #   group_label: "Conversation Metrics"
  #   description: "Count of conversations that ARE flagged as a first conversation."
  #   # group_label: "Conversation Metrics"
  #   type: sum
  #   sql: case when ${first_conversation} = true
  #     and ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  # }

  # measure: first_conversation_opened_count {
  #   label: "First Conversation Opened Count"
  #   group_label: "Conversation Metrics"
  #   description: "Count of conversations that ARE flagged as a first conversation."
  #   # group_label: "Conversation Metrics"
  #   type: sum
  #   sql: case when ${first_conversation} = true
  #     and ${conversation_dates_date}::date = ${started_date}::date then 1 else 0 end ;;
  # }

  # measure: repeat_conversation_count {
  #   label: "Repeat Conversation Count"
  #   group_label: "Conversation Metrics"
  #   description: "Count of conversations that ARE NOT flagged as a first conversation."
  #   # group_label: "Conversation Metrics"
  #   type: sum
  #   sql: case when ${first_conversation} = false
  #     and ${conversation_dates_date}::date = ${ended_date}::date then 1 else 0 end ;;
  # }

  # # measure: closed_conversation_pct {
  # #   label: "Closed Conversations Pct"
  # #   group_label: "Conversation Closure Metrics"
  # #   type: percent_of_total
  # #   sql: ${conversations_ended_count} ;;
  # # }

  # ##########################################################################################
  # ##########################################################################################
  # ## CONSUMER RELATED MEASURES

  # ##########################################################################################
  # ##########################################################################################
  # ## DEVICE RELATED MEASURES

  # measure: device_desktop_count {
  #   label: "Desktop Conv Count"
  #   group_label: "Device Metrics"
  #   type: count_distinct
  #   sql: case when ${device}  = 'DESKTOP'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }

  # measure: device_tablet_count {
  #   label: "Tablet Conv Count"
  #   group_label: "Device Metrics"
  #   type: count_distinct
  #   sql: case when ${device}  = 'TABLET'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }

  # measure: device_mobile_count {
  #   label: "Mobile Conv Count"
  #   group_label: "Device Metrics"
  #   type: count_distinct
  #   sql: case when ${device}  = 'MOBILE'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }

  # ##########################################################################################
  # ##########################################################################################
  # ## MCS RELATED MEASURES

  # measure: mcs_avg {
  #   label: "MCS Average Score"
  #   group_label: "MCS Metrics"
  #   type: average
  #   value_format_name: decimal_2
  #   sql: ${mcs} ;;
  # }

  # measure: mcs_negative_count {
  #   label: "MCS Negative Count"
  #   group_label: "MCS Metrics"
  #   type: count_distinct
  #   value_format_name: decimal_0
  #   sql: case when ${alerted_mcs} = 'Negative'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }

  # measure: mcs_neutral_count {
  #   label: "MCS Neutral Count"
  #   group_label: "MCS Metrics"
  #   description: "Count of MCS conversations that "
  #   type: count_distinct
  #   value_format_name: decimal_0
  #   sql: case when ${alerted_mcs} = 'Neutral'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }

  # measure: mcs_positive_count {
  #   label: "MCS Positive Count"
  #   group_label: "MCS Metrics"
  #   type: count_distinct
  #   value_format_name: decimal_0
  #   sql: case when ${alerted_mcs} = 'Positive'
  #     and ${conversation_dates_date} = ${ended_date} then ${conversation_id} end ;;
  # }
}