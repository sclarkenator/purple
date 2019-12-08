view: customer_nps_dec_2019 {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select "Start Date", "End Date", "Response Type", "IP Address", "PROGRESS", "FINISHED", "Recorded Date"
    , "Response ID", "Recipient Email", "Shopping Experience Satisfaction", "Delivery Experience Satisfaction"
    , "NPS Question Group", "NPS Question", "NPS Comment"
from analytics.csv_uploads.nps_survey_06dec2019
      ;;
  }

  dimension: key {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."Response ID"||${TABLE}."Recipient Email"
  }

  dimension_group: start {
    type: time
    hidden: yes
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
    sql: ${TABLE}."Start Date" ;;
  }

  dimension_group: end {
    type: time
    hidden: yes
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
    sql: ${TABLE}."End Date" ;;
  }

  dimension_group: response {
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
    sql: ${TABLE}."Recorded Date" ;;
  }

  dimension: survey_finished {
    type: yesno
    sql: ${TABLE}.FINISHED ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}."Response ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."Recipient Email" ;;
  }

  dimension: shopping_experience {
    type: string
    hidden: yes
    sql: ${TABLE}."Shopping Experience Satisfaction" ;;
  }

  dimension: shopping_experience_satisfaction {
    type: string
    description: "Customer reported satisfaction with the online shopping experience"
    case: {
      when: {
        sql: ${shopping_experience} = 'Extremely satisfied' ;;
        label: "Extremely Satisfied"
        }
      when: {
        sql: ${shopping_experience} = 'Somewhat satisfied' ;;
        label: "Somewhat Satisfied"
      }
      when: {
        sql: ${shopping_experience} = 'Neither satisfied nor dissatisfied' ;;
        label: "Neither Satisfied nor Dissatisfied"
      }
      when: {
        sql: ${shopping_experience} = 'Somewhat dissatisfied' ;;
        label: "Somewhat Dissatisfied"
      }
      when: {
        sql: ${shopping_experience} = 'Extremely dissatisfied' ;;
        label: "Extremely Dissatisfied"
      }
      else: "Unanswered"
    }
  }

  dimension: delivery_experience {
    type: string
    hidden: yes
    sql: ${TABLE}."Delivery Experience Satisfaction" ;;
  }

  dimension: delivery_experience_satisfaction {
    type: string
    description: "Customer reported satisfaction with the delivery experience"
    case: {
      when: {
        sql: ${delivery_experience} = 'Extremely satisfied' ;;
        label: "Extremely Satisfied"
      }
      when: {
        sql: ${delivery_experience} = 'Somewhat satisfied' ;;
        label: "Somewhat Satisfied"
      }
      when: {
        sql: ${delivery_experience} = 'Neither satisfied nor dissatisfied' ;;
        label: "Neither Satisfied nor Dissatisfied"
      }
      when: {
        sql: ${delivery_experience} = 'Somewhat dissatisfied' ;;
        label: "Somewhat Dissatisfied"
      }
      when: {
        sql: ${delivery_experience} = 'Extremely dissatisfied' ;;
        label: "Extremely Dissatisfied"
      }
      else: "Unanswered"
    }
  }

  dimension: nps_group {
    type: string
    label: "NPS Group"
    description: "Promoter, Passive, or Detractor"
    sql: ${TABLE}."NPS Question Group" ;;
  }

  dimension: nps_raw_response {
    type: number
    label: "NPS Raw Response"
    description: "The actual number selected by the respondent for the NPS question"
    sql: ${TABLE}."NPS Question" ;;
  }

  dimension: nps_comment {
    type: string
    hidden: yes
    label: "NPS Comment"
    sql: ${TABLE}."NPS Comment" ;;
  }

  measure: count {
    type: count
    hidden: yes
  }

  measure: response_count {
    type: count_distinct
    filters: {
      field: nps_group
      value: "-NULL"
    }
    sql: ${TABLE}."Response ID" ;;
  }

  measure: nps_detractors {
    type: count_distinct
    label: "NPS Detractors"
    filters: {
      field: nps_group
      value: "Detractor"
    }
    sql: ${TABLE}."Response ID" ;;
  }

  measure: nps_promoters {
    type: count_distinct
    label: "NPS Promoters"
    filters: {
      field: nps_group
      value: "Promoter"
    }
    sql: ${TABLE}."Response ID" ;;
  }

  measure: nps_passives {
    type: count_distinct
    label: "NPS Passives"
    filters: {
      field: nps_group
      value: "Passive"
    }
    sql: ${TABLE}."Response ID" ;;
  }

#   measure: percent_detractors {
#     type: number
#     sql: ${nps_detractors}/${response_count} ;;
#     value_format_name: percent_1
#   }
#
#   measure: percent_promoters {
#     type: number
#     sql: ${nps_promoters}/${response_count} ;;
#     value_format_name: percent_1
#   }


}
