view: fb_attribution {
  sql_table_name: "CSV_UPLOADS"."FB_ATTRIBUTION"
    ;;

  dimension: ad_set_delivery {
    type: string
    sql: ${TABLE}."AD_SET_DELIVERY" ;;
  }

  dimension: ad_set_name {
    type: string
    sql: ${TABLE}."AD_SET_NAME" ;;
  }

  measure: amount_spent {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}."AMOUNT_SPENT" ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension: campaign_type {
    type: string
    sql: case when ${campaign_name} ilike '%-PT-%' then 'Prospecting'
      when ${campaign_name} ilike '%-RT-%' then 'Retargeting'
      when ${campaign_name} ilike '%-RE-%' then 'Reengage'
    end;;
  }

  dimension: product_type {
    type: string
    sql: case when ${ad_set_name} ilike '%_Matt_%' then 'Mattress'
      when ${ad_set_name} ilike '%_Accs_%' then 'Accessories'
      else 'Mattress'
    end;;
  }

  measure: frequency {
    type: sum
    sql: ${TABLE}."FREQUENCY" ;;
  }

  measure: impressions {
    type: sum
    sql: ${TABLE}."IMPRESSIONS" ;;
  }

  measure: link_clicks {
    type: sum
    sql: ${TABLE}."LINK_CLICKS" ;;
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

  measure: CVR_28_day_click{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases}/${link_clicks} ;;
  }

  measure: CVR_1_day_click{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_1_day_click}/${link_clicks} ;;
  }

  measure: CVR_1_day_view{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_1_day_view}/${link_clicks} ;;
  }

  measure: CPA_28_day_click{
    type:  number
    value_format: "$0.00"
    sql:${amount_spent}/${purchases} ;;
  }

  measure: CPA_1_day_click{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/${purchases_1_day_click} ;;
  }

  measure: CPA_1_day_view{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/${purchases_1_day_view} ;;
  }

  measure: purchases_conversion_value {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE" ;;
  }

  measure: purchases_conversion_value_1_day_click {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_CLICK" ;;
  }

  measure: purchases_conversion_value_1_day_view {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_VIEW" ;;
  }

  measure: ROAS_28_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value}/${amount_spent} ;;
  }

  measure: ROAS_1_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value}/${amount_spent} ;;
  }

  measure: ROAS_1_view{
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value}/${amount_spent} ;;
  }

  measure: reach {
    type: sum
    sql: ${TABLE}."REACH" ;;
  }

  dimension_group: reporting_starts {
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
    sql: ${TABLE}."REPORTING_STARTS" ;;
  }

  dimension: result_indicator {
    type: string
    sql: ${TABLE}."RESULT_INDICATOR" ;;
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

  measure: count {
    type: count
    drill_fields: [ad_set_name, campaign_name]
  }
}
