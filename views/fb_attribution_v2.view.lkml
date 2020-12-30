view: fb_attribution_v2 {
  sql_table_name: "CSV_UPLOADS"."FB_ATTRIBUTION_V2"
    ;;

  dimension: ad_set_budget {
    type: number
    sql: ${TABLE}."AD_SET_BUDGET" ;;
  }

  dimension: ad_set_budget_type {
    type: string
    sql: ${TABLE}."AD_SET_BUDGET_TYPE" ;;
  }

  dimension: amount_spent {
    type: number
    sql: ${TABLE}."AMOUNT_SPENT" ;;
  }

  dimension: campaign_delivery {
    type: string
    sql: ${TABLE}."CAMPAIGN_DELIVERY" ;;
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
    sql: case when ${campaign_name} ilike '%_Matt_%' then 'Mattress'
      when ${campaign_name} ilike '%_Accs_%' then 'Accessories'
      else 'Mattress'
    end;;
  }

  dimension: frequency {
    type: number
    value_format: "0.00"
    sql: ${TABLE}."FREQUENCY" ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}."IMPRESSIONS" ;;
  }

  dimension: link_clicks {
    type: number
    sql: ${TABLE}."LINK_CLICKS" ;;
  }

  dimension: purchases_1_day_click {
    type: number
    sql: ${TABLE}."PURCHASES_1_DAY_CLICK" ;;
  }

  dimension: purchases_1_day_view {
    type: number
    sql: ${TABLE}."PURCHASES_1_DAY_VIEW" ;;
  }

  dimension: purchases_28_day_click {
    type: number
    sql: ${TABLE}."PURCHASES_28_DAY_CLICK" ;;
  }

  dimension: purchases_conversion_value_1_day_click {
    type: number
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_CLICK" ;;
  }

  dimension: purchases_conversion_value_1_day_view {
    type: number
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_VIEW" ;;
  }

  dimension: purchases_conversion_value_28_day_click {
    type: number
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_28_DAY_CLICK" ;;
  }

  measure: CVR_28_day_click{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_28_day_click}/${link_clicks} ;;
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
    sql:${amount_spent}/${purchases_28_day_click} ;;
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
  measure: CPM{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/(${impressions}/1000) ;;
  }
  measure: ROAS_28_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_28_day_click }/${amount_spent} ;;
  }

  measure: ROAS_1_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_1_day_click}/${amount_spent} ;;
  }

  measure: ROAS_1_view{
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_1_day_view}/${amount_spent} ;;
  }

  dimension: reach {
    type: number
    sql: ${TABLE}."REACH" ;;
  }

  dimension_group: reporting_ends {
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
    sql: ${TABLE}."REPORTING_ENDS" ;;
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

  dimension: results_1_day_click {
    type: number
    sql: ${TABLE}."RESULTS_1_DAY_CLICK" ;;
  }

  dimension: results_1_day_view {
    type: number
    sql: ${TABLE}."RESULTS_1_DAY_VIEW" ;;
  }

  dimension: results_28_day_click {
    type: number
    sql: ${TABLE}."RESULTS_28_DAY_CLICK" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
