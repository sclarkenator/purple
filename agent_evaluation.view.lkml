view: agent_evaluation {
  sql_table_name: CUSTOMER_CARE.AGENT_EVALUATION ;;

  dimension: agent_evaluation_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."AGENT_EVALUATION_ID" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: evaluated_id {
    type: number
    sql: ${TABLE}."EVALUATED_ID" ;;
  }

  dimension: evaluator_id {
    type: number
    sql: ${TABLE}."EVALUATOR_ID" ;;
  }

  dimension: form_name {
    type: string
    sql: ${TABLE}."FORM_NAME" ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}."SCORE" ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_evaluation_id, form_name]
  }
}
