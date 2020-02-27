view: qualtrics_answer {
  sql_table_name: MARKETING.QUALTRICS_ANSWER ;;

  dimension: answer {
    type: string
    sql:
      case when ${TABLE}."ANSWER" = 'Extremely satisfied' then '1 - Extremely satisfied'
      when ${TABLE}."ANSWER" = 'Moderately satisfied' then '2 - Moderately satisfied'
      when ${TABLE}."ANSWER" = 'Slightly satisfied' then '3 - Slightly satisfied'
      when ${TABLE}."ANSWER" = 'Neither satisfied nor dissatisfied' then '4 - Neither satisfied nor dissatisfied'
      when ${TABLE}."ANSWER" = 'Slightly dissatisfied' then '5 - Slightly dissatisfied'
      when ${TABLE}."ANSWER" = 'Moderately dissatisfied' then '6 - Moderately dissatisfied'
      when ${TABLE}."ANSWER" = 'Extremely dissatisfied' then '7 - Extremely dissatisfied'
      when ${TABLE}."ANSWER" = 'I did not order/receive that product' then '8 - I did not order/receive that product'
      else ${TABLE}."ANSWER" end;;
  }

  dimension: answer_t2b2 {
    type: string
    sql:
      case when ${TABLE}."ANSWER" = 'Extremely satisfied' then '2 Top (Most Satisfied)'
      when ${TABLE}."ANSWER" = 'Moderately satisfied' then '2 Top (Most Satisfied)'
      when ${TABLE}."ANSWER" = 'Moderately dissatisfied' then '2 Bottom (Least Satisfied)'
      when ${TABLE}."ANSWER" = 'Extremely dissatisfied' then '2 Bottom (Least Satisfied)'
      else ${TABLE}."ANSWER" end;;
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
