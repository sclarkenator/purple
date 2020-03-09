view: narvar_dashboard_track_metrics {


  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_TRACK_METRICS;;

  dimension: created {
    type: date
    sql: ${TABLE}."CREATED" ;;
    primary_key: yes
    hidden: no
  }

  dimension: average_feedback_rating {
    type: number
    sql: ${TABLE}."AVERAGE_FEEDBACK_RATING" ;;
  }

  dimension: avg_feedback_score_created_week {
    type: date
    hidden: yes
    sql: ${TABLE}."AVG_FEEDBACK_SCORE_CREATED_WEEK" ;;
  }

  dimension: average_feedback_score{
    type: number
    sql: ${TABLE}."AVERAGE_FEEDBACK_SCORE" ;;
  }

  dimension: contact_clicks {
    description: "Number of clicks on 'contact us' area of Narvar Dashboard"
    type: number
    sql: ${TABLE}."CONTACT_CLICKS" ;;
  }

  dimension: contact_clicks_trend {
    hidden: yes
    type: number
    sql: ${TABLE}."CONTACT_CLICKS_TREND" ;;
  }

  dimension: device_share_over_time_desktop {
    type: number
    sql: ${TABLE}."DEVICE_SHARE_OVER_TIME_DESKTOP" ;;
  }

  dimension: device_share_over_time_mobile {
    type: number
    sql: ${TABLE}."DEVICE_SHARE_OVER_TIME_MOBILE" ;;
  }

  dimension: engagement {
    type: number
    sql: ${TABLE}."ENGAGEMENT" ;;
  }

  dimension: fb_opt_in_rate {
    type: number
    sql: ${TABLE}."FB_OPT_IN_RATE" ;;
  }

  dimension: fb_opt_ins {
    type: number
    sql: ${TABLE}."FB_OPT_INS" ;;
  }

  dimension: marketing_clicks {
    type: number
    sql: ${TABLE}."MARKETING_CLICKS" ;;
  }

  dimension: marketing_clicks_breakdown_link_id {
    type: number
    sql: ${TABLE}."MARKETING_CLICKS_BREAKDOWN_LINK_ID" ;;
  }

  dimension: marketing_clicks_breakdown_marketing {
    type: number
    sql: ${TABLE}."MARKETING_CLICKS_BREAKDOWN_MARKETING" ;;
  }

  dimension: marketing_clicks_breakdown_navigation {
    type: number
    sql: ${TABLE}."MARKETING_CLICKS_BREAKDOWN_NAVIGATION" ;;
  }

  dimension: marketing_ctr {
    type: number
    sql: ${TABLE}."MARKETING_CTR" ;;
  }

  dimension: mobile_share_desktop {
    type: number
    sql: ${TABLE}."MOBILE_SHARE_DESKTOP" ;;
  }

  dimension: mobile_share_mobile{
    type: number
    sql: ${TABLE}."MOBILE_SHARE_MOBILE" ;;
  }

  dimension: sms_opt_in_rate{
    type: number
    sql: ${TABLE}."SMS_OPT_IN_RATE" ;;
  }

  dimension: sms_opt_ins {
    type: number
    sql: ${TABLE}."SMS_OPT_INS" ;;
  }

  measure: total_visits{
    type: sum
    sql: ${TABLE}."TOTAL_VISITS" ;;
  }

  dimension: unique_tracking_ids {
    type: number
    sql: ${TABLE}."UNIQUE_TRACKING_IDS" ;;
  }

  measure: visits_by_status_just_shipped {
    description: "Count of visits by shipmenet status: 'Just Shipped'"
    type: sum
    sql: ${TABLE}."VISITS_BY_STATUS_JUST_SHIPPED" ;;
  }

  dimension: visits_by_status_in_transit {
    description: "Count of visits by shipmenet status: 'In Transit'"
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_IN_TRANSIT" ;;
  }
  dimension: visits_by_status_exception {
    description: "Count of visits by shipmenet status: 'Exception'"
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_EXCEPTION" ;;
  }
  dimension: visits_by_status_delivered {
    description: "Count of visits by shipmenet status: 'Delivered'"
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_DELIVERED" ;;
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
