#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: sessions {
  sql_table_name: heap.sessions ;;

  dimension: session_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;; }

  dimension: app_name {
    label: "App Name"
    type: string
    sql: ${TABLE}.app_name ;; }

  dimension: app_version {
    label: "App Version"
    type: string
    sql: ${TABLE}.app_version ;; }

  dimension: browser {
    label: "Browser"
    type: string
    sql: ${TABLE}.browser ;; }

  dimension: carrier {
    label: "Carrier"
    type: string
    sql: ${TABLE}.carrier ;; }

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;; }

  dimension: country {
    label: "Country"
    map_layer_name: countries
    type: string
    sql: ${TABLE}.country ;; }

  dimension: device {
    label: "Device"
    type: string
    sql: ${TABLE}.device ;; }

  dimension: device_type {
    label: "Device Type"
    type: string
    sql: ${TABLE}.device_type ;; }

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: ip {
    label: "IP"
    type: string
    sql: ${TABLE}.ip ;; }

  dimension: landing_page {
    label: "Landing Page"
    type: string
    sql: ${TABLE}.landing_page ;; }

  dimension: page_type {
    label: "Page Type"
    type:  string
    description: "Bucketed landing pages"
    sql:  case when ${landing_page} ilike ('%checkouts%') then 'Checkout Page'
           when ${landing_page} ilike ('%mattresses%') or ${landing_page} ilike ('%pillows%') or ${landing_page} ilike ('%/sheets') or ${landing_page} ilike ('%/mattress-protector') or ${landing_page} ilike ('%/platform') or ${landing_page} ilike ('%/powerbase') or ${landing_page} ilike ('%/pet-bed') or ${landing_page} ilike ('%/seatcushions') then 'PDP'
           when ${landing_page} ilike ('purple.com/') then 'Home Page'
           when ${landing_page} ilike ('%medium=%') or ${landing_page} ilike ('%promo') then 'Main Landing Page'
           when ${landing_page} ilike ('%/buy%') then 'Buy Page' end;; }

  dimension: library {
    label: "Library"
    type: string
    sql: ${TABLE}.library ;; }

  dimension: platform {
    label: "Platform"
    type: string
    sql: ${TABLE}.platform ;; }

  dimension: referrer {
    label: "Referrer"
    type: string
    sql: ${TABLE}.referrer ;; }

  dimension: referrer_2 {
    label: "Referrer (grouped)"
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

  dimension: region {
    label: "Region"
    type: string
    sql: ${TABLE}.region ;; }

  dimension: search_keyword {
    label: "Search Keyword"
    type: string
    sql: ${TABLE}.search_keyword ;; }

  dimension_group: time {
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year, hour_of_day]
    sql: ${TABLE}.time ;; }

  dimension: last_30{
    label: "z - Last 30 Days"
    group_label: "Time Date"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.time::date > dateadd(day,-30,current_date);; }

  dimension: rolling_7day {
    label: "z - Rolling 7 Day Filter"
    group_label: "Time Date"
    description: "Yes = 7 most recent days ONLY"
    type: yesno
    sql: ${TABLE}.time::date between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;  }

  dimension: rollingday{
    hidden:  yes
    type: number
    sql: date_part('dayofyear',${TABLE}.time::date)- date_part('dayofyear',current_date) ;; }

  dimension: Before_today{
    group_label: "Time Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.time::date < current_date;; }

  dimension: current_week_num{
    group_label: "Time Date"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${TABLE}.time::date) < date_part('week',current_date);; }

  dimension: prev_week{
    group_label: "Time Date"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${TABLE}.time::date) = date_part('week',current_date)-1;; }

  dimension: week_bucket{
    group_label: "Time Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql: case when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) and date_part('week',${TABLE}.time::date) = date_part('week', current_date) then 'Current Week'
        when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) and date_part('week',${TABLE}.time::date) = date_part('week', current_date) -1 then 'Last Week'
        when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) and date_part('week',${TABLE}.time::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
        when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.time::date) = date_part('week', current_date) then 'Current Week LY'
        when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.time::date) = date_part('week', current_date) -1 then 'Last Week LY'
        when date_part('year', ${TABLE}.time::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.time::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
        else 'Other' end;; }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;; }

  dimension: utm_campaign {
    label: "UTM Campaign"
    type: string
    sql: ${TABLE}.utm_campaign ;; }

  dimension: utm_content {
    label: "UTM Content"
    type: string
    sql: ${TABLE}.utm_content ;; }

  dimension: utm_medium {
    label: "UTM Medium"
    type: string
    sql: ${TABLE}.utm_medium ;; }

  dimension: utm_source {
    label: "UTM Source"
    type: string
    sql: ${TABLE}.utm_source ;; }

  dimension: utm_term {
    label: "UTM Term"
    type: string
    sql: ${TABLE}.utm_term ;; }

  measure: count {
    type: count_distinct
    sql: ${TABLE}.session_id ;;}

  measure: count_k {
    label: "Count (0.K)"
    type: count_distinct
    sql: ${TABLE}.session_id ;;
    value_format: "#,##0,\" K\""}

  measure: distinct_users {
    label: "Distinct Users"
    type: count_distinct
    sql:  ${TABLE}.user_id ;;
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
