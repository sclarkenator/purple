view: liveperson_agent {
  sql_table_name: "LIVEPERSON"."AGENT"
    ;;
  drill_fields: [agent_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: api_user {
    type: yesno
    sql: ${TABLE}."API_USER" ;;
  }

  dimension: deleted {
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: disabled_manually {
    type: yesno
    sql: ${TABLE}."DISABLED_MANUALLY" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: enabled {
    type: yesno
    sql: ${TABLE}."ENABLED" ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}."FULL_NAME" ;;
  }

  dimension: login_name {
    type: string
    sql: ${TABLE}."LOGIN_NAME" ;;
  }

  dimension: manager_of {
    type: string
    sql: ${TABLE}."MANAGER_OF" ;;
  }

  dimension: max_async_chats {
    type: number
    sql: ${TABLE}."MAX_ASYNC_CHATS" ;;
  }

  dimension: max_chats {
    type: number
    sql: ${TABLE}."MAX_CHATS" ;;
  }

  dimension: member_of {
    type: string
    sql: ${TABLE}."MEMBER_OF" ;;
  }

  dimension: must_change_password {
    type: yesno
    sql: ${TABLE}."MUST_CHANGE_PASSWORD" ;;
  }

  dimension: nickname {
    type: string
    sql: ${TABLE}."NICKNAME" ;;
  }

  dimension: permission_groups {
    type: string
    sql: ${TABLE}."PERMISSION_GROUPS" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## Date Fields

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

  dimension_group: last_password_change {
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
    sql: CAST(${TABLE}."LAST_PASSWORD_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
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

  dimension: agent_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: pid {
    type: string
    sql: ${TABLE}."PID" ;;
  }

  dimension: profile_ids {
    type: string
    sql: ${TABLE}."PROFILE_IDS" ;;
  }

  dimension: skill_ids {
    type: string
    sql: ${TABLE}."SKILL_IDS" ;;
  }

  dimension: user_type_id {
    type: number
    sql: ${TABLE}."USER_TYPE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [agent_id, login_name, full_name, nickname]
  }
}
