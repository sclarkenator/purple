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
    group_label: "Address"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: state {
    group_label: "Address"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zip {
    group_label: "Address"
    label: "Zipcode (5)"
    description: "Source: netsuite.sales_order_line"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: split_part(${TABLE}."ZIP",'-',1) ;;
  }

  dimension: crew_rating {
    type: string
    sql: ${TABLE}."CREW_RATING" ;;
  }

  dimension: scheduling_rating {
    type: string
    sql: ${TABLE}."SCHEDULING_RATING" ;;
  }

  dimension: overall_delivery_rating {
    type: string
    sql: ${TABLE}."OVERALL_DELIVERY_RATING" ;;
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

  dimension: tracking_numbers {
    type: string
    sql: ${TABLE}.tracking_numbers ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: response_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension_group: survey_completion {
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
    sql: ${TABLE}."SURVEY_COMPLETION_DATE" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: tranid {
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{order_id._value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
    }
    sql: ${TABLE}."TRANID" ;;
  }

  measure: scheduling_rating_measure {
    label: "Schedule Rating"
    group_label: "Average"
    type: average_distinct
    value_format: "0.0"
    sql: ${TABLE}."SCHEDULING_RATING" ;;
  }

  measure: crew_rating_measure {
    label: "Crew Rating"
    group_label: "Average"
    type: average_distinct
    value_format: "0.0"
    sql: ${TABLE}."CREW_RATING" ;;
  }

  measure: overall_delivery_rating_measure {
    label: "Overall Delivery Rating"
    group_label: "Average"
    type: average_distinct
    value_format: "0.0"
    sql: ${TABLE}."OVERALL_DELIVERY_RATING" ;;
  }

  measure: total_unique_responses {
    type: count_distinct
    sql:  ${TABLE}."RESPONSE_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: crew_rating_top_2 {
    hidden: yes
    type: string
    sql: case
          when ${crew_rating} > 5 then 1
          else 0
          end;;
  }

  dimension: crew_rating_bottom_2 {
    hidden: yes
    type: string
    sql: case
          when ${crew_rating} < 3 then 1
          else 0
          end;;
  }

  dimension: crew_rating_neutral {
    hidden: yes
    type: string
    sql: case
          when ${crew_rating} >= 3 AND ${crew_rating} <= 5 then 1
          else 0
          end;;
  }

  measure: crew_rating_top_2_measure {
    label: "Crew: Satisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${crew_rating_top_2};;
  }

  measure: crew_rating_bottom_2_measure {
    label: "Crew: Dissatisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${crew_rating_bottom_2};;
  }

  measure: crew_rating_neutral_measure {
    label: "Crew: Neutral"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${crew_rating_neutral};;
  }

  dimension: scheduling_rating_top_2 {
    hidden: yes
    type: string
    sql: case
          when ${scheduling_rating} > 5 then 1
          else 0
          end;;
  }

  dimension: scheduling_rating_bottom_2 {
    hidden: yes
    type: string
    sql: case
          when ${scheduling_rating} < 3 then 1
          else 0
          end;;
  }

  dimension: scheduling_rating_neutral {
    hidden: yes
    type: string
    sql: case
          when ${scheduling_rating} >= 3 AND ${scheduling_rating} <= 5 then 1
          else 0
          end;;
  }

  measure: scheduling_rating_top_2_measure {
    label: "Scheduling: Satisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${scheduling_rating_top_2};;
  }

  measure: scheduling_rating_bottom_2_measure {
    label: "Scheduling: Dissatisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${scheduling_rating_bottom_2};;
  }

  measure: scheduling_rating_neutral_measure {
    label: "Scheduling: Neutral"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${scheduling_rating_neutral};;
  }

  dimension: overall_rating_top_2 {
    hidden: yes
    type: string
    sql: case
          when ${overall_delivery_rating} > 5 then 1
          else 0
          end;;
  }

  dimension: overall_rating_bottom_2 {
    hidden: yes
    type: string
    sql: case
          when ${overall_delivery_rating} < 3 then 1
          else 0
          end;;
  }

  dimension: overall_rating_neutral {
    hidden: yes
    type: string
    sql: case
          when ${overall_delivery_rating} >= 3 AND ${overall_delivery_rating} <= 5 then 1
          else 0
          end;;
  }

  measure: overall_rating_top_2_measure {
    label: "Overall: Satisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${overall_rating_top_2};;
  }

  measure: overall_rating_bottom_2_measure {
    label: "Overall: Dissatisfied"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${overall_rating_bottom_2};;
  }

  measure: overall_rating_neutral_measure {
    label: "Overall: Neutral"
    group_label: "Satisfaction"
    type: average_distinct
    value_format: "0.0%"
    sql: ${overall_rating_neutral};;
  }

}
