view: liveperson_conversation_message {
  sql_table_name: "LIVEPERSON"."CONVERSATION_MESSAGE"
    ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: audience {
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: context_data {
    type: string
    sql: ${TABLE}."CONTEXT_DATA" ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: sent_by {
    type: string
    sql: ${TABLE}."SENT_BY" ;;
  }

  dimension: seq {
    type: number
    sql: ${TABLE}."SEQ" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: insert_ts {
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
    type: string
    sql: ${TABLE}."DIALOG_ID" ;;
  }

  dimension: conversation_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: message_id {
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: participant_id {
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
