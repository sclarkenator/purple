######################################################
#   Adspend
#   https://purple.looker.com/dashboards/3635
######################################################
view: adspend_pdt {
  derived_table: {
    explore_source: daily_adspend {
      column: ad_date {}
      column: campaign_type {}
      column: spend_platform {}
      column: medium {}
      column: campaign_name {}
      column: campaign_id {}
      column: adspend_raw {}
      column: impressions {}
      column: clicks {}
      filters: { field: daily_adspend.ad_date value: "2 years" }
      filters: { field: daily_adspend.Before_today value: "Yes" }
      filters: {field: daily_adspend.country value: "US"}
    }
  }
  dimension: ad_date { type: date }
  dimension: campaign_type { type: string }
  dimension: spend_platform { type: string }
  dimension: medium { type: string }
  dimension: campaign_name { type: string }
  dimension: campaign_id { type: string }
  dimension: adspend_raw { type: number }
  dimension: impressions { type: number }
  dimension: clicks { type: number }
}

######################################################
#   Sessions
#   https://purple.looker.com/dashboards/3635
######################################################
view: sessions_pdt {
  derived_table: {
    explore_source: ecommerce {
      column: time_date {}
      column: utm_term {}
      column: utm_source {}
      column: utm_medium {}
      column: utm_campaign {}
      column: count {}
      column: Sum_non_bounced_session { field: heap_page_views.Sum_non_bounced_session }
      column: distinct_users {}
      filters: { field: ecommerce.time_date value: "2 years" }
    }
  }
  dimension: time_date { type: date }
  dimension: utm_term { type: string }
  dimension: utm_source { type: string }
  dimension: utm_medium { type: string }
  dimension: utm_campaign { type: string }
  dimension: count { type: number }
  dimension: Sum_non_bounced_session { type: number }
  dimension: distinct_users { type: number }
}

######################################################
#   Sales
#   https://purple.looker.com/dashboards/3635
######################################################
view: sales_pdt {
  derived_table: {
    explore_source: ecommerce {
      column: created_date { field: sales_order_line_base.created_date }
      column: utm_term {}
      column: utm_source {}
      column: utm_medium {}
      column: utm_campaign {}
      column: total_orders { field: sales_order.total_orders }
      column: total_gross_Amt_non_rounded { field: sales_order_line_base.total_gross_Amt_non_rounded }
      column: new_customer {field: first_order_flag.new_customer}
      column: repeat_customer {field: first_order_flag.repeat_customer}
      column: payment_method {field: sales_order.payment_method}
      column: order_id { field: sales_order.order_id }
      column: mattress_sales { field: sales_order_line.mattress_sales }
      filters: { field: sales_order_line_base.created_date value: "2 years" }
    }
  }
  dimension: created_date { type: date }
  dimension: utm_term { type: string }
  dimension: utm_source { type: string }
  dimension: utm_medium { type: string }
  dimension: utm_campaign { type: string }
  dimension: total_orders { type: number }
  dimension: total_gross_Amt_non_rounded { type: number }
  dimension: new_customer {type: number}
  dimension: repeat_customer {type: number}
  dimension: payment_method {type: string}
  dimension: order_id {type: string}
  dimension: mattress_sales {type:number}

}

######################################################
#   C3
#   https://purple.looker.com/dashboards/3635
######################################################
view: c3_pdt {
  derived_table: {
    explore_source: c3_roa {
      column: SPEND_DATE_date {}
      column: CAMPAIGN_TYPE {}
      column: PLATFORM {}
      column: medium {}
      column: CAMPAIGN_NAME {}
      column: ATTRIBUTION_AMOUNT {}
      column: TRENDED_AMOUNT {}
      filters: { field: c3_roa.SPEND_DATE_date value: "2 years" }
    }
  }
  dimension: SPEND_DATE_date { type: date }
  dimension: CAMPAIGN_TYPE { type: string }
  dimension: PLATFORM { type: string }
  dimension: medium { type: string }
  dimension: CAMPAIGN_NAME { type: string }
  dimension: ATTRIBUTION_AMOUNT { type: number }
  dimension: TRENDED_AMOUNT { type: number }
}


######################################################
#   C3 New
#   https://purple.looker.com/dashboards/3635
######################################################

view: c3_cohort_pdt{
  derived_table: {
    explore_source: c3 {
      column: position_created_date {}
      column: position_created_raw {}
      column: campaign_type_clean {}
      column: Platform_clean {}
      column: medium_clean {}
      column: campaign {}
      column: attribution {}
      column: converter {}
      column: orders {}
      column: order_id {}
      column: network_groupname {}
    }
  }
  dimension: position_created_date {type: date}
  dimension: position_created_raw {type: date_time}
  dimension: campaign_type_clean {type: string}
  dimension: Platform_clean {type: string}
  dimension: medium_clean {type: string}
  dimension: campaign {type: string}
  dimension: attribution {type: number}
  dimension: converter {type: number}
  dimension: orders {type: number}
  dimension: order_id {type: string}
  dimension: network_groupname {type: string}
}

######################################################
#   C3 New
#   https://purple.looker.com/dashboards/3635
######################################################

view: c3_trended_pdt{
  derived_table: {
    explore_source: c3 {
      column: first_touch_sales {}
      column: last_touch_sales {}
      column: influenced { field: c3_conversion_count.influenced }
      column: order_created_date {}
      column: campaign_type_clean {}
      column: Platform_clean {}
      column: medium_clean {}
      column: campaign {}
      column: attribution {}
      column: converter {}
      column: orders {}
      column: order_id {}
      column: network_groupname {}

    }
  }
  dimension: order_created_date {type: date}
  dimension: campaign_type_clean {type: string}
  dimension: Platform_clean {type: string}
  dimension: medium_clean {type: string}
  dimension: campaign {type: string}
  dimension: attribution {type: number}
  dimension: converter {type: number}
  dimension: orders {type: number}
  dimension: first_touch_sales {type:number}
  dimension: last_touch_sales {type:number}
  dimension: influenced {type:number}
  dimension: order_id {type: string}
  dimension: network_groupname {type: string}
}

######################################################
#   CREATING FINAL TABLE
#   Looks from : https://purple.looker.com/dashboards/3635
######################################################
view: roas_pdt {
  derived_table: {
    sql:
    select 'adspend' as source
      , ad_date as date
      , null as position_time
      , campaign_type
      , spend_platform as platform
      , medium
      , null as order_id
      , campaign_name
      , campaign_id
      , null as group_network
      , adspend_raw as adspend
      , impressions
      , clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as mattress_sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
      , null as c3_new_trended
      , null as last_touch_sales
      , null as first_touch_sales
      , null as influenced
    from ${adspend_pdt.SQL_TABLE_NAME}
    union all
    select 'sessions' as source
      , time_date
      , null as position_time
      , utm_term
      , utm_source
      , utm_medium
      , null as order_id
      , utm_campaign
      , utm_campaign as campaign_id
      , null as group_network
      , null as aspend
      , null as impressions
      , null as clicks
      , count as sessions
      , Sum_non_bounced_session as qualified_sessions
      , null as orders
      , null as sales
      , null as mattress_sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
      , null as c3_new_trended
      , null as last_touch_sales
      , null as first_touch_sales
      , null as influenced
    from ${sessions_pdt.SQL_TABLE_NAME}
    union all
    select 'sales' as source
      , created_date
      , null as position_time
      , utm_term
      , utm_source
      , utm_medium
      , order_id::string
      , utm_campaign
      , null as campaign_id
      , null as group_network
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , total_orders as orders
      , total_gross_Amt_non_rounded as sales
      , mattress_sales as mattress_sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , new_customer
      , repeat_customer
      , payment_method
      , null as c3_new_cohort
      , null as c3_new_trended
      , null as last_touch_sales
      , null as first_touch_sales
      , null as influenced
    from ${sales_pdt.SQL_TABLE_NAME}
    union all
    select 'c3' as source
      , SPEND_DATE_date
      , null as position_time
      , CAMPAIGN_TYPE
      , PLATFORM
      , medium
      , null as order_id
      , CAMPAIGN_NAME
      , null as campaign_id
      , null as group_network
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as mattress_sales
      , ATTRIBUTION_AMOUNT as c3_cohort_sales
      , TRENDED_AMOUNT as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
      , null as c3_new_trended
      , null as last_touch_sales
      , null as first_touch_sales
      , null as influenced
   from ${c3_pdt.SQL_TABLE_NAME}
   union all
    select 'c3 cohort' as source
      , position_created_date
      , position_created_raw as position_time
      , campaign_type_clean
      , Platform_clean
      , medium_clean
      , order_id::string
      , Campaign
      , null as campaign_id
      , network_groupname as group_network
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as mattress_sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , attribution as c3_new_cohort
      , null as c3_new_trended
      , null as last_touch_sales
      , null as first_touch_sales
      , null as influenced
   from ${c3_cohort_pdt.SQL_TABLE_NAME}
  union all
    select 'c3 trended' as source
      , order_created_date
      , null as position_time
      , campaign_type_clean
      , Platform_clean
      , medium_clean
      , order_id::string
      , Campaign
      , null as campaign_id
      , network_groupname as group_network
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as mattress_sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
      , attribution as c3_new_trended
      , last_touch_sales
      , first_touch_sales
      , influenced
   from ${c3_trended_pdt.SQL_TABLE_NAME}
    ;;
  datagroup_trigger: pdt_refresh_6am
  }

  dimension: date {
    type: date
    hidden:yes
    sql: ${TABLE}.date ;;
  }

  dimension: position_time {
    type: date_time
    hidden: yes
    sql: ${TABLE}.position_time ;;
  }

  dimension_group: date {
    label: " Dynamic"
    description: "This is trending data, so the date when measuring adspend is the adspend date, when measuring sales it's the sales date, and so on"
    type: time
    timeframes: [raw, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date::date ;;
  }

  dimension: source {
    label: " Data Source"
    description: "Which data source it's coming from"
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: order_id {
   type: string
   sql: ${TABLE}.order_id ;;
  }

  dimension: campaign_type {
    label: "Campaign Type (raw)"
    description: "Data as is from core system (source)"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.campaign_type ;;
  }

  dimension: campaign_type_clean {
    label: " Campaign Type (clean)"
    description: "Transforming the data from each system to match a single format"
    type: string
    sql:
      case when ${TABLE}.campaign_type in ('pt','PRSOPECTING','PROSPECTING','Prospecting','prospecting') or
        left(${TABLE}.campaign_type,2) = 'pt'
        or ${TABLE}.campaign_type = 'lg'
        or ${TABLE}.campaign_type = 'prosp'
        or ${TABLE}.campaign_name ilike 'prospecting'
        or ${TABLE}.campaign_name ilike '%=pt'
        or ${platform} in ('tv','ir')
        or ${medium} in ('af')
          then 'Prospecting'
        when ${TABLE}.campaign_type in ('rt','RETARGETING', 'Retargeting') or
          left(${TABLE}.campaign_type,2) = 'rt'
          or ${TABLE}.campaign_type = 're'
          or ${TABLE}.campaign_name ilike 'retargeting'
          then 'Retargeting'
        when ${TABLE}.campaign_type in ('br','BRAND','Brand') or
          left(${TABLE}.campaign_type,2) = 'br'
          then 'Brand'
        else 'Other' end

      ;;
  }

  dimension: payment_method {
    label: "payment method"
    description: "Method used complete transaction"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: platform {
    label: "Platform (raw)"
    description: "Data as is from core system (source)"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: platform_clean {
    label: " Platform (clean)"
    description: "Transforming the data from each system to match a single format"
    type: string
    sql:
      case when lower(${TABLE}.platform) in ('acuity','ac') then 'Acuity'
        when lower(${TABLE}.platform) in ('admarketplace', 'adm') then 'Admarketplace'
        when lower(${TABLE}.platform)  in ('am','amazon','amazon aap','amazon kindle','amazon media','amazon media group','amazon+aap','amazon-hsa','amazon-sp','amg')
          then 'Amazon'
        when lower(${TABLE}.platform)  in ('al','adlingo') then 'Adlingo'
         when lower(${TABLE}.platform)  in ('agility') then 'Agility'
        when lower(${TABLE}.platform)  in ('adme','admedia') then 'Admedia'
        when lower(${TABLE}.platform)  in ('ash','asher media') then 'AsherMedia'
        when lower(${TABLE}.platform)  in ('bra','brave') then 'BRAVE'
        when lower(${TABLE}.platform)  in ('bg','bing','bing','bn') then 'Bing'
        when lower(${TABLE}.platform)  in ('cor','co','cordless') then 'Cordless'
        when lower(${TABLE}.platform)  in ('chatbot') then 'Chatbot'
        when lower(${TABLE}.platform)  in ('couponbytes') then 'Couponbytes'
        when lower(${TABLE}.platform)  in ('eb','ebay') then 'Ebay'
        when lower(${TABLE}.platform)  in ('em','email') then 'Email'
        when lower(${TABLE}.platform)  in ('korte') then 'Korte'
        when lower(${TABLE}.platform)  in ('rokt') then 'Rokt'
        when lower(${TABLE}.platform)  in ('cn','conde naste') then 'Conde Naste'
        when lower(${TABLE}.platform)  in ('mymove-llc') then 'MyMove-LLC'
        when lower(${TABLE}.platform)  in ('mymove') then 'MyMove'
        when lower(${TABLE}.platform)  in ( 'redcrance') then 'Redcrane'
        when lower(${TABLE}.platform)  in ('fluent') then 'Fluent'
        when lower(${TABLE}.platform)  in ('fkl','findkeeplove') then 'FKL'
        when lower(${TABLE}.platform)  in ('goop') then 'Goop'
        when lower(${TABLE}.platform)  in ('liveintent','lv')
        or lower(${TABLE}.platform) in ('li') then 'Liveintent'
        when lower(${TABLE}.platform)  in ('linkedin', 'li') then 'LinkedIn'
        when lower(${TABLE}.platform)  in ('meredith') then 'Meredith'
        when lower(${TABLE}.platform)  in ('madrivo') then 'Madrivo'
        when lower(${TABLE}.platform)  in ('adwallet') then 'Adwallet'
        when lower(${TABLE}.platform)  in ('liveintent') then 'Liveintent'
        when lower(${TABLE}.platform)  in ('hulu') then 'Hulu'
        when lower(${TABLE}.platform)  in ('integral media') then 'Integral Media'
        when lower(${TABLE}.platform)  in ('ir', 'impact radius') then 'Impact Radius'
        when lower(${TABLE}.platform)  in ('ex','exponential','vdx') then 'VDX'
        when lower(${TABLE}.platform)  in ('facebook','fb','ig','igshopping','instagram','fb/ig') then 'FB/IG'
        when (lower(${TABLE}.platform)  in ('go','gon','google','dv360') and ${campaign_name} not ilike ('%_yt_%'))
        or (lower(${TABLE}.platform)  in ('google','go') and ${TABLE}.medium in ('video','vi') and ${campaign_name} not ilike ('%_yt_%'))
        or lower(${TABLE}.platform)  in ('google','go') then 'Google'
        when lower(${TABLE}.platform)  in ('pinterest','pinterestk','pt') then 'Pinterest'
        when lower(${TABLE}.platform)  in ('sn','snapchat') then 'Snapchat'
        when lower(${TABLE}.platform)  in ('ta','talkable') then 'Talkable'
        when lower(${TABLE}.platform)  in ('tab','taboola') then 'Taboola'
        when lower(${TABLE}.platform)  in ('twitter, tw') then 'Twitter'
        when lower(${TABLE}.platform)  in ('veritone','vr', 'radio','streaming', 'podcast') then 'Veritone'
        when lower(${TABLE}.platform)  in ('verizon media','yahoo','oa','oath','vrz') then 'Verizon Media'
        when lower(${TABLE}.platform)  in ('reddit','reddit.com') then 'Reddit'
        when lower(${TABLE}.platform)  in ('rakuten','rk', 'affiliate') then 'Rakuten'
        when lower(${TABLE}.platform)  in ('postie') then 'Postie'
        when lower(${TABLE}.platform)  in ('stackadapt','sa') then 'StackAdapt'
        when lower(${TABLE}.platform)  in ('simplifi','si') then 'Simplifi'
        when lower(${TABLE}.platform)  in ('spfy') then 'Spotify'
        when lower(${TABLE}.platform)  in ('shid','sherid') then 'SheerID'
        when lower(${TABLE}.platform)  in ('twitter','tw') then 'Twitter'
        when lower(${TABLE}.platform)  in ('outbrain','ob') then 'Outbrain'
        when lower(${TABLE}.platform)  in ('obe') then 'Obé Fitness'
        when lower(${TABLE}.platform) in ('nextdoor','nd') then 'Nextdoor'
        when lower(${TABLE}.platform) in ('tv','oceanmedia', 'ocean media','hu','om') or contains(${medium},'tv') then 'Oceanmedia'
        when lower(${TABLE}.platform)  in ('tiktok','tk') then 'TikTok'
        when lower(${TABLE}.platform)  in ('waze', 'wa') then 'Waze'
        when lower(${TABLE}.platform)  in ('yelp', 'ye') then 'Yelp'
        when lower(${TABLE}.platform)  in ('youtube','youtube.com','yt','youtube') or ${campaign_name} ilike ('%_yt_%')then 'YouTube'
        when lower(${TABLE}.platform) in ('zeta','ze') then 'Zeta'
        else 'Other' end
      ;;
  }

  dimension: medium {
    label: "Medium (raw)"
    description: "Data as is from core system (source)"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.medium ;;
  }

  dimension: campaign_name {
    label: "Campaign Name (raw)"
    description: "Data as is from core system (source)"
    group_label: "Advanced"
    type: string
    sql: lower(${TABLE}.campaign_name);;
  }

  dimension: adspend_campaign_id {
  hidden: no
  type: string
  sql:  case when ${source} = 'adspend' then ${TABLE}.campaign_id else null end ;;
}

  dimension: adspend_campaign_name {
    hidden: no
    type: string
    sql:  case when ${source} = 'adspend' then ${TABLE}.campaign_name else null end ;;
  }

  dimension: session_campaign_id {
    hidden: no
    type: string
    sql:  case when ${source} = 'sessions' then ${TABLE}.campaign_id else null end;;
  }

  dimension: campaign_name_new {
    label: "Campaign Name (new)"
    description: "Matches based on camapign ID in Campaign UTM"
    group_label: "Advanced"
    type: string
    sql: case when ${adspend_campaign_id} = ${session_campaign_id} then ${adspend_campaign_name}
    else ${campaign_name} end ;;
  }

  dimension: network_groupname {
    label: "NetworkGroup Name"
    description: "C3 Network and Group Name concatinated"
    type: string
    sql: ${TABLE}.group_network ;;
  }

  dimension: medium_clean {
    label: " Medium (clean)"
    description: "Transforming the data from each system to match a single format"
    type: string
    sql:
      case
      when lower(${TABLE}.medium) in ('crm','em', 'email') or  lower(${TABLE}.platform) in ('liveintent', 'fluent','ta','talkable', 'email', 'fkl', 'findkeeplove') then 'CRM'
      when lower(${TABLE}.medium) in ('affiliate','af','referral','rf', 'affiliatedisplay', 'affiliatie') or  lower(${TABLE}.platform) in ('couponbytes', 'rk', 'affiliate') then 'Affiliate'
      when lower(${TABLE}.medium) in ('social','so','facebook', 'talkable','paid social', 'paidsocial', 'organic social', 'social ads',
      'video06', 'video_6sec', 'video_47sec', 'video_15sec', 'video_11sec_gif','video_10sec', 'image')
      or lower(${TABLE}.platform) in ('snapchat', 'nextdoor', 'pinterest', 'instagram','quora', 'twitter','facebook', 'quora', 'twitter','fb') then 'Social'
      when lower(${TABLE}.medium) in ('display','ds')
      or  lower(${TABLE}.platform) in ('acuity') and ${TABLE}.medium in ('display','ds')
      or (lower(${TABLE}.platform) in ('agility','acuity', 'oa') and ${TABLE}.medium is null)  then 'Display'
       when lower(${TABLE}.medium) in ('tv','ctv','radio','streaming','traditional','sms','tv','tx','cinema','au','linear','print','radio', 'audio', 'podcast','ir')
      or  lower(${TABLE}.platform) in ('rk','tv','ctv','radio','streaming', 'veritone') then 'Traditional'
      when lower(${TABLE}.medium) in ('search','sr','cpc','cpm', 'seo') or (lower(${TABLE}.medium) = 'feed' and lower(${TABLE}.platform) = 'oa')  then 'Search'
      when lower(${TABLE}.medium) in ('sh','feed','shopping','PLA','pla') then 'PLA'
      when lower(${TABLE}.medium) in ('video','vi', 'yt','youtube','purple fanny pad' ,'raw egg demo', 'sasquatch video',
      'factory tour video','pet bed video','so sciencey','powerbase video','human egg drop test', 'pressure points video','latest technology video',
      'customer unrolling', 'retargetingvideo', 'raw egg test', 'back sleeping video','gordon hayward', 't-pain', 'time travel', 'mattress roll video',
      'made in the usa video', 'unpacking video', 'original kickstarter video')
      or lower(${TABLE}.platform) in ('youtube')
      then 'Video'
      when lower(${TABLE}.medium) in ('native','nt', 'nativeads', 'referralutm_source=taboola','nativeads?utm_source=yahoo') then 'Native'
      when (${TABLE}.medium is null and ${TABLE}.platform is null) then 'Organic/Direct'
      else 'Other' end
      ;;
  }

  dimension: medium_clean_new {
    label: " Medium (clean) New"
    description: "Transforming the data from each system to match a single format"
    type: string
    sql:
      case
      when lower(${TABLE}.medium) in ('au','radio','streaming','radio', 'audio', 'podcast')
      or lower(${TABLE}.platform) in ('radio','streaming','podcast','veritone')then 'Audio'
      when lower(${TABLE}.medium) in ('affiliate','af', 'affiliatedisplay', 'affiliatie')
      or lower(${TABLE}.platform) in ('couponbytes', 'rk', 'affiliate') then 'Affiliate'
      when lower(${TABLE}.medium) in ('crm','em', 'email','sms','tx','print','ir')
      or lower(${TABLE}.platform) in ('ta','talkable') then 'CRM'
      when lower(${TABLE}.medium) in ('ctv')
      or lower(${TABLE}.platform) in ('ctv') then 'CTV'
      when lower(${TABLE}.medium) in ('ds')
      or (lower(${TABLE}.platform) in ('amazon media group') and ${TABLE}.medium in ('display','ds'))
      or (lower(${TABLE}.platform) in ('acuity') and ${TABLE}.medium in ('display','ds'))
      or (lower(${TABLE}.platform) in ('agility','acuity', 'oa') and ${TABLE}.medium is null)
      or (lower(${TABLE}.platform) in ('simplifi') and ${TABLE}.medium in ('display','ds'))
      or (lower(${TABLE}.platform) in ('verizon media') and ${TABLE}.medium in ('display'))
      or (lower(${TABLE}.platform) in ('zeta') and ${TABLE}.medium in ('display'))
      or (${TABLE}.medium in ('display') and lower(${TABLE}.platform) not in ('asher media','amazon-sp')) then 'Display'
      when lower(${TABLE}.medium) in ('crm','em', 'email')
      or lower(${TABLE}.platform) in ('liveintent', 'fluent','ta','talkable', 'email', 'fkl', 'findkeeplove') then 'Lead Gen'
      when lower(${TABLE}.medium) in ('native','nt', 'nativeads', 'referralutm_source=taboola','nativeads?utm_source=yahoo') then 'Native'
      when lower(${TABLE}.medium) in ('organic')
      or lower(${TABLE}.medium) is null and lower(${TABLE}.platform) is null then 'Organic'
      when lower(${TABLE}.medium) in ('search','sr','cpc','cpm', 'seo') and ${campaign_type_clean} in ('Brand') and ${platform} not in ('AMAZON-HSA') then 'Branded Search'
       when lower(${TABLE}.medium) in ('search','sr','cpc','cpm', 'seo') and ${campaign_type_clean} not in ('Brand') then 'Non-Branded Search'
      when lower(${TABLE}.medium) in ('social','so','facebook','paid social', 'paidsocial', 'organic social', 'social ads')
      or lower(${TABLE}.platform) in ('facebook','fb') then 'Social'
      when lower(${TABLE}.platform) in ('snapchat', 'nextdoor', 'pinterest', 'instagram','quora', 'twitter', 'quora', 'twitter') then 'Social Growth'
      when lower(${TABLE}.medium) in ('tv','cinema','linear') or lower(${TABLE}.platform) in ('tv')
      or (lower(${TABLE}.medium) in ('traditional') and lower(${TABLE}.platform) in ('tv'))
      or (lower(${TABLE}.medium) in ('traditional') and lower(${TABLE}.platform) in ('ocean media')) then 'TV'
      when lower(${TABLE}.medium) in ('sh','feed','shopping','PLA','pla') then 'PLA'
      when lower(${TABLE}.medium) in ('video','vi', 'yt','youtube','purple fanny pad' ,'raw egg demo', 'sasquatch video',
      'factory tour video','pet bed video','so sciencey','powerbase video','human egg drop test', 'pressure points video','latest technology video',
      'customer unrolling', 'retargetingvideo', 'raw egg test', 'back sleeping video','gordon hayward', 't-pain', 'time travel', 'mattress roll video',
      'made in the usa video', 'unpacking video', 'original kickstarter video')
      or lower(${TABLE}.platform) in ('youtube')
      then 'Video'
      else 'Other' end
      ;;
  }

dimension: medium_source {
  label: "Medium/Source"
  type: string
  sql: concat(${medium_clean_new},${platform_clean}) ;;
}

dimension: medium_source_type {
    label: "Medium/Source"
    type: string
    sql: concat(${medium_clean_new},${platform_clean},${campaign_type_clean}) ;;
  }

  measure: adspend {
    label: "Adspend ($k)"
    description: "Total Adspend - beware filtering by non adspend fields"
    type: sum
   value_format: "[>=1000000]$0.00,,\"M\";[>=1000]$0.00,\"K\";$0.00"
    sql: ${TABLE}.adspend ;;
  }

  measure: impressions {
    label: "Impressions (#k)"
    description: "Total Impressions - beware filtering by non adspend fields"
    type: sum
    value_format: "#,##0,\" K\""
    sql: ${TABLE}.impressions ;;
  }
  # measure: impressions_num{
  #   label: "Impressions num (#k)"
  #   description: "Total Impressions - beware filtering by non adspend fields"
  #   type: number
  #   value_format: "#,##0,\" K\""
  #   sql: ${TABLE}.impressions ;;
  # }

  # measure: min_impressions {
  #   label: "Min Impressions (#k)"
  #   group_label: "Scorecard"
  #   ##hidden: yes
  #   description: "Minimum Impressions - beware filtering by non adspend fields"
  #   type: min
  #   value_format: "#,##0"
  #   sql:${TABLE}.impressions ;;
  # }
  # measure: max_impressions {
  #   label: "Max Impressions (#k)"
  #   hidden: yes
  #   description: "Max Impressions - beware filtering by non adspend fields"
  #   type: number
  #   value_format: "#,##0,\" K\""
  #   sql: max(${roas_pdt.impressions});;
  # }
  # measure: min_max_impressions {
  #   label: "Max-Min Impressions (#k)"
  #   hidden: yes
  #   description: "Max Impressions - beware filtering by non adspend fields"
  #   type: number
  #   value_format: "#,##0,\" K\""
  #   sql: ${min_impressions} - ${max_impressions};;
  # }
  # measure: normalized_impressions {
  #   label: "Impression (N)"
  #   group_label: "Scorecard"
  #   description: "Normalized Impressions"
  #   type: number
  #   value_format: "0.00\%"
  #   sql: (${impressions}-${min_impressions})/${min_max_impressions};;
  # }

  measure: clicks {
    label: "Clicks (#)"
    description: "Total Clicks - beware filtering by non adspend fields"
    type: sum
    value_format: "#,##0,\" K\""
    sql: ${TABLE}.clicks ;;

  }

  measure: cpm {
    label: "  CPM"
    description: "Adspend / Total impressions/1000"
    type: number
    value_format: "$#,##0.00"
    sql: ${adspend}/NULLIF((${impressions}/1000),0) ;;  }

  measure: cpc {
    label: "  CPC"
    description: "Adspend / Total Clicks"
    type: number
    value_format: "$#,##0.00"
    sql: ${adspend}/NULLIF(${clicks},0) ;;  }

  measure: ctr {
    label: "  CTR"
    description: " (Total Clicks / Total Impressions) *100"
    type: number
    value_format: "00.00%"
    sql: (${clicks}/NULLIF(${impressions},0));;  }

  measure: sessions {
    label: "Sessions (#k)"
    description: "Total Sessions - beware filtering by non UTM/Session fields"
    type: sum
    value_format: "[>=1000000]0,,\"M\"; [>=1000]0,\" K\" ; ##0"
    sql: ${TABLE}.sessions ;;
  }

  measure: qualified_sessions {
    label: "Qualified Sessions (#k)"
    description: "Total Sessions - beware filtering by non UTM/Session fields"
    type: sum
    value_format: "[>=1000000]0,,\"M\"; [>=1000]0,\" K\" ; ##0"
    sql: ${TABLE}.qualified_sessions ;;
  }

  measure: bounce_rate {
    description: "Percent of sessions where user only viewed one page and left the site"
    type: number
    sql: (${sessions}-${qualified_sessions})/nullif(${sessions},0) ;;
    value_format_name: percent_1
  }

  measure: orders {
    label: "Orders (#)"
    description: "Total Orders - beware filtering by non sales fields"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.orders ;;
  }

  measure: total_cvr {
    description: "% of all Sessions that resulted in an order. Source: looker.calculation"
    label: "CVR - All Sessions"
    type: number
    view_label: "Sessions"
    sql: 1.0*(${orders})/NULLIF(${sessions},0) ;;
    value_format_name: percent_2
  }
  measure: sales {
    label: "Gross Sales ($k)"
    description: "Total Gross Sales - beware filtering by non sales fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.sales ;;
  }
  measure: mattress_sales {
    label: "Mattress Sales ($k)"
    description: "Mattress Sales - beware filtering by non sales fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.mattress_sales ;;
  }

  measure: c3_cohort_sales {
    label: "C3 Cohort Sales ($k)"
    description: "Total C3 Sales from adspend date (cohort) - beware filtering by non C3 fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.c3_new_cohort ;;
  }

  measure: c3_trended_sales {
    label: "C3 Trended Sales ($k)"
    description: "Total C3 Sales from sale/purchase date (trended) - beware filtering by non C3 fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.c3_new_trended ;;
  }

  measure: new_customer {
    label: "New Customer"
    description: "Count of new customers"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.new_customer ;;
  }

  measure: repeat_customer {
    label: "Repeat Customer"
    description: "Count of repeat customers"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.repeat_customer ;;
  }

  measure: CPA {
    label: "CPA"
    description: "Cost per Acquisition (Adpend/Orders)"
    type: number
    value_format: "$#,##0.00"
    sql: ${adspend}/${orders} ;;
  }
  measure: new_cohort_amount{
    label: "C3 Atrributed Amount New"
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.c3_new_cohort;;
  }
  measure: last_touch_sales {
    label:"Last Touch Sales"
    description: "Sale amount where C3 position was 'converter'"
    value_format: "$#,##0"
    type: sum
  sql: ${TABLE}.last_touch_sales;;
  }
  measure: first_touch_sales {
    label:"First Touch Sales"
    description: "Sale amount where C3 position was 'originator'"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.first_touch_sales;;
  }
  measure: influenced {
    label: "Multi-touch Sales"
    description: "All C3 touchpoints attributed amount"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.influenced;;
  }
  measure: last_touch_sales_roas {
    label: "ROAS LT"
    description: "C3 Last-touch ROAS"
    value_format: "$#,##0.00"
    type: number
    sql: ${adspend}/nullif(${last_touch_sales},0);;
  }
  measure: first_touch_sales_roas {
    label: "ROAS FT"
    description: "C3 First-touch ROAS"
    value_format: "$#,##0.00"
    type: number
    sql: ${adspend}/nullif(${first_touch_sales},0);;
  }
  measure: multi_touch_sales_roas {
    label: "ROAS MT"
    description: "C3 MT ROAS"
    value_format: "$#,##0.00"
    type: number
    sql: ${adspend}/nullif(${influenced},0);;
  }

  parameter: breakdowns {type: string
    allowed_value: { value: "Medium" }
    allowed_value: { value: "Source" }
    allowed_value: { value: "Type" }
    allowed_value: { value: "Medium/Source"}
    allowed_value: { value: "Medium/Source/Type"}
  }

  dimension: breakdown_types {
    label_from_parameter: breakdowns
    sql:
            CASE
             WHEN {% parameter breakdowns %} = 'Medium' THEN ${medium_clean_new}
             WHEN {% parameter breakdowns %} = 'Source' THEN ${platform_clean}
             WHEN {% parameter breakdowns %} = 'Type' THEN ${campaign_type_clean}
             WHEN {% parameter breakdowns %} = 'Medium/Source' THEN ${medium_source}
             WHEN {% parameter breakdowns %} = 'Medium/Source/Type' THEN ${medium_source_type}
             ELSE NULL
            END ;;
  }

  parameter: website_test {
    type: string

    allowed_value: {
      label: "Sessions"
      value: "sessions"
      }
  }

    measure: website {
      label_from_parameter: website_test
      type: number
      ## value_format: "$0.0,\"K\""
      sql:
         CASE
          WHEN {% parameter website_test %} = 'sessions' THEN sum(${sessions})
         ELSE NULL
        END ;;
  }

  parameter: return_metrics {
    type: string
    allowed_value: {
      label: "Clicks"
      value: "clicks"
    }
    allowed_value: {
      label: "Impressions"
      value: "impressions"
    }
  }

  measure: returns {
    label_from_parameter: return_metrics
    type: number
    ## value_format: "$0.0,\"K\""
    sql:
         CASE
          WHEN {% parameter return_metrics %} = 'clicks' THEN sum(${clicks})
          WHEN {% parameter return_metrics %} = 'impressions' THEN sum(${impressions})
         ELSE NULL
        END ;;
  }
  }
