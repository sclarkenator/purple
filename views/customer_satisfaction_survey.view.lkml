view: customer_satisfaction_survey {
  sql_table_name: ANALYTICS.CUSTOMER_CARE.CUSTOMER_SATISFACTION_SURVEY
    ;;

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
    label: "Agent Incontact ID"
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
    type: yesno
    sql: ${TABLE}."HISTORICAL" ;;
  }

  dimension: issue_resolved {
    label: "* Is Issue Resolved"
    description: "Did the customer indicate the issue was resolved. Source: stella_connect.customer_satisfaction_survey"
    type: yesno
    sql: ${TABLE}."ISSUE_RESOLVED" ;;
  }

  measure: issue_resolved_count {
    label: "FCR"
    description: "First Call Resolution Source: stella_connect.customer_satisfaction_survey"
    type: sum
    sql:case when ${issue_resolved} then 1 else 0 end ;;
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

  measure: star_rating {
    label: "Total Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5.
    Source: stella_connect.customer_satisfaction_survey"
    type: sum
    sql: ${TABLE}."STAR_RATING" ;;
  }

  measure: avg_star_rating {
    label: "Average Agent CSAT Score"
    description: "CSAT score give by customer. Range 0 to 5.
    Source: stella_connect.customer_satisfaction_survey"
    type: average
    value_format: "0.##"
    sql: ${TABLE}."STAR_RATING" ;;
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
    type: count
    drill_fields: [agent_name, customer_name]
  }
}
