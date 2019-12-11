view: custom_role {
  sql_table_name: analytics_stage.zendesk.custom_role ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: role_type {
    type: number
    sql: ${TABLE}."ROLE_TYPE" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: configuration_chat_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_CHAT_ACCESS" ;;
  }

  dimension: configuration_manage_business_rules {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MANAGE_BUSINESS_RULES" ;;
  }

  dimension: configuration_manage_dynamic_content {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MANAGE_DYNAMIC_CONTENT" ;;
  }

  dimension: configuration_manage_extensions_and_channels {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MANAGE_EXTENSIONS_AND_CHANNELS" ;;
  }

  dimension: configuration_manage_facebook {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MANAGE_FACEBOOK" ;;
  }

  dimension: configuration_organization_editing {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_ORGANIZATION_EDITING" ;;
  }

  dimension: configuration_organization_notes_editing {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_ORGANIZATION_NOTES_EDITING" ;;
  }

  dimension: configuration_ticket_deletion {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_DELETION" ;;
  }

  dimension: configuration_view_deleted_tickets {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_VIEW_DELETED_TICKETS" ;;
  }

  dimension: configuration_ticket_tag_editing {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_TAG_EDITING" ;;
  }

  dimension: configuration_twitter_search_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TWITTER_SEARCH_ACCESS" ;;
  }

  dimension: configuration_forum_access_restricted_content {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_FORUM_ACCESS_RESTRICTED_CONTENT" ;;
  }

  dimension: configuration_end_user_list_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_END_USER_LIST_ACCESS" ;;
  }

  dimension: configuration_ticket_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_ACCESS" ;;
  }

  dimension: configuration_ticket_comment_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_COMMENT_ACCESS" ;;
  }

  dimension: configuration_voice_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_VOICE_ACCESS" ;;
  }

  dimension: configuration_moderate_forums {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MODERATE_FORUMS" ;;
  }

  dimension: configuration_group_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_GROUP_ACCESS" ;;
  }

  dimension: configuration_light_agent {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_LIGHT_AGENT" ;;
  }

  dimension: configuration_end_user_profile_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_END_USER_PROFILE_ACCESS" ;;
  }

  dimension: configuration_forum_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_FORUM_ACCESS" ;;
  }

  dimension: configuration_macro_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_MACRO_ACCESS" ;;
  }

  dimension: configuration_report_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_REPORT_ACCESS" ;;
  }

  dimension: configuration_ticket_editing {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_EDITING" ;;
  }

  dimension: configuration_ticket_merge {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_TICKET_MERGE" ;;
  }

  dimension: configuration_view_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_VIEW_ACCESS" ;;
  }

  dimension: configuration_user_view_access {
    type: string
    hidden: yes
    sql: ${TABLE}."CONFIGURATION_USER_VIEW_ACCESS" ;;
  }

  dimension: _fivetran_deleted {
    type: string
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_DELETED" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  set: detail {
    fields: [
      id,
      name,
      description,
      role_type,
      created_at_time,
      updated_at_time
    ]
  }
}
