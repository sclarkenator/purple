## REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html
view: liveperson_campaign {

  sql_table_name: liveperson.campaign ;;
  # drill_fields: [campaign_id]

  set: campaign_default {
    fields: [
      campaign_name,
      engagement_name,
      engagement_type
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: behavior_system_default {
    label: "Behavior System Default"
    type: yesno
    sql: ${TABLE}."BEHAVIOR_SYSTEM_DEFAULT" ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension: engagement_name {
    label: "Engagement Name"
    type: string
    sql: ${TABLE}."ENGAGEMENT_NAME" ;;
  }

  dimension: engagement_type {
    label: "Engagement Type"
    type: string
    sql: case when ${campaign_name} ilike '%proactive%' then 'Proactive' else 'Passive' end ;;
  }

  dimension: goal_name {
    label: "Goal Name"
    type: string
    sql: ${TABLE}."GOAL_NAME" ;;
  }

  dimension: lob_name {
    label: "LOB Name"
    type: string
    sql: ${TABLE}."LOB_NAME" ;;
  }

  dimension: location_name {
    label: "Location Name"
    type: string
    sql: ${TABLE}."LOCATION_NAME" ;;
  }

  dimension: profile_system_default {
    label: "Profile System Default"
    type: yesno
    sql: ${TABLE}."PROFILE_SYSTEM_DEFAULT" ;;
  }

  dimension: source {
    label: "Source Name"
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: visitor_behavior_name {
    label: "Visitor Behavor"
    type: string
    sql: ${TABLE}."VISITOR_BEHAVIOR_NAME" ;;
  }

  dimension: visitor_profile_name {
    label: "Visitor Profile Name"
    type: string
    sql: ${TABLE}."VISITOR_PROFILE_NAME" ;;
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
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: conversation_id || campaign_id ;;
  }

  dimension: campaign_id {
    type: number
    hidden: yes
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: conversation_id {
    type: number
    hidden: yes
    sql: ${TABLE}.conversation_id ;;
  }

  dimension: engagement_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ENGAGEMENT_ID" ;;
  }

  dimension: goal_id {
    type: number
    hidden: yes
    sql: ${TABLE}."GOAL_ID" ;;
  }

  dimension: lob_id {
    type: number
    hidden: yes
    sql: ${TABLE}."LOB_ID" ;;
  }

  dimension: location_id {
    type: number
    hidden: yes
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: visitor_behavior_id {
    type: number
    hidden: yes
    sql: ${TABLE}."VISITOR_BEHAVIOR_ID" ;;
  }

  dimension: visitor_profile_id {
    type: number
    hidden: yes
    sql: ${TABLE}."VISITOR_PROFILE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: campaign_count {
    label: "Campaign Count"
    type: count
    # hidden: yes
  }
}
