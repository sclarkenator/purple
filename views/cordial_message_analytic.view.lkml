view: cordial_message_analytic {
  sql_table_name: "MARKETING"."CORDIAL_ANALYTIC_EMAIL"
    ;;

  # 5/20/2022 - Updated the source table from analytics.marketing.cordial_message_analytic (old) to analytics.marketing.cordial_message_analytic (old). Since main sales model is being sunsetted we did not update the naming in Looker.

  measure: aov {
    type: average
    sql: ${TABLE}."AOV" ;;
  }

  dimension: bounce_rate_raw {
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

  measure: bounce_rate {
    type: number
    value_format: "0.00%"
    sql: ${bounced_total}/${sent_total} ;;
  }

  dimension: click_rate_raw {
    type: number
    hidden: yes
    sql: ${TABLE}."CLICK_RATE" ;;
  }

  measure: click_rate {
    type: number
    value_format: "0.00%"
    sql: ${click_total}/${sent_total} ;;
  }

  measure: click_total {
    type: sum
    sql: ${TABLE}."CLICK_TOTAL" ;;
  }

  measure: clicks_unique {
    type: sum
    sql: ${TABLE}."CLICKS_UNIQUE" ;;
  }

  dimension: complaint_rate_raw {
    type: number
    hidden: yes
    sql: ${TABLE}."COMPLAINT_RATE" ;;
  }

  measure: complaint_rate {
    type: number
    value_format: "0.00%"
    sql: ${complaints}/${sent_total} ;;
  }

  measure: complaints {
    type: sum
    sql: ${TABLE}."COMPLAINTS" ;;
  }

  dimension: ctor {
    type: number
    sql: ${TABLE}."CTOR" ;;
  }

  dimension: delivered_rate_raw {
    type: number
    hidden: yes
    sql: ${TABLE}."DELIVERED_RATE" ;;
  }

  measure: delivered_rate {
    type: number
    value_format: "0.00%"
    sql: ${delivered_total}/${sent_total} ;;
  }

  measure: delivered_total {
    type: sum
    sql: ${TABLE}."DELIVERED_TOTAL" ;;
  }

  dimension: message_id {
    #hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: type {
    type:  string
    sql:  case when right(${message_id},2) = 'ot' then 'Batch' else 'Automated' end ;;
  }

  dimension: message_name {
    type: string
    sql: ${TABLE}."MESSAGE_NAME" ;;
  }

  dimension: open_rate_raw {
    type: number
    hidden: yes
    sql: ${TABLE}."OPEN_RATE" ;;
  }

  measure: open_rate {
    type: number
    value_format: "0.00%"
    sql: ${opens_unique}/${sent_total} ;;
  }

  measure: opens_total {
    type: sum
    sql: ${TABLE}."OPENS_TOTAL" ;;
  }

  measure: opens_unique {
    type: sum
    sql: ${TABLE}."OPENS_UNIQUE" ;;
  }

  dimension: opt_out_rate_raw {
    type: number
    hidden: yes
    sql: ${TABLE}."OPT_OUT_RATE" ;;
  }

  measure: opt_out_rate {
    type: number
    value_format: "0.00%"
    sql: ${opt_outs}/${sent_total} ;;
  }


  measure: opt_outs {
    type: sum
    sql: ${TABLE}."OPT_OUTS" ;;
  }

  measure: revenue {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."REVENUE" ;;
  }

  measure: revenue_send {
    label: "Revenue per Send"
    type: number
    value_format: "$0.00"
    sql: ${revenue}/${sent_total} ;;
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

  measure: purchase_rate {
    type: number
    value_format: "0.00%"
    sql: ${total_purchases}/${sent_total} ;;
  }

  measure: count {
    type: count
  }
}
