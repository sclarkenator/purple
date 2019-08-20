view: narvar_dashboard_notify_metrics {


  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_NOTIFY_METRICS;;

  dimension: week_of {
    type: date
    sql: ${TABLE}."WEEK_OF" ;;
    primary_key: yes
  }

  dimension: accepted_delay_overdue {
    type: number
    sql: ${TABLE}."ACCEPTED_DELAY_OVERDUE" ;;
  }

  dimension: accepted_delivered_standard{
    type: number
    sql: ${TABLE}."ACCEPTED_DELIVERED_STANDARD" ;;
  }

  dimension: accepted_delivery_anticipation_standard {
    type: number
    sql: ${TABLE}."ACCEPTED_DELIVERY_ANTICIPATION_STANDARD" ;;
  }

  dimension: accepted_shipment_confirmation_standard {
    type: number
    sql: ${TABLE}."ACCEPTED_SHIPMENT_CONFIRMATION_STANDARD" ;;
  }

  dimension: click_distribution_tracking {
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_TRACKING" ;;
  }

  dimension: click_distribution_marketing {
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_MARKETING" ;;
  }

  dimension: click_distribution_footer {
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_FOOTER" ;;
  }

  dimension: click_through_rate_delay_overdue {
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_DELAY_OVERDUE" ;;
  }

  dimension: click_through_rate_shipment_confirmation {
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_SHIPMENT_CONFIRMATION" ;;
  }

  dimension: click_through_rate_delivery_anticipation {
    type: number
    sql: ${TABLE}."CLICK_THROUGH_RATE_DELIVERY_ANTICIPATION" ;;
  }

  dimension: click_through_rate_delivered {
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_DELIVERED" ;;
  }

  dimension: click_tracking {
    type: number
    sql: ${TABLE}."CLICK_TRACKING" ;;
  }

  dimension: click_marketing {
    type: number
    sql: ${TABLE}."CLICK_MARKETING" ;;
  }

  dimension: click_footer {
    type: number
    sql: ${TABLE}."CLICK_FOOTER" ;;
  }

  dimension: click_to_track_page {
    type: number
    sql: ${TABLE}."CLICK_TO_TRACK_PAGE" ;;
  }

  dimension: emails_accepted{
    type: number
    sql: ${TABLE}."EMAILS_ACCEPTED" ;;
  }

  measure: open_rate_delay_overdue {
    type: average
    sql: ${TABLE}."OPEN_RATE_DELAY_OVERDUE" ;;
  }

  measure: open_rate_shipment_confirmation {
    type: average
    sql: ${TABLE}."OPEN_RATE_SHIPMENT_CONFIRMATION" ;;
  }

  measure: open_rate_delivery_anticipation{
    type: average
    sql: ${TABLE}."OPEN_RATE_DELIVERY_ANTICIPATION" ;;
  }

  measure: open_rate_delivered {
    type: average
    sql: ${TABLE}."OPEN_RATE_DELIVERED" ;;
  }

  dimension: total_click {
    type: number
    sql: ${TABLE}."TOTAL_CLICK" ;;
  }





  dimension_group: insert_ts {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."INSERT_TS" ;;

  }

  measure: count {
    type: count
  }



 }
