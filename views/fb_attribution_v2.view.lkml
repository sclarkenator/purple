view: fb_attribution_v2 {
  sql_table_name: "CSV_UPLOADS"."FB_ATTRIBUTION_V2"
    ;;



  dimension: ad_set_budget_type {
    type: string
    sql: ${TABLE}."AD_SET_BUDGET_TYPE" ;;
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

  measure: ad_set_budget {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."AD_SET_BUDGET" ;;
  }

  measure: amount_spent {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."AMOUNT_SPENT" ;;
  }

  measure: frequency {
    type: sum
    value_format: "0.00"
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

 measure: purchases_1_day_click {
    type: sum
    sql: ${TABLE}."PURCHASES_1_DAY_CLICK" ;;
  }

 measure: purchases_1_day_view {
    type: sum
    sql: ${TABLE}."PURCHASES_1_DAY_VIEW" ;;
  }

  measure: purchases_28_day_click {
    type: sum
    sql: ${TABLE}."PURCHASES_28_DAY_CLICK" ;;
  }

  measure: purchases_conversion_value_1_day_click {
    type: sum
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_CLICK" ;;
  }

  measure: purchases_conversion_value_1_day_view {
    type: sum
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_1_DAY_VIEW" ;;
  }

  measure: purchases_conversion_value_28_day_click {
    type: sum
    value_format:  "$#,##0.00"
    sql: ${TABLE}."PURCHASES_CONVERSION_VALUE_28_DAY_CLICK" ;;
  }

  measure: CVR_28_day_click{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_28_day_click}/NULLIF(${link_clicks},0) ;;
  }

  measure: CVR_1_day_click{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_1_day_click}/NULLIF(${link_clicks},0) ;;
  }

  measure: CVR_1_day_view{
    type:  number
    value_format: "0.0%"
    sql:  ${purchases_1_day_view}/NULLIF(${link_clicks},0) ;;
  }

  measure: CPA_28_day_click{
    type:  number
    value_format: "$0.00"
    sql:${amount_spent}/NULLIF(${purchases_28_day_click},0) ;;
  }

  measure: CPA_1_day_click{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/NULLIF(${purchases_1_day_click},0) ;;
  }

  measure: CPA_1_day_view{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/NULLIF(${purchases_1_day_view},0) ;;
  }
  measure: CPM{
    type:  number
    value_format: "$0.00"
    sql:  ${amount_spent}/NULLIF((${impressions}/1000),0) ;;
  }
  measure: ROAS_28_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_28_day_click}/NULLIF(${amount_spent},0) ;;
  }

  measure: ROAS_1_click {
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_1_day_click}/NULLIF(${amount_spent},0) ;;
  }

  measure: ROAS_1_view{
    type: number
    value_format: "$0.00"
    sql: ${purchases_conversion_value_1_day_view}/NULLIF(${amount_spent},0) ;;
  }

  measure: reach {
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
