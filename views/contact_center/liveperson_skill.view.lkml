view: liveperson_skill {
  sql_table_name: "LIVEPERSON"."SKILL"
    ;;
  drill_fields: [skill_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: can_transfer {
    type: yesno
    sql: ${TABLE}."CAN_TRANSFER" ;;
  }

  dimension: deleted {
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: fallback_when_away {
    type: yesno
    sql: ${TABLE}."FALLBACK_WHEN_AWAY" ;;
  }

  dimension: max_wait_time {
    type: number
    sql: ${TABLE}."MAX_WAIT_TIME" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: redistribute {
    type: yesno
    sql: ${TABLE}."REDISTRIBUTE" ;;
  }

  dimension: routing_config {
    type: string
    sql: ${TABLE}."ROUTING_CONFIG" ;;
  }

  dimension: skill_order {
    type: number
    sql: ${TABLE}."SKILL_ORDER" ;;
  }

  dimension: transfer_list {
    type: string
    sql: ${TABLE}."TRANSFER_LIST" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: skill_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."SKILL_ID" ;;
  }

  dimension: special_occasion_id {
    type: number
    sql: ${TABLE}."SPECIAL_OCCASION_ID" ;;
  }

  dimension: working_hours_id {
    type: number
    sql: ${TABLE}."WORKING_HOURS_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [skill_id, name]
  }
}
