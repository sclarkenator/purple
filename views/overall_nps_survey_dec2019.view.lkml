view: overall_nps_survey_dec2019 {
  derived_table: {
    sql: select max(FULFILLED_DATE) as "Last Fulfilled Date", CREATED_DATE, ORDER_ID, "DELIVERY_EXPERIENCE_SATISFACTION","EMAIL", "NPS_COMMENT","NPS_QUESTION","NPS_QUESTION_GROUP", "SHOPPING_EXPERIENCE_SATISFACTION","SURVEY_RECORDED_DATE","TRANID"
      from ANALYTICS.CSV_UPLOADS.NPS_SURVEY_DEC2019
      group by ORDER_ID, "EMAIL", CREATED_DATE, "DELIVERY_EXPERIENCE_SATISFACTION", "NPS_COMMENT","NPS_QUESTION","NPS_QUESTION_GROUP", "SHOPPING_EXPERIENCE_SATISFACTION","SURVEY_RECORDED_DATE","TRANID"
 ;;
  }

  measure: count {
    type: count
  }

  dimension_group: last_fulfilled_date {
    label: "Order Fulfilled"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."Last Fulfilled Date" ;;
  }

  dimension_group: created {
    label: "Order Created"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: delivery_experience {
    hidden:  yes
    type: string
    sql: ${TABLE}."DELIVERY_EXPERIENCE_SATISFACTION" ;;
  }

  dimension: delivery_experience_satisfaction {
    type: string
    description: "Customer reported satisfaction with the delivery experience"
    case: {
      when: {
        sql: ${TABLE}.delivery_experience = 'Extremely satisfied' ;;
        label: "Extremely Satisfied"
      }
      when: {
        sql: ${TABLE}.delivery_experience = 'Somewhat satisfied' ;;
        label: "Somewhat Satisfied"
      }
      when: {
        sql: ${TABLE}.delivery_experience = 'Neither satisfied nor dissatisfied' ;;
        label: "Neither Satisfied nor Dissatisfied"
      }
      when: {
        sql: ${TABLE}.delivery_experience = 'Somewhat dissatisfied' ;;
        label: "Somewhat Dissatisfied"
      }
      when: {
        sql: ${TABLE}.delivery_experience = 'Extremely dissatisfied' ;;
        label: "Extremely Dissatisfied"
      }
      else: "Unanswered"
    }
  }

  dimension: delivery_satisfaction_buckets {
    type: string
    description: "Those who answered either Extremely Satisfied or Somewhat Satisfied vs those less satisfied"
    case: {
      when: {
        sql: ${TABLE}.delivery_experience = 'Extremely satisfied' or ${TABLE}.delivery_experience = 'Somewhat satisfied' ;;
        label: "Satisfied"
      }
      when: {
        sql: ${TABLE}.delivery_experience = 'Neither satisfied nor dissatisfied' or ${TABLE}.delivery_experience = 'Somewhat dissatisfied' or ${TABLE}.delivery_experience = 'Extremely dissatisfied' ;;
        label: "Unsatisfied"
      }
      else: "Other"
    }
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}."NPS_COMMENT" ;;
  }

  dimension: nps_question {
    type: string
    sql: ${TABLE}."NPS_QUESTION" ;;
  }

  dimension: nps_question_group {
    type: string
    sql: ${TABLE}."NPS_QUESTION_GROUP" ;;
  }

  measure: nps_response_count {
    type: count_distinct
    label: "NPS Respondent Count"
    filters: {
      field: nps_question_group
      value: "Promoter, Passive, Detractor"
    }
    sql: ${TABLE}.order_id ;;
  }

  measure: nps_detractors {
    type: count_distinct
    label: "Detractor Count"
    filters: {
      field: nps_question_group
      value: "Detractor"
    }
    sql: ${TABLE}.order_id ;;
  }

  measure: nps_promoters {
    type: count_distinct
    label: "Promoter Count"
    filters: {
      field: nps_question_group
      value: "Promoter"
    }
    sql: ${TABLE}.order_id ;;
  }

  measure: nps_passives {
    type: count_distinct
    label: "Passive Count"
    filters: {
      field: nps_question_group
      value: "Passive"
    }
    sql: ${TABLE}.order_id ;;
  }

  dimension: shopping_experience {
    hidden: yes
    type: string
    sql: ${TABLE}."SHOPPING_EXPERIENCE_SATISFACTION" ;;
  }

  dimension: shopping_experience_satisfaction {
    type: string
    description: "Customer reported satisfaction with the online shopping experience"
    case: {
      when: {
        sql: ${TABLE}.shopping_experience = 'Extremely satisfied' ;;
        label: "Extremely Satisfied"
      }
      when: {
        sql: ${TABLE}.shopping_experience = 'Somewhat satisfied' ;;
        label: "Somewhat Satisfied"
      }
      when: {
        sql: ${TABLE}.shopping_experience = 'Neither satisfied nor dissatisfied' ;;
        label: "Neither Satisfied nor Dissatisfied"
      }
      when: {
        sql: ${TABLE}.shopping_experience = 'Somewhat dissatisfied' ;;
        label: "Somewhat Dissatisfied"
      }
      when: {
        sql: ${TABLE}.shopping_experience = 'Extremely dissatisfied' ;;
        label: "Extremely Dissatisfied"
      }
      else: "Unanswered"
    }
  }

  dimension: shopping_satisfaction_buckets {
    type: string
    description: "Those who answered either Extremely Satisfied or Somewhat Satisfied vs those less satisfied"
    case: {
      when: {
        sql: ${TABLE}.shopping_experience = 'Extremely satisfied' or ${TABLE}.shopping_experience = 'Somewhat satisfied' ;;
        label: "Satisfied"
      }
      when: {
        sql: ${TABLE}.shopping_experience = 'Neither satisfied nor dissatisfied' or ${TABLE}.shopping_experience = 'Somewhat dissatisfied' or ${TABLE}.shopping_experience = 'Extremely dissatisfied' ;;
        label: "Unsatisfied"
      }
      else: "Other"
    }
  }



  dimension_group: survey_recorded_date {
    label: "Survey Recorded"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SURVEY_RECORDED_DATE"  ;;
  }

  dimension: tranid {
    hidden: yes
    type: string
    sql: ${TABLE}."TRANID" ;;
  }
}
