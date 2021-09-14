view: liveperson_skill {
  # REFERENCE: https://developers.liveperson.com/administration-skills-appendix.html

  sql_table_name: "LIVEPERSON"."SKILL"
    ;;
  drill_fields: [skill_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: can_transfer {
    label: "Can Transfer"
    description: "Whether the skill can transfer to other skills."
    type: yesno
    sql: ${TABLE}."CAN_TRANSFER" ;;
  }

  dimension: deleted {
    label: "Deleted"
    description: "Whether the item is deleted or not."
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: description {
    label: "Description"
    description: "The skill’s description. Default: null (i.e. skill can transfer to all skills)."
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: fallback_when_away {
    label: "Fallback When Away"
    description: "Setting per skill whether or not to use fallback skill when all agents are away."
    type: yesno
    sql: ${TABLE}."FALLBACK_WHEN_AWAY" ;;
  }

  dimension: max_wait_time {
    label: "Max Wait Time"
    description: "The skill’s max wait time. Defaults to 120."
    type: number
    sql: ${TABLE}."MAX_WAIT_TIME" ;;
  }

  dimension: name {
    label: "Name"
    description: "Skill’s unique name."
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: redistribute {
    label: "Redistribute"

    type: yesno
    sql: ${TABLE}."REDISTRIBUTE" ;;
  }

  dimension: routing_config {
    label: "Routing Config"
    description: "For each agent group the parameters of the percentage and priority split routing."
    type: string
    hidden: yes
    sql: ${TABLE}."ROUTING_CONFIG" ;;
  }

  dimension: skill_order {
    label: "Skill Order"
    description: "The skill’s order."
    type: number
    sql: ${TABLE}."SKILL_ORDER" ;;
  }

  dimension: transfer_list {
    label: "Transfer List"
    description: "The list of Skill ids to which this skill can transfer conversations."
    type: string
    sql: ${TABLE}."TRANSFER_LIST" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

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

  dimension: skill_id {
    label: "Skill ID"
    group_label: "* IDs"
    primary_key: yes
    type: number
    sql: ${TABLE}."SKILL_ID" ;;
  }

  dimension: special_occasion_id {
    label: "Special Occasion ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."SPECIAL_OCCASION_ID" ;;
  }

  dimension: working_hours_id {
    label: "Working Hours ID"
    group_label: "* IDs"
    type: number
    sql: ${TABLE}."WORKING_HOURS_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [skill_id, name]
  }
}