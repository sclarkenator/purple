## REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html
view: liveperson_message {

  # sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"  ;;
  derived_table: {
    sql:
      with CMRows as (
        select *
            -- ,right(message_id, len(message_id) - position('msg:', message_id)-3)::int as seq
            ,ROW_NUMBER() OVER (ORDER BY conversation_id
                , right(message_id, len(message_id) - position('msg:', message_id)-3)::int) AS rn
        from liveperson.conversation_message c
        )

      select
          case when a.full_name ilike '%-bot' then 'Bot'
              when a.full_name ilike '%virtual assistant' then 'Virtual Assistant'
              else cm1.sent_by end as Sender
          ,a.full_name as agent_name
          ,case when not(a.full_name ilike '%-bot' or a.full_name ilike '%virtual assistant') then cm1.participant_id end as liveperson_id
          ,cm1.*
          ,datediff(second, case when cm1.conversation_id = cm2.conversation_id then cm2.created end, cm1.created) as response_time
          ,case when f.min_seq is not null then TRUE end as agent_first

      from CMRows cm1

          left join CMRows cm2
              on cm1.rn = cm2.rn +1

          left join liveperson.agent a
              on cm1.sent_by = 'Agent'
              and cm1.participant_id = a.agent_id::text

          left join (
              select conversation_id
                  ,min(seq) as min_seq
              from CMRows cm1
                  left join liveperson.agent a
                      on cm1.sent_by = 'Agent'
                      and cm1.participant_id = a.agent_id::text
                      and a.full_name not ilike '%-bot'
                      and a.full_name not ilike '%virtual assistant'
              group by conversation_id
          ) f
          on cm1.conversation_id = f.conversation_id
          and cm1.seq = f.min_seq

      order by cm1.rn
      ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: agent_name {
    label: "Agent Name"
    group_label: "Agent Data (Message)"
    description: "Name of agent sending message."
    type: string
    sql: ${TABLE}.agent_name ;;
    # hidden: yes
  }

  dimension: audience {
    label: "Audience"
    # group_label: "* Message Details"
    description: "Who can receive the message. Valid values: 'ALL', 'AGENTS_AND_MANAGERS'"
    type: string
    hidden: yes  # Hidden because there is currently only one value showing in this field
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: context_data {
    label: "Context Data"
    # group_label: "* Message Details"
    description: "Contains context information about the consumer's message, including raw and structured metadata."
    type: string
    hidden: yes
    sql: ${TABLE}."CONTEXT_DATA" ;;
  }

  dimension: device {
    label: "Message Device"
    description: "Type of device used to send consumer message.  (MOBILE / DESKTOP / TABLET)"
  }

  dimension: message {
    label: "Message"
    # group_label: "* Message Details"
    description: "Message value."
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: response_time {
    label: "Response Time"
    description: "Response time in seconds."
    # group_label: "* Message Details"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.response_time ;;
  }

  dimension: sender {
    label: "Sender Type"
    # group_label: "* Message Details"
    description: "Who sent the message. Valid values: 'Agent', 'Consumer', 'Bot', 'Virtual Assistant'."
    type: string
    sql: ${TABLE}.sender ;;
  }

  dimension: seq {
    label: "Sequence Number"
    # group_label: "* Message Details"
    description: "Message's sequence in the conversation.  Does not have to be continuous, i.e. 0, 2, 5, etc."
    type: number
    # hidden: yes
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    label: "Message Type"
    # group_label: "* Message Details"
    description: "The message data type, i.e. TEXT_PLAIN, TEXT_HTML, LINK, etc."
    type: string
    hidden: yes  # Hidden because there is currently only one value in this field
    sql: ${TABLE}."TYPE" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: created_ts {
    label: "- Message Created"
    description: "TS when message was created in MT."
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
    # hidden: yes
    sql: CAST(${TABLE}.created AS TIMESTAMP_NTZ) ;;
  }

  dimension: minute_30_only {
    type: string
    group_label: "- Message Created Date"
    sql: right(${created_ts_minute30},5) ;;
  }

  dimension_group: insert_ts {
    label: "- Message Inserted"
    description: "TS when message record was inserted in database in MT."
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: conversation_id {
    label: "Conversation ID"
    group_label: "* IDs"
    type: string
    # hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    group_label: "* IDs"
    description: "Agent's InContact ID."
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.employee_id ;;
  }

  dimension: liveperson_id {
    label: "LivePerson ID"
    group_label: "* IDs"
    description: "Agent's LivePerson ID."
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.liveperson_id ;;
  }

  dimension: message_id {
    label: "Message ID"
    description: "Combined Conversation ID and Seq #"
    # group_label: "* IDs"
    primary_key: yes
    type: string
    # hidden: yes
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: participant_id {
    label: "Participant ID"
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."PARTICIPANT_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## HUMAN AGENT MEASURES

  measure: active_human_agent_count {
    label: "Active Agent Count"
    description: "Count of human agents that were active in a given period."
    group_label: "* Human Agent Measures"
    type: count_distinct
    sql: case when sent_by = 'Consumer' then ${participant_id} end ;;
  }

  measure: message_human_agent_count {
    label: "Message Count - Agents"
    description: "Count of messages sent by a human agent."
    group_label: "* Human Agent Measures"
    type: count_distinct
    sql: case when ${sender} = 'Agent' then ${message_id} end ;;
  }

  measure: response_time_human_agent_avg {
    label: "Response Time Avg - Agents"
    description: "Average response time in seconds for human agent."
    group_label: "* Human Agent Measures"
    type: string
    sql: concat(0 + floor(avg(case when ${sender} = 'Agent' then ${response_time} end)/60), ':'
      , right(concat('0', floor(mod(avg(case when ${sender} = 'Agent' then ${response_time} end), 60))), 2)) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## PURPLE MEASURES - Includes humans, bots, and virtual assistants

  measure: message_all_agent_count {
    label: "Message Count - Purple"
    description: "Count of messages sent by a human, bot, and virtual assistant agent."
    group_label: "* All Agent Measures"
    type: count_distinct
    # sql: case when ${sender} in ('Agent', 'Bot', 'Virtual Assistant') then ${message_id} end ;;
    sql: case when ${sender} in ('Agent', 'Bot', 'Virtual Assistant') then ${message_id} end ;;
  }

  measure: response_time_all_agent_avg {
    label: "Response Time Avg - Purple"
    description: "Average response time in secondsfor human, bot, and virtual assistant agents."
    group_label: "* All Agent Measures"
    type: string
    sql: concat(0 + floor(avg(case when in ('Agent', 'Bot', 'Virtual Assistant') then ${response_time} end)/60), ':'
      , right(concat('0', floor(mod(avg(case when ${sender}in ('Agent', 'Bot', 'Virtual Assistant')  then ${response_time} end), 60))), 2)) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## BOT MEASURES

  measure: message_count_bot {
    label: "Message Count - Bots"
    description: "Count of messages sent by a bot."
    group_label: "* Bot Measures"
    type: count_distinct
    sql: case when ${sender} = 'Bot' then ${message_id} end ;;
  }

  measure: bot_response_time_avg {
    label: "Response Time Avg - Bots"
    group_label: "* Bot Measures"
    description: "Average bot response time in seconds."
    type: average
    value_format_name: decimal_2
    sql: case when ${sender} = 'Bot' then ${response_time}/60 end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## CONSUMER MEASURES

  measure: active_consumers_count {
    alias: [consumers_active]
    label: "Active Consumer Count"
    group_label: "* Consumer Measures"
    type: count_distinct
    sql: case when sent_by = 'Consumer' then ${participant_id} end ;;
  }

  measure: message_count_consumer {
    label: "Message Count - Consumers"
    description: "Count of messages sent by a consumer."
    group_label: "* Consumer Measures"
    type: count_distinct
    sql: case when ${sender} = 'Consumer' then ${message_id} end ;;
  }

  measure: consumer_response_time_avg {
    label: "Response Time Avg - Consumers"
    description: "Average response time in seconds."
    group_label: "* Consumer Measures"
    type: average
    value_format_name: decimal_2
    sql: case when ${sender} = 'Consumer' then ${response_time}/60 end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## VIRTUAL ASSISTANT MEASURES

  measure: message_count_virtual_assistant {
    label: "Message Count - Virtual Assistants"
    description: "Count of messages sent by a virtual agent."
    group_label: "* Virtual Assistant Measures"
    type: count_distinct
    sql: case when ${sender} = 'Virtual Assistant' then ${message_id} end ;;
  }

  measure: response_time_virtual_assistant_avg {
    label: "Response Time Avg - Virtual Assistants"
    description: "Average bot response time in seconds."
    group_label: "* Virtual Assistant Measures"
    type: average
    value_format_name: decimal_2
    sql: case when ${sender} = 'Bot' then ${response_time}/60 end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DEVICE MEASURES

  measure: device_desktop_count {
    label: "Message Count Desktop"
    description: "Count of consumer messages from a Desktop computer."
    group_label: "* Device Measures"
    type: count_distinct
    sql: case when ${device}  = 'DESKTOP' then ${message_id} end ;;
  }

  measure: device_tablet_count {
    label: "Message Count Tablet"
    description: "Count of consumer messages from a Tablet device."
    group_label: "* Device Measures"
    type: count_distinct
    sql: case when ${device}  = 'TABLET' then ${message_id} end ;;
  }

  measure: device_mobile_count {
    label: "Message Count Mobile"
    description: "Count of consumer messages from a Mobile (phone) device."
    group_label: "* Device Measures"
    type: count_distinct
    sql: case when ${device}  = 'MOBILE' then ${message_id} end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL MEASURES

  measure: conversation_count {
    label: "Active Conversation Count"
    type: count_distinct
    sql: ${conversation_id} ;;
    hidden: yes
  }

                                                          # dimension: duration_days {
                                                          #   type: number
                                                          #   sql: ${response_time} / 86400 ;;
                                                          # }

  measure: message_count {
    label: "Message Count"
    type: count_distinct
    sql: ${message_id} ;;
  }

                                                          # measure: message_percentage {
                                                          #   label: "Message Percentage"
                                                          #   type: percent_of_total
                                                          #   value_format: "##0.0"
                                                          #   sql: count(distinct ${message_id}) ;;
                                                          # }

  measure: response_time_avg {
    label: "Avg Response Time"
    description: "Average response time in seconds."
    type: number
    value_format_name: decimal_2
    sql: average(${response_time})/60 ;;
  }
}
