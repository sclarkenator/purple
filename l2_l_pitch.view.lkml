view: ltol_pitch {
  label: "L2L Pitch Data"
  sql_table_name: PRODUCTION.L2L_PITCH ;;

  dimension: pitch_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
  }

  measure: actual {
    type: sum
    sql: ${TABLE}."ACTUAL" ;;
  }

  dimension: actual_product {
    type: number
    sql: ${TABLE}."ACTUAL_PRODUCT" ;;
  }

  dimension: area {
    hidden: yes
    type: number
    sql: ${TABLE}."AREA" ;;
  }

  dimension: build_sequence {
    type: number
    hidden: yes
    sql: ${TABLE}."BUILD_SEQUENCE" ;;
  }

  measure: changeover_earned_hours {
    type: sum
    sql: ${TABLE}."CHANGEOVER_EARNED_HOURS" ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}."COMMENT" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    type: string
    sql: ${TABLE}."CREATEDBY" ;;
  }

  dimension: cycle_time {
    type: number
    sql: ${TABLE}."CYCLE_TIME" ;;
  }

  measure: demand {
    type: sum
    sql: ${TABLE}."DEMAND" ;;
  }

  measure: downtime_minutes {
    type: sum
    sql: ${TABLE}."DOWNTIME_MINUTES" ;;
  }

  measure: earned_hours {
    type: sum
    sql: ${TABLE}."EARNED_HOURS" ;;
  }

  dimension: has_actual_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_ACTUAL_DETAILS" ;;
  }

  dimension: has_operator_count_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_OPERATOR_COUNT_DETAILS" ;;
  }

  dimension: has_scrap_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_SCRAP_DETAILS" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: lastupdated {
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
    sql: ${TABLE}."LASTUPDATED" ;;
  }

  dimension: lastupdatedby {
    type: string
    sql: ${TABLE}."LASTUPDATEDBY" ;;
  }

  dimension: line {
    type: number
    sql: ${TABLE}."LINE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  measure: nonproduction_minutes {
    type: sum
    sql: ${TABLE}."NONPRODUCTION_MINUTES" ;;
  }

  measure: operational_availability {
    type: sum
    sql: ${TABLE}."OPERATIONAL_AVAILABILITY" ;;
  }

  measure: total_operator_count {
    type: sum
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }
  measure: Avg_operator_count {
    type: average
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }

  dimension: overall_equipment_effectiveness {
    type: number
    sql: ${TABLE}."OVERALL_EQUIPMENT_EFFECTIVENESS" ;;
  }

  dimension_group: pitch_end {
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
    sql: ${TABLE}."PITCH_END" ;;
  }

  dimension_group: pitch_start {
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
    sql: ${TABLE}."PITCH_START" ;;
  }

  measure: Total_planned_operator_count {
    type: sum
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }
  measure: Avg_planned_operator_count {
    type: average
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }

  dimension: planned_product {
    type: number
    sql: ${TABLE}."PLANNED_PRODUCT" ;;
  }

  measure: planned_production_minutes {
    type: sum
    sql: ${TABLE}."PLANNED_PRODUCTION_MINUTES" ;;
  }

  measure: scrap {
    type: sum
    sql: ${TABLE}."SCRAP" ;;
  }

  dimension: shift {
    type: number
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension_group: shift_start {
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
    sql: ${TABLE}."SHIFT_START_DATE" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [pitch_id, name]
  }
}
