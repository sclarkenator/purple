view: cordial_message_analytic {
  sql_table_name: "MARKETING"."CORDIAL_MESSAGE_ANALYTIC"
    ;;

  dimension: aov {
    type: number
    sql: ${TABLE}."AOV" ;;
  }

  dimension: bounce_rate {
    type: number
    sql: ${TABLE}."BOUNCE_RATE" ;;
  }

  dimension: bounced_hard {
    type: number
    sql: ${TABLE}."BOUNCED_HARD" ;;
  }

  dimension: bounced_soft {
    type: number
    sql: ${TABLE}."BOUNCED_SOFT" ;;
  }

  dimension: bounced_total {
    type: number
    sql: ${TABLE}."BOUNCED_TOTAL" ;;
  }

  dimension: click_rate {
    type: number
    sql: ${TABLE}."CLICK_RATE" ;;
  }

  dimension: click_total {
    type: number
    sql: ${TABLE}."CLICK_TOTAL" ;;
  }

  dimension: clicks_unique {
    type: number
    sql: ${TABLE}."CLICKS_UNIQUE" ;;
  }

  dimension: complaint_rate {
    type: number
    sql: ${TABLE}."COMPLAINT_RATE" ;;
  }

  dimension: complaints {
    type: number
    sql: ${TABLE}."COMPLAINTS" ;;
  }

  dimension: ctor {
    type: number
    sql: ${TABLE}."CTOR" ;;
  }

  dimension: delivered_rate {
    type: number
    sql: ${TABLE}."DELIVERED_RATE" ;;
  }

  dimension: delivered_total {
    type: number
    sql: ${TABLE}."DELIVERED_TOTAL" ;;
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

  dimension: message_id {
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: message_name {
    type: string
    sql: ${TABLE}."MESSAGE_NAME" ;;
  }

  dimension: open_rate {
    type: number
    sql: ${TABLE}."OPEN_RATE" ;;
  }

  dimension: opens_total {
    type: number
    sql: ${TABLE}."OPENS_TOTAL" ;;
  }

  dimension: opens_unique {
    type: number
    sql: ${TABLE}."OPENS_UNIQUE" ;;
  }

  dimension: opt_out_rate {
    type: number
    sql: ${TABLE}."OPT_OUT_RATE" ;;
  }

  dimension: opt_outs {
    type: number
    sql: ${TABLE}."OPT_OUTS" ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  dimension_group: sent {
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
    sql: ${TABLE}."SENT_DATE" ;;
  }

  dimension: sent_total {
    type: number
    sql: ${TABLE}."SENT_TOTAL" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: total_purchases {
    type: number
    sql: ${TABLE}."TOTAL_PURCHASES" ;;
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
    drill_fields: [message_name]
  }
}
