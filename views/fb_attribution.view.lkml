view: fb_attribution {
  sql_table_name: "CSV_UPLOADS"."FB_ATTRIBUTION"
    ;;

  measure: budget {
    type: sum
    sql: ${TABLE}."BUDGET" ;;
  }

  dimension: budget_type {
    type: string
    sql: ${TABLE}."BUDGET_TYPE" ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  measure: clicks {
    type: sum
    sql: ${TABLE}."CLICKS" ;;
  }

  dimension: delivery {
    type: string
    sql: ${TABLE}."DELIVERY" ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}."END_DATE" ;;
  }

  measure: frequency {
    type: sum
    sql: ${TABLE}."FREQUENCY" ;;
  }

  measure: impressions {
    type: sum
    sql: ${TABLE}."IMPRESSIONS" ;;
  }

  dimension: indicator {
    type: string
    sql: ${TABLE}."INDICATOR" ;;
  }

  measure: purchases {
    type: sum
    sql: ${TABLE}."PURCHASES" ;;
  }

  measure: purchases_1_day_click {
    type: sum
    sql: ${TABLE}."PURCHASES_1_DAY_CLICK" ;;
  }

  measure: purchases_1_day_view {
    type: sum
    sql: ${TABLE}."PURCHASES_1_DAY_VIEW" ;;
  }

  measure: purchases_value {
    type: sum
    sql: ${TABLE}."PURCHASES_VALUE" ;;
  }

  measure: purchases_value_1_day_click {
    type: sum
    sql: ${TABLE}."PURCHASES_VALUE_1_DAY_CLICK" ;;
  }

  measure: purchases_value_1_day_view {
    type: sum
    sql: ${TABLE}."PURCHASES_VALUE_1_DAY_VIEW" ;;
  }

  measure: reach {
    type: sum
    sql: ${TABLE}."REACH" ;;
  }

  measure: results {
    type: sum
    sql: ${TABLE}."RESULTS" ;;
  }

  measure: results_1_day_click {
    type: sum
    sql: ${TABLE}."RESULTS_1_DAY_CLICK" ;;
  }

  measure: results_1_day_view {
    type: sum
    sql: ${TABLE}."RESULTS_1_DAY_VIEW" ;;
  }

  measure: results_on_ad {
    type: sum
    sql: ${TABLE}."RESULTS_ON_AD" ;;
  }

  measure: spend {
    type: sum
    sql: ${TABLE}."SPEND" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."START_DATE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
