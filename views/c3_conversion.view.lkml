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

  dimension: network_groupname {
    type: string
    sql: lower(concat(${TABLE}."NETWORK_NAME",${TABLE}."GROUP_NAME")) ;;
  }
  dimension: Platform_clean {
    type: string
    sql: CASE
    WHEN CONTAINS(${network_groupname},'acuity') then 'Acuity'
    WHEN CONTAINS(${network_groupname},'adlingo') then 'Adlingo'
    WHEN CONTAINS(${network_groupname},'admarketplace') then 'Admarketplace'
    WHEN CONTAINS(${network_groupname},'admedia') then 'Admedia'
    WHEN CONTAINS(${network_groupname},'agility') then 'Agility'
    WHEN CONTAINS(${network_groupname},'amazon') then 'Amazon'
    WHEN CONTAINS(${network_groupname},'bing') then 'Bing'
    WHEN CONTAINS(${network_groupname},'brave') then 'Brave'
    WHEN CONTAINS(${network_groupname},'blog') then 'Blog'
    WHEN CONTAINS(${network_groupname},'cordless') then 'Cordless'
    WHEN CONTAINS(${network_groupname},'duckduck') then 'DuckDuckGo'
    WHEN CONTAINS(${network_groupname},'ebay') then 'Ebay'
    WHEN CONTAINS(${network_groupname},'email') then 'Email'
    WHEN CONTAINS(${network_groupname},'exponential') then 'VDX'
    WHEN CONTAINS(${network_groupname},'(fb)')
    OR CONTAINS(${network_groupname},'facebook') then 'FB/IG'
    WHEN CONTAINS(${network_groupname},'google')
    OR CONTAINS(${network_groupname},'gdn')
    OR CONTAINS(${network_groupname},'(3859)') then 'Google'
    WHEN CONTAINS(${network_groupname},'hulu') then 'Hulu'
    WHEN CONTAINS(${network_groupname},'impact radius') then 'Impact Radius'
    WHEN CONTAINS(${network_groupname},'linkedin') then 'LinkedIn'
    WHEN CONTAINS(${network_groupname},'nextdoor') then 'Nextdoor'
    WHEN CONTAINS(${network_groupname},'organic') then 'Organic'
    WHEN CONTAINS(${network_groupname},'outbrain') then 'Outbrain'
    WHEN CONTAINS(${network_groupname},'pintrest')
    OR CONTAINS(${network_groupname},'pinterest')then 'Pinterest'
    WHEN CONTAINS(${network_groupname},'podcast') then 'podcast'
    WHEN CONTAINS(${network_groupname},'quora') then 'Quora'
    WHEN CONTAINS(${network_groupname},'radio') then 'Radio'
    WHEN CONTAINS(${network_groupname},'reddit') then 'Reddit'
    WHEN CONTAINS(${network_groupname},'rakuten') then 'Rakuten'
    WHEN CONTAINS(${network_groupname},'simplifi') then 'Simplifi'
    WHEN CONTAINS(${network_groupname},'snapchat') then 'SnapChat'
    WHEN CONTAINS(${network_groupname},'taboola') then 'Taboola'
    WHEN CONTAINS(${network_groupname},'tv') then 'TV'
    WHEN CONTAINS(${network_groupname},'twitter') then 'Twitter'
    WHEN CONTAINS(${network_groupname},'waze') then 'Waze'
    WHEN CONTAINS(${network_groupname},'yahoo')
    OR CONTAINS(${network_groupname},'verizon media')
    OR CONTAINS(${network_groupname},'verizonmedia') then 'Yahoo'
    WHEN CONTAINS(${network_groupname},'gemini native') then 'Yahoo Native'
    WHEN CONTAINS(${network_groupname},'yelp') then 'Yelp'
    WHEN CONTAINS(${network_groupname},'youtube') then 'YouTube'
    ELSE 'Other'
    END
    ;;
  }



}
