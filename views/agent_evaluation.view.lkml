view: agent_evaluation {
  derived_table: {
    sql:
        select *
        from (select distinct SEQUENCE_ID as AGENT_EVALUATION_ID,
                EMPLOYEE_CUSTOM_ID as EVALUATED_ID,
                REVIEWER_CUSTOM_ID as EVALUATOR_ID,
                SCORE,
                SCORECARD_NAME as FORM_NAME,
                COMPLETED_AT as CREATED,
                COUNT_TOWARD_SCORE
              from analytics.customer_care.stella_connect_review) e
          left join (
            select team_name as evaluator_team_name, incontact_id, rank()over(partition by incontact_id order by end_date desc) as rank
            from analytics.customer_care.team_lead_name
            where team_name is not null
            ) t
            on e.evaluator_id = t.incontact_id
            and t.rank = 1
          left join (
            select team_type as evaluator_team_type, name as evaluator_name, email as evaluator_email, supervisor as is_supervisor, incontact_id
            from analytics.customer_care.agent_lkp
            ) a
            on e.evaluator_id = a.incontact_id;;
      # from analytics.customer_care.agent_evaluation e
      #     left join (
      #       select team_name as evaluator_team_name, incontact_id, rank()over(partition by incontact_id order by end_date desc) as rank
      #       from analytics.customer_care.team_lead_name
      #       where team_name is not null
      #       ) t
      #       on e.evaluator_id = t.incontact_id
      #       and t.rank = 1
      #     left join (
      #       select team_type as evaluator_team_type, name as evaluator_name, email as evaluator_email, supervisor as is_supervisor, incontact_id
      #       from analytics.customer_care.agent_lkp
      #       ) a
      #       on e.evaluator_id = a.incontact_id;;
  }
  #sql_table_name: CUSTOMER_CARE.AGENT_EVALUATION ;;

  dimension: agent_evaluation_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."AGENT_EVALUATION_ID" ;;
  }

  dimension: count_toward_score {
    type: yesno
    sql: ${TABLE}."COUNT_TOWARD_SCORE" ;;
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

  parameter: dynamic_date_granularity {
    description: "This parameter changes the date range visualized."
    type: unquoted
    allowed_value: {label:"Day" value:"day"}
    allowed_value: {label:"Week" value:"week"}
    allowed_value: {label:"Month" value:"month"}
    allowed_value: {label:"Quarter" value:"quarter"}
    allowed_value: {label:"Year" value:"year"}
  }

  dimension: dynamic_date {
    label_from_parameter: dynamic_date_granularity
    sql:
    {% if dynamic_date_granularity._parameter_value == 'day' %}
      ${created_date}
    {% elsif dynamic_date_granularity._parameter_value == 'week' %}
      ${created_week}
    {% elsif dynamic_date_granularity._parameter_value == 'month' %}
      ${created_month}
    {% elsif dynamic_date_granularity._parameter_value == 'quarter' %}
      ${created_quarter}
    {% elsif dynamic_date_granularity._parameter_value == 'year' %}
      ${created_year}
    {% else %}
      NULL
    {% endif %};;
  }

  dimension: evaluated_id {
    type: number
    sql: ${TABLE}."EVALUATED_ID" ;;
  }

  dimension: evaluator_id {
    type: number
    group_label: "Evaluator"
    sql: ${TABLE}."EVALUATOR_ID" ;;
  }

  dimension: evaluator_name {
    type: string
    group_label: "Evaluator"
    sql: ${TABLE}."EVALUATOR_NAME" ;;
  }

  dimension: evaluator_email {
    type: string
    group_label: "Evaluator"
    sql: ${TABLE}."EVALUATOR_EMAIL" ;;
  }

  dimension: evaluator_team {
    type: string
    group_label: "Evaluator"
    sql: ${TABLE}."EVALUATOR_TEAM_NAME" ;;
  }

  dimension: evaluator_team_type {
    type: string
    group_label: "Evaluator"
    sql:  ${TABLE}."EVALUATOR_TEAM_TYPE" ;;
  }

  dimension: evaluator_is_supervisor {
    type: yesno
    group_label: "Evaluator"
    sql: ${TABLE}."IS_SUPERVISOR" ;;
  }

  dimension: form_name {
    type: string
    sql: ${TABLE}."FORM_NAME" ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}."SCORE" ;;
  }

  measure: average_eval_score {
    label: "Average Evaluation Score"
    type: average
    value_format: "#.0"
    sql: ${TABLE}."SCORE" ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_evaluation_id, form_name]
  }
}
