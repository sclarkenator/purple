view: sessions {
  sql_table_name: main_production.sessions ;;

  dimension: session_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.session_id ;;
  }

  dimension: app_name {
    type: string
    sql: ${TABLE}.app_name ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: event_id {
    type: number
    sql: ${TABLE}.event_id ;;
  }

  dimension: ip {
    type: string
    sql: ${TABLE}.ip ;;
  }

  dimension: landing_page {
    type: string
    sql: ${TABLE}.landing_page ;;
  }

  dimension: library {
    type: string
    sql: ${TABLE}.library ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: referrer {
    type: string
    sql: ${TABLE}.referrer ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: search_keyword {
    type: string
    sql: ${TABLE}.search_keyword ;;
  }

  dimension_group: time {
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
    sql: ${TABLE}.time ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: utm_campaign {
    type: string
    sql: ${TABLE}.utm_campaign ;;
  }

  dimension: utm_content {
    type: string
    sql: ${TABLE}.utm_content ;;
  }

  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: utm_term {
    type: string
    sql: ${TABLE}.utm_term ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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
