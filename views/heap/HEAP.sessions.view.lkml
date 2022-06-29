#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------
include: "/views/_period_comparison.view.lkml"
view: sessions {

  # derived_table: {
  #   sql:
  #       select *
  #       from heap_data.purple.sessions
  #       where browser not in ('SchemaBot 1.2','KlarnaBot','KlarnaPriceWatcherBot 1.0','BrandVeritySpider 1.0','SemrushBot')
  #       --where browser not ilike ('%bot%')
  #       ;;
#     datagroup_trigger: pdt_refresh_6am
  # }
  sql_table_name: ANALYTICS.HEAP.V_ECOMMERCE_SESSIONS ;;

   extends: [_period_comparison]
   #### Used with period comparison view
   dimension_group: event {
     hidden: yes
     type: time
     timeframes: [raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,
       day_of_year,week,month,month_num,quarter,quarter_of_year,year]
     convert_tz: no
     datatype: date
     sql: ${TABLE}.time ;;
   }

  dimension: session_id {
    #primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;; }

  dimension: session_unique_id {
    hidden: yes
    type: string
    primary_key: yes
    #sql: ${session_id} || '-' || ${user_id} ;;
    sql: ${TABLE}.session_unique_id ;;
  }

  dimension: app_name {
    label: "App Name"
    description: "Source: HEAP.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.app_name ;; }

  dimension: app_version {
    label: "App Version"
    description: "Source: HEAP.sessions"
    type: string
    hidden:  yes
    sql: ${TABLE}.app_version ;; }

  dimension: browser {
    label: "Browser"
    description: "Source: HEAP.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.browser ;; }

  dimension: browser_bucket {
    label: "Browser Bucket"
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.browser_bucket ;;
  }

  dimension: carrier {
    label: "Carrier"
    description: "Source: HEAP.sessions"
    type: string
    group_label: "Advanced"
    sql: ${TABLE}.carrier ;; }

  dimension: city {
    group_label: "Advanced"
    label: "City"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.city ;; }

  dimension: country {
    group_label: "Advanced"
    label: "Country"
    description: "Source: HEAP.sessions"
    map_layer_name: countries
    type: string
    sql: ${TABLE}.country ;; }

  dimension: device {
    label: "Device"
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.device ;; }

  dimension: device_type {
    label: "Device Type"
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.device_type ;; }

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: ip {
    label: "IP"
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.ip ;; }

  dimension: landing_page {
    label: " Landing Page"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.landing_page ;; }

  dimension: page_type {
    label: " Page Type"
    type:  string
    description: "Bucketed landing pages. Source: looker calculation"
    sql:  ${TABLE}.page_type;;
  }

dimension: page_product_type {
    label: "Page Product Type"
    type:  string
    description: "Bucketed landing pages by PDPs. Source: looker calculation"
    sql:  ${TABLE}.page_product_type;;
  }

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
    description: "Device OS. Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.platform ;; }

  dimension: referrer {
    label: " Referrer"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.referrer ;; }

  dimension: referrer_2 {
    label: " Referrer (grouped)"
    description: "Source: looker calculation"
    type: string
    sql: ${TABLE}.referrer_2 ;;
  }


  dimension: referrer_domain {
    hidden: yes
    #sql: split_part(${referrer},'/',3) ;;
    sql: ${TABLE}.referrer_domain ;;
  }

#   dimension: referrer_domain_mapped {
#     sql: CASE WHEN ${referrer_domain} like '%facebook%' THEN 'facebook' WHEN ${referrer_domain} like '%google%' THEN 'google' ELSE ${referrer_domain} END ;;
#     html: {{ linked_value }}
#       <a href="/dashboards/heap_block::referrer_dashboard?referrer_domain={{ value | encode_uri }}" target="_new">
#       <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>
#       ;;
#   }

  dimension: region {
    label: "Region"
    type: string
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    sql: ${TABLE}.region ;; }

  dimension: in_canada {
    label: "In Canada"
    type: yesno
    description: " 'Yes' if Region is one of the 13 Canadian provinces or territories, otherwise 'No'. Source: HEAP.sessions"
    group_label: "Advanced"
    sql: ${TABLE}.in_canada ;;
  }

  dimension: search_keyword {
    label: "Search Keyword"
    group_label: "Advanced"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.search_keyword ;; }

  dimension: liquid_date {
    group_label: "Dynamic Date"
    label: "z - liquid date"
    description: "If > 365 days in the look, than month, if > 30 than week, else day"
    sql:
    CASE
      WHEN
        datediff(
                'day',
                cast({% date_start time_date %} as date),
                cast({% date_end time_date  %} as date)
                ) >365
      THEN cast(${time_month} as varchar)
      WHEN
        datediff(
                'day',
                cast({% date_start time_date %} as date),
                cast({% date_end time_date  %} as date)
                ) >30
      THEN cast(${time_week} as varchar)
      else ${time_date}
      END
    ;;
  }

  # dimension: liquid_date_comps {
  #   group_label: "Dynamic Date"
  #   label: "z - liquid date comps"
  #   description: "If > 365 days in the look, than month, if > 30 than week, else day"
  #   sql:
  #   CASE
  #     WHEN
  #       datediff(
  #               'day',
  #               cast({% date_start time_date %} as date),
  #               cast({% date_end time_date  %} as date)
  #               ) >365
  #     THEN cast(${time_month_name} as varchar)
  #     WHEN
  #       datediff(
  #               'day',
  #               cast({% date_start time_date %} as date),
  #               cast({% date_end time_date  %} as date)
  #               ) >30
  #     THEN cast(${time_week_of_year} as varchar)
  #     else ${time_day_of_year}
  #     END
  #   ;;
  # }

  dimension_group: time {
    ### Scott Clark 1/13/21: Deleted week_of_year. need to reverse this last week of 2021
    group_label: "  Session Time"
    description: "Source: HEAP.sessions"
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, month, month_name, quarter, quarter_of_year, year, hour_of_day, minute,hour, week_of_year]
    sql: ${TABLE}.time ;; }

  # dimension: time_week_of_year {
  #   ## Scott Clark 1/13/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type:  number
  #   label: "Week of Year"
  #   group_label: "  Session Time"
  #   description: "2021 adjusted week of year number"
  #   sql: case when ${time_date::date} >= '2020-12-28' and ${time_date::date} <= '2021-01-03' then 1
  #             when ${time_year::number}=2021 then date_part(weekofyear,${time_date::date}) + 1
  #             else date_part(weekofyear,${time_date::date}) end ;;
  # }

  dimension: adj_year {
    ## Scott Clark 1/13/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "  Session Time"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${time_date::date} >= '2020-12-28' and ${time_date::date} <= '2021-01-03' then 2021 else ${time_year::number} end   ;;
  }


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
    #sql: ${TABLE}.time::date > dateadd(day,-30,current_date);;
    sql:${TABLE}.last_30 ;;
  }

  dimension: rolling_7day {
    label: "z - Rolling 7 Day Filter"
    group_label: "  Session Time"
    description: "Yes = 7 most recent days ONLY. Source: looker calculation"
    type: yesno
    #sql: ${TABLE}.time::date between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;
    sql: ${TABLE}.rolling_7day ;;
  }

  dimension: rollingday{
    hidden:  yes
    type: number
    #sql: date_part('dayofyear',${TABLE}.time::date)- date_part('dayofyear',current_date) ;;
    sql:  ${TABLE}.rollingday ;;
  }

  dimension: Before_today{
    group_label: "  Session Time"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: looker calculation"
    type: yesno
    #sql: ${TABLE}.time::date < current_date;;
    sql:  ${TABLE}.before_today ;;
  }

  dimension: current_week_num{
    group_label: "  Session Time"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker calculation"
    type: yesno
    #sql: date_trunc(week, ${TABLE}.time::date) < date_trunc(week, current_date) ;;
    sql: ${TABLE}.current_week_num ;;
  }

  dimension: current_week_filter_heap{
    view_label: "Sessions"
    group_label: "  Session Time"
    label: "z - Current Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the current week of the year (for each year). Source: looker calculation"
    type: yesno
    #sql: EXTRACT(WEEK FROM ${time_date}::date) = EXTRACT(WEEK FROM current_date::date) ;;
    sql: ${TABLE}.current_week_filter_heap ;;
  }

  dimension: current_month_filter_heap{
    view_label: "Sessions"
    group_label: "  Session Time"
    label: "z - Current Month"
    #hidden:  yes
    description: "Yes/No for if the date is in the current month of the year (for each year). Source: looker calculation"
    type: yesno
    # sql: EXTRACT(month FROM ${time_date}::date) = EXTRACT(month FROM current_date::date) ;;
    sql:  ${TABLE}.current_month_filter_heap ;;
  }

  dimension: prev_week{
    group_label: "  Session Time"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker calculation"
    type: yesno
    # sql:  date_trunc(week, ${TABLE}.time::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
    sql: ${TABLE}.prev_week ;;
  }
  dimension: week_bucket_old{
    group_label: "  Session Time"
    label: "z - Week Bucket"
    hidden: yes
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker calculation"
    type: string
     sql:  ${TABLE}.week_bucket_old ;; }

  dimension: week_bucket{
    group_label: "  Session Time"
    label: "z - Week Bucket"
    hidden: no
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker calculation"
    type: string
     sql:  CASE WHEN ${time_week_of_year} = date_part (weekofyear,current_date) AND ${time_year} = date_part (year,current_date) THEN 'Current Week'
             WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -1 AND ${time_year} = date_part (year,current_date) THEN 'Last Week'
             WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -2 AND ${time_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
             WHEN ${time_week_of_year} = date_part (weekofyear,current_date) AND ${time_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
             WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -1 AND ${time_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
             WHEN ${time_week_of_year} = date_part (weekofyear,current_date) -2 AND ${time_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;; }

  dimension: channel {
    type: string
    hidden:  yes
    label: " Channel"
    description: "Channel that current session came from. Source: looker calculation"
    sql: ${TABLE}.channel ;;
  }

  dimension: channel2 {
    type: string
    hidden:  no
    label: " Channel"
    description: "Channel that current session came from. Source: looker calculation"
    sql:${TABLE}.channel2 ;;
  }

  dimension: utm_campaign {
    group_label: "UTM Tags"
    label: "UTM Campaign"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_campaign ;; }

  dimension: utm_campaign_raw {
    hidden: yes
    type:  string
    sql:  ${TABLE}.utm_campaign ;;
  }

  dimension: utm_content {
    group_label: "UTM Tags"
    label: "UTM Content"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_content ;;
  }

  dimension: evergreen_split{
    group_label: "UTM Tags"
    label: "Evergreen Split"
    description: "Evergreen USA (incl.USA Finance) vs all other Evergreen Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.evergreen_split;;
  }

  dimension: promo_name {
    group_label: "UTM Tags"
    label: "Promo Name"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.promo_name ;;
  }

  dimension: utm_medium {
    group_label: "UTM Tags"
    label: "UTM Medium"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_medium ;; }

  dimension: medium_bucket {
    label: "Medium"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: ${TABLE}.medium_bucket ;;
  }



  dimension: utm_source {
    group_label: "UTM Tags"
    label: "UTM Source"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: source_bucket {
    label: "Source"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: ${TABLE}.source_bucket ;;
  }

  dimension: source_medium {
    hidden: yes
    type: string
    sql: ${TABLE}.source_medium;;
  }

  dimension: utm_term {
    group_label: "UTM Tags"
    label: "UTM Term"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_term ;; }

  dimension: term_bucket {
    label: "Campaign Type"
    group_label: "Adspend Mapping"
    description: "Source: looker calculation"
    type: string
    sql: ${TABLE}.term_bucket ;;
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

  # measure: count_current_period {
  #   hidden: yes
  #   label: "Count of Sessions Current Period"
  #   description: "Source: looker calculation"
  #   type: count_distinct
  #   filters: [is_current_period: "yes"]
  #   sql: ${TABLE}.session_id ;;}

  # measure: count_comparison_period {
  #   hidden: yes
  #   label: "Count of Sessions Comparison Period"
  #   description: "Source: looker calculation"
  #   type: count_distinct
  #   filters: [is_comparison_period: "yes"]
  #   sql: ${TABLE}.session_id ;;}

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

  # Used for C-level Dasboard
  parameter: see_data_by_sessions {
    description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
    hidden: yes
    type: unquoted
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
  }

  dimension: see_data_sessions {
    view_label: "Sessions"
    label: "See Data By"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by_sessions._parameter_value == 'day' %}
      ${time_date}
    {% elsif see_data_by_sessions._parameter_value == 'week' %}
      ${time_week}
    {% elsif see_data_by_sessions._parameter_value == 'month' %}
      ${time_month}
    {% elsif see_data_by_sessions._parameter_value == 'quarter' %}
      ${time_quarter}
    {% else %}
      ${time_date}
    {% endif %};;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      session_id,
      app_name,
      users.user_id,
      users.author_name,
      users.out_of_stock_product_name,
      users.customer_service_agent_name,
      users.last_products_bought_product_3_name,
      users.last_products_bought_product_2_name,
      users.abandoned_product_3_name,
      users.abandoned_product_2_name,
      users.abandoned_product_1_name,
      users.last_products_bought_product_1_name,
      users.first_conversion_event_name,
      users.recent_conversion_event_name,
      users.hs_email_last_email_name,
      users.lastname,
      users.firstname,
      users.talkable_campaign_name,
      users.full_name,
      all_events.count,
      blog_viewed_page_any_post.count,
      cart_mattress_add_to_cart.count,
      cart_orders_placed_order.count,
      cart_orders_shopify_confirmed_order.count,
      checkout_click_amazon_pay.count,
      checkout_click_paypal.count,
      checkout_step_1_continue_to_shipping_step_1_continue_to_shipping.count,
      checkout_step_2_continue_to_payment.count,
      checkout_step_3_complete.count,
      checkout_submit_customer_info.count,
      checkout_viewed_page_order_confirmation.count,
      core_events_change_any_field.count,
      core_events_click_any_element.count,
      core_events_submit_any_form.count,
      homepage_hp_featured_on_bar.count,
      homepage_hp_watch_video_clicks.count,
      homepage_viewed_page_homepage.count,
      hubspot_email_opened_email.count,
      mattress_viewed_page_compare.count,
      mattress_viewed_page_mattress_science.count,
      mattress_viewed_page_sleep_cool.count,
      navigation_nav_about_clicked_science.count,
      navigation_nav_about_clicked_support.count,
      pageviews.count,
      product_detail_page_pdp_add_to_cart.count,
      product_detail_page_pdp_add_to_cart_financing.count,
      product_detail_page_pdp_add_to_cart_financing_amount.count,
      product_detail_page_pdp_add_to_cart_financing_view_details.count,
      product_detail_page_pdp_alt_image_1_click.count,
      product_detail_page_pdp_alt_image_2_click.count,
      product_detail_page_pdp_alt_image_3_click.count,
      product_detail_page_pdp_alt_image_4_click.count,
      product_detail_page_pdp_alt_image_5_click.count,
      product_detail_page_pdp_alt_image_clicks.count,
      product_detail_page_pdp_benefit_bar.count,
      product_detail_page_pdp_compare_mattress_banner.count,
      product_detail_page_pdp_faqs.count,
      product_detail_page_pdp_offers.count,
      product_detail_page_pdp_product_detail_clicks_firm_medium_soft.count,
      product_detail_page_pdp_product_information_clicks.count,
      product_viewed_page_either_mattress_buy.count,
      product_viewed_page_either_mattress_lp.count,
      product_viewed_page_mattress_protector_buy.count,
      product_viewed_page_mattress_protector_lp.count,
      product_viewed_page_new_mattress.count,
      product_viewed_page_new_mattress_buy.count,
      product_viewed_page_og_mattress_buy.count,
      product_viewed_page_og_mattress_lp.count,
      product_viewed_page_pet_bed_buy.count,
      product_viewed_page_pet_bed_lp.count,
      product_viewed_page_pillow_buy.count,
      product_viewed_page_pillow_lp.count,
      product_viewed_page_platform_buy.count,
      product_viewed_page_platform_lp.count,
      product_viewed_page_power_base_buy.count,
      product_viewed_page_power_base_lp.count,
      product_viewed_page_seat_cushion_buy.count,
      product_viewed_page_seat_cushion_lp.count,
      product_viewed_page_sheets_buy.count,
      product_viewed_page_sheets_lp.count,
      products_purchase_seat_cushion.count,
      purchase.count,
      returns_viewed_page_refund_policy.count,
      reviews_click_any_review.count,
      reviews_submit_mattress_review.count,
      reviews_viewed_page_all_reviews.count,
      reviews_viewed_page_mattress_reviews.count,
      seat_cushions__a_b_viewed_page_seat_cushion_buy_with_double.count,
      seat_cushions__a_b_viewed_page_seat_cushion_buy_without_double.count,
      support_page_support_call_us.count,
      support_page_support_email_us.count,
      support_page_support_live_chat.count
    ]
  }
}
