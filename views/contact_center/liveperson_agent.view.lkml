## REFERENCE PAGE: https://developers.liveperson.com/administration-users-appendix.html
view: liveperson_agent {

  label: "LivePerson Agent"
  sql_table_name: "LIVEPERSON"."AGENT"
    ;;
  drill_fields: [agent_id]

  set: default_liveperson_agent_linked {
    fields: [
      agent_name_cc_lp,
      team_lead_cc_lp,
      team_type_cc_lp,
      team_group_cc_lp,
      is_active_cc_lp,
      is_supervisor_cc_lp
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: agent_name {
    label: "Agent Name"
    # group_label: "* LivePerson Agent Data"
    description: "Agents First and Last name."
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: is_active_cc_lp {
    label: "Is Active"
    # group_label: "* LivePerson Agent Data"
    description: "Team Type name. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: yesno
    sql: nvl(case when ${agent_name} ilike '%bot' then 'Yes'
        when ${agent_name} ilike '%virtual%' then 'Yes' end
      , ${agent_data.is_active}) ;;
  }

  dimension: is_supervisor_cc_lp {
    label: "Is Supervisor"
    # group_label: "* LivePerson Agent Data"
    description: "Supervisor flag. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: yesno
    sql: nvl(case when ${agent_id} in (3263325330, 3566812330, 3293544230, 3511734130) then 'No'
        else null end
      , ${agent_data.is_supervisor}) ;;
  }

  dimension: agent_name_cc_lp {
    label: "Agent Name"
    # group_label: "* LivePerson Agent Data"
    description: "Agents First and Last name. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: string
    sql: nvl(${TABLE}.full_name, ${agent_data.agent_name}) ;;
  }

  dimension: team_lead_cc_lp {
    label: "Team Lead"
    # group_label: "* LivePerson Agent Data"
    description: "Team Lead name. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: string
    sql: nvl(case when ${agent_id} in (3263325330, 3566812330) then 'Bot'
        when ${agent_id} in (3293544230, 3511734130) then 'Virtual Assistant' end
      , ${agent_data.team_name}) ;;
  }

  dimension: team_type_cc_lp {
    label: "Team Type"
    # group_label: "* LivePerson Agent Data"
    description: "Team Type name. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: string
    sql: nvl(case when ${agent_id} in (3263325330, 3566812330, 3293544230, 3511734130) then 'Bot/VA' end
      , ${agent_data.team_type}) ;;
  }

  dimension: team_group_cc_lp {
    label: "Team Group"
    # group_label: "* LivePerson Agent Data"
    description: "Team Group including bot and virtual assistants. Uses LivePerson data if CC data is missing. Requires agent_data be linked in the explore, otherwise throws error."
    type: string
    sql: nvl(case when ${agent_id} in (3263325330, 3566812330, 3293544230, 3511734130) then 'Bot/VA' end
      , ${agent_data.team_group}) ;;
  }

  dimension: api_user {
    label: "API User"
    description: "A User which is created as an API User doesn't have a password."
    type: yesno
    hidden: yes
    sql: ${TABLE}."API_USER" ;;
  }

  dimension: deleted {
    label: "Deleted"
    group_label: "* LivePerson Agent Data"
    description: "Indicates whether or not the item is deleted."
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: disabled_manually {
    label: "Disabled Manually"
    group_label: "* LivePerson Agent Data"
    description: "Indicates whether or not the user was disabled by an administrator."
    type: yesno
    sql: ${TABLE}."DISABLED_MANUALLY" ;;
  }

  dimension: email {
    label: "Email"
    group_label: "* LivePerson Agent Data"
    description: "The user's email address."
    type: string
    hidden: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: enabled {
    label: "Enabled"
    group_label: "* LivePerson Agent Data"
    description: "Indicates whether the agent's account is active/enabled."
    type: yesno
    sql: ${TABLE}."ENABLED" ;;
  }

  dimension: full_name { # obtain this info from agent_data view
    label: "Full Name"
    group_label: "* LivePerson Agent Data"
    description: "User's full name."
    type: string
    hidden: yes
    sql: ${TABLE}."FULL_NAME" ;;
  }

  dimension: login_name {
    label: "Login Name"
    group_label: "* LivePerson Agent Data"
    description: "A user's unique login name."
    type: string
    hidden: yes
    sql: ${TABLE}."LOGIN_NAME" ;;
  }

  dimension: manager_of {
    label: "Manager Of"
    group_label: "* LivePerson Agent Data"
    description: "The user’s agent groups as a manager. Only an agent manager can manage agent groups."
    type: string
    hidden: yes
    sql: ${TABLE}."MANAGER_OF" ;;
  }

  dimension: max_async_chats {
    label: "Max Conversations"
    group_label: "* LivePerson Agent Data"
    description: "Max number of open MESSAGING conversations a user can take."
    type: number
    sql: ${TABLE}."MAX_ASYNC_CHATS" ;;
  }

  dimension: max_chats { # We do not use LivePerson Chat functionality at this time.
    label: "Max Chats"
    group_label: "* LivePerson Agent Data"
    description: "Max number of CHAT conversations a user can take."
    type: number
    hidden: yes
    sql: ${TABLE}."MAX_CHATS" ;;
  }

  dimension: member_of {
    label: "Member Of"
    group_label: "* LivePerson Agent Data"
    description: "The agent group that the agent is a member of."
    type: string
    hidden: yes
    sql: ${TABLE}."MEMBER_OF" ;;
  }

  dimension: must_change_password {
    label: "Must Change Password"
    group_label: "* LivePerson Agent Data"
    description: "Flag that forces user to change password on next login."
    type: yesno
    hidden: yes
    sql: ${TABLE}."MUST_CHANGE_PASSWORD" ;;
  }

  dimension: nickname {
    label: "Nickname"
    group_label: "* LivePerson Agent Data"
    description: "A user’s nickname."
    type: string
    hidden: yes
    sql: ${TABLE}."NICKNAME" ;;
  }

  dimension: permission_groups {
    label: "Permission Groups"
    group_label: "* LivePerson Agent Data"
    description: "The user’s permission groups."
    type: string
                                                                      hidden: yes
    sql: ${TABLE}."PERMISSION_GROUPS"::text ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## Date Fields

  dimension_group: insert_ts {
    label: "- Inserted"
    description: "TS when agent record was inserted in database."
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_password_change {
    label: "- LivePerson Last Password Change"
    # group_label: "* LivePerson Agent Data"
    description: "Date when password was last changed."
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_PASSWORD_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: modified {
    label: "- LivePerson Agent Modified"
    description: "TS when agent record was modified in LivePerson."
    # group_label: "* LivePerson Agent Data"
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "- Updated"
    description: "TS when agent record was updated in database."
    # group_label: "* LivePerson Agent Data"
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
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
    # hidden: yes
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: employee_id {
    label: "Zendesk ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: pid {
    label: "Process ID"
    group_label: "* LivePerson IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."PID" ;;
  }

  dimension: profile_id {
    label: "Profile ID"
    group_label: "* LivePerson IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."PROFILE_IDS" ;;
  }

  dimension: skill_id {
    label: "Skill ID"
    group_label: "* LivePerson IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."SKILL_IDS" ;;
  }

  dimension: user_type_id {
    label: "User Type ID"
    group_label: "* LivePerson IDs"
    type: number
    hidden: yes
    sql: ${TABLE}."USER_TYPE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: measure_count {
    type: count
    hidden: yes
    drill_fields: [agent_id, login_name, full_name, nickname]
  }
}
