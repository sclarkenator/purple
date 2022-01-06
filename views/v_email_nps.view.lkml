view: v_email_nps {
  derived_table: {
    sql:
      with v as (SELECT qa.survey_id
                      , qa.response_id
                      , max (case when qa.question_id in ('Delivery Experience','Q16') then qa.answer end) "Delivery Experience"
                      , max (case when qa.question_id in ('Shopping Experience','Q15') then qa.answer end) "Shopping Experience"
                      , max (case when qa.question_id in ('NPS Question','Q42') then qa.answer end) "NPS Question"
                      , max (case when qa.question_id in ('NPS Question_NPS_GROUP','Q42_NPS_GROUP') then qa.answer end) "NPS Group"
                 FROM marketing.qualtrics_answer qa
                 WHERE qa.survey_id in ('SV_ePTgnsU5PwdX2rb', 'SV_aUYARcteJyqsSGh')
                 and qa.question_text not in ('FL_5_BLOCK_RANDOMIZER_DISPLAY_ORDER_DELIVERYEXPERIENCE', 'FL_5_BLOCK_RANDOMIZER_DISPLAY_ORDER_SHOPPINGEXPERIENCE')
                 GROUP BY 1,2)
      select q.recipient_email as email
           , v.survey_id
           , v."Delivery Experience" as delivery_experience
           , "Shopping Experience" as shopping_experience
           , try_to_number("NPS Question") as nps_question
           , "NPS Group" as nps_group
           , start_date as survey_start_date
           , end_date as survey_finish_date
      from v
      join analytics.marketing.QUALTRICS_RESPONSE as q
          on q.response_id = v.response_id;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}.email ;;
  }

  dimension: survey_id {
    type: string
    #hidden: yes
    sql: ${TABLE}.survey_id ;;
  }


  dimension_group: survey_start_date {
    type: time
    label: "Survey Start Date"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.survey_start_date ;;
  }

  dimension_group: survey_finish_date {
    type: time
    label: "Survey Finish Date"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.survey_finish_date ;;
  }

  dimension: delivery_experience {
    type: string
    label: "Delivery Experience"
    sql: ${TABLE}.delivery_experience ;;
  }

  dimension: shopping_experience {
    type: string
    label: "Shopping Experience"
    sql: ${TABLE}.shopping_experience ;;
  }

  dimension: nps_question {
    type: number
    label: "NPS Score"
    sql: ${TABLE}.nps_question ;;
  }

  dimension: nps_group {
    type: string
    label: "NPS Group"
    sql: ${TABLE}.nps_group ;;
  }

}
