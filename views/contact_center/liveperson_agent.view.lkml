view: liveperson_agent {
  # REFERENCE PAGE: https://developers.liveperson.com/administration-users-appendix.html

  sql_table_name: "LIVEPERSON"."AGENT"
    ;;
  drill_fields: [agent_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: api_user {
    label: "API User"
    description: "A User which is created as an API User doesn't have a password."
    type: yesno
    hidden: yes
    sql: ${TABLE}."API_USER" ;;
  }

  dimension: deleted {
    label: "Deleted"
    description: "Indicates whether or not the item is deleted."
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: disabled_manually {
    label: "Disabled Manually"
    description: "Indicates whether or not the user was disabled by an administrator."
    type: yesno
    sql: ${TABLE}."DISABLED_MANUALLY" ;;
  }

  dimension: email {
    label: "Email"
    description: "The user's email address."
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: enabled {
    label: "Enabled"
    description: "Indicates whether the agent's account is active/enabled."
    type: yesno
    sql: ${TABLE}."ENABLED" ;;
  }

  dimension: full_name { # obtain this info from agent_data view
    label: "Full Name"
    description: "User's full name."
    type: string
    hidden: yes
    sql: ${TABLE}."FULL_NAME" ;;
  }

  dimension: login_name {
    label: "Login Name"
    description: "A user's unique login name."
    type: string
    sql: ${TABLE}."LOGIN_NAME" ;;
  }

  dimension: manager_of {
    label: "Manager Of"
    description: "The user’s agent groups as a manager. Only an agent manager can manage agent groups."
    type: string
    sql: ${TABLE}."MANAGER_OF" ;;
  }

  dimension: max_async_chats {
    label: "Max Conversations"
    description: "Max number of open MESSAGING conversations a user can take."
    type: number
    sql: ${TABLE}."MAX_ASYNC_CHATS" ;;
  }

  dimension: max_chats { # We do not use LivePerson Chat functionality at this time.
    label: "Max Chats"
    description: "Max number of CHAT conversations a user can take."
    type: number
    hidden: yes
    sql: ${TABLE}."MAX_CHATS" ;;
  }

  dimension: member_of {
    label: "Member Of"
    description: "The agent group that the agent is a member of."
    type: string
    sql: ${TABLE}."MEMBER_OF" ;;
  }

  dimension: must_change_password {
    label: "Must Change Password"
    description: "Flag that forces user to change password on next login."
    type: yesno
    hidden: yes
    sql: ${TABLE}."MUST_CHANGE_PASSWORD" ;;
  }

  dimension: nickname {
    label: "Nickname"
    description: "A user’s nickname."
    type: string
    sql: ${TABLE}."NICKNAME" ;;
  }

  dimension: permission_groups {
    label: "Permission Groups"
    description: "The user’s permission groups."
    type: string
    sql: ${TABLE}."PERMISSION_GROUPS" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## Date Fields

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
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_password_change {
    label: "* Last Password Change"
    description: "Date when password was last changed."
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
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: employee_id {
    label: "InContact ID"
    group_label: "* IDs"
    type: number
    hidden: yes
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: pid {
    label: "Process ID"
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."PID" ;;
  }

  dimension: profile_ids {
    label: "Profile ID"
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."PROFILE_IDS" ;;
  }

  dimension: skill_ids {
    label: "Skill ID"
    group_label: "* IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."SKILL_IDS" ;;
  }

  dimension: user_type_id {
    label: "User Type ID"
    group_label: "* IDs"
    type: number
    hidden: yes
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
