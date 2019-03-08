view: customer_satisfaction_survey {
  sql_table_name: CUSTOMER_CARE.CUSTOMER_SATISFACTION_SURVEY ;;

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: comments {
    type: string
    sql: ${TABLE}."COMMENTS" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: ip_address {
    type: string
    hidden: yes
    sql: ${TABLE}."IP_ADDRESS" ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}."KEY" ;;
  }

  dimension: likely_to_recommend {
    type: string
    sql: ${TABLE}."LIKELY_TO_RECOMMEND" ;;
  }

  dimension: questions_answered_by_rep {
    type: string
    sql: ${TABLE}."QUESTIONS_ANSWERED_BY_REP" ;;
  }

  dimension: satisfied_with_rep {
    type: string
    sql: ${TABLE}."SATISFIED_WITH_REP" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: survey_id {
    type: string
    primary_key: yes
    sql: ${TABLE}."SURVEY_ID" ;;
  }

  dimension: ticket_id {
    type: string
    sql: ${TABLE}."TICKET_ID" ;;
  }

  measure: count {
    label: "Survey Count"
    type: count
    drill_fields: []
  }

  measure: averge_likely_to_recommend {
    label: "Average Likelihood to Recommend"
    type: average
    #value_format: "0.##"
    sql: ${TABLE}."LIKELY_TO_RECOMMEND" ;;
  }

  measure: percent_likely_to_recommend_10 {
    label: "Percent with Likelihood to Recommend of 10"
    type: number
    value_format: "0.0%"
    sql: sum(case when  ${TABLE}."LIKELY_TO_RECOMMEND" = 10 then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
  }

  measure: average_statisfied_with_rep {
    label: "Average CSAT"
    type: average
    #value_format: "0.##"
    sql: ${TABLE}."SATISFIED_WITH_REP" ;;
  }

  measure: Percent_CSAT_10 {
    label: "Percent with CSAT of 10"
    type: number
    value_format: "0.0%"
    sql: sum(case when  ${TABLE}."SATISFIED_WITH_REP" = 10 then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
  }

  measure: percent_questions_answered_by_rep {
    label: "Percent Questions Answered"
    description: "Percent of respondents who said yes, that their questions had been answered by the rep"
    type: number
    value_format: "0.0%"
    sql: sum(case when lower(${TABLE}."QUESTIONS_ANSWERED_BY_REP") = 'yes' then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
  }
}
