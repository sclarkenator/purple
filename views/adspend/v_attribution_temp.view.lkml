view: v_attribution_temp {
  sql_table_name: "MARKETING"."V_ATTRIBUTION_TEMP"
    ;;

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }


  measure: conversion_value {
    type: sum
    sql: ${TABLE}."CONVERSION_VALUE" ;;
  }

  dimension: data_source {
    type: string
    sql: ${TABLE}."DATA_SOURCE" ;;
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

  measure: ft_sales {
    type: sum
    sql: ${TABLE}."FT_SALES" ;;
  }

  measure: lt_sales {
    type: sum
    sql: ${TABLE}."LT_SALES" ;;
  }

  measure: mt_sales {
    type: sum
    sql: ${TABLE}."MT_SALES" ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}."PLATFORM" ;;
  }

  measure: sessions {
    type: sum
    sql: ${TABLE}."SESSIONS" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  measure: spend {
    type: sum
    sql: ${TABLE}."SPEND" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
