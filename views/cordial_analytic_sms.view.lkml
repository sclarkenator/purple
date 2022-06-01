view: cordial_analytic_sms {
  sql_table_name: "MARKETING"."CORDIAL_ANALYTIC_SMS"
    ;;

########################################################################################
## PRIMARY KEY
########################################################################################

  dimension: message_id {
    hidden: yes
    label: "Message ID"
    group_label: "IDs"
    description: ""
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

########################################################################################
## IDs
########################################################################################

  dimension: message_key {
    type: string
    sql: ${TABLE}."MESSAGE_KEY" ;;
  }

########################################################################################
## DIMENSIONS
########################################################################################

  dimension: tags {
    type: string
    sql: ${TABLE}."tags" ;;
  }

  dimension: message_name {
    type: string
    sql: ${TABLE}."MESSAGE_NAME" ;;
  }

########################################################################################
# FLAGS
########################################################################################

########################################################################################
## MEASURES / FACTS
########################################################################################

  measure: record_count {
    hidden: yes
    type: count
    drill_fields: [message_id]
  }

  dimension: aov {
    type: number
    sql: ${TABLE}."AOV" ;;
  }

  dimension: click_rate {
    type: number
    sql: ${TABLE}."CLICK_RATE" ;;
  }

  dimension: clicks_total {
    type: number
    sql: ${TABLE}."CLICKS_TOTAL" ;;
  }

  dimension: clicks_unique {
    type: number
    sql: ${TABLE}."CLICKS_UNIQUE" ;;
  }

  dimension: delivered_rate {
    type: number
    sql: ${TABLE}."DELIVERED_RATE" ;;
  }

  dimension: delivered_total {
    type: number
    sql: ${TABLE}."DELIVERED_TOTAL" ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
  }

  dimension: sent_total {
    type: number
    sql: ${TABLE}."SENT_TOTAL" ;;
  }

  dimension: total_purchases {
    type: number
    sql: ${TABLE}."TOTAL_PURCHASES" ;;
  }

########################################################################################
## DRILL DOWNS
########################################################################################

########################################################################################
## DATES
########################################################################################



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
    sql: ${TABLE}.CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_delivered {
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
    sql: ${TABLE}.CAST(${TABLE}."LAST_DELIVERED" AS TIMESTAMP_NTZ) ;;
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
    sql: ${TABLE}.CAST(${TABLE}."SENT_DATE" AS TIMESTAMP_NTZ) ;;
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
    sql: ${TABLE}.CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }
}
