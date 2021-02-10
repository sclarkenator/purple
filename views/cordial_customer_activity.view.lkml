view: cordial_customer_activity {
  sql_table_name: "MARKETING"."V_CORDIAL_CUSTOMER_ACTIVITY"
    ;;

  dimension: email {
    group_label: "Customer"
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: most_recent_email_clicked {
    type: time
    group_label: "Clicked"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."MOST_RECENT_EMAIL_CLICKED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: most_recent_email_open {
    type: time
    group_label: "Opened"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."MOST_RECENT_EMAIL_OPEN" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: most_recent_email_sent {
    type: time
    group_label: "Sent"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."MOST_RECENT_EMAIL_SENT" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: oldest_email_clicked {
    type: time
    group_label: "Clicked"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OLDEST_EMAIL_CLICKED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: oldest_email_open {
    type: time
    group_label: "Opened"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OLDEST_EMAIL_OPEN" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: oldest_email_sent {
    type: time
    group_label: "Sent"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OLDEST_EMAIL_SENT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: opened_count {
    type: number
    group_label: "Opened"
    sql: ${TABLE}."OPENED_COUNT" ;;
  }

  dimension: sent_count {
    type: number
    group_label: "Sent"
    sql: ${TABLE}."SENT_COUNT" ;;
  }

  dimension: clicked_count {
    type: number
    group_label: "Clicked"
    sql: ${TABLE}."CLICKED_COUNT" ;;
  }

  dimension: subscribe_status {
    group_label: "Opened"
    type: string
    sql: ${TABLE}."SUBSCRIBE_STATUS" ;;
  }


  measure: click_through_rate {
    type: average
    sql: ${TABLE}."CLICKED_COUNT"/${TABLE}."SENT_COUNT" ;;
    description: "Count of emails clicked divided by count of emails sent"
    drill_fields: []
  }


  measure: open_rate {
    type: average
    sql: ${TABLE}."OPENED_COUNT"/${TABLE}."SENT_COUNT" ;;
    description: "Count of emails opened divided by count of emails sent"
    drill_fields: []
  }
}
