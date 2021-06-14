view: agent_state {
  sql_table_name: "CUSTOMER_CARE"."AGENT_STATE"
    ;;

  dimension: PK {
    label: "ID"
    description: "Primary key ID. [login_sessin_id] & 3 digit version of [Session State Index]"
    group_label: "* IDs"
    primary_key: yes
    # hidden: yes
    # sql: login_session_id || '-' || session_state_index  ;;
    sql: login_session_id || right(concat( '00', session_state_index), 3) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: state_name {
    label: "State Name"
    description: "Name of state agent was logged into."
    type: string
    sql: case when ${TABLE}."STATE_NAME" = 'InbountConsult' then 'InboundConsult'
      else ${TABLE}."STATE_NAME" end;;
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

  ##########################################################################################
  ##########################################################################################
  ## YesNo Flag Dimensions

  dimension: available{
    label: "Available"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'Available' then 1 else 0 end ;;
  }

  dimension: inbound_consult{
    label: "Inbound Consult"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'InboundConsult' then 1 else 0 end ;;
  }

  dimension: inbound_contact{
    label: "Inbound Contact"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'InboundContact' then 1 else 0 end ;;
  }

  dimension: loggedin{
    label: "Logged In"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'LoggedIn' then 1 else 0 end ;;
  }

  dimension: loggedout{
    label: "Logged Out"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'LoggedOut' then 1 else 0 end ;;
  }

  dimension: outbound_consult{
    label: "Outbound Consult"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'OutboundConsult' then 1 else 0 end ;;
  }

  dimension: outbound_contact{
    label: "Outbound Contact"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'OutboundContact' then 1 else 0 end ;;
  }

  dimension: unavailable{
    label: "Unavailable"
    group_label: "* Flags"
    type: yesno
    sql: case when ${state_name} = 'Unavailable' then 1 else 0 end ;;
  }

  ##########################################################################################
  ##########################################################################################
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

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSION GROUPS

  dimension_group: insert_ts {
    label: "Insert ts"
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

  dimension_group: state_start_ts {
    label: "State Start ts UTC"
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
    label: "State Start ts"
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
    label: "Update ts"
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

  ##########################################################################################
  ##########################################################################################
  ## COUNT MEASURES

  measure: available_count{
    label: "Available Count"
    group_label: "Count Measures"
    type: sum
    sql: ${available} ;;
  }

  measure: count {
    group_label: "Count Measures"
    type: count
    # hidden: yes
    drill_fields: [state_name, unavailable_code_name]
  }

  measure: inbound_consult_count{
    label: "InboundConsult Count"
    group_label: "Count Measures"
    type: sum
    sql: ${inbound_consult} ;;
  }

  measure: inbound_contact_count{
    label: "InboundContact Count"
    group_label: "Count Measures"
    type: sum
    sql: ${inbound_contact} ;;
  }

  measure: loggedin_count{
    label: "Logged In Count"
    group_label: "Count Measures"
    type: sum
    sql: ${loggedin} ;;
  }

  measure: loggedout_count{
    label: "Logged Out Count"
    group_label: "Count Measures"
    type: sum
    sql: ${loggedout} ;;
  }

  measure: outbound_consult_count{
    label: "OutboundConsult Count"
    group_label: "Count Measures"
    type: sum
    sql: ${outbound_consult} ;;
  }

  measure: outbound_contact_count{
    label: "OutboundContact Count"
    group_label: "Count Measures"
    type: sum
    sql: ${outbound_contact} ;;
  }

  measure: unavailable_count{
    label: "Unavailable Count"
    group_label: "Count Measures"
    type: sum
    sql: ${unavailable} ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## SUM DURATION MEASURES

  measure: available_duration_sum_min{
    label: "Available Time"
    group_label: "Sum Duration Measures"
    description: "Duration in minutes agent was in a state flaged as Available."
    type: number
    value_format_name: decimal_2
    sql: sum(
      case when ${TABLE}.state_name = 'Available' then ${TABLE}."STATE_DURATION"/60
        end) ;;
  }

  measure: state_duration_sum_min {
    label: "State Duration"
    group_label: "Sum Duration Measures"
    description: "Duration in minutes agent was in a given state."
    type: number
    value_format_name: decimal_2
    sql: sum(${TABLE}."STATE_DURATION")/60 ;;
  }

  measure: unavailable_duration_sum_min {
    label: "Unavailable Time"
    group_label: "Sum Duration Measures"
    description: "Duration in minutes agent was in a state flaged as Unavailable."
    type: number
    value_format_name: decimal_2
    sql: sum(
      case when ${TABLE}.state_name = 'Unavailable' then ${TABLE}."STATE_DURATION"
        when ${TABLE}.state_name = 'OutboundPending' then ${TABLE}."STATE_DURATION"
        end) / 60 ;;
  }

}
