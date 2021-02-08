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

  dimension: answer_order {
    label: "Answer order"
    type: number
    sql:
      case when ${TABLE}."ANSWER" in ('Extremely certain','Extremely helpful','Strongly agree','Extremely likely','1','Less than 1 week ago','Less than 1 week','Less than an hour','Between 18 and 24','Less than $15000','0 to 3 months') then '1'
      when ${TABLE}."ANSWER" in ('Very certain','Very helpful','Somewhat agree','Somewhat likely','2','Less than 2 weeks ago','Less than 2 weeks','About an hour','Between 25 and 39','$15000 to $24999','Over 3 months to 6 months') then '2'
      when ${TABLE}."ANSWER" in ('Moderately certain','Moderately helpful','Neither agree nor disagree','Neither likely nor unlikely','3','Less than 1 month ago','Less than 1 month','2-3 hours','Between 40 and 54','$25000 to $34999','Over 6 months to 1 year') then '3'
      when ${TABLE}."ANSWER" in ('Slightly certain','Slightly helpful','Somewhat disagree','Somewhat unlikely','4','Less than 2 months ago','Less than 2 months','4-5 hours','Between 55 and 75','$35000 to $49000','Over 1 year to 5 years') then '4'
      when ${TABLE}."ANSWER" in ('Not certain at all','Not helpful at all','Strongly disagree','Extremely unlikely','5','Less than 3 months ago','Less than 3 months','6-7 hours','76+','$50000 to $74999','Over 5 years') then '5'
      when ${TABLE}."ANSWER" in ('Less than 6 months ago','Less than 6 months','8-9 hours','$75000 to $99999','6') then '6'
      when ${TABLE}."ANSWER" in ('Less than 1 year ago','Less than 1 year','10 or more hours','$100000 to $124999','7') then '7'
      when ${TABLE}."ANSWER" in ('More than 1 year ago','More than 1 year','$125000 to $149999','8') then '8'
      when ${TABLE}."ANSWER" in ('$150000 to $199999','9') then '9'
      when ${TABLE}."ANSWER" in ('$200000 to $249999','10') then '10'
      when ${TABLE}."ANSWER" in ('$250000 or more','11') then '11'
      when ${TABLE}."ANSWER" in ('12') then '12'
      when ${TABLE}."ANSWER" in ('13') then '13'
      when ${TABLE}."ANSWER" in ('14') then '14'
      when ${TABLE}."ANSWER" in ('15') then '15'
      else '99'
      end;;
  }

  dimension: answer_t2b2 {
    label: "Answer Buckets "
    type: string
    sql:
      case
      when ${TABLE}."ANSWER" in ('Extremely satisfied','Moderately satisfied') then 'Satisfied (Top 2)'
      when ${TABLE}."ANSWER" in ('Moderately dissatisfied', 'Extremely dissatisfied') then 'Dissatisfied (Bottom 2)'
      when ${TABLE}."ANSWER" = 'I did not order/receive that product' then 'N/A'
      else 'Passive' end;;
  }

  dimension: confidence_in_purchase {
    label: "Confidence in purchase"
    type: string
    sql: case
          when ${TABLE}."QUESTION_NAME" = "QCONFIDENCE" and ${TABLE}."ANSWER" in ("Extremely certain","Very certain") then "Extremely or very certain"
          when ${TABLE}."QUESTION_NAME" = "QCONFIDENCE" and ${TABLE}."ANSWER" in ("Not certain at all","Slightly certain") then "Slightly or not at all certain"
          else "other"
          end;;
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
    hidden: yes
    label: "Promoter Count"
    filters: {field: answer value: "Promoter"}
    filters: {field: question_id value: "On a scale from 0-10 how likely are you to recommend Purple to a friend or colleague? - Group"}
    sql: ${TABLE}.response_id  ;;
  }

  measure: nps_passive {
    type: count_distinct
    hidden: yes
    label: "Passive Count"
    filters: {field: answer value: "Passive"}
    filters: {field: question_id value: "On a scale from 0-10 how likely are you to recommend Purple to a friend or colleague? - Group"}
    sql: ${TABLE}.response_id ;;
  }

  measure: nps_detractor {
    type: count_distinct
    hidden: yes
    label: "Detractor Count"
    filters: {field: answer value: "Detractor"}
    filters: {field: question_id value: "On a scale from 0-10 how likely are you to recommend Purple to a friend or colleague? - Group"}
    sql: ${TABLE}.response_id ;;
  }

    measure: nps_response_count {
      type: count_distinct
      hidden: yes
      label: "NPS Respondent Count"
      filters: {field: answer value: "Promoter, Passive, Detractor"}
      filters: {field: question_id value: "On a scale from 0-10 how likely are you to recommend Purple to a friend or colleague? - Group"}
      sql: ${TABLE}.response_id ;;
    }

  measure: answer_1 {
    type: sum
    hidden:  no
    label: "Numeric answer"
    sql: ${TABLE}.answer ;;
  }

  measure: nps_score {
    type: number
    hidden: yes
    label: "NPS Score"
    sql: case when ${nps_response_count} < 1 then 0 else ((${nps_promoter}/${nps_response_count})-(${nps_detractor}/${nps_response_count}))*100 end ;;
    }




}
