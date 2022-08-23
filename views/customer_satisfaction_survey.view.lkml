include: "/views/_period_comparison.view.lkml"
view: customer_satisfaction_survey {
  extends: [_period_comparison]
  sql_table_name: ANALYTICS.CUSTOMER_CARE.CUSTOMER_SATISFACTION_SURVEY
    ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: ${survey_id}||${agent_id} ;;
  }

#### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: CAST(${TABLE}."RESPONSE_RECEIVED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: created {
    description: "When the CSAT survey was sent to the customer. Source: stella_connect.customer_satisfaction_survey"
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: customer_email {
    type: string
    label: "Customer Email"
    description: "Customer email for CSAT survey. Source: stella_connect.customer_satisfaction_survey"
    sql: ${TABLE}."CUSTOMER_EMAIL" ;;
  }

  dimension: customer_name {
    description: "Customer name for CSAT survey. Source: stella_connect.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: agent_email {
    label: "Agent Email"
    description: "Source: stella_connect.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."EMPLOYEE_EMAIL" ;;
  }

  dimension: agent_id {
    label: "Agent InContact ID"
    description: "Agent Incontact ID. Source: stella_connect.customer_satisfaction_survey"
    type: number
    sql: ${TABLE}."EMPLOYEE_ID" ;;
  }

  dimension: agent_name {
    label: "Agent Name"
    description: "Agent Name on CSAT. Source: stella_connect.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."EMPLOYEE_NAME" ;;
  }

  dimension: historical {
    label: "* Is Historical CSAT"
    description: "Pre-Stella Connect CSAT. Source: analytics.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."HISTORICAL" ;;
  }

  dimension: issue_resolved {
    label: "* Is Issue Resolved"
    description: "Did the customer indicate the issue was resolved. Source: stella_connect.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."ISSUE_RESOLVED" ;;
  }

  measure: issue_resolved_count {
    label: "FCR Resolved"
    description: "First Call Resolution Source: stella_connect.customer_satisfaction_survey"
    type: count_distinct
    sql:case when ${issue_resolved} = 'true' then ${pk} end ;;
  }

  measure: issue_resolved_total {
    label: "FCR Count"
    description: "First Call Resolution including true and false (excluding null) Source: stella_connect.customer_satisfaction_survey"
    type: count_distinct
    sql:case when ${issue_resolved} is not null then ${pk} end ;;
  }

  measure: first_contact_rate {
    label: "FCR"
    description: "First Call Resolution/ Count *including true and false (excluding null) Source: stella_connect.customer_satisfaction_survey"
    type: number
    value_format: "0.00\%"
    sql: ${issue_resolved_count}/case when ${issue_resolved_total} > 0 then${issue_resolved_total} end *100  ;;
  }

  dimension: issue_resolved_comment {
    type: string
    sql: ${TABLE}."ISSUE_RESOLVED_COMMENT" ;;
  }

  dimension: nps_comment {
    description: "Net Promoter Comment Score Source: stella_connect.customer_satisfaction_survey"
    type: string
    sql: ${TABLE}."NPS_COMMENT" ;;
  }

  measure: nps_rating {
    label: "Total NPS Rating"
    description: "Net Promoter Score Source: stella_connect.customer_satisfaction_survey"
    type: sum
    sql: ${TABLE}."NPS_RATING" ;;
  }

  measure: avg_nps_rating {
    label: "Average NPS Rating"
    description: "Net Promoter Score Source: stella_connect.customer_satisfaction_survey"
    type: average
    value_format: "0.##"
    sql: ${TABLE}."NPS_RATING" ;;
  }

  measure: nps_calc {
    hidden: yes
     type: number
    sql: case when ${TABLE}."NPS_RATING" in (1,2,3,4,5,6) then -1
        when ${TABLE}."NPS_RATING" in (9,10) then 1
        when ${TABLE}."NPS_RATING" in (7,8) then 0
        else null end ;;
  }

  measure: nps_score {
    hidden: no
    label: "NPS Score"
    description: "NPS Score (% of Promoters)-(% of Detractors)"
    type: number
    value_format_name: decimal_2
    sql: (sum(${nps_calc})/count(${nps_calc}))*100  ;;
  }

  dimension_group: response_received {
    description: "When the customer responded to the CSAT survey. Source: stella_connect.customer_satisfaction_survey"
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
    sql: CAST(${TABLE}."RESPONSE_RECEIVED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: sequence_id {
    hidden: yes
    description: "Used in API call"
    type: number
    sql: ${TABLE}."SEQUENCE_ID" ;;
  }

  dimension: star_rating_score {
    label: "Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5. Source: stella_connect.customer_satisfaction_survey"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}."STAR_RATING" ;;
  }

  measure: star_rating {
    label: "Total Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5. Source: stella_connect.customer_satisfaction_survey"
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}."STAR_RATING" ;;
  }

  measure: star_rating_count {
    label: "Total Agent CSATs"
    description: "CSAT score give by customer. Range 0 to 5. Source: stella_connect.customer_satisfaction_survey"
    type: count_distinct
    value_format_name: decimal_2
    sql_distinct_key: ${pk} ;;
    sql:  case when ${TABLE}."STAR_RATING" is not null then ${pk} end;;
  }

  measure: avg_star_rating {
    label: "Average Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5. Source: stella_connect.customer_satisfaction_survey"
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}."STAR_RATING" ;;
  }

  measure: 5_star_rating {
    label: "Agent CSAT Scores of 5"
    #description: "CSAT score give by customer. Range 0 to 5. Source: stella_connect.customer_satisfaction_survey"
    type: count_distinct
    value_format: "0.##"
    sql: case when ${star_rating_score} = '5' then ${pk} end ;;
  }

  measure: top_box {
    label: "Top Box"
    description: "CSAT score of 5 / total CSAT scores. Source: stella_connect.customer_satisfaction_survey"
    type: number
    value_format: "0.00\%"
    sql: ${5_star_rating}/nullif(${star_rating_count}, 0)*100;;
  }

  dimension: star_rating_comment {
    type: string
    sql: ${TABLE}."STAR_RATING_COMMENT" ;;
  }

  dimension: survey_id {
    type: string
    sql: ${TABLE}."SURVEY_ID" ;;
  }

  dimension: ticket_id {
    label: "Zendesk Ticket ID"
    description: "Zendesk Ticket ID. Source: stella_connect.customer_satisfaction_survey"
    type: number
    sql: ${TABLE}."TICKET_ID" ;;
  }

  measure: count {
    type: count_distinct
    sql: ${pk} ;;
    drill_fields: [agent_name, customer_name]
  }
}
