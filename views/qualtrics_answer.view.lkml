view: qualtrics_answer {
  sql_table_name: MARKETING.QUALTRICS_ANSWER ;;

  dimension: answer {
    type: string
    sql: ${TABLE}."ANSWER" ;;
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: question_id {
    type: string
    sql: ${TABLE}."QUESTION_ID" ;;
  }

  dimension: question_name {
    type: string
    sql: ${TABLE}."QUESTION_NAME" ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension: survey_id {
    type: string
    sql: ${TABLE}."SURVEY_ID" ;;
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: [question_name]
  }
}
