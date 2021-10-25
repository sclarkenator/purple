# The name of this view in Looker is "Agent Status"
view: liveperson_agent_status {
  sql_table_name: "LIVEPERSON"."AGENT_STATUS" ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: reason {
    label: "Reason"
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: sub_type {
    label: "Sub Type ID"
    type: number
    value_format_name: id
    sql: ${TABLE}."SUB_TYPE" ;;
  }

  dimension: type {
    label: "Type ID"
    type: number
    value_format_name: id
    sql: ${TABLE}."TYPE" ;;
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
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: previous_status_change {
    label: "- Previous Status Change"
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
    sql: CAST(${TABLE}."PREVIOUS_STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

dimension_group: status_change {
  label: "Status Change"
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
  sql: CAST(${TABLE}."STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    type: string
    # hidden: yes
    primary_key: yes
    sql: concat(${agent_id}, '-', ${session_id}, '-', right(concat('00', ${sequence_number}), 2)) ;;
  }

  dimension: agent_id {
    type: number
    # hidden: yes
    value_format_name: id
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: sequence_number {
    label: "Sequence Number"
    type: number
    value_format_name: id
    sql: ${TABLE}."SEQUENCE_NUMBER" ;;
  }

  dimension: session_id {
    type: number
    value_format_name: id
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: status_reason_id {
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."STATUS_REASON_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: agent_status_count {
    label: "Agent Status Count"
    type: count
    drill_fields: []
  }

  measure: total_sequence_number {
    type: sum
    hidden: yes
    sql: ${sequence_number} ;;
  }

  measure: average_sequence_number {
    type: average
    hidden: yes
    sql: ${sequence_number} ;;
  }

  measure: total_sub_type {
    type: sum
    hidden: yes
    sql: ${sub_type} ;;
  }

  measure: average_sub_type {
    type: average
    hidden: yes
    sql: ${sub_type} ;;
  }

  measure: total_type {
    type: sum
    hidden: yes
    sql: ${type} ;;
  }

  measure: average_type {
    type: average
    hidden: yes
    sql: ${type} ;;
  }
}
