view: c3_conversion {
  sql_table_name: MARKETING.C3_CONVERSION ;;

  dimension: key {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${order_id} || ${position}  ;;
  }

  dimension: ad {
    type: string
    hidden: yes
    sql: ${TABLE}."AD" ;;
  }

  dimension: ad_id {
    type: string
    hidden: yes
    sql: ${TABLE}."AD_ID" ;;
  }

  dimension: ad_size {
    type: string
    hidden: yes
    sql: ${TABLE}."AD_SIZE" ;;
  }

  dimension: advertiser {
    type: string
    hidden: yes
    sql: ${TABLE}."ADVERTISER" ;;
  }

  dimension: attribution_dim {
    type: number
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}."CREATIVE" ;;
  }

  dimension: group_name {
    type: string
    sql: ${TABLE}."GROUP_NAME" ;;
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

  dimension: sale_amount_dim {
    type: number
    sql: ${TABLE}."SALE_AMOUNT" ;;
  }

  dimension: touchpoint_type {
    type: string
    sql: ${TABLE}."TOUCHPOINT_TYPE" ;;
  }

  dimension: next_door {
    type: yesno
    sql: ${referring_id} ilike ('%nextdoor%') ;;
  }

  measure: attribution {
    type: sum
    sql: ${TABLE}."ATTRIBUTION" ;;
  }

  measure: converter {
    description: "Count of orders by the last touch"
    type: sum
    sql: case when ${position_name} = 'CONVERTER' then 1 else 0 end ;;
  }

  measure: orders {
    description: "Count of Distinct orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension: network_1 {
    description: "First part of network Name"
    type: string
    sql: ${TABLE}."NETWORK_1" ;;
  }

}
