view: liveperson_conversation_message {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html

  sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"
    ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: audience {
    label: "Audience"
    description: "Who can receive the message. Valid values: 'ALL', 'AGENTS_AND_MANAGERS'"
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: context_data {
    label: "Context Data"
    description: "Contains context information about the consumer's message, including raw and structured metadata."
    type: string
    hidden: yes
    sql: ${TABLE}."CONTEXT_DATA" ;;
  }

  dimension: device {
    label: "Device"
    description: "Device the message was sent from.  Depreciated (not supported)"
    type: string
    hidden: yes
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: message {
    label: "Message"
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: sent_by {
    label: "Sent By"
    description: "Who sent the message. Valid values: 'agent', 'consumer'"
    type: string
    sql: ${TABLE}."SENT_BY" ;;
  }

  dimension: seq {
    label: "Seq"
    description: "Message's sequence in the conversation.  Does not have to be continuous, i.e. 0, 2, 5, etc."
    type: number
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    label: "Type"
    description: "The message data type, i.e. TEXT_PLAIN, TEXT_HTML, LINK, etc."
    type: string
    hidden: yes
    sql: ${TABLE}."TYPE" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

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

  dimension: message_id {
    label: "Message ID"
    group_label: "* IDs"
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

  measure: count {
    type: count
    drill_fields: [conversation.conversation_id]
  }
}
