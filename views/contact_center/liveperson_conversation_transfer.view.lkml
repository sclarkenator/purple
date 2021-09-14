view: liveperson_conversation_transfer {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html#:~:text=string-,Transfer%20info,-NAME
  sql_table_name: "LIVEPERSON"."CONVERSATION_TRANSFER"
    ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: reason {
    label: "Reason"
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: created {
    label: "* Created"
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

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

  dimension: assigned_agent_id {
    label: "Assigned Agent ID"
    group_label: "* ID"
    type: number
    sql: ${TABLE}."ASSIGNED_AGENT_ID" ;;
  }

  dimension: conversation_id {
    label: "Conversation ID"
    group_label: "* ID"
    type: string
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: dialog_id {
    label: "Dialog ID"
    group_label: "* ID"
    type: string
    sql: ${TABLE}."DIALOG_ID" ;;
  }

  dimension: source_agent_id {
    label: "Source Agent ID"
    group_label: "* ID"
    type: number
    sql: ${TABLE}."SOURCE_AGENT_ID" ;;
  }

  dimension: source_skill_id {
    label: "Source Skill ID"
    group_label: "* ID"
    type: number
    sql: ${TABLE}."SOURCE_SKILL_ID" ;;
  }

  dimension: target_skill_id {
    label: "Target Skill ID"
    group_label: "* ID"
    type: number
    sql: ${TABLE}."TARGET_SKILL_ID" ;;
  }

  dimension: transfered_by_id {
    label: "Transfered By ID"
    group_label: "* ID"
    type: number
    sql: ${TABLE}."TRANSFERED_BY_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: []
  }
}
