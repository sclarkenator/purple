view: agent_state {
  ## Tracks Zendesk agent states throughout the day as per the agent's FAC selections and Unavailable Codes
  ## e.g. States: Available, Unavailable, LoggedOut and Unavail Codes: Break, Meeting, QA Coaching

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

  dimension: available_time {
    label: "Available Seconds"
    description: "Time in seconds spent in an available state."
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: case when ${TABLE}.state_name = 'Available'
        or ${unavailable_code_name} = 'Zendesk Chat' then ${TABLE}.state_duration end ;;
  }

  dimension: custom_state_name {
    label: "State Name Custom"
    description: "State Name data that reassigns some states, such as reassigning 'Zendesk Chat' states to Available from Unavailable."
    type: string
    sql: case when ${TABLE}.unavailable_code_name = 'Zendesk Chat' then 'Available'
      else ${TABLE}.state_name end ;;
  }

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

  dimension: unavailable_time {
    label: "Unavailable Seconds"
    description: "Time in seconds spent in an unavailable state."
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: case when ${TABLE}.state_name in ('Unavailable', 'OutboundPending')
      and ${unavailable_code_name} <> 'Zendesk Chat' then ${TABLE}.state_duration end ;;
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

  parameter: dynamic_date_granularity {
    description: "This parameter changes the date range visualized."
    type: unquoted
    allowed_value: {label:"Day" value:"day"}
    allowed_value: {label:"Week" value:"week"}
    allowed_value: {label:"Month" value:"month"}
    allowed_value: {label:"Quarter" value:"quarter"}
    allowed_value: {label:"Year" value:"year"}
  }

  dimension: dynamic_date {
    sql:
    {% if dynamic_date_granularity._parameter_value == 'day' %}
      ${state_start_ts_mst_date}
    {% elsif dynamic_date_granularity._parameter_value == 'week' %}
      ${state_start_ts_mst_week}
    {% elsif dynamic_date_granularity._parameter_value == 'month' %}
      ${state_start_ts_mst_month}
    {% elsif dynamic_date_granularity._parameter_value == 'quarter' %}
      ${state_start_ts_mst_quarter}
    {% elsif dynamic_date_granularity._parameter_value == 'year' %}
      ${state_start_ts_mst_year}
    {% else %}
      NULL
    {% endif %};;
  }

  #####################################################################
  #####################################################################
  ## OTHER MEASURES

  measure: available_pct {
    label: "Available Pct"
    group_label: "Other Measures"
    description: "Percentage of time in available state."
    type: string
    value_format_name: percent_2
    sql: sum(${unavailable_time}) /
      nullifzero(sum(${unavailable_time}) + sum(${available_time}));;
  }

  measure: count {
    type: count
    group_label: "Other Measures"
    # hidden: yes
    drill_fields: [state_name, unavailable_code_name]
  }

  measure: state_percentage {
    label: "State Pct"
    group_label: "Other Measures"
    description: "Percent of time spent in a state."
    type: percent_of_total
    sql: ${state_duration_sum_min} ;;
  }

  measure: unavailable_pct {
    label: "Unavailable Pct"
    group_label: "Other Measures"
    description: "Percentage of time in unavailable state."
    type: number
    value_format_name: percent_2
    sql: sum(${available_time}) /
      nullifzero(sum(${unavailable_time}) + sum(${available_time})) ;;
  }

  measure: working_rate {
    label: "Working Rate"
    group_label: "Other Measures"
    description: "(Total Login Time - Break - Lunch - Personal) / Total Login Time"
    type: number
    value_format_name: percent_2
    sql: (sum(${TABLE}."STATE_DURATION") - (case when (sum(case when ${TABLE}.unavailable_code_name in ('Break', 'Lunch', 'Personal') then ${TABLE}."STATE_DURATION" end)
      ) is Null then '0' else ( sum(case when ${TABLE}.unavailable_code_name in ('Break', 'Lunch', 'Personal') then ${TABLE}."STATE_DURATION" end)
      ) end )) / nullifzero(sum(${TABLE}."STATE_DURATION")) ;;
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
    sql: sum(${available_time}) / 60 ;;
  }

  measure: available_duration_sum_sec{
    label: "Available Time Sec"
    group_label: "Sum Measures"
    description: "Duration in seconds agent was in a state flags as Available."
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: sum(${available_time}) ;;
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

  measure: state_duration_sum_hrs{
    label: "State Duration Hrs"
    group_label: "Sum Measures"
    description: "Duration in hours agent was in a given state."
    type: number
    value_format_name: decimal_2
    sql: (sum(${TABLE}."STATE_DURATION")/60)/60 ;;
  }

  measure: unavailable_duration_sum_min{
    label: "Unavailable Time"
    group_label: "Sum Measures"
    description: "Duration in minutes agent was in a state flags as Unavailable."
    type: number
    value_format_name: decimal_2
    sql: sum(${unavailable_time}) / 60 ;;
  }

  measure: unavailable_duration_sum_sec{
    label: "Unavailable Time Sec"
    group_label: "Sum Measures"
    description: "Duration in seconds agent was in a state flags as Unavailable."
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: sum(${unavailable_time}) ;;
  }

  measure: working_time_sum_min {
    label: "Working Time"
    group_label: "Sum Measures"
    description: "Total Login Minutes - Break - Lunch - Personal"
    type: number
    value_format_name: decimal_2
    sql: (sum(${TABLE}."STATE_DURATION") - (case when (sum(case when ${TABLE}.unavailable_code_name in ('Break', 'Lunch', 'Personal') then ${TABLE}."STATE_DURATION" end)
      ) is Null then '0' else ( sum(case when ${TABLE}.unavailable_code_name in ('Break', 'Lunch', 'Personal') then ${TABLE}."STATE_DURATION" end)
      ) end ))/60 ;;
  }

  measure: acw_avg {
    label: "ACW Average"
    group_label: "Average Measures"
    description: "Average time an agent spends in the Unavailable Wrap Up state"
    type: average
    value_format_name: decimal_2
    sql: (case when ${TABLE}.unavailable_code_name = 'Wrap Up' then ${TABLE}."STATE_DURATION" end)/60 ;;
  }
}
