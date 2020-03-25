view: cordial_message_analytic {
  sql_table_name: "MARKETING"."CORDIAL_MESSAGE_ANALYTIC"
    ;;

  measure: aov {
    type: average
    sql: ${TABLE}."AOV" ;;
  }

  dimension: bounce_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."BOUNCE_RATE" ;;
  }

  measure: bounced_hard {
    type: sum
    sql: ${TABLE}."BOUNCED_HARD" ;;
  }

  measure: bounced_soft {
    type: sum
    sql: ${TABLE}."BOUNCED_SOFT" ;;
  }

  measure: bounced_total {
    type: sum
    sql: ${TABLE}."BOUNCED_TOTAL" ;;
  }

  dimension: click_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."CLICK_RATE" ;;
  }

  measure: click_total {
    type: sum
    sql: ${TABLE}."CLICK_TOTAL" ;;
  }

  measure: clicks_unique {
    type: sum
    sql: ${TABLE}."CLICKS_UNIQUE" ;;
  }

  dimension: complaint_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."COMPLAINT_RATE" ;;
  }

  measure: complaints {
    type: sum
    sql: ${TABLE}."COMPLAINTS" ;;
  }

  dimension: ctor {
    type: number
    sql: ${TABLE}."CTOR" ;;
  }

  dimension: delivered_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."DELIVERED_RATE" ;;
  }

  measure: delivered_total {
    type: sum
    sql: ${TABLE}."DELIVERED_TOTAL" ;;
  }

  dimension: message_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: message_name {
    type: string
    sql: ${TABLE}."MESSAGE_NAME" ;;
  }

  dimension: open_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."OPEN_RATE" ;;
  }

  measure: opens_total {
    type: sum
    sql: ${TABLE}."OPENS_TOTAL" ;;
  }

  measure: opens_unique {
    type: sum
    sql: ${TABLE}."OPENS_UNIQUE" ;;
  }

  dimension: opt_out_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."OPT_OUT_RATE" ;;
  }

  measure: opt_outs {
    type: sum
    sql: ${TABLE}."OPT_OUTS" ;;
  }

  measure: revenue {
    type: sum
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

  measure: sent_total {
    type: sum
    sql: ${TABLE}."SENT_TOTAL" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  measure: total_purchases {
    type: sum
    sql: ${TABLE}."TOTAL_PURCHASES" ;;
  }

  measure: count {
    type: count
  }
}
