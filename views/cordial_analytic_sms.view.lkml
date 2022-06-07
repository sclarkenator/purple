view: cordial_analytic_sms {
  label: "Cordial SMS"
  sql_table_name: "MARKETING"."CORDIAL_ANALYTIC_SMS"
    ;;

########################################################################################
## IDs
########################################################################################


  dimension: message_id {
    primary_key: yes
    hidden: yes
    label: "Message ID"
    group_label: "IDs"
    description: ""
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

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

#####################
# FLAGS
#####################

########################################################################################
## MEASURES / FACTS
########################################################################################

  measure: record_count {
    # hidden: yes
    type: count
    drill_fields: [message_id]
  }

  dimension: aov_dim {
    hidden: yes
    type: number
    sql: ${TABLE}."AOV" ;;
  }

  measure: aov {
    # hidden: yes
    label: "AOV"
    type: average
    value_format: "$#,##0"
    sql: ${aov_dim};;
  }

  dimension: click_rate_dim {
    hidden: yes
    type: number
    sql: ${TABLE}."CLICK_RATE" ;;
  }

  measure: click_rate {
    # hidden: yes
    type: average
    value_format: "0.0\%"
    sql: ${click_rate_dim};;
  }

  dimension: clicks {
    hidden: yes
    type: number
    sql: ${TABLE}."CLICKS_TOTAL" ;;
  }

  measure: total_clicks {
    # hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${clicks};;
  }

  dimension: clicks_unique {
    hidden: yes
    type: number
    sql: ${TABLE}."CLICKS_UNIQUE" ;;
  }

  measure: total_unique_clicks {
    # hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${clicks_unique};;
  }

  dimension: delivered_rate {
    hidden: yes
    type: number
    sql: ${TABLE}."DELIVERED_RATE" ;;
  }

  dimension: delivered_total {
    hidden: yes
    type: number
    sql: ${TABLE}."DELIVERED_TOTAL" ;;
  }

  dimension: revenue {
    hidden: yes
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
  }

  dimension: sent {
    hidden: yes
    type: number
    sql: ${TABLE}."SENT_TOTAL" ;;
  }

  measure: total_sent {
    # hidden: yes
    # label:
    # group_label: "As needed."
    # description: "Calculation is not required. This is already given."
    type: sum
    value_format: "#,##0"
    sql: ${sent};;
  }

  dimension: total_purchases {
    hidden: yes
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
