#-------------------------------------------------------------------
# Owner - Scott Clark
# Daily Ad Spend
#-------------------------------------------------------------------
include: "/views/_period_comparison.view.lkml"
view: daily_adspend {
  sql_table_name: marketing.adspend ;;
  extends: [_period_comparison]

  dimension: ad_date_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}.ad_id||'-'||${TABLE}.date;; }

  dimension_group: ad {
    ### Scott Clark 1/8/21: Deleted week_of_year. need to reverse this last week of 2021
    label: "  Ad"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;; }

  dimension: ad_week_of_year {
    ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
    type:  number
    label: "Week of Year"
    group_label: "  Ad Date"
    description: "2021 adjusted week of year number"
    sql: case when ${ad_date::date} >= '2020-12-28' and ${ad_date::date} <= '2021-01-03' then 1
              when ${ad_year::number}=2021 then date_part(weekofyear,${ad_date::date}) + 1
              else date_part(weekofyear,${ad_date::date}) end ;;
  }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "  Ad Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${ad_date::date} >= '2020-12-28' and ${ad_date::date} <= '2021-01-03' then 2021 else ${ad_year} end   ;;
  }

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

  dimension: date_raw {
    hidden: yes
    type: date_time
    sql: ${TABLE}.date ;;
  }

  dimension: MTD_flg{
    label: "z - MTD Flag"
    group_label: "  Ad Date"
    description: "This field is for formatting on MTD (month to date) reports"
    type: yesno
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) and month(${TABLE}.date) = month(dateadd(day,-1,current_date)) and year(${TABLE}.date) = year(current_date) ;;  }

  dimension: last_30{
    label: "z - Last 30 Days"
    group_label: "  Ad Date"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.date > dateadd(day,-30,current_date);; }

  dimension: rolling_7day {
    label: "z - Rolling 7 Day Filter"
    group_label: "  Ad Date"
    description: "Yes = 7 most recent days ONLY"
    type: yesno
    sql: ${ad_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;  }

  dimension: Before_today{
    group_label: "  Ad Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.date < current_date;; }

  dimension: current_week_num{
    group_label: "  Ad Date"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is before the previous week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.date::date) < date_trunc(week, current_date) ;;}
    #sql: date_part('week',${TABLE}.date) < date_part('week',current_date);; }
    #sql: date_part('week',${TABLE}.date) < 53;; }

  dimension: prev_week{
    group_label: "  Ad Date"
    label: "z - Previous Week"
    description: "Yes/No for if the date is the previous week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension_group: current {
    label: "  Ad"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: current_date ;; }

  dimension: bef_current_week_num {
    group_label: "  Ad Date"
    label: "z - Week Number Before Current Week"
    description: "Yes/No for Ad Date Week of Year is before Current Date Week of Year"
    type: yesno
    sql:  ${ad_week_of_year} < ${current_week_of_year} ;; }

  dimension: ytd {
    group_label: "  Ad Date"
    label: "z - YTD"
    description: "Yes/No for Ad Date Day of Year is before Current Date Day of Year"
    type: yesno
    sql:  ${ad_day_of_year} < ${current_day_of_year} ;; }

  dimension: day_offset {
    group_label: "  Ad Date"
    label: "z - Day Offset"
    description: "A difference in day of year, yesterday is a -1 tomorrow is a 1, today is 0.  You'll need to filter by year as it's all years"
    type: number
    sql:  ${ad_day_of_year} - ${current_day_of_year} ;; }

  dimension: week_offset {
    group_label: "  Ad Date"
    label: "z - Week Offset"
    description: "A difference in week of year, yesterday is a -1 tomorrow is a 1, today is 0.  You'll need to filter by year as it's all years"
    type: number
    sql:  ${ad_week_of_year} - ${current_week_of_year} ;; }

  measure: adspend {
    label: "Total Adspend ($k)"
    group_label: "Advanced"
    description: "Total adspend for selected channels (includes Agency cost)"
    type: number
    value_format: "$#,##0,\" K\""
    sql: ${agency_cost}+${adspend_no_agency} ;;  }

  measure: adspend_raw {
    label: "  Total Adspend ($)"
    description: "Total adspend for selected channels (includes Agency cost)"
    type: number
    value_format: "$#,##0"
    sql: ${adspend} ;;  }

  measure: adspend_no_calc {
    label: "Total Adspend - No Calc ($)"
    group_label: "Advanced"
    description: "Total adspend for selected channels (includes Agency cost) but without calculations"
    type: sum
    value_format:  "$#,##0"
    #agency cost + adspend no agency
    sql:  case when ${TABLE}.platform in ('FB/IG') and (${TABLE}.date::date >= '2019-06-04'and ${TABLE}.date::date <= '2020-12-11') then ${TABLE}.spend*1.1
      when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' AND ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      when (${TABLE}.source ilike ('%outub%')and ${TABLE}.platform NOT in ('DV360')) and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      else ${TABLE}.spend
      end ;; }

  # measure: adspend_current_period{
  #   label: "Total Adspend ($k) current period"
  #   group_label: "Advanced"
  #   description: "Total adspend for selected channels (includes Agency cost)"
  #   type: number
  #   value_format: "$#,##0,\" K\""
  #   sql: ${adspend_no_calc_current_period}+${adspend_no_agency_current_period} ;;  }

  # measure: adspend_no_calc_current_period {
  #   label: "Total Adspend Current Period - No Calc ($)"
  #   group_label: "Advanced"
  #   description: "Total adspend for selected channels (includes Agency cost) but without calculations"
  #   type: sum
  #   value_format:  "$#,##0"
  #   #agency cost + adspend no agency
  #   sql:  case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' then ${TABLE}.spend*.1
  #     when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
  #     when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01'and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.06
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.085
  #     when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.01
  #     when ${TABLE}.platform in ('RADIO','PODCAST','CINEMA') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.06
  #     else ${TABLE}.spend
  #     end ;;
  #   filters: [is_current_period: "yes"]
  #   }

  # measure: adspend_no_agency_current_period {
  #   label: "Adspend without Agency Cost ($) current period"
  #   group_label: "Advanced"
  #   description: "Total adspend EXCLUDING Agency Within and Modus agency fees for selected channels"
  #   type: sum
  #   value_format: "$#,##0"
  #   sql: case
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01' and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.94
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2020-03-01' then ${TABLE}.spend*.915
  #     when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.9
  #     when ${TABLE}.source in ('RADIO','PODCAST','CINEMA') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.94
  #     else ${TABLE}.spend
  #     end ;;
  #   filters: [is_current_period: "yes"]
  # }
  # measure: adspend_no_calc_comparison_period {
  #   label: "Total Adspend Comparison Period - No Calc ($)"
  #   group_label: "Advanced"
  #   description: "Total adspend for selected channels (includes Agency cost) but without calculations"
  #   type: sum
  #   value_format:  "$#,##0"
  #   #agency cost + adspend no agency
  #   sql:  case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' then ${TABLE}.spend*.1
  #     when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
  #     when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01'and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.06
  #     when ${TABLE}.source in ('TV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.085
  #     when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.01
  #     when ${TABLE}.platform in ('RADIO','PODCAST','CINEMA') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.06
  #     else ${TABLE}.spend
  #     end ;;
  #   filters: [is_comparison_period: "yes"]
  # }

  measure: agency_cost {
    label: "  Agency Cost ($)"
    group_label: "Advanced"
    description: "Total cost to Agency Within and Modus for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' and ${TABLE}.date::date < '2020-11-30' then ${TABLE}.spend*.1
      when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' and ${TABLE}.date::date <= '2020-07-31' then ${TABLE}.spend*.1
      when (${TABLE}.source ilike ('%outub%') and ${TABLE}.platform in ('GOOGLE')) and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
      -- when ${TABLE}.platform in ('DV360') then ${TABLE}.spend*.05 -- MAPPED TOTAL MEDIA COST 3/1
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01'and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.06
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.085
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.1
      when ${TABLE}.platform in ('RADIO','PODCAST','STREAMING','CINEMA')
      OR (${TABLE}.platform in ('YOUTUBE') AND ${TABLE}.source in ('AUDIO')) and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.06
      end ;;
    }


  measure: adspend_no_agency {
    label: "Adspend without Agency Cost ($)"
    group_label: "Advanced"
    description: "Total adspend EXCLUDING Agency Within and Modus agency fees for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01' and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.94
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2020-03-01' then ${TABLE}.spend*.915
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.9
      when ${TABLE}.platform in ('RADIO','PODCAST','STREAMING','CINEMA')
      OR (${TABLE}.platform in ('YOUTUBE') AND ${TABLE}.source in ('AUDIO')) and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.94
      else ${TABLE}.spend
      end ;;
  }

  measure: avg_adspend {
    label: "Average Daily Spend"
    hidden:  yes
    description: "Hidden field to get average daily adspend for defined period"
    type: number
    sql: sum(${TABLE}.spend)/NULLIF(count(distinct(${ad_date})),0) ;;  }

  measure: impressions {
    label: "  Total Impressions"
    description: "Total impressions for selected channels (online only)"
    type: sum
    sql: ${TABLE}.impressions ;; }

  measure: impressions_mil {
    label: "Total Impressions (Millions)"
    group_label: "Advanced"
    description: "Total impressions for selected channels (online only)"
    type: sum
    value_format: "#,##0,\" K\""
    sql: ${TABLE}.impressions ;; }


  measure: clicks {
    label: "  Total Clicks"
    description: "Total clicks for selected channels (online only)"
    type: sum
    sql: ${TABLE}.clicks ;; }

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


#   #dimension: spend_platform {
#     label: " Spend Platform"
#     description: "What platform for spend (google, facebook, TV, etc.)"
#     type:  string
#     sql: case when ${TABLE}.source ilike ('%outub%') then 'YOUTUBE.COM'
#         when ${TABLE}.source ilike ('%instagram%') then 'INSTAGRAM'
#         when ${TABLE}.source = ('RAKUTEN') then 'RAKUTEN'
#         when ${TABLE}.source = ('CTV') then 'CTV'
#         when ${TABLE}.source = ('TV') then 'TV'
#         when ${TABLE}.source = ('RADIO') then 'RADIO'
#         when ${TABLE}.source = ('STREAMING') then 'STREAMING'
#         when ${TABLE}.source = ('PODCAST') then 'PODCAST'
#         else ${TABLE}.platform end ;; }

dimension: country {
  label: "Country"
  description: "USA or CA"
  type:  string
  sql: ${TABLE}.country;;}

  dimension: budget_owner {
    label: "Budget Owner"
    description: "a way to filter spend by budget owner"
    type:  string
    sql: ${TABLE}.budget_owner;;}


dimension: spend_platform {
    label: "Spend Platform"
    description: "What platform for spend (google, facebook, oceanmedia)"
    type:  string
    sql: ${TABLE}.platform;;}

  dimension: Spend_platform_condensed {
    label: "Major Spend Platform"
    description: "What platform for spend, grouping smaller platforms into all other (Facebook,Google,TV,Amazon,Yahoo,Other)"
    group_label: "Advanced"
    type: string
    case: {
      when: {sql: ${TABLE}.platform in ('FACEBOOK','PINTEREST','SNAPCHAT','TWITTER','FB/IG') ;; label: "Social" }
      when: {sql: ${TABLE}.platform = 'GOOGLE' ;; label: "Google"}
      when: {sql: ${TABLE}.platform in ('RADIO','PODCAST','CINEMA','SIRIUSXM','PANDORA','PRINT','VERITONE') or ${TABLE}.source in ('CTV','TV','RADIO','STREAMING','PODCAST');; label: "Traditional" }
      when: {sql: ${TABLE}.platform in ('AMAZON MEDIA GROUP','AMAZON-SP','AMAZON-HSA','AMAZON PPC') ;;  label: "Amazon" }
      when: {sql: ${TABLE}.platform in ('YAHOO','BING') ;; label: "Yahoo/Bing" }
      when: {sql: ${TABLE}.platform = 'AFFILIATE' ;; label: "Affiliate"}
      when: {sql: ${TABLE}.platform in ('EXPONENTIAL','ACUITY','ADROLL','HIVEWIRE','HARMON') ;; label: "Partners" }
      #when: {sql: ${TABLE}.platform = 'HARMON' ;; label: "HARMON"}
      else: "Other" } }

  dimension: medium {
    label: "  Medium"
    description: "Calculated based on source and platform"
    type: string
    case: {
      when: {sql: ${spend_platform} = 'AFFILIATE' OR ${TABLE}.platform in ('AFFILIATE')  or ${source} in ('AFFILIATE');; label: "affiliate" }
      when: {sql: ${TABLE}.platform in ('PODCAST','RADIO','STREAMING','SPOTIFY','SIRIUSXM') or ${spend_platform} ilike 'STREAMING%' or (${source} = 'AUDIO' and ${spend_platform}='YOUTUBE');; label: "audio" }
      when: {sql: ${TABLE}.platform in ('MADRIVO','ADWALLET','FKL', 'FLUENT','Fluent', 'LIVEINTENT', 'TALKABLE','ROKT') or ${TABLE}.platform ilike ('MYMOVE%') ;; label: "crm" }
      when: {sql: lower(${TABLE}.platform) in ('google','bing','verizon') and ${campaign_name} ilike ('%shopping%') or ${campaign_name} ilike ('sh_%') or ${TABLE}.source in ('PLA') ;; label: "pla"}
      when: {sql: (${campaign_name} ilike '%ative%' and not ${spend_platform} = 'ADMARKETPLACE') or ${campaign_name} ilike 'nt_%' or ${TABLE}.source in ('Native','NATIVE') OR ${TABLE}.platform in ('TABOOLA', 'MATTRESS TABOOLA');; label: "native" }
      when: {sql: ${TABLE}.source in ('DISPLAY')
        or ${spend_platform} = 'AMAZON-SP' or ${campaign_name} ilike '%displa%' and ${TABLE}.platform ilike ('ACUITY') ;; label:"display" }
      when: {sql: ${TABLE}.source ilike ('%earc%') or (${campaign_name} ilike 'NB%' and ${spend_platform} <> 'OCEAN MEDIA')
        or (${campaign_name} ilike '&ative%earch%' and ${spend_platform} = 'ADMARKETPLACE')
        or ${spend_platform} in ('AMAZON-HSA');; label:"search"}
      when: {sql: ${TABLE}.platform in ('FACEBOOK','WAZE','PINTEREST','SNAPCHAT','QUORA','TWITTER', 'NEXTDOOR', 'FB/IG', 'TIKTOK') OR ${TABLE}.source ilike ('instagram')
        or ${TABLE}.source ilike 'messenger' ;; label:"social"}
      when: {sql: ${TABLE}.platform in ('HULU','PRINT','PANDORA','USPS','NINJA','INTEGRAL MEDIA','OCEAN MEDIA', 'POSTIE','REDCRANE', 'TV', 'VERITONE', 'MODUS')
        OR ${TABLE}.source in ('CINEMA','VERITONE') ;; label:"traditional"}
      when: {sql: ${TABLE}.platform = 'HARMON' OR ${TABLE}.source ilike ('%outub%') or ${TABLE}.source in ('VIDEO','Video')
        or (${spend_platform} = 'EXPONENTIAL' and ${TABLE}.source <> 'EXPONENTIAL') ;; label:"video" }
      else: "other" }
  }

  dimension: medium_new{
    label: "Medium New"
    description: "Calculated based on source and platform"
    hidden: no
    type: string
    case: {

      when: {sql: UPPER(${TABLE}.platform) in ('PINTEREST','SNAPCHAT','QUORA','TWITTER', 'NEXTDOOR', 'TIKTOK') ;; label:"social growth"}
      when: {sql: UPPER(${TABLE}.platform) in ('FB/IG') ;; label:"social"}
      when: {sql: UPPER(${TABLE}.source) = 'TV' or UPPER(${TABLE}.platform) = 'TV' ;; label:"TV"}
      when: {sql: UPPER(${TABLE}.platform) in ('INTEGRAL MEDIA','LIVEINTENT','TALKABLE','POSTIE','PRINT') ;; label: "crm" }
      when: {sql: UPPER(${spend_platform}) = 'AFFILIATE' OR UPPER(${TABLE}.platform) in ('AFFILIATE') or UPPER(${source}) in ('AFFILIATE');; label: "affiliate" }
      when: {sql: UPPER(${TABLE}.platform) in ('PODCAST','RADIO','STREAMING','SPOTIFY','SIRIUSXM', 'PANDORA')
          or (UPPER(${TABLE}.platform) in ('YOUTUBE') and UPPER(${source})='AUDIO') ;; label: "audio" }
      when: {sql: (NOT UPPER(${TABLE}.platform) in ('FB/IG')) and ${campaign_name} ilike '%ative%' or ${TABLE}.source in ('Native','NATIVE') OR UPPER(${TABLE}.platform) in ('TABOOLA', 'MATTRESS TABOOLA');; label: "native" }
      when: {sql: (UPPER(${TABLE}.source) = 'SEARCH' AND LOWER(${campaign_name}) ilike '%_br_%')
                  or (UPPER(${TABLE}.source) = 'SEARCH' AND LOWER(${campaign_name}) ilike '%Brand:%')
                  or (UPPER(${TABLE}.source) = 'SEARCH' AND LOWER(${campaign_name}) ilike '%Brand_%')
                  or UPPER(${TABLE}.source) = 'AMAZON PPC';; label:"brand search"}
      when: {sql: UPPER(${TABLE}.source) = 'CTV' OR UPPER(${TABLE}.platform) in ('HULU');; label:"CTV"}
      when: {sql: UPPER(${TABLE}.platform) in ('EBAY','AMAZON MEDIA GROUP') OR ${TABLE}.source ilike ('%ispla%') or UPPER(${TABLE}.source) in ('DISPLAY')
          or UPPER(${spend_platform}) = 'AMAZON-SP' or ${campaign_name} ilike '%displa%' or UPPER(${TABLE}.platform) ilike ('ACUITY') ;; label:"display" }
      when: {sql: (${TABLE}.source ilike ('SEARCH') AND NOT (LOWER(${campaign_name}) ilike 'br%'))
                  or UPPER(${spend_platform}) in ('AMAZON-HSA')
                  or (${campaign_name} ilike '&ative%earch%' and UPPER(${spend_platform}) = 'ADMARKETPLACE');; label:"search"}
      when: {sql: UPPER(${TABLE}.platform) in ('ADWALLET','FKL','FLUENT','FLUENT','MADRIVO','ROKT','REDCRANE') or ${TABLE}.platform ilike ('MYMOVE%') ;; label: "lead gen" }
      when: {sql: lower(${TABLE}.platform) in ('google','bing','verizon') and ${campaign_name} ilike ('%shopping%') or ${campaign_name} ilike ('sh_%') or UPPER(${TABLE}.source) in ('PLA') ;; label: "pla"}
      when: {sql: ${TABLE}.platform = 'HARMON' OR ${TABLE}.source ilike ('%outub%') or UPPER(${TABLE}.source) = 'VIDEO'
            or (UPPER(${spend_platform}) = 'EXPONENTIAL' and UPPER(${TABLE}.source) <> 'EXPONENTIAL')
            or UPPER(${TABLE}.source) = 'EXPONENTIAL';; label:"video" }
      else: "other" }
  }

  dimension: channel {
    type: string
    hidden:  no
    label: " Channel"
    description: "Channel that current session came from"
    sql: case when ${medium} ilike '%Search%' then 'search'
          when ${medium} ilike '%Social%' then 'social'
          when ${medium} ilike 'Video' then 'video'
          when ${medium} ilike 'Native' then 'native'
          when ${medium} ilike 'Display' then 'display'
          when ${medium} ilike 'pla' then 'pla'
          when ${medium} ilike '%Affiliate%' then 'affiliate'
          when ${medium} ilike 'traditional' then 'traditional'
          when ${medium} ilike 'crm' then 'crm'
          when ${medium} is null then 'organic'
          when ${medium} ilike 'Referral' then 'referral'
          when ${medium} ilike 'Shopping' then 'shopping'
          else 'other'
           end ;; }

  dimension: agency_within {
    label: "      * Managed by Agency Within"
    description: "A Channel Managed by Agency Within"
    type: yesno
    sql: (${spend_platform} = 'GOOGLE' and ${medium} = 'display')
      or ${spend_platform} = 'YOUTUBE.COM' or ${spend_platform} = 'FACEBOOK' or ${spend_platform} = 'INSTAGRAM'
       ;;
  }

  dimension: ad_display_type {
    label: "Ad Display Type"
    hidden:  yes
    group_label: "Advanced"
    description: "How ad was presented (Search, Display, Video, TV, etc.)"
    type:  string
    sql: ${TABLE}.source ;; }

  dimension: source {
    label: "Source"
    group_label: "Advanced"
    description: "How ad was presented (Search, Display, Video, TV, etc.)"
    type:  string
    sql: ${TABLE}.source ;; }

  dimension: campaign_name {
    label: "Campaign Name"
    type:  string
    sql: ${TABLE}.campaign_name ;; }

  dimension: campaign_id {
    label: "Campaign ID"
    type:  string
    sql: ${TABLE}.campaign_id;; }


  dimension: ad_name {
    label: "Ad Name"
    type:  string
    sql: ${TABLE}.ad_name ;; }

  dimension: ad_id {
    label: "Ad ID"
    type:  string
    sql: ${TABLE}.ad_id ;; }

  dimension: campaign_type {
    label: "Campaign Type"
    group_label: "Advanced"
    description: "Bucketing the Campaign type into Prospecting, Retargeting, Brand, and Other"
    type:  string
    case: {
      when: {sql:  ${TABLE}.campaign_type = 'BRAND' ;; label: "BRAND" }
      when: { sql:  ${TABLE}.campaign_type = 'PROSPECTING' ;;  label: "PROSPECTING" }
      when: { sql:  ${TABLE}.campaign_type = 'RETARGETING' ;;  label: "RETARGETING" }
      else: "OTHER" } }

  dimension: ad_device {
    label: "  Ad Device"
    description: "What device was ad viewed on? (Mobile, Tablet, Desktop, Other)"
    type: string
    case: {
      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_SMARTPHONE','IPHONE','MOBILE DEVICES WITH FULL BROWSERS','SMARTPHONE') ;;
        label: "MOBILE" }
      when: { sql: upper(${TABLE}.device) in ('ANDROID_TABLET','IPAD','TABLETS WITH FULL BROWSERS','IPOD','TABLET') ;;
        label: "TABLET" }
      when: { sql: upper(${TABLE}.device) in ('COMPUTER','COMPUTERS','DESKTOP') ;;  label: "DESKTOP" }
      else: "OTHER"  } }

  dimension: platform_source_group {
    hidden:  no
    label:  "Platform Source Group"
    group_label: "Advanced"
    description: "Grouping of source, platform, and if the name has shop"
    type: string
    case: {
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.campaign_name) like '%shop%' ;; label: "Google-Shopping" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) = 'search network' ;; label: "Google-Search" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) = 'display network' ;; label: "Google-Display" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) like '%youtube%' ;; label: "Youtube" }
      when: { sql: ${TABLE}.platform = 'BING' ;; label: "BING" }
      when: { sql: ${TABLE}.platform = 'AMAZON MEDIA GROUP' ;; label: "Amazon Media Group" }
      when: { sql: ${TABLE}.platform = 'YAHOO' ;; label: "Verizon Media Group" }
      else: "Other" } }

  dimension: purchase_viewthrough_conversions {
    hidden:  yes
    label: "Purchase Viewthrough Conversions"
    description: "Conversions within 1 day of viewing a page - only for Quora"
    type: number
    sql: ${TABLE}.purchase_viewthrough_conversions ;; }

#For Ocean Media Reporting
 dimension: ocean_bucket {
    hidden: yes
    case: {
      when: {sql: ${spend_platform} = 'TV' ;; label: "TV"}
      when: {sql: ${spend_platform} IN ('FACEBOOK','INSTAGRAM') AND ${campaign_type} <> 'RETARGETING' ;; label: "FB PT"}
      when: {sql: ${spend_platform} IN ('FACEBOOK','INSTAGRAM') AND ${campaign_type} = 'RETARGETING' ;; label: "FB RT"}
      when: {sql: ${medium} = 'video' ;; label: "Video"}
      when: {sql: ${medium} = 'social' ;; label: "Social"}
      when: {sql: ${medium} = 'search' and ${campaign_type} = 'BRAND' ;; label: "Brand SEM"}
      when: {sql: ${medium} = 'search' and ${campaign_type} <> 'BRAND' ;; label: "Brand SEM"}
      when: {sql: ${medium} = 'affiliate' ;; label: "Affiliate"}
      when: {sql: ${spend_platform} = 'INTEGRAL MEDIA' ;; label: "Outdoor"}
      when: {sql: ${spend_platform} = 'PODCAST' ;; label: "Audio Channel 1"}
      when: {sql: ${spend_platform} = 'SPOTIFY' ;; label: "Audio Channel 2"}
      else: "Other"
    }
  }

  dimension: product_focus{
    hidden: no
    label: "Product focus"
    description: "Product category being advertised. Defaults to MATTRESS if no specific category is mentioned in the campaign description."
    group_label: "Advanced"
    sql: case when campaign_name ilike '%acc%' then 'BEDDING'
                when campaign_name ilike '%protector%' then 'BEDDING'
                when campaign_name ilike '%heet%' then 'BEDDING'
                when campaign_name ilike '%matt%' then 'MATTRESS'
                when campaign_name ilike '%illo%' then 'BEDDING'
                when campaign_name ilike '%armony%' then 'BEDDING'
                when campaign_name ilike '%ushio%' then 'SEATING'
                when campaign_name ilike '%desk%' then 'SEATING'
                when campaign_name ilike '%et b%' then 'PET'
                when campaign_name ilike '%bedd%' then 'BEDDING'
                when campaign_name ilike '%rame%' then 'BASE'
                when campaign_name ilike '%platform%' then 'BASE'
                when campaign_name ilike '%foundati%' then 'BASE'
                when campaign_name ilike '%blanket%' then 'BEDDING'
                when campaign_name ilike '%mask%' then 'MASK'
                when campaign_name ilike '%bed%' then 'MATTRESS'
                else 'MATTRESS' end ;;
  }

  measure: last_updated_date {
    type: date
    sql: MAX(${ad_raw}) ;;
    convert_tz: no
  }

  ## For _period_comparison
  measure: adspend_current_period {
    label: "Total Adspend Current Period"
    group_label: "Period Comparison"
    description: "Total adspend for selected channels (includes Agency cost)"
    type: number
    value_format: "$#,##0"
    sql: ${agency_cost_current_period}+${adspend_no_agency_current_period} ;;  }

  measure: agency_cost_current_period {
    label: "  Agency Cost ($) Current Period"
    group_label: "Period Comparison"
    description: "Total cost to Agency Within and Modus for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' or ${TABLE}.date::date < '2021-01-01' then ${TABLE}.spend*.1
    when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display'
    and ${TABLE}.date::date >= '2019-06-14' and ${TABLE}.date::date <= '2020-07-31' then ${TABLE}.spend*.1
    when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01'and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.06
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.085
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.1
      when ${TABLE}.platform in ('RADIO','PODCAST','CINEMA','STREAMING') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.06
      end ;;
    filters: [is_current_period: "yes"]
  }


  measure: adspend_no_agency_current_period {
    label: "Adspend without Agency Cost ($) Current Period"
    group_label: "Period Comparison"
    description: "Total adspend EXCLUDING Agency Within and Modus agency fees for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01' and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.94
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2020-03-01' then ${TABLE}.spend*.915
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.9
      when ${TABLE}.PLATFORM in ('RADIO','PODCAST','CINEMA','STREAMING') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.94
      else ${TABLE}.spend
      end ;;
    filters: [is_current_period: "yes"]
  }

  measure: adspend_no_calc_current_period {
    label: "Total Adspend - No Calc ($) Current Period"
    group_label: "Period Comparison"
    description: "Total adspend for selected channels (includes Agency cost) but without calculations"
    type: sum
    value_format:  "$#,##0"
    #agency cost + adspend no agency
    sql:  case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' or ${TABLE}.date::date < '2021-01-01' then ${TABLE}.spend*1.1
      when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      else ${TABLE}.spend
      end ;;
    filters: [is_current_period: "yes"]
  }

  measure: adspend_comparison_period {
    label: "Total Adspend Comparison Period"
    group_label: "Period Comparison"
    description: "Total adspend for selected channels (includes Agency cost)"
    type: number
    value_format: "$#,##0"
    sql: ${agency_cost_comparison_period}+${adspend_no_agency_comparison_period} ;;
  }

  measure: agency_cost_comparison_period {
    label: "  Agency Cost ($) Comparison Period"
    group_label: "Period Comparison"
    description: "Total cost to Agency Within and Modus for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04' or ${TABLE}.date::date < '2021-01-01'then ${TABLE}.spend*.1
      when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
      when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*.1
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01'and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.06
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.085
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.1
      when ${TABLE}.platform in ('RADIO','PODCAST','CINEMA') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.06
      end ;;
    filters: [is_comparison_period: "yes"]
  }

  measure: adspend_no_agency_comparison_period {
    label: "Adspend without Agency Cost ($) Comparison Period"
    group_label: "Period Comparison"
    description: "Total adspend EXCLUDING Agency Within and Modus agency fees for selected channels"
    type: sum
    value_format: "$#,##0"
    sql: case
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2018-10-01' and ${TABLE}.date::date < '2020-03-01' then ${TABLE}.spend*.94
      when ${TABLE}.source in ('TV') and ${TABLE}.date::date >= '2020-03-01' then ${TABLE}.spend*.915
      when ${TABLE}.source in ('CTV') and ${TABLE}.date::date > '2020-03-01' then ${TABLE}.spend*.9
      when ${TABLE}.platform in ('RADIO','PODCAST','CINEMA') and ${TABLE}.date::date >= '2019-08-01' then ${TABLE}.spend*.94
      else ${TABLE}.spend
      end ;;
    filters: [is_comparison_period: "yes"]
  }

  measure: adspend_no_calc_comparison_period {
    label: "Total Adspend - No Calc ($) Comparison Period"
    group_label: "Period Comparison"
    description: "Total adspend for selected channels (includes Agency cost) but without calculations"
    type: sum
    value_format:  "$#,##0"
    #agency cost + adspend no agency
    sql:  case when ${TABLE}.platform in ('FB/IG') and ${TABLE}.date::date >= '2019-06-04'or ${TABLE}.date::date < '2021-01-01' then ${TABLE}.spend*1.1
      when ${TABLE}.platform in ('GOOGLE') and ${medium} = 'display' and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      when ${TABLE}.source ilike ('%outub%') and ${TABLE}.date::date >= '2019-06-14' then ${TABLE}.spend*1.1
      else ${TABLE}.spend
      end ;;
    filters: [is_comparison_period: "yes"]
  }

  ##For C-level Dashboard

  parameter: see_data_by {
    type: unquoted
    hidden: yes
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Medium"
      value: "medium"
    }
    allowed_value: {
      label: "Spend Platform"
      value: "spend_platform"
    }
  }

  dimension: see_data {
    label: "See Data By"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${ad_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${ad_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${ad_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${ad_quarter}
    {% elsif see_data_by._parameter_value == 'medium' %}
      ${medium}
    {% elsif see_data_by._parameter_value == 'spend_platform' %}
      ${spend_platform}
    {% else %}
      ${ad_date}
    {% endif %};;
  }

}
