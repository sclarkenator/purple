view: liveperson_agent {
  sql_table_name: "LIVEPERSON"."AGENT"
    ;;
  drill_fields: [agent_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: api_user {
    label: "API User"
    type: yesno
    sql: ${TABLE}."API_USER" ;;
  }

  dimension: deleted {
    label: "Deleted"
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: disabled_manually {
    label: "Disabled Manually"
    type: yesno
    sql: ${TABLE}."DISABLED_MANUALLY" ;;
  }

  dimension: email {
    label: "Email"
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: enabled {
    label: "Enabled"
    type: yesno
    sql: ${TABLE}."ENABLED" ;;
  }

  dimension: full_name {
    label: "Ful Name"
    type: string
    sql: ${TABLE}."FULL_NAME" ;;
  }

  dimension: login_name {
    label: "Login Name"
    type: string
    sql: ${TABLE}."LOGIN_NAME" ;;
  }

  dimension: manager_of {
    label: "Manager Of"
    type: string
    sql: ${TABLE}."MANAGER_OF" ;;
  }

  dimension: max_async_chats {
    label: "Max Conversations"
    description: "Max number of open MESSAGING conversations a user can take."
    type: number
    sql: ${TABLE}."MAX_ASYNC_CHATS" ;;
  }

  dimension: max_chats {
    description: "Max number of CHAT conversations a user can take."
    type: number
    hidden: yes
    sql: ${TABLE}."MAX_CHATS" ;;
  }

  dimension: member_of {
    label: "Member Of"
    type: string
    sql: ${TABLE}."MEMBER_OF" ;;
  }

  dimension: must_change_password {
    label: "Must Change Password"
    type: yesno
    sql: ${TABLE}."MUST_CHANGE_PASSWORD" ;;
  }

  dimension: nickname {
    label: "Nickname"
    type: string
    sql: ${TABLE}."NICKNAME" ;;
  }

  dimension: permission_groups {
    label: "Permission Groups"
    type: string
    sql: ${TABLE}."PERMISSION_GROUPS" ;;
  }

  # dimension: team_group {
  #   sql:  ;;
  # }

  ##########################################################################################
  ##########################################################################################
  ## Date Fields

  dimension_group: insert_ts {
    label: "* Updated"
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
    label: "Last Password Change"
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
    label: "* Modified"
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
    label: "* Updated"
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
    label: "LivePerson ID"
    group_label: "* IDs"
    primary_key: yes
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: employee_id {
    label: "InContact ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: pid {
    group_label: "* IDs"
    type: string
    sql: ${TABLE}."PID" ;;
  }

  dimension: profile_ids {
    group_label: "* IDs"
    type: string
    sql: ${TABLE}."PROFILE_IDS" ;;
  }

  dimension: skill_ids {
    group_label: "* IDs"
    type: string
    sql: ${TABLE}."SKILL_IDS" ;;
  }

  dimension: user_type_id {
    group_label: "* IDs"
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
