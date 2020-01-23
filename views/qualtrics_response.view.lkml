view: qualtrics_response {
  sql_table_name: MARKETING.QUALTRICS_RESPONSE ;;

  dimension: distribution_channel {
    type: string
    sql: ${TABLE}."DISTRIBUTION_CHANNEL" ;;
  }

  dimension: duration_in_seconds {
    type: number
    sql: ${TABLE}."DURATION_IN_SECONDS" ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: finished {
    type: yesno
    sql: ${TABLE}."FINISHED" ;;
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

  dimension: last_sales_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_SALES_ORDER_UNIQUE_ITEMS" ;;
  }

  dimension: latest_sales_order_id {
    type: string
    sql: ${TABLE}."LATEST_SALES_ORDER_ID" ;;
  }

  dimension: netsuite_customer_id {
    type: string
    sql: ${TABLE}."NETSUITE_CUSTOMER_ID" ;;
  }

  dimension: progress {
    type: number
    sql: ${TABLE}."PROGRESS" ;;
  }

  dimension: recipient_email {
    type: string
    sql: ${TABLE}."RECIPIENT_EMAIL" ;;
  }

  dimension: recipient_first_name {
    type: string
    sql: ${TABLE}."RECIPIENT_FIRST_NAME" ;;
  }

  dimension: recipient_last_name {
    type: string
    sql: ${TABLE}."RECIPIENT_LAST_NAME" ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension: shopify_customer_id {
    type: string
    sql: ${TABLE}."SHOPIFY_CUSTOMER_ID" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: survey_id {
    type: string
    sql: ${TABLE}."SURVEY_ID" ;;
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

  dimension: user_language {
    type: string
    sql: ${TABLE}."USER_LANGUAGE" ;;
  }

  dimension: zendesk_id {
    type: string
    sql: ${TABLE}."ZENDESK_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [recipient_first_name, recipient_last_name]
  }
}
