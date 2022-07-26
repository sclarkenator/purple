# view: c3_conversion {
# Deprecated on 7/26 after discussion with Savannah G. C3 is an add agency we terminated with over a year ago.
#   sql_table_name: MARKETING.C3_CONVERSION ;;

#   dimension: key {
#     type: string
#     hidden: yes
#     primary_key: yes
#     sql: ${order_id} || ${position}  ;;
#   }

#   dimension: ad {
#     type: string
#     hidden: yes
#     sql: ${TABLE}."AD" ;;
#   }

#   dimension: ad_id {
#     type: string
#     hidden: yes
#     sql: ${TABLE}."AD_ID" ;;
#   }

#   dimension: ad_size {
#     type: string
#     hidden: yes
#     sql: ${TABLE}."AD_SIZE" ;;
#   }

#   dimension: advertiser {
#     type: string
#     hidden: yes
#     sql: ${TABLE}."ADVERTISER" ;;
#   }

#   dimension: attribution_dim {
#     type: number
#     hidden: yes
#     sql: ${TABLE}."ATTRIBUTION" ;;
#   }

#   dimension: campaign {
#     type: string
#     sql: ${TABLE}."CAMPAIGN" ;;
#   }

#   dimension: conversion_type {
#     type: string
#     sql: ${TABLE}."CONVERSION_TYPE" ;;
#   }

#   dimension: creative {
#     type: string
#     hidden: yes
#     sql: ${TABLE}."CREATIVE" ;;
#   }

#   dimension: group_name {
#     type: string
#     sql: ${TABLE}."GROUP_NAME" ;;
#   }

#   dimension: is_brand {
#     type: string
#     sql: ${TABLE}."IS_BRAND" ;;
#   }

#   dimension: network_name {
#     type: string
#     sql: ${TABLE}."NETWORK_NAME" ;;
#   }

#   dimension: new_customer {
#     type: string
#     sql: ${TABLE}."NEW_CUSTOMER" ;;
#   }

#   dimension_group: order_created {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}."ORDER_CREATED" ;;
#   }

#   dimension: order_id {
#     type: number
#     sql: ${TABLE}."ORDER_ID" ;;
#   }

#   dimension: placement {
#     type: string
#     sql: ${TABLE}."PLACEMENT" ;;
#   }

#   dimension: position {
#     type: number
#     sql: ${TABLE}."POSITION" ;;
#   }

#   dimension_group: position_created {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}."POSITION_CREATED" ;;
#   }

#   dimension: position_name {
#     type: string
#     sql: ${TABLE}."POSITION_NAME" ;;
#   }

#   dimension: referring_id {
#     type: string
#     sql: ${TABLE}."REFERRING_ID" ;;
#   }

#   measure: sale_amount_dim {
#     type: sum
#     sql: ${TABLE}."SALE_AMOUNT" ;;
#   }

#   dimension: touchpoint_type {
#     type: string
#     sql: ${TABLE}."TOUCHPOINT_TYPE" ;;
#   }

#   dimension: next_door {
#     type: yesno
#     sql: ${referring_id} ilike ('%nextdoor%') ;;
#   }

#   measure: attribution {
#     type: sum
#     sql: ${TABLE}."ATTRIBUTION" ;;
#   }

#   measure: converter {
#     description: "Count of orders by the last touch"
#     type: sum
#     sql: case when ${position_name} = 'CONVERTER' then 1 else 0 end ;;
#   }
#   measure: last_touch_sales{
#     description: "Sales by the last touch"
#     type: sum
#     sql: case when ${position_name} = 'CONVERTER' then ${TABLE}."SALE_AMOUNT" else 0 end ;;
#   }
#   measure: first_touch_sales{
#     description: "Sales by the first touch"
#     type: sum
#     sql: case when ${position_name} = 'ORIGINATOR' then ${TABLE}."SALE_AMOUNT" else 0 end ;;
#   }

#   measure: orders {
#     description: "Count of Distinct orders"
#     type: count_distinct
#     sql: ${order_id} ;;
#   }

#   dimension: network_groupname {
#     type: string
#     sql: lower(concat(${TABLE}."NETWORK_NAME",${TABLE}."GROUP_NAME")) ;;
#   }
#   dimension: Platform_clean {
#     type: string
#     sql: CASE
#     WHEN CONTAINS(${network_groupname},'acuity') then 'Acuity'
#     WHEN CONTAINS(${network_groupname},'adlingo') then 'Adlingo'
#     WHEN CONTAINS(${network_groupname},'admarketplace') then 'Admarketplace'
#     WHEN CONTAINS(${network_groupname},'admedia') then 'Admedia'
#     WHEN CONTAINS(${network_groupname},'agility') then 'Agility'
#     WHEN CONTAINS(${network_groupname},'amazon') then 'Amazon'
#     WHEN CONTAINS(${network_groupname},'rakuten')
#     OR CONTAINS(${network_groupname},'affiliate')  then 'Rakuten'
#     WHEN CONTAINS(${network_groupname},'bing') and NOT CONTAINS(${network_groupname},'RAKUTEN')then 'Bing'
#     WHEN CONTAINS(${network_groupname},'brave') then 'Brave'
#     WHEN CONTAINS(${network_groupname},'blog') then 'Blog'
#     WHEN CONTAINS(${network_groupname},'cordless') then 'Cordless'
#     WHEN CONTAINS(${network_groupname},'chatbot') then 'Adlingo'
#     WHEN CONTAINS(${network_groupname},'duckduck') then 'DuckDuckGo'
#     WHEN CONTAINS(${network_groupname},'DV360') then 'DV360'
#     WHEN CONTAINS(${network_groupname},'ebay') then 'Ebay'
#     WHEN CONTAINS(${network_groupname},'email') then 'Email'
#     WHEN CONTAINS(${network_groupname},'exponential') then 'VDX'
#     WHEN CONTAINS(${network_groupname},'(fb)')
#     OR CONTAINS(${network_groupname},'facebook')
#     OR CONTAINS(${network_groupname},'instagram') then 'FB/IG'
#     WHEN (CONTAINS(${network_groupname},'google') and not CONTAINS(${network_groupname},'simplifi'))
#     OR CONTAINS(${network_groupname},'gdn')
#     OR CONTAINS(${group_name},'DV360 Video')
#     OR CONTAINS(${group_name},'DV360 Display')
#     OR CONTAINS(${network_groupname},'GDN')
#     OR CONTAINS(${network_groupname},'rt - dpa remarketing')
#     OR CONTAINS(${network_groupname},'rt - new mattresses')
#     OR CONTAINS(${network_groupname},'rt - purple promotions ')
#     OR CONTAINS(${network_groupname},'rt - purple remarketing display new')
#     OR CONTAINS(${network_groupname},'rt - spring sale')
#     OR CONTAINS(${network_groupname},'pt - don')
#     OR CONTAINS(${network_groupname},'pt - hp display')
#     OR CONTAINS(${network_groupname},'rt - remarketing')
#     OR CONTAINS(${network_groupname},'pt - native prospect')
#     OR CONTAINS(${network_groupname},'rt - free')
#     OR (CONTAINS(${network_groupname}, '(0201)') and CONTAINS(${network_groupname},'display'))
#     OR (CONTAINS(${network_groupname}, '(8846)') and CONTAINS(${network_groupname},'display'))
#     OR (CONTAINS(${network_groupname}, '(3859)') and CONTAINS(${network_groupname},'pla')) then 'Google'
#     WHEN CONTAINS(${network_groupname},'hulu') then 'Hulu'
#     WHEN CONTAINS(${network_groupname},'impact radius') then 'Impact Radius'
#     WHEN CONTAINS(${network_groupname},'linkedin') then 'LinkedIn'
#     WHEN CONTAINS(${network_groupname},'modus') then 'Modus'
#     WHEN CONTAINS(${network_groupname},'meredith') then 'Meredith'
#     WHEN CONTAINS(${network_groupname},'nextdoor') then 'Nextdoor'
#     WHEN CONTAINS(${network_groupname},'organic') then 'Organic'
#     WHEN CONTAINS(${network_groupname},'outbrain') then 'Outbrain'
#     WHEN CONTAINS(${network_groupname},'pintrest')
#     OR CONTAINS(${network_groupname},'pinterest')
#     OR (CONTAINS(${network_groupname}, '1 |') and CONTAINS(${network_groupname},'paid social'))
#     OR (CONTAINS(${network_groupname}, '2 |') and CONTAINS(${network_groupname},'paid social'))
#     OR (CONTAINS(${network_groupname}, '3 |') and CONTAINS(${network_groupname},'paid social'))
#     then 'Pinterest'
#     WHEN CONTAINS(${network_groupname},'podcast') then 'podcast'
#     WHEN CONTAINS(${network_groupname},'quora') then 'Quora'
#     WHEN CONTAINS(${network_groupname},'radio') then 'Radio'
#     WHEN CONTAINS(${network_groupname},'reddit') then 'Reddit'
#     WHEN CONTAINS(${network_groupname},'rakuten')
#     OR CONTAINS(${network_groupname},'affiliate')  then 'Rakuten'
#     WHEN CONTAINS(${network_groupname},'sheerid') then 'SherID'
#     WHEN CONTAINS(${network_groupname},'simplifi') then 'Simplifi'
#     WHEN CONTAINS(${network_groupname},'snapchat') then 'SnapChat'
#     WHEN CONTAINS(${group_name},'SMS') then 'SMS'
#     WHEN CONTAINS(${network_groupname},'stackadapt') then 'StackAdapt'
#     WHEN CONTAINS(${network_groupname},'spotx') then 'Spot X'
#     WHEN CONTAINS(${network_groupname},'taboola') then 'Taboola'
#     WHEN CONTAINS(${network_groupname},'referral') then 'Talkable'
#     WHEN CONTAINS(${network_groupname},'tv') then 'TV'
#     WHEN CONTAINS(${network_groupname},'twitter') then 'Twitter'
#     WHEN CONTAINS(${network_groupname},'uncategorized') then 'Uncategorized'
#     WHEN CONTAINS(${network_groupname},'waze') then 'Waze'
#     WHEN CONTAINS(${network_groupname},'yahoo')
#     OR CONTAINS (lower(${network_groupname}),'verizon media')
#     OR CONTAINS(${network_groupname},'verizonmedia')
#     OR CONTAINS(${group_name},'Native')
#     OR (CONTAINS(${network_groupname}, 'dpa-') and CONTAINS(${network_groupname},'pla'))then 'Verizon Media'
#     WHEN CONTAINS(${network_groupname},'gemini native') then 'Yahoo'
#     WHEN CONTAINS(${network_groupname},'yelp') then 'Yelp'
#     WHEN CONTAINS(${network_groupname},'youtube')
#     OR (CONTAINS(${network_name},'DV360') and ${group_name}='Video') then 'YouTube'
#     WHEN CONTAINS(${network_groupname},'zeta') then 'Zeta'
#     ELSE 'Other'
#     END
#     ;;
#   }

#   dimension: medium_clean {
#     type: string
#     sql: CASE
#     WHEN CONTAINS(${group_name},'Youtube') or contains(${network_name},'Youtube') or CONTAINS(${group_name},'DV360 Video')  then 'Video'
#     WHEN CONTAINS(${group_name},'AdMarketplace')
#     or CONTAINS (${group_name},'Bing Non-Brand')
#     or CONTAINS(${group_name}, 'Bing Brand')
#     or CONTAINS (${group_name},'Google Non-Brand')
#     or CONTAINS(${group_name},'Yelp Search')
#     or CONTAINS(${group_name},'Google Brand') or CONTAINS(${network_name}, '(Bing)') then 'Search'
#     WHEN CONTAINS(${network_name}, '(Bing Native)') or CONTAINS(${network_name},'(3859) > Visitors > Discovery')
#     or ${network_name} ilike '(3859) > nt_% > Discovery' then 'Native'
#     WHEN CONTAINS(${group_name},'AdMedia')
#     or CONTAINS(${group_name},'DV360 Display') then 'Display'
#     WHEN CONTAINS(${group_name},'PLA') then 'PLA'
#     WHEN CONTAINS(${group_name},'Affiliate Display') then 'Affiliate'
#     WHEN CONTAINS(${group_name},'SEO') or CONTAINS(${group_name},'ORGANIC') then 'Organic/Direct'
#     WHEN CONTAINS(${group_name},'Social')
#     and not CONTAINS(lower(${network_name}) ,'yelp') then 'Social'
#     WHEN CONTAINS(${group_name},'Radio')
#     or CONTAINS(${group_name}, 'Podcast')
#     or CONTAINS (${group_name},'TV') then 'Traditional'
#     --WHEN CONTAINS(${network_groupname},'tv') then 'TV'
#     ELSE ${TABLE}.group_name
#     END ;;
#     }

#   dimension: campaign_type_clean {
#     type: string
#     sql:case when ${group_name} ilike ('%brand%') and ${group_name} not ilike ('%non-brand%')
#     or ${campaign} ilike ('br %')
#     or ${campaign} ilike ('% br %')
#     or ${campaign} ilike ('%-br-%')
#     or ${network_name} ilike ('br %')
#     or ${network_name} ilike ('% br %')
#     or ${network_name} ilike ('%-br-%')
#     or ${network_name} ilike ('%_br_%')then 'Brand'
# when ${group_name} = 'TV'
#     or ${group_name} = 'Affiliate'
#     or CONTAINS (${group_name},'Radio')
#     or CONTAINS (${group_name},'Non-Brand')
#     or ${network_name} ilike ('%prospect%')
#     or ${network_name} ilike ('%pros%')
#     or ${network_name} ilike ('pt_%')
#     or ${network_name} ilike (' pt%')
#     or ${network_name} ilike ('% pt %')
#     or ${network_name} ilike ('pt%')
#     or ${network_name} ilike ('%_pt')
#     or ${network_name} ilike ('%_pt_%')
#     or ${network_name} ilike ('%_pt ')
#     or ${network_name} ilike ('%-pt%')
#     or CONTAINS (${network_name},'Rakuten')
#     or CONTAINS (${network_name},'rakuten')
#     or CONTAINS (${network_name},'Impact Radius')
#     or ${campaign} ilike ('%prospect%')
#     or ${campaign} ilike ('%pros%')
#     or ${campaign} ilike ('pt_%')
#     or ${campaign} ilike (' pt%')
#     or ${campaign} ilike ('% pt %')
#     or ${campaign} ilike ('pt%')
#     or ${campaign} ilike ('%_pt')
#     or ${campaign} ilike ('%_pt ')
#     or ${campaign} ilike ('%-pt%') then 'Prospecting'
# when ${network_name} ilike ('%retarget%')
#     or ${network_name} ilike ('%remarket%')
#     or ${network_name} ilike ('rt_%')
#     or ${network_name} ilike (' rt%')
#     or ${network_name} ilike ('% rt %')
#     or ${network_name} ilike ('rt%')
#     or ${network_name} ilike ('%_rt')
#     or ${network_name} ilike ('%_rt ')
#     or ${network_name} ilike ('%-rt%')
#     or ${network_name} ilike ('%> RT-%')
#     or ${campaign} ilike ('%retarget%')
#     or ${campaign} ilike ('%remarket%')
#     or ${campaign} ilike ('rt_%')
#     or ${campaign} ilike ('%_rt_%')
#     or ${campaign} ilike (' rt%')
#     or ${campaign} ilike ('% rt %')
#     or ${campaign} ilike ('rt%')
#     or ${campaign} ilike ('%_rt')
#     or ${campaign} ilike ('%_rt ')
#     or ${campaign} ilike ('%-rt%') then 'Retargeting'
# else 'Other'
# end;;
#     }

#   dimension: N1 {
#     type: string
#     sql: ${TABLE}."NETWORK_1" ;;
#   }

#   dimension: N2 {
#     type: string
#     sql: ${TABLE}."NETWORK_2" ;;
#   }

#   dimension: N3 {
#       type: string
#       sql: ${TABLE}."NETWORK_3" ;;
#   }
#   dimension: N4 {
#     type: string
#     sql: ${TABLE}."NETWORK_4" ;;
#   }
#   dimension: N5 {
#     type: string
#     sql: ${TABLE}."NETWORK_5" ;;
#   }
#   dimension: N6 {
#     type: string
#     sql: ${TABLE}."NETWORK_6" ;;
#   }
#   dimension: N7 {
#     type: string
#     sql: ${TABLE}."NETWORK_7" ;;
#   }
#   dimension: N8 {
#     type: string
#     sql: ${TABLE}."NETWORK_8" ;;
#   }
#   dimension: campaign_name_new {
#     type: string
#     sql: CASE when ${Platform_clean} = 'Acuity' then ${N3}
#     when ${Platform_clean} = 'Admarketplace' then ${N2}
#     when ${Platform_clean} = 'Agility' then ${N2}
#     when ${Platform_clean} = 'Amazon' then ${N2}
#     when ${Platform_clean} = 'Bing' then ${N2}
#     when ${Platform_clean} = 'Cordless' then ${N2}
#     when ${Platform_clean} = 'DuckDuckGo' then ${N2}
#     when ${Platform_clean} = 'Ebay' then ${N1}
#     when ${Platform_clean} = 'FB/IG' then ${N2}
#     ElSE ${network_name}
#     END;;
#   }

# }
