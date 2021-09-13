view: liveperson_conversation_message {
  sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"
    ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: audience {
    label: "Audience"
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: context_data {
    label: "Context Data"
    type: string
    hidden: yes
    sql: ${TABLE}."CONTEXT_DATA" ;;
  }

  dimension: device {
    label: "Device"
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: message {
    label: "Message"
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: sent_by {
    label: "Sent By"
    type: string
    sql: ${TABLE}."SENT_BY" ;;
  }

  dimension: seq {
    label: "Seq"
    type: number
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    label: "Type"
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

  dimension: dialog_id {
    label: "Dialog ID"
    group_label: "* IDs"
    type: string
    sql: ${TABLE}."DIALOG_ID" ;;
  }

  dimension: conversation_id {
    label: "Conversation ID"
    group_label: "* IDs"
    type: string
    # hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: message_id {
    label: "Message ID"
    group_label: "* IDs"
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: participant_id {
    label: "Participant ID"
    group_label: "* IDs"
    type: string
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
