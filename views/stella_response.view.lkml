view: stella_response {
  sql_table_name: CUSTOMER_CARE.STELLA_RESPONSE ;;

  dimension: additional_question_eligible {
    type: yesno
    sql: ${TABLE}."ADDITIONAL_QUESTION_ELIGIBLE" ;;
  }

  dimension: additional_question_id {
    type: number
    sql: ${TABLE}."ADDITIONAL_QUESTION_ID" ;;
  }

  dimension: additional_question_response_multiple_choice {
    type: string
    sql: ${TABLE}."ADDITIONAL_QUESTION_RESPONSE_MULTIPLE_CHOICE" ;;
  }

  dimension: additional_question_response_scalar {
    type: number
    sql: ${TABLE}."ADDITIONAL_QUESTION_RESPONSE_SCALAR" ;;
  }

  dimension: additional_question_text {
    type: string
    sql: ${TABLE}."ADDITIONAL_QUESTION_TEXT" ;;
  }

  dimension: areas_for_improvement {
    type: string
    sql: ${TABLE}."AREAS_FOR_IMPROVEMENT" ;;
  }

  dimension: areas_of_excellence_selected {
    type: string
    sql: ${TABLE}."AREAS_OF_EXCELLENCE_SELECTED" ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}."BRAND" ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  dimension: comments {
    type: string
    sql: ${TABLE}."COMMENTS" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: custom_link_eligible {
    type: yesno
    sql: ${TABLE}."CUSTOM_LINK_ELIGIBLE" ;;
  }

  dimension: custom_link_initiated {
    type: yesno
    sql: ${TABLE}."CUSTOM_LINK_INITIATED" ;;
  }

  dimension: customer_custom_id {
    type: string
    sql: ${TABLE}."CUSTOMER_CUSTOM_ID" ;;
  }

  dimension: customer_email_address {
    type: string
    sql: ${TABLE}."CUSTOMER_EMAIL_ADDRESS" ;;
  }

  dimension: customer_full_name {
    type: string
    sql: ${TABLE}."CUSTOMER_FULL_NAME" ;;
  }

  dimension: employee_custom_id {
    type: number
    sql: ${TABLE}."EMPLOYEE_CUSTOM_ID" ;;
  }

  dimension: employee_email_address {
    type: string
    sql: ${TABLE}."EMPLOYEE_EMAIL_ADDRESS" ;;
  }

  dimension: employee_first_name {
    type: string
    sql: ${TABLE}."EMPLOYEE_FIRST_NAME" ;;
  }

  dimension: employee_last_name {
    type: string
    sql: ${TABLE}."EMPLOYEE_LAST_NAME" ;;
  }

  dimension: ext_interaction_id {
    type: string
    sql: ${TABLE}."EXT_INTERACTION_ID" ;;
  }

  dimension: external_url {
    type: string
    sql: ${TABLE}."EXTERNAL_URL" ;;
  }

  dimension: facebook_follow_eligible {
    type: yesno
    sql: ${TABLE}."FACEBOOK_FOLLOW_ELIGIBLE" ;;
  }

  dimension: facebook_follow_initiated {
    type: yesno
    sql: ${TABLE}."FACEBOOK_FOLLOW_INITIATED" ;;
  }

  dimension: facebook_share_eligible {
    type: yesno
    sql: ${TABLE}."FACEBOOK_SHARE_ELIGIBLE" ;;
  }

  dimension: facebook_share_initiated {
    type: yesno
    sql: ${TABLE}."FACEBOOK_SHARE_INITIATED" ;;
  }

  dimension_group: insert_ts {
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

  dimension: language {
    type: string
    sql: ${TABLE}."LANGUAGE" ;;
  }

  dimension: request_delivery_status {
    type: string
    sql: ${TABLE}."REQUEST_DELIVERY_STATUS" ;;
  }

  dimension: request_id {
    type: string
    sql: ${TABLE}."REQUEST_ID" ;;
  }

  dimension_group: request_sent {
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
    sql: ${TABLE}."REQUEST_SENT_AT" ;;
  }

  dimension: requested_via {
    type: string
    sql: ${TABLE}."REQUESTED_VIA" ;;
  }

  dimension_group: response_received {
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
    sql: ${TABLE}."RESPONSE_RECEIVED_AT" ;;
  }

  dimension: reward_eligible {
    type: yesno
    sql: ${TABLE}."REWARD_ELIGIBLE" ;;
  }

  dimension: reward_name {
    type: string
    sql: ${TABLE}."REWARD_NAME" ;;
  }

  dimension: star_rating {
    type: number
    sql: ${TABLE}."STAR_RATING" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: team_leader {
    type: string
    sql: ${TABLE}."TEAM_LEADER" ;;
  }

  dimension: team_leader_employee_custom_id {
    type: string
    sql: ${TABLE}."TEAM_LEADER_EMPLOYEE_CUSTOM_ID" ;;
  }

  dimension: twitter_follow_eligible {
    type: yesno
    sql: ${TABLE}."TWITTER_FOLLOW_ELIGIBLE" ;;
  }

  dimension: twitter_follow_initiated {
    type: yesno
    sql: ${TABLE}."TWITTER_FOLLOW_INITIATED" ;;
  }

  dimension: twitter_share_eligible {
    type: yesno
    sql: ${TABLE}."TWITTER_SHARE_ELIGIBLE" ;;
  }

  dimension: twitter_share_initiated {
    type: yesno
    sql: ${TABLE}."TWITTER_SHARE_INITIATED" ;;
  }

  dimension_group: update_ts {
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
    drill_fields: [employee_last_name, reward_name, employee_first_name, customer_full_name]
  }
}
