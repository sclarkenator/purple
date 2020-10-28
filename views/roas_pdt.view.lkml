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
      column: adspend_raw {}
      column: impressions {}
      column: clicks {}
      filters: { field: daily_adspend.ad_date value: "2 years" }
      filters: { field: daily_adspend.Before_today value: "Yes" }
    }
  }
  dimension: ad_date { type: date }
  dimension: campaign_type { type: string }
  dimension: spend_platform { type: string }
  dimension: medium { type: string }
  dimension: campaign_name { type: string }
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

view: c3_new_pdt{
  derived_table: {
    explore_source: c3 {
      column: position_created_date {}
      column: campaign_type_clean {}
      column: Platform_clean {}
      column: medium_clean {}
      column: campaign {}
      column: attribution {}
      column: converter {}
      column: orders {}
    }
  }
  dimension: position_created_date {type: date}
  dimension: campaign_type_clean {type: string}
  dimension: Platform_clean {type: string}
  dimension: medium_clean {type: string}
  dimension: campaign {type: string}
  dimension: attribution {type: number}
  dimension: converter {type: number}
  dimension: orders {type: number}
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
      , campaign_type
      , spend_platform as platform
      , medium, campaign_name
      , adspend_raw as adspend
      , impressions
      , clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
    from ${adspend_pdt.SQL_TABLE_NAME}
    union all
    select 'sessions' as source
      , time_date
      , utm_term
      , utm_source
      , utm_medium
      , utm_campaign
      , null as aspend
      , null as impressions
      , null as clicks
      , count as sessions
      , Sum_non_bounced_session as qualified_sessions
      , null as orders
      , null as sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
    from ${sessions_pdt.SQL_TABLE_NAME}
    union all
    select 'sales' as source
      , created_date
      , utm_term
      , utm_source
      , utm_medium
      , utm_campaign
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , total_orders as orders
      , total_gross_Amt_non_rounded as sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , new_customer
      , repeat_customer
      , payment_method
      , null as c3_new_cohort
    from ${sales_pdt.SQL_TABLE_NAME}
    union all
    select 'c3' as source
      , SPEND_DATE_date
      , CAMPAIGN_TYPE
      , PLATFORM
      , medium
      , CAMPAIGN_NAME
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , ATTRIBUTION_AMOUNT as c3_cohort_sales
      , TRENDED_AMOUNT as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , null as c3_new_cohort
   from ${c3_pdt.SQL_TABLE_NAME}
   union all
    select 'c3 new' as source
      , position_created_date
      , campaign_type_clean
      , Platform_clean
      , medium_clean
      , Campaign
      , null as aspend
      , null as impressions
      , null as clicks
      , null as sessions
      , null as qualified_sessions
      , null as orders
      , null as sales
      , null as c3_cohort_sales
      , null as c3_trended_sales
      , null as new_customer
      , null as repeat_customer
      , null as payment_method
      , attribution as c3_new_cohort
   from ${c3_new_pdt.SQL_TABLE_NAME}
    ;;
  datagroup_trigger: pdt_refresh_6am
  }

  dimension: date {
    type: date
    hidden:yes
    sql: ${TABLE}.date ;;
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
      case when ${TABLE}.campaign_type in ('pt','PRSOPECTING','PROSPECTING','Prospecting') or
        left(${TABLE}.campaign_type,2) = 'pt'
          then 'Prospecting'
        when ${TABLE}.campaign_type in ('rt','RETARGETING', 'Retargeting') or
          left(${TABLE}.campaign_type,2) = 'rt'
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
      case when ${TABLE}.platform in ('ACUITY','ac') then 'Acuity'
        when ${TABLE}.platform in ('ADMARKETPLACE', 'adm') then 'Admarketplace'
        when ${TABLE}.platform in ('am','amazon aap','amazon kindle','AMAZON MEDIA GROUP','amazon+aap','AMAZON-HSA','AMAZON-SP','amg')
          then 'Amazon'
        when ${TABLE}.platform in ('al','ADLINGO') then 'Adlingo'
        when ${TABLE}.platform in ('adme','ADMEDIA') then 'Admedia'
        when ${TABLE}.platform in ('bra','BRAVE') then 'BRAVE'
        when ${TABLE}.platform in ('bg','BING','bing','bn') then 'Bing'
        when ${TABLE}.platform in ('co','CORDLESS') then 'Cordless'
        when ${TABLE}.platform in ('eb','EBAY') then 'Ebay'
        when ${TABLE}.platform in ('em','EMAIL','email','MYMOVE-LLC', 'REDCRANE','FLUENT','FKL','MADRIVO', 'ADWLLET', 'LIVEINTENT') then 'crm'
        when ${TABLE}.platform in ('ex','EXPONENTIAL','VDX') then 'VDX'
        when ${TABLE}.platform in ('FACEBOOK','facebook','fb','ig','igshopping','INSTAGRAM','instagram','FB/IG') then 'FB/IG'
        when ${TABLE}.platform in ('youtube','YOUTUBE.COM','yt','YOUTUBE')
          or (${TABLE}.platform in ('GOOGLE','go') and ${TABLE}.medium in ('video','vi')) then 'YouTube'
        when ${TABLE}.platform in ('go','GOOGLE','google') then 'Google'
        when ${TABLE}.platform in ('PINTEREST','pinterest','pinterestk','pt') then 'Pinterest'
        when ${TABLE}.platform in ('sn','SNAPCHAT','snapchat') then 'Snapchat'
        when ${TABLE}.platform in ('ta','talkable') then 'Talkable'
        when ${TABLE}.platform in ('tab','taboola','TABOOLA') then 'Taboola'
        when ${TABLE}.platform in ('YAHOO','yahoo','oa','oath','vrz') then 'Yahoo'
        when ${TABLE}.platform in ('VERITONE','vr', 'RADIO','STREAMING', 'PODCAST') then 'Veritone'
        when ${TABLE}.platform in ('RAKUTEN','rk') then 'Rakuten'
        when ${TABLE}.platform in ('SIMPLIFI','si') then 'Simplifi'
        when ${TABLE}.platform in ('TWITTER','tw') then 'Twitter'
        when ${TABLE}.platform in ('OUTBRAIN','ob') then 'Outbrain'
        when ${TABLE}.platform in ('NEXTDOOR','nd') then 'Nextdoor'
        when ${TABLE}.platform in ('TV','tv','OCEAN MEDIA','hu') then 'Oceanmedia'
        when ${TABLE}.platform in ('WAZE', 'wa') then 'Waze'
        when ${TABLE}.platform in ('YELP', 'ye') then 'Yelp'
        when ${TABLE}.platform in ('youtube','YOUTUBE.COM','yt','YOUTUBE')
        or (${TABLE}.platform in ('GOOGLE','go') and ${TABLE}.medium in ('video','vi')) then 'YouTube'
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

  dimension: medium_clean {
    label: " Medium (clean)"
    description: "Transforming the data from each system to match a single format"
    type: string
    sql:
      case when lower(${TABLE}.medium) in ('social','so','facebook', 'talkable','paid social', 'paidsocial', 'organic social', 'social ads',
      'video06', 'video_6sec', 'video_47sec', 'video_15sec', 'video_11sec_gif','video_10sec', 'image')
        or lower(${TABLE}.platform) in ('snapchat', 'nextdoor','NEXTDOOR', 'pinterest', 'instagram','quora', 'twitter','facebook', 'quora', 'twitter','fb')  then 'Social'
        when lower(${TABLE}.medium) in ('display','ds')
        or  lower(${TABLE}.platform) in ('acuity') and ${TABLE}.medium in ('display','ds'))
          or lower((${TABLE}.platform) in ('agility','acuity', 'oa') and ${TABLE}.medium is null)  then 'Display'
        when lower(${TABLE}.medium) in ('crm','em', 'email') or  ${TABLE}.platform in ('liveintent', 'fluent') then 'CRM'
        when lower(${TABLE}.medium) in ('tv','ctv','radio','streaming','traditional','sms','tv','tx','cinema','au','linear','print','radio', 'audio', 'podcast','ir')
        or  lower(${TABLE}.platform) in ('rk','tv','ctv','radio','streaming') then 'Traditional'
        when lower(${TABLE}.medium) in ('search','sh','sr','cpc','shopping','cpm') then 'Search'
        when lower(${TABLE}.medium in ('video','vi', 'yt','youtube','purple fanny pad' ,'raw egg demo', 'sasquatch video',
        'factory tour video','pet bed video','so sciencey','powerbase video','human egg drop test', 'pressure points video','latest technology video',
        'customer unrolling', 'retargetingvideo', 'raw egg test', 'back sleeping video','gordon hayward', 't-pain', 'time travel', 'mattress roll video',
        'made in the usa video', 'unpacking video', 'original kickstarter video') or  lower(${TABLE}.platform) in ('youtube') then 'Video'
        when lower(${TABLE}.medium) in ('affiliate','af','referral','rf', 'affiliatedisplay', 'affiliatie') or  lower(${TABLE}.platform) in ('couponbytes') then 'Affiliate'
        when lower(${TABLE}.medium)$ in ('native','nt', 'nativeads', 'referralutm_source=taboola','nativeads?utm_source=yahoo')then 'Native'
        when lower(${TABLE}.medium) in ('organic')
          or lower(${TABLE}.medium) is null then 'Organic'
        else 'Other' end
      ;;
  }


  measure: adspend {
    label: "Adspend ($k)"
    description: "Total Adspend - beware filtering by non adspend fields"
    type: sum
    value_format: "[>=1000000]$0.00,,\"M\"; [>=1000]$0.00,\" K\" ; $##0.00"
    sql: ${TABLE}.adspend ;;
  }

  measure: impressions {
    label: "Impressions (#k)"
    description: "Total Impressions - beware filtering by non adspend fields"
    type: sum
    value_format: "#,##0,\" K\""
    sql: ${TABLE}.impressions ;;
  }

  measure: clicks {
    label: "Clicks (#)"
    description: "Total Clicks - beware filtering by non adspend fields"
    type: sum
    value_format: "#,##0,\" K\""
    sql: ${TABLE}.clicks ;;
  }

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

  measure: orders {
    label: "Orders (#)"
    description: "Total Orders - beware filtering by non sales fields"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.orders ;;
  }

  measure: sales {
    label: "Gross Sales ($k)"
    description: "Total Gross Sales - beware filtering by non sales fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.sales ;;
  }

  measure: c3_cohort_sales {
    label: "C3 Cohort Sales ($k)"
    description: "Total C3 Sales from adspend date (cohort) - beware filtering by non C3 fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.c3_cohort_sales ;;
  }

  measure: c3_trended_sales {
    label: "C3 Trended Sales ($k)"
    description: "Total C3 Sales from sale/purchase date (trended) - beware filtering by non C3 fields"
    type: sum
    value_format: "$#,##0,\" K\""
    #value_format: "$#,##0"
    sql: ${TABLE}.c3_trended_sales ;;
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
    value_format: "#,##0"
    sql: ${TABLE}.c3_new_cohort;;
  }


}
