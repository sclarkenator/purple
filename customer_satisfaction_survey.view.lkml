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
    sql: ${TABLE}."SURVEY_ID" ;;
  }

  dimension: ticket_id {
    type: string
    sql: ${TABLE}."TICKET_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
