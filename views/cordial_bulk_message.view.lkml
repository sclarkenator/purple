view: cordial_bulk_message {
  sql_table_name: "MARKETING"."CORDIAL_BULK_MESSAGE"
    ;;

  measure: audience_total {
    type: sum
    sql: ${TABLE}."AUDIENCE_TOTAL" ;;
  }

  dimension: bm_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."BM_ID" ;;
  }

  measure: bounces {
    type: sum
    sql: ${TABLE}."BOUNCES" ;;
  }

  dimension: bs {
    hidden: yes
    type: number
    sql: ${TABLE}."BS" ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  dimension: classification {
    type: string
    sql: ${TABLE}."CLASSIFICATION" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
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
    sql: ${TABLE}."END_TIME" ;;
  }

  dimension: from_desc {
    type: string
    sql: ${TABLE}."FROM_DESC" ;;
  }

  dimension: from_email {
    type: string
    sql: ${TABLE}."FROM_EMAIL" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  measure: opt_outs {
    type: sum
    sql: ${TABLE}."OPT_OUTS" ;;
  }

  dimension: reply_email {
    type: string
    sql: ${TABLE}."REPLY_EMAIL" ;;
  }

  dimension_group: schedule {
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
    sql: ${TABLE}."SCHEDULE" ;;
  }

  dimension_group: send {
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
    sql: ${TABLE}."SEND_TIME" ;;
  }

  measure: sent {
    type: sum
    sql: ${TABLE}."SENT" ;;
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
    sql: ${TABLE}."START_TIME" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  measure: total_clicks {
    type: sum
    sql: ${TABLE}."TOTAL_CLICKS" ;;
  }

  measure: total_opens {
    type: sum
    sql: ${TABLE}."TOTAL_OPENS" ;;
  }

  dimension: track_links {
    type: yesno
    sql: ${TABLE}."TRACK_LINKS" ;;
  }

  dimension: transport_id {
    type: string
    sql: ${TABLE}."TRANSPORT_ID" ;;
  }

  measure: unique_clicks {
    type: sum
    sql: ${TABLE}."UNIQUE_CLICKS" ;;
  }

  measure: unique_opens {
    type: sum
    sql: ${TABLE}."UNIQUE_OPENS" ;;
  }

  dimension: utm_campaign {
    type: string
    sql: ${TABLE}."UTM_CAMPAIGN" ;;
  }

  measure: count {
    type: count
  }
}
