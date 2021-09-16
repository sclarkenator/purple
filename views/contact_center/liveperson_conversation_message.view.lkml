view: liveperson_conversation_message {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

  sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"
    ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: audience {
    label: "Audience"
    group_label: "* Message Details"
    description: "Who can receive the message. Valid values: 'ALL', 'AGENTS_AND_MANAGERS'"
    type: string
    # hidden: yes
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: context_data {
    label: "Context Data"
    group_label: "* Message Details"
    description: "Contains context information about the consumer's message, including raw and structured metadata."
    type: string
    hidden: yes
    sql: ${TABLE}."CONTEXT_DATA" ;;
  }

  dimension: device {
    label: "Device"
    group_label: "* Message Details"
    description: "Device the message was sent from.  Depreciated (not supported)"
    type: string
    # hidden: yes
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: message {
    label: "Message"
    group_label: "* Message Details"
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: sent_by {
    label: "Sent By"
    group_label: "* Message Details"
    description: "Who sent the message. Valid values: 'agent', 'consumer'"
    type: string
    sql: ${TABLE}."SENT_BY" ;;
  }

  dimension: seq {
    label: "Seq"
    group_label: "* Message Details"
    description: "Message's sequence in the conversation.  Does not have to be continuous, i.e. 0, 2, 5, etc."
    type: number
    hidden: yes
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    label: "Type"
    group_label: "* Message Details"
    description: "The message data type, i.e. TEXT_PLAIN, TEXT_HTML, LINK, etc."
    type: string
    hidden: yes
    sql: ${TABLE}."TYPE" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: insert_ts {
    label: "- Inserted"
    description: "TS when message record was inserted in database."
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

  dimension: message_id {
    label: "Message ID"
    description: "Combined Conversation ID and Seq #"
    group_label: "* IDs"
    primary_key: yes
    type: string
    # hidden: yes
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: participant_id {
    label: "Participant ID"
    group_label: "* IDs"
    type: string
    # hidden: yes
    sql: ${TABLE}."PARTICIPANT_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: message_count {
    label: "Message Count"
    type: count_distinct
    sql: ${message_id} ;;
  }

  measure: message_percentage {
    label: "Message Percentage"
    type: percent_of_total
    value_format: "##0.0"
    sql: count(distinct ${message_id}) ;;
  }
}
