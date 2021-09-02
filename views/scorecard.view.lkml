view: scorecard {
  sql_table_name:"DATAGRID"."SCRATCH"."SCORECARD"
    ;;

  dimension: aov {
    type: number
    sql: ${TABLE}."AOV" ;;
  }

   measure: aov_score {
    type: sum
    sql: ${TABLE}."AOV_SCORE" ;;
  }

   dimension: bounce_rate {
    type: number
    sql: ${TABLE}."BOUNCE_RATE" ;;
  }

  measure: bounce_rate_score {
    type: sum
    sql: ${TABLE}."BOUNCE_RATE_SCORE" ;;
  }

   dimension: clicks {
    type: number
    sql: ${TABLE}."CLICKS" ;;
  }

  dimension: conversion_value {
    type: number
    sql: ${TABLE}."CONVERSION_VALUE" ;;
  }

   dimension: cpc {
    type: number
    sql: ${TABLE}."CPC" ;;
  }

  measure: cpc_score {
    type: sum
    sql: ${TABLE}."CPC_SCORE" ;;
  }

  dimension: cpm {
    type: number
    sql: ${TABLE}."CPM" ;;
  }

  measure: cpm_score {
    type: sum
    sql: ${TABLE}."CPM_SCORE" ;;
  }

  dimension: ctr {
    type: number
    sql: ${TABLE}."CTR" ;;
  }

   measure: ctr_score {
    type: sum
    sql: ${TABLE}."CTR_SCORE" ;;
  }

  measure: cv_max {
    type: number
    sql: ${TABLE}."CV_MAX" ;;
  }

   measure: cv_min {
    type: number
    sql: ${TABLE}."CV_MIN" ;;
  }

   measure: cv_roas {
    type: number
    sql: ${TABLE}."CV_ROAS" ;;
  }

   measure: cv_roas_score {
    type: sum
    sql: ${TABLE}."CV_ROAS_SCORE" ;;
  }

  measure: ft_max {
    type: number
    sql: ${TABLE}."FT_MAX" ;;
  }

  measure: ft_min {
    type: number
    sql: ${TABLE}."FT_MIN" ;;
  }

  measure: ft_roas {
    type: number
    sql: ${TABLE}."FT_ROAS" ;;
  }

  measure: ft_roas_score {
    type: sum
    sql: ${TABLE}."FT_ROAS_SCORE" ;;
  }

  measure: ft_sales {
    type: number
    sql: ${TABLE}."FT_SALES" ;;
  }

  measure: imp {
    type: number
    sql: ${TABLE}."IMP" ;;
  }

  measure: lt_margin {
    type: number
    sql: ${TABLE}."LT_MARGIN" ;;
  }

  measure: lt_margin_roas {
    type: number
    sql: ${TABLE}."LT_MARGIN_ROAS" ;;
  }

  measure: lt_max {
    type: number
    sql: ${TABLE}."LT_MAX" ;;
  }

  measure: lt_min {
    type: number
    sql: ${TABLE}."LT_MIN" ;;
  }

  measure: lt_roas {
    type: number
    sql: ${TABLE}."LT_ROAS" ;;
  }

  measure: lt_roas_score {
    type: sum
    sql: ${TABLE}."LT_ROAS_SCORE" ;;
  }

  measure: lt_sales {
    type: number
    sql: ${TABLE}."LT_SALES" ;;
  }

  measure: margin_max {
    type: number
    sql: ${TABLE}."MARGIN_MAX" ;;
  }

   measure: margin_min {
    type: number
    sql: ${TABLE}."MARGIN_MIN" ;;
  }

  measure: margin_roas_score {
    type: sum
    sql: ${TABLE}."MARGIN_ROAS_SCORE" ;;
  }

   measure: mattress_percent_score {
    type: sum
    sql: ${TABLE}."MATTRESS_PERCENT_SCORE" ;;
  }

  measure: max_aov {
    type: number
    sql: ${TABLE}."MAX_AOV" ;;
  }

  measure: max_bounce {
    type: number
    sql: ${TABLE}."MAX_BOUNCE" ;;
  }

  measure: max_cpc {
    type: number
    sql: ${TABLE}."MAX_CPC" ;;
  }

  measure: max_cpm {
    type: number
    sql: ${TABLE}."MAX_CPM" ;;
  }

  measure: max_ctr {
    type: number
    sql: ${TABLE}."MAX_CTR" ;;
  }

  measure: max_percent_mattresss {
    type: number
    sql: ${TABLE}."MAX_PERCENT_MATTRESSS" ;;
  }

  measure: max_sessions {
    type: number
    sql: ${TABLE}."MAX_SESSIONS" ;;
  }

  dimension: medium {
    type: string
    sql: ${TABLE}."MEDIUM" ;;
  }

   measure: min_aov {
    type: number
    sql: ${TABLE}."MIN_AOV" ;;
  }

  measure: min_bounce {
    type: number
    sql: ${TABLE}."MIN_BOUNCE" ;;
  }

  measure: min_cpc {
    type: number
    sql: ${TABLE}."MIN_CPC" ;;
  }

  dimension: min_cpm {
    type: number
    sql: ${TABLE}."MIN_CPM" ;;
  }

  dimension: min_ctr {
    type: number
    sql: ${TABLE}."MIN_CTR" ;;
  }

  dimension: min_percent_mattresss {
    type: number
    sql: ${TABLE}."MIN_PERCENT_MATTRESSS" ;;
  }

  dimension: min_sessions {
    type: number
    sql: ${TABLE}."MIN_SESSIONS" ;;
  }

  dimension: mt_max {
    type: number
    sql: ${TABLE}."MT_MAX" ;;
  }

  dimension: mt_min {
    type: number
    sql: ${TABLE}."MT_MIN" ;;
  }

  dimension: mt_roas {
    type: number
    sql: ${TABLE}."MT_ROAS" ;;
  }

  measure: mt_roas_score {
    type: sum
    sql: ${TABLE}."MT_ROAS_SCORE" ;;
  }

  dimension: mt_sales {
    type: number
    sql: ${TABLE}."MT_SALES" ;;
  }

  dimension_group: mth {
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
    sql: ${TABLE}."MTH" ;;
  }

  dimension: normalized_aov {
    type: number
    sql: ${TABLE}."NORMALIZED_AOV" ;;
  }

  dimension: normalized_bounce {
    type: number
    sql: ${TABLE}."NORMALIZED_BOUNCE" ;;
  }

  dimension: normalized_cpc {
    type: number
    sql: ${TABLE}."NORMALIZED_CPC" ;;
  }

  dimension: normalized_cpm {
    type: number
    sql: ${TABLE}."NORMALIZED_CPM" ;;
  }

  dimension: normalized_ctr {
    type: number
    sql: ${TABLE}."NORMALIZED_CTR" ;;
  }

  dimension: normalized_cv_roas {
    type: number
    sql: ${TABLE}."NORMALIZED_CV_ROAS" ;;
  }

  dimension: normalized_ft_roas {
    type: number
    sql: ${TABLE}."NORMALIZED_FT_ROAS" ;;
  }

  dimension: normalized_lt_roas {
    type: number
    sql: ${TABLE}."NORMALIZED_LT_ROAS" ;;
  }

  dimension: normalized_margin_roas {
    type: number
    sql: ${TABLE}."NORMALIZED_MARGIN_ROAS" ;;
  }

  dimension: normalized_mt_roas {
    type: number
    sql: ${TABLE}."NORMALIZED_MT_ROAS" ;;
  }

  dimension: normalized_percent_mattresss {
    type: number
    sql: ${TABLE}."NORMALIZED_PERCENT_MATTRESSS" ;;
  }

  dimension: normalized_sessions {
    type: number
    sql: ${TABLE}."NORMALIZED_SESSIONS" ;;
  }

  dimension: percent_mattresss {
    type: number
    sql: ${TABLE}."PERCENT_MATTRESSS" ;;
  }

  measure: session_score {
    type: sum
    sql: ${TABLE}."SESSION_SCORE" ;;
  }

  dimension: spend {
    type: number
    sql: ${TABLE}."SPEND" ;;
  }

  dimension: total_sessions {
    type: number
    sql: ${TABLE}."TOTAL_SESSIONS" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

  measure: value{
    type: number
    sql: ${lt_roas_score}+${aov_score}+${cpc_score}+
    ${ctr_score}+${cpm_score}+${session_score}+
    ${margin_roas_score}+${ft_roas_score}+${mt_roas_score};;
  }
  measure: website{
    type: number
    sql: ${aov_score}+${session_score}+${bounce_rate_score} ;;
  }
  measure: total_score{
    type: number
    sql: ${value}+${website};;
  }
}
