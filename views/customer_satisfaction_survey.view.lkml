view: customer_satisfaction_survey {
  sql_table_name: CUSTOMER_CARE.CUSTOMER_SATISFACTION_SURVEY ;;

  dimension: agent_csat {
    type: number
    label: "Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5.
      Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."AGENT_CSAT" ;;

  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: areas_of_excellence_response {
    type: string
    label: "Areas of Excellence"
    description: "Areas of Excellence give by customer.
      Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."AREAS_OF_EXCELLENCE_RESPONSE" ;;
  }

  dimension: areas_of_improvement_response {
    type: string
    label: "Areas of Improvement"
    description: "Areas of Improvement give by customer.
      Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."AREAS_OF_IMPROVEMENT_RESPONSE" ;;
  }

  dimension: comment {
    type: string
    label: "Customer Comment"
    description: "Free response comment by customer.
      Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."COMMENT" ;;
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

  dimension: customer_email {
    type: string
    label: "Customer Email"
    description: "Customer email for CSAT survey.
      Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."CUSTOMER_EMAIL" ;;
  }

  dimension: fcr_comment {
    type: string
    #label: "Customer Email"
    description: "
    Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."FCR_COMMENT" ;;
  }

  dimension: fcr_response {
    type: string
    #label: "Customer Email"
    description: "
    Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."FCR_RESPONSE" ;;
  }

  dimension: nps_comment {
    type: string
    #label: "Customer Email"
    description: "
    Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."NPS_COMMENT" ;;
  }

  dimension: nps_response {
    type: string
    #label: "Customer Email"
    description: "
    Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."NPS_RESPONSE" ;;
  }

  measure: count {
    label: "Survey Count"
    type: count
    drill_fields: []
  }

#   measure: averge_likely_to_recommend {
#     label: "Average Likelihood to Recommend"
#     type: average
#     #value_format: "0.##"
#     sql: ${TABLE}."LIKELY_TO_RECOMMEND" ;;
#   }
#
#   measure: percent_likely_to_recommend_10 {
#     label: "Percent with Likelihood to Recommend of 10"
#     type: number
#     value_format: "0.0%"
#     sql: sum(case when  ${TABLE}."LIKELY_TO_RECOMMEND" = 10 then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
#   }
#
#   measure: average_statisfied_with_rep {
#     label: "Average CSAT"
#     type: average
#     value_format: "0.##"
#     sql: ${TABLE}."SATISFIED_WITH_REP" ;;
#   }
#
#   measure: Percent_CSAT_10 {
#     label: "Percent with CSAT of 10"
#     type: number
#     value_format: "0.0%"
#     sql: sum(case when  ${TABLE}."SATISFIED_WITH_REP" = 10 then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
#   }
#
#   measure: percent_questions_answered_by_rep {
#     label: "Percent Questions Answered"
#     description: "Percent of respondents who said yes, that their questions had been answered by the rep"
#     type: number
#     value_format: "0.0%"
#     sql: sum(case when lower(${TABLE}."QUESTIONS_ANSWERED_BY_REP") = 'yes' then 1 else 0 end) / count(${TABLE}."SURVEY_ID") ;;
#   }
}
