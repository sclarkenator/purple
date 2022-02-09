view: stella_connect_review {

  sql_table_name: "CUSTOMER_CARE"."STELLA_CONNECT_REVIEW"
    ;;

  dimension: comment {
    type: string
    sql: ${TABLE}."COMMENT" ;;
  }

  dimension_group: completed {
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
    sql: CAST(${TABLE}."COMPLETED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: count_toward_score {
    type: yesno
    sql: ${TABLE}."COUNT_TOWARD_SCORE" ;;
  }

  dimension: employee_custom_id {
    type: number
    sql: ${TABLE}."EMPLOYEE_CUSTOM_ID" ;;
  }

  dimension: employee_email {
    type: string
    sql: ${TABLE}."EMPLOYEE_EMAIL" ;;
  }

  dimension: employee_first_name {
    type: string
    sql: ${TABLE}."EMPLOYEE_FIRST_NAME" ;;
  }

  dimension: employee_last_name {
    type: string
    sql: ${TABLE}."EMPLOYEE_LAST_NAME" ;;
  }

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

  dimension: interaction_id {
    type: string
    sql: ${TABLE}."INTERACTION_ID" ;;
  }

  dimension: interaction_url {
    type: string
    sql: ${TABLE}."INTERACTION_URL" ;;
  }

  dimension: is_autofailed {
    type: yesno
    sql: ${TABLE}."IS_AUTOFAILED" ;;
  }

  dimension: option_id {
    type: string
    sql: ${TABLE}."OPTION_ID" ;;
  }

  dimension: option_score {
    type: number
    sql: ${TABLE}."OPTION_SCORE" ;;
  }

  measure: total_option_score {
    type: sum
    sql: ${option_score} ;;
  }

  measure: average_option_score {
    type: average
    sql: ${option_score} ;;
  }

  dimension: option_text {
    type: string
    sql: ${TABLE}."OPTION_TEXT" ;;
  }

  dimension: question_id {
    type: number
    sql: ${TABLE}."QUESTION_ID" ;;
  }

  dimension: question_text {
    type: string
    sql: ${TABLE}."QUESTION_TEXT" ;;
  }

  dimension: reviewer_custom_id {
    type: number
    sql: ${TABLE}."REVIEWER_CUSTOM_ID" ;;
  }

  dimension: reviewer_email {
    type: string
    sql: ${TABLE}."REVIEWER_EMAIL" ;;
  }

  dimension: reviewer_first_name {
    type: string
    sql: ${TABLE}."REVIEWER_FIRST_NAME" ;;
  }

  dimension: reviewer_last_name {
    type: string
    sql: ${TABLE}."REVIEWER_LAST_NAME" ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}."SCORE" ;;
  }

  measure: average_score {
    type: average
    sql:  ${score} ;;
  }

  dimension_group: scorecard_archived {
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
    sql: CAST(${TABLE}."SCORECARD_ARCHIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: scorecard_name {
    type: string
    sql: ${TABLE}."SCORECARD_NAME" ;;
  }

  dimension: section {
    type: string
    sql: ${TABLE}."SECTION" ;;
  }

  dimension: section_weight {
    type: number
    sql: ${TABLE}."SECTION_WEIGHT" ;;
  }

  dimension: sequence_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."SEQUENCE_ID" ;;
  }

  dimension: solicitation_id {
    type: string
    sql: ${TABLE}."SOLICITATION_ID" ;;
  }

  dimension: team_leader_custom_id {
    type: number
    sql: ${TABLE}."TEAM_LEADER_CUSTOM_ID" ;;
  }

  dimension: team_leader_email {
    type: string
    sql: ${TABLE}."TEAM_LEADER_EMAIL" ;;
  }

  dimension: team_leader_first_name {
    type: string
    sql: ${TABLE}."TEAM_LEADER_FIRST_NAME" ;;
  }

  dimension: team_leader_last_name {
    type: string
    sql: ${TABLE}."TEAM_LEADER_LAST_NAME" ;;
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

  dimension: uuid {
    type: string
    sql: ${TABLE}."UUID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      scorecard_name,
      employee_last_name,
      employee_first_name,
      reviewer_last_name,
      team_leader_first_name,
      reviewer_first_name,
      team_leader_last_name
    ]
  }
}
