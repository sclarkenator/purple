include: "/views/_period_comparison.view.lkml"
view: v_fb_all {
  sql_table_name: "MARKETING"."V_FB_ALL" ;;
  extends: [_period_comparison]


#### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,week,
      month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }


  dimension: account_id {
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."ACCOUNT_NAME" ;;
  }

  dimension: ad_id {
    type: string
    sql: ${TABLE}."AD_ID" ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}."AD_NAME" ;;
  }

  dimension: adset_id {
    type: number
    sql: ${TABLE}."ADSET_ID" ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}."ADSET_NAME" ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension: impression_device {
    type: string
    sql: ${TABLE}."IMPRESSION_DEVICE" ;;
  }

  dimension: publisher_platform {
    type: string
    sql: ${TABLE}."PUBLISHER_PLATFORM" ;;
  }

  dimension: platform_position {
    type: string
    sql: ${TABLE}."PLATFORM_POSITION" ;;
  }

  measure: clicks {
    type: sum
    sql: ${TABLE}."CLICKS" ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}."DATE" ;;
  }

  measure: estimated_ad_recall_rate {
    type: number
    hidden: yes
    sql: ${TABLE}."ESTIMATED_AD_RECALL_RATE" ;;
  }

  measure: estimated_ad_recallers {
    type: number
    hidden: yes
    sql: ${TABLE}."ESTIMATED_AD_RECALLERS" ;;
  }

  measure: full_view_impressions {
    label: "Full Impressions"
    hidden:  yes
    type: sum
    sql: ${TABLE}."FULL_VIEW_IMPRESSIONS" ;;
  }

 measure: full_view_reach {
    label: "Full Reach"
    hidden: yes
    type: sum
    sql: ${TABLE}."FULL_VIEW_REACH" ;;
  }

  measure: impressions {
    label: "Impressions"
    type: sum
    sql: ${TABLE}."IMPRESSIONS" ;;
  }

  measure: inline_link_clicks {
    label: "Link Clicks"
    type: sum
    sql: ${TABLE}."INLINE_LINK_CLICKS" ;;
  }

  measure: inline_post_engagement {
    label: "Inline Post Engmt"
    type: sum
    sql: ${TABLE}."INLINE_POST_ENGAGEMENT" ;;
  }

  dimension: objective {
    type: string
    sql: ${TABLE}."OBJECTIVE" ;;
  }

  measure: landing_page_views {
    label: "Landing Page Views"
    type: sum
    sql: ${TABLE}."LANDING_PAGE_VIEWS" ;;
  }

  measure: purchase_1_dc {
    label: "Purchases 1DC"
    type: sum
    sql: ${TABLE}."PURCHASE_1DC" ;;
  }

  measure: purchase_1_dv {
    label: "Purchases 1DV"
    type: sum
    sql: ${TABLE}."PURCHASE_1DV" ;;
  }

  measure: purchase_28_dc {
    label: "Purchases 28DC"
    type: sum
    sql: ${TABLE}."PURCHASE_28DC" ;;
  }

 measure: purchase_28_dv {
    label: "Purchases 28DV"
    type: sum
    sql: ${TABLE}."PURCHASE_28DV" ;;
  }

 measure: purchase_7_dc {
    label: "Purchases 7DC"
    type: sum
    sql: ${TABLE}."PURCHASE_7DC" ;;
  }

  measure: purchase_7_dv {
    label: "Purchases 7DV"
    type: sum
    sql: ${TABLE}."PURCHASE_7DV" ;;
  }

  measure: purchase_conversion_value_1_dc {
    label: "Purchases Value 1DC"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_1DC" ;;
  }

  measure: purchase_conversion_value_1_dv {
   label: "Purchase Value 1DV"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_1DV"  ;;
  }

  measure: purchase_conversion_value_28_dc {
    label: "Purchase Value 28DC"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_28DC" ;;
  }

  measure: purchase_conversion_value_28_dv {
    label: "Purchase Value 28DV"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_28DV" ;;
  }

  measure: purchase_conversion_value_7_dc {
    label: "Purchase Value 7DC"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DC" ;;
  }

  measure: purchase_conversion_value_7_dv {
    label: "Purchase Value 7DV"
    value_format: "$#,##0.00"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DV" ;;
  }

  measure: reach {
    label: "Reach"
    type: sum
    sql: ${TABLE}."REACH" ;;
  }

  measure: spend {
    label: "Spend"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."SPEND" ;;
  }

  measure: unique_clicks {
    label: "Unique Clicks"
    type: sum
    sql: ${TABLE}."UNIQUE_CLICKS" ;;
  }
  measure: cpm {
    label: "CPM"
    description: "Adspend / Total impressions/1000"
    type: number
    value_format: "$0.00"
    sql: ${spend}/NULLIF((${impressions}/1000),0);;
  }
  measure: ROAS_28DC{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_28_dc}/NULLIF(${spend},0);;

  }
  measure: ROAS_28DV{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_28_dv}/NULLIF(${spend},0);;

  }
  measure: ROAS_7DC{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_7_dc}/NULLIF(${spend},0);;

  }
  measure: ROAS_7DV{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_7_dv}/NULLIF(${spend},0);;

  }
  measure: ROAS_1DC{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_1_dc}/NULLIF(${spend},0);;

  }
  measure: ROAS_1DC_1DV{
    type: number
    value_format: "$0.00"
    sql:(${purchase_conversion_value_1_dc}+ ${purchase_conversion_value_1_dv})/NULLIF(${spend},0);;
  }
  measure: ROAS_1DV{
    type: number
    value_format: "$0.00"
    sql: ${purchase_conversion_value_1_dv}/NULLIF(${spend},0);;
  }
  measure: CVR_28DC{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_28_dc}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CVR_28DV{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_28_dv}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CVR_7DC{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_7_dc}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CVR_7DV{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_7_dv}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CVR_1DC{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_1_dc}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CVR_1DV{
    description: "Conversion rate"
    type: number
    value_format: "0.0%"
    sql:  ${purchase_1_dv}/NULLIF(${inline_link_clicks},0);;
  }
  measure: CPA_28DC{
    type: number
    value_format: "$0.00"
    sql: ${spend}/NULLIF(${purchase_28_dc},0);;

  }
  measure: CPA_28DV{
    type: number
    value_format: "$0.00"
    sql: ${spend}/NULLIF(${purchase_28_dv},0);;
  }
  measure: CPA_7DC{
    type: number
    value_format: "$0.00"
    sql: ${purchase_7_dc}/NULLIF(${spend},0);;
  }
  measure: CPA_7DV{
    type: number
    value_format: "$0.00"
    sql: ${purchase_7_dv}/NULLIF(${spend},0);;
  }
  measure: CPA_1DC{
    type: number
    value_format: "$0.00"
    sql: ${purchase_1_dc}/NULLIF(${spend},0);;
  }
  measure: CPA_1DV{
    type: number
    value_format: "$0.00"
    sql: ${purchase_1_dv}/NULLIF(${spend},0);;
  }
  measure: count {
    hidden: yes
    type: count
    drill_fields: [campaign_name, ad_name, adset_name, account_name]
  }
}
