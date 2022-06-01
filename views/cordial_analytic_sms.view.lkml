# The name of this view in Looker is "Cordial Analytic Sms"
view: cordial_analytic_sms {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "MARKETING"."CORDIAL_ANALYTIC_SMS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Aov" in Explore.

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

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: message_id {
    type: string
    sql: ${TABLE}."MESSAGE_ID" ;;
  }

  dimension: message_key {
    type: string
    sql: ${TABLE}."MESSAGE_KEY" ;;
  }

  dimension: message_name {
    type: string
    sql: ${TABLE}."MESSAGE_NAME" ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
  }

  measure: average_revenue {
    type: average
    sql: ${revenue} ;;
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

  dimension: sent_total {
    type: number
    sql: ${TABLE}."SENT_TOTAL" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."tags" ;;
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
    sql: ${TABLE}.CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [message_name]
  }
}
