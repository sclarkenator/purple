view: c3_conversion {
  sql_table_name: MARKETING.C3_CONVERSION ;;

  dimension: ad {
    type: string
    sql: ${TABLE}."AD" ;;
  }

  dimension: ad_id {
    type: string
    sql: ${TABLE}."AD_ID" ;;
  }

  dimension: ad_size {
    type: string
    sql: ${TABLE}."AD_SIZE" ;;
  }

  dimension: advertiser {
    type: string
    sql: ${TABLE}."ADVERTISER" ;;
  }

  dimension: attribution {
    type: number
    sql: ${TABLE}."ATTRIBUTION" ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: conversion_type {
    type: string
    sql: ${TABLE}."CONVERSION_TYPE" ;;
  }

  dimension: creative {
    type: string
    sql: ${TABLE}."CREATIVE" ;;
  }

  dimension: group_name {
    type: string
    sql: ${TABLE}."GROUP_NAME" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: is_brand {
    type: string
    sql: ${TABLE}."IS_BRAND" ;;
  }

  dimension: network_name {
    type: string
    sql: ${TABLE}."NETWORK_NAME" ;;
  }

  dimension: new_customer {
    type: string
    sql: ${TABLE}."NEW_CUSTOMER" ;;
  }

  dimension_group: order_created {
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
    sql: ${TABLE}."ORDER_CREATED" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    primary_key: yes
  }

  dimension: placement {
    type: string
    sql: ${TABLE}."PLACEMENT" ;;
  }

  dimension: position {
    type: number
    sql: ${TABLE}."POSITION" ;;
  }

  dimension_group: position_created {
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
    sql: ${TABLE}."POSITION_CREATED" ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}."POSITION_NAME" ;;
  }

  dimension: referring_id {
    type: string
    sql: ${TABLE}."REFERRING_ID" ;;
  }

  dimension: sale_amount {
    type: number
    sql: ${TABLE}."SALE_AMOUNT" ;;
  }

  dimension: touchpoint_type {
    type: string
    sql: ${TABLE}."TOUCHPOINT_TYPE" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: [position_name, group_name, network_name]
  }
}
