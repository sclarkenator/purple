view: liveperson_message {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

  # sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"  ;;
  derived_table: {
    sql:
      with CMRows as (
        select *
            ,right(message_id, len(message_id) - position('msg:', message_id)-3)::int as seq
            ,ROW_NUMBER() OVER (ORDER BY conversation_id, right(message_id, len(message_id) - position('msg:', message_id)-3)::int) AS rn
        from liveperson.conversation_message c
        )

        select
            case when a.full_name ilike '%-bot' then 'Bot'
                when a.full_name ilike '%virtual assistant' then 'Virtual Assistant'
                else cm1.sent_by end as Sender
            ,a.full_name as agent_name
            ,cm1.*
            ,datediff(second, case when cm1.conversation_id = cm2.conversation_id then cm2.created end, cm1.created) as response_time
        from CMRows cm1
            left join CMRows cm2
                on cm1.rn = cm2.rn +1
            left join liveperson.agent a
                on cm1.sent_by = 'Agent'
                and cm1.participant_id = a.agent_id::varchar(50)
        order by cm1.conversation_id, cm1.seq
        ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: agent_name {
    label: "Agent Name"
    description: "Name of agent sending message."
    type: string
    sql: ${TABLE}.agent_name ;;
    hidden: yes
  }

  dimension: audience {
    label: "Audience"
    # group_label: "* Message Details"
    description: "Who can receive the message. Valid values: 'ALL', 'AGENTS_AND_MANAGERS'"
    type: string
    hidden: yes  # Hidden because there is currently only one value in this field
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
    label: "Device"
    # group_label: "* Message Details"
    description: "Device the message was sent from.  Depreciated (not supported)"
    type: string
    # hidden: yes
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: message {
    label: "Message"
    # group_label: "* Message Details"
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

  dimension: testing_only_rn {
    label: "RN (TESTING TOOL)"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.rn ;;
  }

  dimension: sender {
    label: "Sender Type"
    # group_label: "* Message Details"
    description: "Who sent the message. Valid values: 'Agent', 'Consumer', 'Bot', 'Virtual Assistant'."
    type: string
    sql: ${TABLE}.sender ;;
  }

  dimension: sent_by {
    label: "Sent By"
    # group_label: "* Message Details"
    description: "Who sent the message. Valid values: 'Agent', 'Consumer'"
    type: string
    hidden: yes # Replaced with sender dimension above.  Can be reenabled if needed.
    sql: ${TABLE}."SENT_BY" ;;
  }

  dimension: seq {
    label: "Seq"
    # group_label: "* Message Details"
    description: "Message's sequence in the conversation.  Does not have to be continuous, i.e. 0, 2, 5, etc."
    type: number
    # hidden: yes
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    label: "Type"
    # group_label: "* Message Details"
    description: "The message data type, i.e. TEXT_PLAIN, TEXT_HTML, LINK, etc."
    type: string
    hidden: yes
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
      # quarter,
      year
    ]
    # hidden: yes
    sql: CAST(${TABLE}.created AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    label: "- Message Inserted"
    description: "TS when message record was inserted in database in MT."
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

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: conversation_id {
    label: "Conversation ID"
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: employee_id {
    label: "InContact ID"
    group_label: "* IDs"
    description: "Agent's InContact ID."
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.employee_id ;;
  }

  dimension: message_id {
    label: "Message ID"
    description: "Combined Conversation ID and Seq #"
    group_label: "* IDs"
    primary_key: yes
    type: string
    hidden: yes
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
  ## MEASURES

  measure: consumers_active {
    label: "Active Consumers"
    # type: count
    type: count_distinct
    sql: ${participant_id} ;;
  }

  measure: message_count {
    label: "Message Count"
    type: count_distinct
    sql: ${message_id} ;;
  }

  measure: message_consumer_count {
    label: "Message Consumer Count"
    type: count_distinct
    sql: case when sent_by = 'Consumer' then ${message_id} end ;;
  }

  measure: message_agent_count {
    label: "Message Agent Count"
    type: count_distinct
    sql: case when sent_by = 'Agent' then ${message_id} end ;;
  }

  measure: message_percentage {
    label: "Message Percentage"
    type: percent_of_total
    value_format: "##0.0"
    sql: count(distinct ${message_id}) ;;
  }
                                                                            dimension: duration_days {
                                                                              type: number
                                                                              sql: ${response_time} / 86400 ;;
                                                                            }

                                                                            measure: response_time_avg_test {
                                                                              label: "Avg Response Time TEST"
                                                                              description: "Average response time in seconds."
                                                                              type: date_time
                                                                              # value_format_name: "HH:mm"
                                                                              sql: ${duration_days} ;;
                                                                            }
  measure: response_time_avg {
    label: "Avg Response Time"
    description: "Average response time in seconds."
    type: average
    value_format_name: decimal_2
    sql: ${response_time}/60 ;;
  }

  measure: agent_response_time_avg {
    label: "Avg Agent Response Time"
    description: "Average response time in seconds."
    type: average
    value_format_name: decimal_2
    sql: case when ${sender} = 'Agent' then ${response_time}/60 end ;;
  }

  measure: consumer_response_time_avg {
    label: "Avg Consumer Response Time"
    description: "Average response time in seconds."
    type: average
    value_format_name: decimal_2
    sql: case when ${sender} = 'Consumer' then ${response_time}/60 end ;;
  }
}
