view: narvar_dashboard_notify_metrics {


  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_NOTIFY_METRICS;;

  dimension: week_of {
    type: date
    sql: ${TABLE}."WEEK_OF" ;;
    primary_key: yes
  }

  measure: accepted_delay_overdue {
    description: "Number of 'Delay Overdue' emails accepted by server (not necessarily opened)"
    type: number
    sql: ${TABLE}."ACCEPTED_DELAY_OVERDUE" ;;
  }

  measure: accepted_delivered_standard{
    description: "Number of 'Delivered Standard' emails accepted by server (not necessarily opened)"
    type: number
    sql: ${TABLE}."ACCEPTED_DELIVERED_STANDARD" ;;
  }

  measure: accepted_delivery_anticipation_standard {
    description: "Number of 'Delivery Anticipation' emails accepted by server (not necessarily opened)"
    type: number
    sql: ${TABLE}."ACCEPTED_DELIVERY_ANTICIPATION_STANDARD" ;;
  }

  measure: accepted_shipment_confirmation_standard {
    description: "Number of 'Shipment Confirmation' emails accepted by server (not necessarily opened)"
    type: sum
    sql: ${TABLE}."ACCEPTED_SHIPMENT_CONFIRMATION_STANDARD" ;;
  }

  measure: click_distribution_tracking {
    description: "Click Distribution on 'Tracking' area of Narvar dashboard"
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_TRACKING" ;;
  }

  measure: click_distribution_marketing {
    description: "Click Distribution on 'Marketing' area of Narvar dashboard"
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_MARKETING" ;;
  }

  measure: click_distribution_footer {
    description: "Click Distribution on 'Footer' area of Narvar dashboard"
    type: number
    sql: ${TABLE}."CLICK_DISTRIBUTION_FOOTER" ;;
  }

  measure: click_through_rate_delay_overdue {
    description: "Click Through Rate from 'Delay Overdue' campaign emails"
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_DELAY_OVERDUE" ;;
  }

  measure: click_through_rate_shipment_confirmation {
    description: "Click Through Rate from 'Shipment Confirmation' campaign emails"
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_SHIPMENT_CONFIRMATION" ;;
  }

  measure: click_through_rate_delivery_anticipation {
    description: "Click Through Rate from 'Delivery Anticipation' campaign emails"
    type: number
    sql: ${TABLE}."CLICK_THROUGH_RATE_DELIVERY_ANTICIPATION" ;;
  }

  measure: click_through_rate_delivered {
    description: "Click Through Rate from 'Delivery' campaign emails"
    type: number
    sql: ${TABLE}."CLICKK_THROUGH_RATE_DELIVERED" ;;
  }

  measure: click_tracking {
    description: "Clicks on 'Tracking' area of Narvar Dashboard"
    type: sum
    sql: ${TABLE}."CLICK_TRACKING" ;;
  }

  measure: click_marketing {
    description: "Clicks on 'Marketing' area of Narvar Dashboard"
    type: sum
    sql: ${TABLE}."CLICK_MARKETING" ;;
  }

  measure: click_footer {
    description: "Clicks on 'Footer' area of Narvar Dashboard"
    type: sum
    sql: ${TABLE}."CLICK_FOOTER" ;;
  }

  measure: click_to_track_page {
    description: "Clicks on 'Tracking' area of Narvar Dashboard that lead to the tracking page"
    type: sum
    sql: ${TABLE}."CLICK_TO_TRACK_PAGE" ;;
  }

  measure: emails_accepted{
    description: "Number of emails accepted by the email server"
    type: number
    sql: ${TABLE}."EMAILS_ACCEPTED" ;;
  }

  measure: open_rate_delay_overdue {
    description: "(Number of opened emails / number of accepted emails) for 'Delay Overdue' email campaign"
    type: average
    sql: ${TABLE}."OPEN_RATE_DELAY_OVERDUE" ;;
  }

  measure: open_rate_shipment_confirmation {
    description: "(Number of opened emails / number of accepted emails) for 'Shipment Confirmation' email campaign"
    type: average
    sql: ${TABLE}."OPEN_RATE_SHIPMENT_CONFIRMATION" ;;
  }

  measure: open_rate_delivery_anticipation{
    description: "(Number of opened emails / number of accepted emails) for 'Delivery Anticipation' email campaign"
    type: average
    sql: ${TABLE}."OPEN_RATE_DELIVERY_ANTICIPATION" ;;
  }

  measure: open_rate_delivered {
    description: "(Number of opened emails / number of accepted emails) for 'Delivered' email campaign"
    type: average
    sql: ${TABLE}."OPEN_RATE_DELIVERED" ;;
  }

  measure: total_click {
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
    hidden: yes
    type: count
  }
 }
