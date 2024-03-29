view: contact_history {
  ## Provides a list of contact states which a call enters during the course of the call
  ##     e.g., Active, Prequeue, Transfer

  sql_table_name: "CUSTOMER_CARE"."CONTACT_HISTORY" ;;

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS
  dimension: contact_state_name {
    label: "Contact State Name"
    type: string
    sql: ${TABLE}."CONTACT_STATE_NAME" ;;
  }

  dimension: digital_contact_state_name {
    label: "Digital Contact State Name"
    hidden: yes
    sql: nullif(${TABLE}."DIGITAL_CONTACT_STATE_NAME", '') ;;
  }

  dimension: duration {
    label: "Duration"
    type: number
    sql: ${TABLE}."DURATION" ;;
  }

  dimension: is_warehoused {
    label: "Is Warehoused"
    type: yesno
    sql: ${TABLE}."IS_WAREHOUSED" ;;
  }

  dimension: skill_name {
    label: "Skill Name"
    type: string
    sql: ${TABLE}."SKILL_NAME" ;;
  }

  dimension: state_index {
    label: "State Index"
    type: number
    sql: ${TABLE}."STATE_INDEX" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## TIME STATE DIMENSIONS

  dimension_group: insert_ts {
    label: "* Insert"
    description: "Date record was inserted."
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: start_ts {
    label: "* Contact Begin UTC"
    description: "Date contact began in UTC time."
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
    sql: CAST(${TABLE}."START_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: start_ts_mst {
    label: "* Contact Begin"
    description: "Date contact began."
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
    sql: CAST(${TABLE}."START_TS_MST" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## ID DIMENSIONS

  dimension: primary_key {
    label: "Primary Key"
    type: string
    primary_key: yes
    hidden: yes
    sql: concat(contact_id, state_index) ;;
  }

  dimension: agent_id {
    label: "Agent ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: contact_id {
    label: "Contact ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
  }

  dimension: contact_state_id {
    label: "Contact State ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."CONTACT_STATE_ID" ;;
  }

  dimension: digital_contact_state_id {
    label: "Digital Contact State ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."DIGITAL_CONTACT_STATE_ID" ;;
  }

  dimension: skillid {
    label: "Skill ID"
    group_label: "* IDs"
    type: number
    value_format_name: id
    sql: ${TABLE}."SKILLID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [digital_contact_state_name, contact_state_name, skill_name]
  }

  measure:refused_count {
    label: "Refused Count"
    description: "Count of contact refusals"
    type: sum
    value_format_name: decimal_0
    sql: case when ${contact_state_name} = 'Refused' then 1 end ;;
  }
}
