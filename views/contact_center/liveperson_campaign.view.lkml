# The name of this view in Looker is "Campaign"
view: liveperson_campaign {

  sql_table_name: "LIVEPERSON"."CAMPAIGN"
    ;;
  drill_fields: [campaign_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: behavior_system_default {
    type: yesno
    sql: ${TABLE}."BEHAVIOR_SYSTEM_DEFAULT" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension: engagement_name {
    type: string
    sql: ${TABLE}."ENGAGEMENT_NAME" ;;
  }

  dimension: engagement_type {
    type: string
    sql: case when ${campaign_name} ilike '%proactive%' then 'Proactive' else 'Passive' end ;;
  }

  dimension: goal_name {
    type: string
    sql: ${TABLE}."GOAL_NAME" ;;
  }

  dimension: lob_name {
    type: string
    sql: ${TABLE}."LOB_NAME" ;;
  }

  dimension: location_name {
    type: string
    sql: ${TABLE}."LOCATION_NAME" ;;
  }

  dimension: profile_system_default {
    type: yesno
    sql: ${TABLE}."PROFILE_SYSTEM_DEFAULT" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: visitor_behavior_name {
    type: string
    sql: ${TABLE}."VISITOR_BEHAVIOR_NAME" ;;
  }

  dimension: visitor_profile_name {
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: campaign_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."CAMPAIGN_ID" ;;
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
    drill_fields: [detail*]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      campaign_id,
      goal_name,
      visitor_profile_name,
      visitor_behavior_name,
      engagement_name,
      lob_name,
      campaign_name,
      location_name
    ]
  }
}
