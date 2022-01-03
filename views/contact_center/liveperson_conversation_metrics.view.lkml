view: liveperson_conversation_metrics {
  derived_table: {
    sql:
      with messages as (
        select m.*
          ,rank()over(partition by m.conversation_id, m.sender order by m.created, m.seq) sender_rnk
        from (
          select
            row_number()over(partition by conversation_id order by created, seq) as rn
            -- ,rank() over(partition by )
            ,conversation_id
            ,message_id
            ,created
            -- ,left(created, 19) as created
            ,a.full_name as agent_name
            ,seq
            ,case when a.full_name ilike '%-bot' then 'Bot'
              when a.full_name ilike '%virtual assistant' then 'Virtual Assistant'
              else cm.sent_by end as Sender
            ,message
            ,case when seq = 0 then 1  -- First message
              when message like 'You are now connected to%' and message like '%Virtual Assistant.' then 2  -- Connected to Bot
              when message like 'You are now connected to%' and message not like '%Virtual Assistant.' then 3  -- Connected to human agent
              when message ilike '% transfer you to a representative%'
                  and a.full_name ilike '%virtual assistant' then 4 -- Bot starts transferring to human agent
              end as flag

          from liveperson.conversation_message cm

            left join liveperson.agent a
              on cm.sent_by = 'Agent'
              and cm.participant_id = a.agent_id::string

          order by conversation_id, created, seq
          ) m
        )

      select distinct
        m1.conversation_id
        ,m1.created
        ,round(datediff(seconds, m1.created, m2_1.created)/60, 2) as time_to_first_response_virtual_agent
        ,round(datediff(seconds, m4.created, m3_1.created)/60, 2) as time_to_first_response_hum_from_bot
        ,round(datediff(seconds, m1.created, m3.created)/60, 2) as time_to_assignment_human
        ,round(datediff(seconds, m1.created, m3_1.created)/60, 2) as time_to_first_human_response
        ,round(datediff(seconds, m3.created, m3_1.created)/60, 2) as time_to_first_human_response_from_assignment
        ,m10.messages_per_conversation_human
        ,m10.messages_per_conversation_bot
        ,m10.messages_per_conversation_virtual_agent
        ,m10.messages_per_conversation_consumer
        ,m10.messages_per_conversation
        ,case when round(datediff(seconds, m1.created, m3_1.created)/60, 2) <= 5 then 1
            else 0 end as in_sla_flag
        ,m9.agent_segments

      from (
        select *
        from messages
        where seq = 0
        ) m1 -- First message

        left join messages m2  -- Connected to Bot
          on m2.flag = 2
          and m1.conversation_id = m2.conversation_id

        left join messages m2_1  -- First response from Bot
          on m1.conversation_id = m2_1.conversation_id
          and m2_1.sender_rnk = 1
          and m2_1.sender = 'Virtual Assistant'

        left join (
          select conversation_id
              ,min(created) as created
          from messages
          where message like 'You are now connected to%' and message not like '%Virtual Assistant.'
          group by conversation_id
          ) m3  -- Connected to human agent
          on m1.conversation_id = m3.conversation_id

        left join (
          select conversation_id
              ,min(created) as created
          from messages
          where sender = 'Agent'
          group by conversation_id
          ) m3_1  --first human agent response
          on m1.conversation_id = m3_1.conversation_id

        left join messages m4
          on m1.conversation_id = m4.conversation_id
          and m4.flag = 4

        left join (
          select conversation_id
            ,count(distinct agent_name) as agent_segments
          from messages
          where sender = 'Agent'
          group by conversation_id
          ) m9
          on m1.conversation_id = m9.conversation_id

        left join (
          select conversation_id
            ,count(distinct case when sender = 'Agent' then message_id end) as messages_per_conversation_human
            ,count(distinct case when sender = 'Bot' then message_id end) as messages_per_conversation_bot
            ,count(distinct case when sender = 'Virtual Assistant' then message_id end) as messages_per_conversation_virtual_agent
            ,count(distinct case when sender = 'Consumer' then message_id end) as messages_per_conversation_consumer
            ,count(distinct message_id) as messages_per_conversation
          from messages
          group by conversation_id
          ) m10
          on m1.conversation_id = m10.conversation_id
      ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: conversation_id {
    label: "Conversation ID"
    primary_key: yes
    type: string
    hidden: yes
    sql: ${TABLE}.conversation_id ;;
  }

  dimension_group: conversation_created {
    label: "Conversation Created"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      minute30,
      hour_of_day,
      day_of_week
    ]
    hidden: yes
    sql: CAST(${TABLE}.created AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## CONVERSATION METRICS

  dimension: time_to_first_response_virtual_agent {
    label: "TTFR (Bot)"
    group_label: "Time Metrics"
    description: "Time to first response from a virtual agent."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.time_to_first_response_virtual_agent ;;
  }

  dimension: time_to_first_response_hum_from_bot {
    label: "TTFR (Human From Bot)"
    group_label: "Time Metrics"
    description: "Time to first response by human from Bot."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.time_to_first_response_hum_from_bot ;;
  }

  dimension: time_to_assignment_human {
    label: "TTA (Human)"
    group_label: "Time Metrics"
    description: "Time to human assignment."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.time_to_assignment_human ;;
  }

  dimension: time_to_first_human_response {
    label: "TTFR (Human)"
    group_label: "Time Metrics"
    description: "Time to first response from a human agent."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.time_to_first_human_response ;;
  }

  dimension: time_to_first_human_response_from_assignment {
    label: "TTFRA (Human)"
    group_label: "Time Metrics"
    description: "Time to first response from human agent after assignment."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.time_to_first_human_response_from_assignment ;;
  }

  dimension: in_sla_flag {
    label: "In SLA"
    group_label: "Conversation Metrics"
    description: "Flags conversations answered within SLA."
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.in_sla_flag ;;
  }

  dimension: agent_segments {
    label: "Agent Segment Count"
    group_label: "Conversation Metrics"
    description: "Number of agents involved in conversation."
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.agent_segments ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## CONVERSATION MEASURES

  measure: time_to_first_response_virtual_agent_avg {
    label: "AVG TTFR (Bot)"
    group_label: "Time Measures"
    description: "Average time to first response from a virtual agent."
    type: average
    value_format_name: decimal_2
    sql: ${time_to_first_response_virtual_agent} ;;
  }

  measure: time_to_first_response_hum_from_bot_avg {
    label: "AVG TTFR (Human From Bot)"
    group_label: "Time Measures"
    description: "Average time to first response by human from Bot."
    type: average
    value_format_name: decimal_2
    sql: ${time_to_first_response_hum_from_bot} ;;
  }

  measure: time_to_assignment_human_avg {
    label: "AVG TTA (Human)"
    group_label: "Time Measures"
    description: "Average time to first human assignment."
    type: average
    value_format_name: decimal_2
    sql: ${time_to_assignment_human} ;;
  }

  measure: time_to_first_human_response_avg {
    label: "AVG TTFR (Human)"
    group_label: "Time Measures"
    description: "Average time to first response from a human agent."
    type: average
    value_format_name: decimal_2
    sql: ${time_to_first_human_response} ;;
  }

  measure: time_to_first_human_response_from_assignment_avg {
    label: "AVG TTFRA (Human)"
    group_label: "Time Measures"
    description: "Average time to first response from human agent after assignment."
    type: average
    value_format_name: decimal_2
    sql: ${time_to_first_human_response_from_assignment}*60 ;;
  }

  measure: in_sla_count {
    label: "In SLA"
    group_label: "Conversation Measures"
    description: "Count of conversations answered within 5 minute SLA."
    type: sum
    value_format_name: decimal_0
    sql: ${in_sla_flag} ;;
  }

  measure: out_sla_count {
    label: "Out SLA"
    group_label: "Conversation Measures"
    description: "Count of conversations not answered within 5 minute SLA."
    type: sum
    value_format_name: decimal_0
    sql: case when ${in_sla_flag} = 1 then 0
      else 1 end ;;
  }

  measure: sla_count {
    label: "SLA Count"
    group_label: "Conversation Measures"
    description: "Count of conversations that count toward 5 minute SLA."
    type: count_distinct
    value_format_name: decimal_0
    sql: case when ${time_to_first_human_response} > 0 then ${conversation_id}
      else null end ;;
  }

  measure: in_sla_pct {
    label: "In SLA PCT"
    group_label: "Conversation Measures"
    description: "Percent of conversations answered within 5 minute SLA."
    type: number
    value_format_name: decimal_0
    sql: sum(${in_sla_flag}
        / case when ${time_to_first_human_response} > 0 then ${conversation_id}
          else null end ;;
  }

  measure: agent_segments_count {
    label: "AVG Agent Segment Count (Human)"
    group_label: "Conversation Measures"
    description: "Average number of human agents involved in conversation."
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}.agent_segments ;;
  }



  }
