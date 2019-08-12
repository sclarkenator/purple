view: narvar_dashboard_track_metrics {


  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_TRACK_METRICS;;

  dimension: created {
    type: date
    sql: ${TABLE}."CREATED" ;;
    primary_key: yes
  }


  dimension: average_feedback_rating {
    type: number
    sql: ${TABLE}."AVERAGE_FEEDBACK_RATING" ;;

  }

  dimension: avg_feedback_score_created_week {
    type: date
    sql: ${TABLE}."AVG_FEEDBACK_SCORE_CREATED_WEEK" ;;
  }

  dimension: average_feedback_score{
    type: number
    sql: ${TABLE}."AVERAGE_FEEDBACK_SCORE" ;;
  }

  dimension: contact_clicks {
    type: number
    sql: ${TABLE}."CONTACT_CLICKS" ;;
  }

  dimension: contact_clicks_trend {
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

  dimension: total_visits{
    type: number
    sql: ${TABLE}."TOTAL_VISITS" ;;
  }

  dimension: unique_tracking_ids {
    type: number
    sql: ${TABLE}."UNIQUE_TRACKING_IDS" ;;
  }

  dimension: visits_by_status_just_shipped {
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_JUST_SHIPPED" ;;
  }

  dimension: visits_by_status_in_transit {
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_IN_TRANSIT" ;;
  }
  dimension: visits_by_status_exception {
    type: number
    sql: ${TABLE}."VISITS_BY_STATUS_EXCEPTION" ;;
  }
  dimension: visits_by_status_delivered {
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
    type: count
  }
 }
