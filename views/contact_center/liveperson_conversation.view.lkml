view: liveperson_conversation {
  sql_table_name: "LIVEPERSON"."CONVERSATION"
    ;;
  drill_fields: [conversation_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: alerted_mcs {
    type: number
    sql: ${TABLE}."ALERTED_MCS" ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}."BROWSER" ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: duration_seconds {
    type: number
    sql: ${TABLE}."DURATION_SECONDS" ;;
  }

  dimension: engagementsource {
    type: string
    sql: ${TABLE}."ENGAGEMENTSOURCE" ;;
  }

  dimension: first_conversation {
    type: yesno
    sql: ${TABLE}."FIRST_CONVERSATION" ;;
  }

  dimension: full_dialog_status {
    type: string
    sql: ${TABLE}."FULL_DIALOG_STATUS" ;;
  }

  dimension: last_queue_state {
    type: string
    sql: ${TABLE}."LAST_QUEUE_STATE" ;;
  }

  dimension: mcs {
    type: number
    sql: ${TABLE}."MCS" ;;
  }

  dimension: partial {
    type: yesno
    sql: ${TABLE}."PARTIAL" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: ended {
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
    sql: CAST(${TABLE}."ENDED" AS TIMESTAMP_NTZ) ;;
  }

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

  dimension_group: started {
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
    sql: CAST(${TABLE}."STARTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: conversation_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: campaign_engagement_id {
    type: number
    sql: ${TABLE}."CAMPAIGN_ENGAGEMENT_ID" ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: goal_id {
    type: number
    sql: ${TABLE}."GOAL_ID" ;;
  }

  dimension: interaction_context_id {
    type: number
    sql: ${TABLE}."INTERACTION_CONTEXT_ID" ;;
  }

  dimension: last_agent_group_id {
    type: number
    sql: ${TABLE}."LAST_AGENT_GROUP_ID" ;;
  }

  dimension: last_agent_id {
    type: number
    sql: ${TABLE}."LAST_AGENT_ID" ;;
  }

  dimension: last_skill_id {
    type: number
    sql: ${TABLE}."LAST_SKILL_ID" ;;
  }

  dimension: lob_id {
    type: number
    sql: ${TABLE}."LOB_ID" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: visitor_behavior_id {
    type: number
    sql: ${TABLE}."VISITOR_BEHAVIOR_ID" ;;
  }

  dimension: visitor_id {
    type: string
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: visitor_profile_id {
    type: number
    sql: ${TABLE}."VISITOR_PROFILE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [conversation_id, conversation_message.count]
  }
}
