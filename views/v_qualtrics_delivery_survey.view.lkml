# The name of this view in Looker is "V Qualtrics Delivery Survey"
view: v_qualtrics_delivery_survey {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "SHIPPING"."V_QUALTRICS_DELIVERY_SURVEY"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Additional Comments" in Explore.

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

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension: state {
    type: string
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

  measure: count {
    type: count
    drill_fields: []
  }
}
