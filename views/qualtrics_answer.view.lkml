view: qualtrics_answer {
  sql_table_name: MARKETING.QUALTRICS_ANSWER ;;

  dimension: survey_response_question_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}.survey_id||'-'||${TABLE}.response_id||'-'||${TABLE}.question_id;; }

  dimension: answer {
    type: string
    sql:
      case when ${TABLE}."ANSWER" = 'Extremely satisfied' then '1 - Extremely satisfied'
      when ${TABLE}."ANSWER" = 'Moderately satisfied' then '2 - Moderately satisfied'
      when ${TABLE}."ANSWER" in ('Slightly satisfied','Somewhat satisfied') then '3 - Slightly satisfied'
      when ${TABLE}."ANSWER" = 'Neither satisfied nor dissatisfied' then '4 - Neither satisfied nor dissatisfied'
      when ${TABLE}."ANSWER" in ('Slightly dissatisfied','Somewhat dissatisfied') then '5 - Slightly dissatisfied'
      when ${TABLE}."ANSWER" = 'Moderately dissatisfied' then '6 - Moderately dissatisfied'
      when ${TABLE}."ANSWER" = 'Extremely dissatisfied' then '7 - Extremely dissatisfied'
      when ${TABLE}."ANSWER" = 'I did not order/receive that product' then '8 - I did not order/receive that product'
      else ${TABLE}."ANSWER" end;;
  }

  dimension: answer_t2b2 {
    type: string
    sql:
      case
      when ${TABLE}."ANSWER" in ('Extremely satisfied','Moderately satisfied') then '2 Top (Most Satisfied)'
      when ${TABLE}."ANSWER" in ('Moderately dissatisfied', 'Extremely dissatisfied') then '2 Bottom (Least Satisfied)'
      else ${TABLE}."ANSWER" end;;
  }


  dimension_group: insert_ts {
    hidden:  yes
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
    hidden:  yes
    type: string
    sql: ${TABLE}."SURVEY_ID" ;;
  }

  dimension_group: update_ts {
    hidden:  yes
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

  measure: nps_promoter {
    type: count_distinct
    label: "Promoter Count"
    filters: {field: answer value: "Promoter"}
    sql: ${TABLE}.response_id  ;;
  }

  measure: nps_passive {
    type: count_distinct
    label: "Passive Count"
    filters: {field: answer value: "Passive"}
    sql: ${TABLE}.response_id ;;
  }

  measure: nps_detractor {
    type: count_distinct
    label: "Detractor Count"
    filters: {field: answer value: "Detractor"}
    sql: ${TABLE}.response_id ;;
  }

    measure: nps_response_count {
      type: count_distinct
      label: "NPS Respondent Count"
      filters: {field: answer value: "Promoter, Passive, Detractor"}
      sql: ${TABLE}.response_id ;;
    }

  measure: nps_score {
    type: number
    label: "NPS Score"
    sql: case when ${nps_response_count} < 1 then 0 else ((${nps_promoter}/${nps_response_count})-(${nps_detractor}/${nps_response_count}))*100 end ;;
    }




}
