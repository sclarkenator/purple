## REFERENCE: https://developers.liveperson.com/administration-skills-appendix.html
view: liveperson_skill {

  sql_table_name: "LIVEPERSON"."SKILL"
    ;;
  drill_fields: [skill_name ]

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
    description: "Whether the item has been deleted."
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
    label: "Max Allowed Wait Time"
    description: "The skill’s maximum allowed wait time.  This is a setting, not a measure. Defaults to 120."
    type: number
    sql: ${TABLE}."MAX_WAIT_TIME" ;;
  }

  dimension: skill_name {
    alias: [name]
    label: "Skill Name"
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
    label: "Transfers To"
    description: "The list of Skill ids to which this skill can transfer conversations."
    type: string
    sql: ${TABLE}."TRANSFER_LIST" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: insert_ts {
    label: "- Inserted"
    description: "TS when skill record was originally inserted into database."
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

  dimension_group: modified {
    label: "- Skill Modified"
    description: "TS when skill was modified in LivePerson."
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    label: "- Updated"
    description: "TS when skill record was updated in database."
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

  dimension: skill_id {
    label: "Skill ID"
    group_label: "* IDs"
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."SKILL_ID" ;;
  }

  dimension: special_occasion_id {
    label: "Special Occasion ID"
    group_label: "* IDs"
    type: number
    hidden: yes
    sql: ${TABLE}."SPECIAL_OCCASION_ID" ;;
  }

  dimension: working_hours_id {
    label: "Working Hours ID"
    group_label: "* IDs"
    type: number
    hidden: yes
    sql: ${TABLE}."WORKING_HOURS_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    label: "Skills Count"
    type: count
    hidden: yes
    drill_fields: [skill_id, skill_name]
  }
}
