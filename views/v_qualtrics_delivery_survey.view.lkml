view: v_qualtrics_delivery_survey {sql_table_name: "SHIPPING"."V_QUALTRICS_DELIVERY_SURVEY" ;;

  dimension: additional_comments {
    type: string
    sql: ${TABLE}."ADDITIONAL_COMMENTS" ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: delivery_crew {
    type: string
    sql: ${TABLE}."DELIVERY_CREW" ;;
  }

  dimension: delivery_schedule {
    type: string
    sql: ${TABLE}."DELIVERY_SCHEDULE" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: fulfilled {
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
    sql: ${TABLE}."FULFILLED" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: overall_experience {
    type: string
    sql: ${TABLE}."OVERALL_EXPERIENCE" ;;
  }

  dimension: response_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}."STATE" ;;
  }

  dimension_group: survey_complettion {
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
    sql: ${TABLE}."SURVEY_COMPLETTION_DATE" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  measure: delivery_schedule_measure {
    label: "Delivery Schedule"
    group_label: "Average"
    type: average
    value_format: "0.0"
    sql: ${TABLE}."DELIVERY_SCHEDULE" ;;
  }

  measure: delivery_crew_measure {
    label: "Delivery Crew"
    group_label: "Average"
    type: average
    value_format: "0.0"
    sql: ${TABLE}."DELIVERY_CREW" ;;
  }

  measure: overall_experience_measure {
    label: "Overall Experience"
    group_label: "Average"
    type: average
    value_format: "0.0"
    sql: ${TABLE}."OVERALL_EXPERIENCE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
