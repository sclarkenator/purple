view: agent_state {
  sql_table_name: "CUSTOMER_CARE"."AGENT_STATE"
    ;;

  dimension: PK {
    label: "ID"
    description: "Primary key ID. [login_session_id] & 3 digit version of [Session State Index]"
    group_label: "* IDs"
    primary_key: yes
    # hidden: yes
    # sql: login_session_id || '-' || session_state_index  ;;
    sql: login_session_id || right(concat( '00', session_state_index), 3) ;;
  }

  #####################################################################
  #####################################################################
  ## GENERAL DIMENSIONS

  dimension: state_name {
    label: "State Name"
    description: "Name of state agent was logged into."
    type: string
    sql: ${TABLE}."STATE_NAME" ;;
  }

  dimension: unavailable_code_name {
    label: "Unavailable Code Name"
    description: "The name of the custom or system generated Unavailable Code as defined in inContact."
    type: string
    sql: ${TABLE}."UNAVAILABLE_CODE_NAME" ;;
  }

  dimension: session_state_index {
    label: "Session State Index"
    description: "Cardinal order of states for the Agent. A step-by-step accounting of the different states that the Agent was in throughout their shift. The numbers have no significance. They start with 1 and go to as many as the number of different states the Agent was in for that period. The period ends when the Agent logs out. The numbers restart from 1 again when the Agent logs back in, even if this occurs within the same workday."
    type: number
    value_format_name: id
    sql: ${TABLE}."SESSION_STATE_INDEX" ;;
  }

  #####################################################################
  #####################################################################
  ## NON-KEY ID DIMENSIONS

  dimension: agent_id {
    label: "Agent ID"
    group_label: "* IDs"
    description: "Agent ID is based on InContact ID."
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: login_session_id {
    label: "Login Session ID"
    group_label: "* IDs"
    description: "The session ID created when the agent logs in, and ends when they log out.  There may be multiple sessions for the same agent in the same workday. "
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}."LOGIN_SESSION_ID" ;;
  }

  dimension: state_id {
    label: "State ID"
    group_label: "* IDs"
    description: "Numeric identifier for the Agent State."
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}."STATE_ID" ;;
  }

  dimension: unavailable_code_id {
    label: "Unavailable Code ID"
    group_label: "* IDs"
    description: "Unavailable State reason code."
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}."UNAVAILABLE_CODE_ID" ;;
  }

  #####################################################################
  #####################################################################
  ## DATE DIMENSION GROUPS

  dimension_group: insert_ts {
    label: "* Insert"
    description: "Date record was originally inserted."
    type: time
    hidden: yes
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

  dimension_group: state_start_ts_utc {
    label: "* State Begin UTC"
    description: "Date/time agent state began in UTC."
    hidden: yes
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
    sql: CAST(${TABLE}."STATE_START_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: state_start_ts_mst {
    label: "* State Begin"
    description: "Date/time agent state began in Mountain Time."
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
    sql: CAST(${TABLE}."STATE_START_TS_MST" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "* Update"
    description: "Date record was last updated."
    type: time
    hidden: yes
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

  #####################################################################
  #####################################################################
  ## OTHER MEASURES

  measure: count {
    type: count
    group_label: "Other Measures"
    # hidden: yes
    drill_fields: [state_name, unavailable_code_name]
  }

  measure: working_rate {
    label: "Working Rate"
    group_label: "Other Measures"
    description: "(Total Phone Time - Break - Lunch - Personal) / Total Phone Time"
    type: number
    value_format_name: decimal_2
    sql: ((sum(${TABLE}.duration)
      - sum(case when ${TABLE}.unavailable_code_name in ('Break', 'Lunch', 'Personal') then ${TABLE}."STATE_DURATION" end)
      /sum(${TABLE}.duration))/60 ;;
  }

  #####################################################################
  #####################################################################
  ## SUM MEASURES

  measure: available_duration_sum_min{
    label: "Available Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a state flags as Available."
    type: number
    value_format_name: decimal_2
    sql: sum(
      case when ${TABLE}.state_name = 'Available' then ${TABLE}."STATE_DURATION"/60
        end) ;;
  }

  measure: available_duration_sum_sec{
    label: "Available Time Sec"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a state flags as Available."
    # hidden: yes
    type: number
    value_format_name: decimal_0
    sql: sum(
      case when ${TABLE}.state_name = 'Available' then ${TABLE}."STATE_DURATION"
        end) ;;
  }

  measure: break_sum_min {
    label: "Break Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a Break state."
    type: number
    value_format_name: decimal_2
    sql: sum(case when ${TABLE}.unavailable_code_name = 'Break' then ${TABLE}."STATE_DURATION" end)/60 ;;
  }

  measure: lunch_sum_min {
    label: "Lunch Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a Lunch state."
    type: number
    value_format_name: decimal_2
    sql: sum(case when ${TABLE}.unavailable_code_name = 'Lunch' then ${TABLE}."STATE_DURATION" end)/60 ;;
  }

  measure: personal_sum_min {
    label: "Personal Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a Personal state."
    type: number
    value_format_name: decimal_2
    sql: sum(case when ${TABLE}.unavailable_code_name = 'Personal' then ${TABLE}."STATE_DURATION" end)/60 ;;
  }

  measure: state_duration_sum_sec {
    label: "State Duration Sec"
    group_label: "Sum Measures"
    description: "Duration in seconds agent was in a given state."
    type: sum
    sql: ${TABLE}."STATE_DURATION" ;;
  }

  measure: state_duration_sum_min{
    label: "State Duration Min"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a given state."
    type: number
    value_format_name: decimal_2
    sql: sum(${TABLE}."STATE_DURATION")/60 ;;
  }

  measure: unavailable_duration_sum_min{
    label: "Unavailable Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a state flags as Unavailable."
    type: number
    value_format_name: decimal_2
    sql: sum(
      case when ${TABLE}.state_name = 'Unavailable' then ${TABLE}."STATE_DURATION"
        when ${TABLE}.state_name = 'OutboundPending' then ${TABLE}."STATE_DURATION"
        end) / 60 ;;
  }

  measure: unavailable_duration_sum_sec{
    label: "Unavailable Time Sec"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a state flags as Unavailable."
    # hidden: yes
    type: number
    value_format_name: decimal_0
    sql: sum(
      case when ${TABLE}.state_name = 'Unavailable' then ${TABLE}."STATE_DURATION"
        when ${TABLE}.state_name = 'OutboundPending' then ${TABLE}."STATE_DURATION"
        end) ;;
  }
}
