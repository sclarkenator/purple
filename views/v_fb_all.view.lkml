view: v_fb_all {
  sql_table_name: "MARKETING"."V_FB_ALL"
    ;;

  dimension_group: _fivetran_synced {
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
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
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

  measure: clicks {
    type: sum
    sql: ${TABLE}."CLICKS" ;;
  }

  measure: conversion_rate_ranking {
    type: number
    hidden: yes
    sql: ${TABLE}."CONVERSION_RATE_RANKING" ;;
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

  measure: engagement_rate_ranking {
    type: number
    hidden: yes
    sql: ${TABLE}."ENGAGEMENT_RATE_RANKING" ;;
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

  measure: purchase_1_dc {
    label: "Purchase 1DC"
    type: sum
    sql: ${TABLE}."PURCHASE_1DC" ;;
  }

  measure: purchase_1_dv {
    label: "Purchase 1DV"
    type: sum
    sql: ${TABLE}."PURCHASE_1DV" ;;
  }

  measure: purchase_28_dc {
    label: "Purchase 28DC"
    type: sum
    sql: ${TABLE}."PURCHASE_28DC" ;;
  }

 measure: purchase_28_dv {
    label: "Purchase 28DV"
    type: sum
    sql: ${TABLE}."PURCHASE_28DV" ;;
  }

 measure: purchase_7_dc {
    label: "Purchase 7DC"
    type: sum
    sql: ${TABLE}."PURCHASE_7DC" ;;
  }

  measure: purchase_7_dv {
    label: "Purchase 7DV"
    type: sum
    sql: ${TABLE}."PURCHASE_7DV" ;;
  }

  measure: purchase_conversion_value_1_dc {
    label: "Purchase Value 1DC"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_1DC" ;;
  }

  measure: purchase_conversion_value_1_dv {
   label: "Purchase Value 1Dv"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_1DV" ;;
  }

  measure: purchase_conversion_value_28_dc {
    label: "Purchase Value 28DC"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_28DC" ;;
  }

  measure: purchase_conversion_value_28_dv {
    label: "Purchase Value 28DV"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_28DV" ;;
  }

  measure: purchase_conversion_value_7_dc {
    label: "Purchase Value 7DC"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DC" ;;
  }

  measure: purchase_conversion_value_7_dv {
    label: "Purchase Value 7DV"
    type: sum
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DV" ;;
  }

  dimension: quality_ranking {
    type: string
    hidden: yes
    sql: ${TABLE}."QUALITY_RANKING" ;;
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

  measure: count {
    hidden: yes
    type: count
    drill_fields: [campaign_name, ad_name, adset_name, account_name]
  }
}
