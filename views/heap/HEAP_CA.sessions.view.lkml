#######################################
# Created By: Blake Walton 2020-11-16 #
#######################################

view: heap_ca_sessions {

  sql_table_name: heap_canada.heap.sessions ;;

  dimension: session_id {
    #primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;; }

  dimension: session_unique_id {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${session_id} || '-' || ${user_id} ;;
  }

  dimension: app_name {
    label: "App Name"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.app_name ;; }

  dimension: app_version {
    label: "App Version"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    hidden:  yes
    sql: ${TABLE}.app_version ;; }

  dimension: browser {
    label: "Browser"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.browser ;; }

  dimension: browser_bucket {
    label: "Browser Bucket"
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: case when ${browser} ilike ('%Chrome%') then 'Chrome'
              when ${browser} ilike ('%Safari%') then 'Safari'
              when ${browser} ilike ('%Amazon Silk%') then 'Amazon Silk'
              when ${browser} ilike ('%Edge%') then 'Edge'
              when ${browser} ilike ('%Firefox%') then 'Firefox'
              when ${browser} ilike ('%IE%') then 'Edge'
              when ${browser} ilike ('%Facebook%') then 'Facebook'
              when ${browser} ilike ('%Chromium%') then 'Chromium'
              when ${browser} ilike ('%Opera%') then 'Opera'
              when ${browser} ilike ('%Samsung Internet%') then 'Samsung Internet'
              when ${browser} ilike ('%NewFront%') then 'NewFront'
              when ${browser} ilike ('%Apple Mail%') then 'Apple Mail'
              when ${browser} ilike ('%AppleMail%') then 'Apple Mail'
              else 'Other' end ;; }

  dimension: carrier {
    label: "Carrier"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.carrier ;; }

  dimension: city {
    group_label: "Advanced"
    label: "City"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.city ;; }

  dimension: country {
    group_label: "Advanced"
    label: "Country"
    description: "Source: HEAP_CANADA.sessions"
    map_layer_name: countries
    type: string
    sql: ${TABLE}.country ;; }

  dimension: device {
    label: "Device"
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.device ;; }

  dimension: device_type {
    label: "Device Type"
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.device_type ;; }

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: ip {
    label: "IP"
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.ip ;; }

  dimension: landing_page {
    label: " Landing Page"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.landing_page ;; }

  dimension: page_type {
    label: " Page Type"
    type:  string
    description: "Bucketed landing pages. Source: looker calculation"
    sql:  case when ${landing_page} ilike ('%checkouts%') then 'Checkout Page'
       when ${landing_page} ilike ('%mattresses%') or ${landing_page} ilike ('%pillows%') or ${landing_page} ilike ('%/sheets') or ${landing_page} ilike ('%/mattress-protector') or ${landing_page} ilike ('%/platform') or ${landing_page} ilike ('%/powerbase') or ${landing_page} ilike ('%/pet-bed') or ${landing_page} ilike ('%/seatcushions') then 'PDP'
       when ${landing_page} ilike ('purple.com/') then 'Home Page'
       when ${landing_page} ilike ('%medium=%') or ${landing_page} ilike ('%promo') then 'Main Landing Page'
       when ${landing_page} ilike ('%/buy%') then 'Buy Page' end;; }

  dimension: library {
    label: "Library"
    type: string
    hidden: yes
    sql: ${TABLE}.library ;; }

  dimension: phone_model {
    hidden: yes
    sql: ${TABLE}.phone_model ;;
  }

  dimension: platform {
    label: "Platform"
    group_label: "Advanced"
    description: "Device OS. Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.platform ;; }

  dimension: referrer {
    label: " Referrer"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.referrer ;; }

  dimension: referrer_2 {
    label: " Referrer (grouped)"
    description: "Source: looker calculation"
    type: string
    sql: case when ${TABLE}.referrer ilike ('%purple.com%') then 'https://purple.com/*'
                when ${TABLE}.referrer ilike ('%google.%') then 'https://google.com/*'
                when ${TABLE}.referrer ilike ('%facebook%') then 'https://facebook.com/*'
                when ${TABLE}.referrer ilike ('%youtube%') then 'https://youtube.com/*'
                when ${TABLE}.referrer ilike ('%msn.%') then 'https://msn.com/*'
                when ${TABLE}.referrer ilike ('%bing.%') then 'https://bing.com/*'
                when ${TABLE}.referrer ilike ('%yahoo.%') then 'https://yahoo.com/*'
                when ${TABLE}.referrer ilike ('%myslumberyard%') then 'https://myslumberyard.com/*'
                when ${TABLE}.referrer ilike ('%tuck%') then 'https://tuck.com/*'
                when ${TABLE}.referrer ilike ('%pinterest.%') then 'https://pinterest.com/*'
                when ${TABLE}.referrer ilike ('%affirm%') then 'https://affirm.com/*'
                when ${TABLE}.referrer ilike ('%sleepopolis%') then 'https://sleepopolis.com/*'
                when ${TABLE}.referrer ilike ('%mattressclarity%') then 'https://mattressclarity.com/*'
                when ${TABLE}.referrer ilike ('%narvar.%') then 'https://narvar.com/*'
                when ${TABLE}.referrer ilike ('%instagram%') then 'https://instagram.com/*'
                else left(${TABLE}.referrer,16)||'*' end ;; }
        #https://purple.com

  dimension: referrer_domain {
    hidden: yes
    sql: split_part(${referrer},'/',3) ;;
    }



  dimension: region {
    label: "Region"
    type: string
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    sql: ${TABLE}.region ;; }

  dimension: in_canada {
    label: "In Canada"
    type: yesno
    description: " 'Yes' if Region is one of the 13 Canadian provinces or territories, otherwise 'No'. Source: HEAP_CANADA.sessions"
    group_label: "Advanced"
    sql: case when ${TABLE}.region in ('Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador', 'Nova Scotia',
              'Ontario', 'Prince Edward Island', 'Quebec', 'Saskatchewan', 'Northwest Territories', 'Nunavut', 'Yukon')
              then true else false end ;; }

  dimension: search_keyword {
    label: "Search Keyword"
    group_label: "Advanced"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: ${TABLE}.search_keyword ;; }

  dimension_group: time {
    group_label: "  Session Time"
    description: "Source: HEAP_CANADA.sessions"
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year, hour_of_day, minute,hour]
    sql: ${TABLE}.time ;; }

  dimension_group: current_date_sessions {
    view_label: "Sessions"
    label: "    Current"
    description:  "Current Time/Date for calculations. Source: looker.calculation"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

  dimension: last_30{
    label: "z - Last 30 Days"
    group_label: "  Session Time"
    description: "Yes/No for if the date is in the last 30 days. Source: looker calculation"
    type: yesno
    sql: ${TABLE}.time::date > dateadd(day,-30,current_date);; }

  dimension: rolling_7day {
    label: "z - Rolling 7 Day Filter"
    group_label: "  Session Time"
    description: "Yes = 7 most recent days ONLY. Source: looker calculation"
    type: yesno
    sql: ${TABLE}.time::date between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;  }

  dimension: rollingday{
    hidden:  yes
    type: number
    sql: date_part('dayofyear',${TABLE}.time::date)- date_part('dayofyear',current_date) ;; }

  dimension: Before_today{
    group_label: "  Session Time"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: looker calculation"
    type: yesno
    sql: ${TABLE}.time::date < current_date;; }

  dimension: current_week_num{
    group_label: "  Session Time"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker calculation"
    type: yesno
    sql: date_trunc(week, ${TABLE}.time::date) < date_trunc(week, current_date) ;;}

  dimension: current_week_filter_heap{
    view_label: "Sessions"
    group_label: "  Session Time"
    label: "z - Current Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the current week of the year (for each year). Source: looker calculation"
    type: yesno
    sql: EXTRACT(WEEK FROM ${time_date}::date) = EXTRACT(WEEK FROM current_date::date) ;;
  }

  dimension: current_month_filter_heap{
    view_label: "Sessions"
    group_label: "  Session Time"
    label: "z - Current Month"
    #hidden:  yes
    description: "Yes/No for if the date is in the current month of the year (for each year). Source: looker calculation"
    type: yesno
    sql: EXTRACT(month FROM ${time_date}::date) = EXTRACT(month FROM current_date::date) ;;
  }

  dimension: prev_week{
    group_label: "  Session Time"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker calculation"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.time::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: week_bucket_old{
    group_label: "  Session Time"
    label: "z - Week Bucket"
    hidden: yes
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker calculation"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.time::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.time::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.time::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.time::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.time::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.time::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: week_bucket{
    group_label: "  Session Time"
    label: "z - Week Bucket"
    hidden: no
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker calculation"
    type: string
    sql:  CASE WHEN ${time_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${time_year} = date_part (year,current_date) THEN 'Current Week'
            WHEN ${time_week_of_year} = date_part (weekofyear,current_date) AND ${time_year} = date_part (year,current_date) THEN 'Last Week'
            WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -1 AND ${time_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
            WHEN ${time_week_of_year} = date_part (weekofyear,current_date) +1 AND ${time_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
            WHEN ${time_week_of_year} = date_part (weekofyear,current_date) AND ${time_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
            WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -1 AND ${time_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;}

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;; }

  dimension: channel {
    type: string
    hidden:  no
    label: " Channel"
    description: "Channel that current session came from. Source: looker calculation"
    sql: case when ${utm_medium} = 'sr' or ${utm_medium} = 'search' or ${utm_medium} = 'cpc' /*or qsp.search = 1*/ then 'search'
                when ${utm_medium} = 'so' or ${utm_medium} ilike '%social%' or ${referrer} ilike '%fb%' or ${referrer} ilike '%facebo%' or ${referrer} ilike '%insta%' or ${referrer} ilike '%l%nk%din%' or ${referrer} ilike '%pinteres%' or ${referrer} ilike '%snapch%' then 'social'
                when ${utm_medium} ilike 'vi' or ${utm_medium} ilike 'video' or ${referrer} ilike '%y%tube%' then 'video'
                when ${utm_medium} ilike 'nt' or ${utm_medium} ilike 'native' then 'native'
                when ${utm_medium} ilike 'ds' or ${utm_medium} ilike 'display' or ${referrer} ilike '%outbrain%' or ${referrer} ilike '%doubleclick%' or ${referrer} ilike '%googlesyndica%' then 'display'
                when ${utm_medium} ilike 'sh' or ${utm_medium} ilike 'shopping' then 'shopping'
                when ${utm_medium} ilike 'af' or ${utm_medium} ilike 'ir' or ${utm_medium} ilike '%affiliate%' then 'affiliate'
                when ${utm_medium} ilike 'em' or ${utm_medium} ilike 'email' or ${referrer} ilike '%mail.%' or ${referrer} ilike '%outlook.live%' then 'email'
                when ${utm_medium} is null and (${referrer} ilike '%google%' or ${referrer} ilike '%bing%' or ${referrer} ilike '%yahoo%' or ${referrer} ilike '%ask%' or ${referrer} ilike '%aol%' or ${referrer} ilike '%msn%' or ${referrer} ilike '%yendex%' or ${referrer} ilike '%duckduck%') then 'organic'
                when ${utm_medium} ilike 'rf' or ${utm_medium} ilike 'referral' or ${utm_medium} ilike '%partner platfo%' or lower(${referrer}) not like '%purple%' then 'referral'
                when (${referrer} ilike '%purple%' and ${utm_medium} is null) or ${referrer} is null then 'direct' else 'undefined' end ;;
  }

  dimension: utm_campaign {
    group_label: "UTM Tags"
    label: "UTM Campaign"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: lower(${TABLE}.utm_campaign) ;; }

  dimension: utm_campaign_raw {
    hidden: yes
    type:  string
    sql:  ${TABLE}.utm_campaign ;;
  }

  dimension: utm_content {
    group_label: "UTM Tags"
    label: "UTM Content"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: lower(${TABLE}.utm_content) ;;
  }

  dimension: promo_name {
    group_label: "UTM Tags"
    label: "Promo Name"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    case: {
      when: {
        sql: ${utm_content} ilike ('%hgg%')
          or ${utm_campaign} ilike ('%hgg%');;
        label: "Holiday Gift Guide"
      }
      when: {
        sql:lower(${utm_content}) ilike ('%bfd%')
                  or lower(${utm_content}) ilike ('%bfg%')
                  or lower(${utm_campaign}) ilike ('%-bfd%')
                  or lower(${utm_campaign}) ilike ('%bfd_%');;
        label: "Black Friday"
      }
      when: {
        sql:${utm_content} ilike ('%cmd%') ;;
        label: "Cyber Monday"
      }
      else: "unknown"
    }
  }

  dimension: utm_medium {
    group_label: "UTM Tags"
    label: "UTM Medium"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: lower(${TABLE}.utm_medium) ;; }

  dimension: medium_bucket {
    label: "Medium"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: case when ${utm_medium} in ('sr','search','cpc') then 'search'
                when ${utm_medium} = 'so' or ${utm_medium} ilike '%social%' or ${utm_medium} ilike '%facebook%' or ${utm_medium} ilike '%instagram%' or ${utm_medium} ilike 'twitter' then 'social'
                when ${utm_medium} = 'vi' or ${utm_medium} ilike 'video' or ${utm_source} = 'youtube' then 'video'
                when ${utm_medium} = 'af' or ${utm_medium} ilike 'affiliate' then 'affiliate'
                when ${utm_medium} = 'ds' or ${utm_medium} ilike 'display' then 'display'
                when ${utm_medium} = 'lc' then 'local'
                when ${utm_medium} = 'nt' or ${utm_medium} in ('native','nativeads') then 'native'
                when ${utm_medium} = 'rf' or ${utm_medium} ilike 'referral' then 'referral'
                when ${utm_medium} = 'sh'
                or ${utm_medium} = 'feed'
                or ${utm_medium} ilike '%shopping%' then 'pla'
                 when ${utm_medium} = 'em' or ${utm_medium} ilike '%email%' then 'email'
                when ${utm_medium} in( 'sms', 'tx') then 'SMS'
                when ${utm_medium} in ('au','tv','podcast' ,'radio','cinema', 'print','linear') then 'traditional'
                else 'other' end ;;
  }

  dimension: utm_source {
    group_label: "UTM Tags"
    label: "UTM Source"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: lower(${TABLE}.utm_source) ;; }

  dimension: source_bucket {
    label: "Source"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: case when ${utm_source} ilike '%go%' or ${utm_source} ilike '%google%' or ${utm_source} ilike '%gco%'then 'GOOGLE'
                    when ${utm_source} in ('ac') then 'ACUITY'
                    when ${utm_source} in ('adme') then 'ADMEDIA'
                    when ${utm_source} in ('adm') then 'ADMARKETPLACE'
                    when ${utm_source} ilike '%bg%' then 'BING'
                    when ${utm_source} in ('bra') then 'BRAVE'
                    when ${utm_source} in ('co') then 'CORDLESS'
                    when ${utm_source} in ('cn') then 'CONDE NASTE'
                    when ${utm_source} in ('ex') then 'VDX'
                    when ${utm_source} ilike '%fb%' or ${utm_source} ilike '%faceboo%'
                    or ${utm_source} in ('instagram')  then 'FB/IG'
                    when ${utm_source} in ('em') then 'Email'
                    when ${utm_source} in ('findkeeplove') then 'fkl'
                    when ${utm_source} ilike '%yahoo%' then 'YAHOO'
                    when ${utm_source} ilike '%yt%' or ${utm_source} ilike '%youtube%' then 'YOUTUBE'
                    when ${utm_source} ilike '%snapchat%' then 'SNAPCHAT'
                    when ${utm_source} ilike '%adwords%' then 'ADWORDS'
                    when ${utm_source} in ('pinterest', 'pt') then 'PINTEREST'
                    when ${utm_source} in ('ir') then 'IMPACT RADIUS'
                    when ${utm_source} in ('md') then 'MODUS'
                    when ${utm_source} in ('nd') then 'NEXTDOOR'
                    when ${utm_source} in ('om','tv') then 'OCEAN MEDIA'
                    when ${utm_source} ilike '%ob%' then 'OUTBRAIN'
                    when ${utm_source} ilike '%bing%' then 'BING'
                    when ${utm_source} ilike '%gemini%' then 'YAHOO'
                    when ${utm_source} ilike '%vrz%' or ${utm_source} ilike '%oa%' then 'VERIZON MEDIA'
                    when ${utm_source} in ('rk') then 'RAKUTEN'
                    when ${utm_source} in ('si') then 'SIMPLIFI'
                    when ${utm_source} in ('sn') then 'SNAPCHAT'
                    when ${utm_source} in ('sl') then 'SLICK'
                    when ${utm_source} ilike '%tab%' then 'TABOOLA'
                    when ${utm_source} in ('talkable','ta') then 'TALKABLE'
                    when ${utm_source} in ('tk') then 'TIKTOK'
                    when ${utm_source} ilike '%twitter%' then 'TWITTER'
                    when ${utm_source} in ('vr') then 'VERITONE'
                    when ${utm_source} in ('ye') then 'YELP'
                    when ${utm_source} in ('wa') then 'WAZE'
                    when ${utm_source} in ('ze', 'zeta') then 'ZETA'
                    else 'OTHER' end ;;
  }

  dimension: source_medium {
    hidden: yes
    type: string
    sql: ${utm_source} || '/' || ${utm_medium} ;;
  }

  dimension: utm_term {
    group_label: "UTM Tags"
    label: "UTM Term"
    description: "Source: HEAP_CANADA.sessions"
    type: string
    sql: lower(${TABLE}.utm_term) ;; }

  dimension: term_bucket {
    label: "Campaign Type"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    sql: case when ${utm_term} ilike '%br%' then 'BRAND'
            when ${utm_term} ilike '%pt%' then 'PROSPECTING'
            when ${utm_term} = '%rt%' then 'RETARGETING'
            else 'OTHER' end ;;
  }

  dimension_group: current {
    label: "  Ad"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: current_date ;; }

  dimension: ytd {
    group_label: "  Session Time"
    label: "z - YTD"
    description: "Yes/No for Ad Date Day of Year is before Current Date Day of Year. Source: looker calculation"
    type: yesno
    sql:  ${time_day_of_year} < ${current_day_of_year} ;; }

  measure: count {
    label: "Count of Sessions"
    description: "Source: looker calculation"
    type: count_distinct
    sql: ${TABLE}.session_id ;;}

  measure: count_k {
    label: "Count (0.K)"
    description: "Source: looker calculation"
    type: count_distinct
    sql: ${TABLE}.session_id ;;
    value_format: "#,##0,\" K\""}

  measure: distinct_users {
    label: "Distinct Users"
    description: "Source: looker calculation"
    type: count_distinct
    sql:  ${TABLE}.user_id ;;
  }

  measure: average_sessions_per_user {
    hidden: yes
    type: number
    sql: ${count}::float/nullif(${distinct_users},0) ;;
    value_format_name: decimal_1
  }

  # ----- Sets of fields for drilling ------
  # set: detail {
  #   fields: [
  #     session_id,
  #     app_name,
  #     users.user_id,
  #     users.author_name,
  #     users.out_of_stock_product_name,
  #     users.customer_service_agent_name,
  #     users.last_products_bought_product_3_name,
  #     users.last_products_bought_product_2_name,
  #     users.abandoned_product_3_name,
  #     users.abandoned_product_2_name,
  #     users.abandoned_product_1_name,
  #     users.last_products_bought_product_1_name,
  #     users.first_conversion_event_name,
  #     users.recent_conversion_event_name,
  #     users.hs_email_last_email_name,
  #     users.lastname,
  #     users.firstname,
  #     users.talkable_campaign_name,
  #     users.full_name,
  #     all_events.count,
  #     blog_viewed_page_any_post.count,
  #     cart_mattress_add_to_cart.count,
  #     cart_orders_placed_order.count,
  #     cart_orders_shopify_confirmed_order.count,
  #     checkout_click_amazon_pay.count,
  #     checkout_click_paypal.count,
  #     checkout_step_1_continue_to_shipping_step_1_continue_to_shipping.count,
  #     checkout_step_2_continue_to_payment.count,
  #     checkout_step_3_complete.count,
  #     checkout_submit_customer_info.count,
  #     checkout_viewed_page_order_confirmation.count,
  #     core_events_change_any_field.count,
  #     core_events_click_any_element.count,
  #     core_events_submit_any_form.count,
  #     homepage_hp_featured_on_bar.count,
  #     homepage_hp_watch_video_clicks.count,
  #     homepage_viewed_page_homepage.count,
  #     hubspot_email_opened_email.count,
  #     mattress_viewed_page_compare.count,
  #     mattress_viewed_page_mattress_science.count,
  #     mattress_viewed_page_sleep_cool.count,
  #     navigation_nav_about_clicked_science.count,
  #     navigation_nav_about_clicked_support.count,
  #     pageviews.count,
  #     product_detail_page_pdp_add_to_cart.count,
  #     product_detail_page_pdp_add_to_cart_financing.count,
  #     product_detail_page_pdp_add_to_cart_financing_amount.count,
  #     product_detail_page_pdp_add_to_cart_financing_view_details.count,
  #     product_detail_page_pdp_alt_image_1_click.count,
  #     product_detail_page_pdp_alt_image_2_click.count,
  #     product_detail_page_pdp_alt_image_3_click.count,
  #     product_detail_page_pdp_alt_image_4_click.count,
  #     product_detail_page_pdp_alt_image_5_click.count,
  #     product_detail_page_pdp_alt_image_clicks.count,
  #     product_detail_page_pdp_benefit_bar.count,
  #     product_detail_page_pdp_compare_mattress_banner.count,
  #     product_detail_page_pdp_faqs.count,
  #     product_detail_page_pdp_offers.count,
  #     product_detail_page_pdp_product_detail_clicks_firm_medium_soft.count,
  #     product_detail_page_pdp_product_information_clicks.count,
  #     product_viewed_page_either_mattress_buy.count,
  #     product_viewed_page_either_mattress_lp.count,
  #     product_viewed_page_mattress_protector_buy.count,
  #     product_viewed_page_mattress_protector_lp.count,
  #     product_viewed_page_new_mattress.count,
  #     product_viewed_page_new_mattress_buy.count,
  #     product_viewed_page_og_mattress_buy.count,
  #     product_viewed_page_og_mattress_lp.count,
  #     product_viewed_page_pet_bed_buy.count,
  #     product_viewed_page_pet_bed_lp.count,
  #     product_viewed_page_pillow_buy.count,
  #     product_viewed_page_pillow_lp.count,
  #     product_viewed_page_platform_buy.count,
  #     product_viewed_page_platform_lp.count,
  #     product_viewed_page_power_base_buy.count,
  #     product_viewed_page_power_base_lp.count,
  #     product_viewed_page_seat_cushion_buy.count,
  #     product_viewed_page_seat_cushion_lp.count,
  #     product_viewed_page_sheets_buy.count,
  #     product_viewed_page_sheets_lp.count,
  #     products_purchase_seat_cushion.count,
  #     purchase.count,
  #     returns_viewed_page_refund_policy.count,
  #     reviews_click_any_review.count,
  #     reviews_submit_mattress_review.count,
  #     reviews_viewed_page_all_reviews.count,
  #     reviews_viewed_page_mattress_reviews.count,
  #     seat_cushions__a_b_viewed_page_seat_cushion_buy_with_double.count,
  #     seat_cushions__a_b_viewed_page_seat_cushion_buy_without_double.count,
  #     support_page_support_call_us.count,
  #     support_page_support_email_us.count,
  #     support_page_support_live_chat.count
  #   ]
  # }
}
