## REFERENCE: https://developers.liveperson.com/agent-metrics-api-methods-agent-status.html
view: liveperson_agent_status {
  sql_table_name: "LIVEPERSON"."AGENT_STATUS" ;;

  set: default_agent_status {
    fields: [
      reason,
      status_change_date,
      status_change_time,
      status_change_minute,
      status_change_minute15,
      status_change_hour,
      status_change_week,
      status_change_month,
      status_change_year,
      pk
    ]
    }

    # set: agent_login_time {
    #   fields: [
    #     status_change_date,
    #     status_change_time,
    #     status_change_week,
    #     status_change_month,
    #     status_change_year,
    #     time_logged_in
    #   ]
  # }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: reason {
    label: "Reason"
    description: "Optional custom reason for the status change. Null if no custom reason was provided by the agent."
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  # dimension: session_sequence {
  #   label: "Session Sequence"
  #   type: string
  # }

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

  dimension_group: previous_status_change {
    label: "- Previous Status Change"
    type: time
    timeframes: [
      raw,
      time,
      minute,
      minute15,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."PREVIOUS_STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

dimension_group: status_change {
  label: "- Status Change"
  type: time
  timeframes: [
      raw,
      time,
      minute,
      minute15,
      hour,
      date,
      week,
      month,
      quarter,
      year
  ]
  sql: CAST(${TABLE}."STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    label: "Session Sequence ID (pk)"
    description: "[Agent ID] - [Session ID] - [Sequence Number]"
    type: string
    # hidden: yes
    primary_key: yes
    sql: concat(${agent_id}, '-', ${session_id}, '-', right(concat('00', ${sequence_number}), 2)) ;;
  }

  dimension: agent_id {
    description: "Agent's LivePerson ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: sequence_number {
    label: "Sequence Number"
    description: "Sequential number of this status change within the session."
    type: number
    value_format_name: id
    sql: ${TABLE}."SEQUENCE_NUMBER" ;;
  }

  dimension: session_id {
    description: "Identifier of the session during which this status change took place."
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: status_reason_id {
    description: "Identifier of optional custom reason for the status change."
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."STATUS_REASON_ID" ;;
  }

  dimension: subtype_id {
    label: "Subtype ID"
    description: "Subtype ID of status change when Type = 'Status Changed'."
    type: string
    hidden: yes
    sql: ${TABLE}.sub_type ;;
  }

  dimension: type_id{
    label: "Type ID"
    description: "Type ID of status change."
    type: string
    hidden: yes
    sql: ${TABLE}.type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: agent_count {
    label: "Agent Count"
    type: count_distinct
    hidden: yes
    sql: agent_id ;;
    drill_fields: [pk]
    # html:
    #   <ul>
    #     <li> Time Logged In: {{value}} </li>
    #     <li> Agent Count: {{value}} </li>
    #   </ul>;;
  }

  measure: agent_status_count {
    label: "Agent Status Count"
    type: count
    hidden: yes
    drill_fields: [pk]
  }
}
