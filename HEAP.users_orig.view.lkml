#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: users_orig {
  sql_table_name: heap.users ;;

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: _email {
    label: "Email"
    type: string
    sql: ${TABLE}._email ;;
  }

  dimension: abandoned_cart_1st_conversion_did_not_use_incentive {
    type: string
    sql: ${TABLE}.abandoned_cart_1st_conversion_did_not_use_incentive ;; }

  dimension: abandoned_cart_active_last_clicked {
    type: string
    sql: ${TABLE}.abandoned_cart_active_last_clicked ;; }

  dimension: abandoned_cart_active_last_opened {
    type: string
    sql: ${TABLE}.abandoned_cart_active_last_opened ;; }

  dimension: abandoned_cart_campaign_version {
    type: string
    sql: ${TABLE}.abandoned_cart_campaign_version ;; }

  dimension: abandoned_cart_categories_bought {
    type: string
    sql: ${TABLE}.abandoned_cart_categories_bought ;; }

  dimension: abandoned_cart_categories_text {
    type: string
    sql: ${TABLE}.abandoned_cart_categories_text ;; }

  dimension: abandoned_cart_conversion_date {
    type: string
    sql: ${TABLE}.abandoned_cart_conversion_date ;; }

  dimension: abandoned_cart_converted {
    type: string
    sql: ${TABLE}.abandoned_cart_converted ;; }

  dimension: abandoned_cart_counter {
    type: string
    sql: ${TABLE}.abandoned_cart_counter ;; }

  dimension: abandoned_cart_date {
    type: string
    sql: ${TABLE}.abandoned_cart_date ;; }

  dimension: abandoned_cart_first_start_date {
    type: string
    sql: ${TABLE}.abandoned_cart_first_start_date ;; }

  dimension: abandoned_cart_last_click_conversion_attribution {
    type: string
    sql: ${TABLE}.abandoned_cart_last_click_conversion_attribution ;; }

  dimension: abandoned_cart_last_clicked_date {
    type: string
    sql: ${TABLE}.abandoned_cart_last_clicked_date ;; }

  dimension: abandoned_cart_last_open_conversion_attribution {
    type: string
    sql: ${TABLE}.abandoned_cart_last_open_conversion_attribution ;; }

  dimension: abandoned_cart_last_opened_date {
    type: string
    sql: ${TABLE}.abandoned_cart_last_opened_date ;; }

  dimension: abandoned_cart_number_of_products_bought {
    type: string
    sql: ${TABLE}.abandoned_cart_number_of_products_bought ;; }

  dimension: abandoned_cart_products {
    type: string
    sql: ${TABLE}.abandoned_cart_products ;; }

  dimension: abandoned_cart_products_bought {
    type: string
    sql: ${TABLE}.abandoned_cart_products_bought ;; }

  dimension: abandoned_cart_products_html {
    type: string
    sql: ${TABLE}.abandoned_cart_products_html ;; }

  dimension: abandoned_cart_products_text {
    type: string
    sql: ${TABLE}.abandoned_cart_products_text ;; }

  dimension: abandoned_cart_recovery_workflow_conversion {
    type: string
    sql: ${TABLE}.abandoned_cart_recovery_workflow_conversion ;; }

  dimension: abandoned_cart_recovery_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.abandoned_cart_recovery_workflow_conversion_amount ;; }

  dimension: abandoned_cart_recovery_workflow_conversion_date {
    type: string
    sql: ${TABLE}.abandoned_cart_recovery_workflow_conversion_date ;; }

  dimension: abandoned_cart_recovery_workflow_start_date {
    type: string
    sql: ${TABLE}.abandoned_cart_recovery_workflow_start_date ;; }

  dimension: abandoned_cart_roi {
    type: string
    sql: ${TABLE}.abandoned_cart_roi ;; }

  dimension: abandoned_cart_start_abandoned_cart_value {
    type: string
    sql: ${TABLE}.abandoned_cart_start_abandoned_cart_value ;; }

  dimension: abandoned_cart_start_categories_abandoned {
    type: string
    sql: ${TABLE}.abandoned_cart_start_categories_abandoned ;;
  }

  dimension: abandoned_cart_start_date {
    type: string
    sql: ${TABLE}.abandoned_cart_start_date ;;
  }

  dimension: abandoned_cart_start_number_of_products_abandoned {
    type: string
    sql: ${TABLE}.abandoned_cart_start_number_of_products_abandoned ;;
  }

  dimension: abandoned_cart_start_products_abandoned {
    type: string
    sql: ${TABLE}.abandoned_cart_start_products_abandoned ;;
  }

  dimension: abandoned_cart_start_times_starting_any_segment_of_campaign {
    type: string
    sql: ${TABLE}.abandoned_cart_start_times_starting_any_segment_of_campaign ;;
  }

  dimension: abandoned_cart_times_roi_calculated {
    type: string
    sql: ${TABLE}.abandoned_cart_times_roi_calculated ;;
  }

  dimension: abandoned_cart_unique_emails_click {
    type: string
    sql: ${TABLE}.abandoned_cart_unique_emails_click ;;
  }

  dimension: abandoned_cart_unique_emails_open {
    type: string
    sql: ${TABLE}.abandoned_cart_unique_emails_open ;;
  }

  dimension: abandoned_cart_url {
    type: string
    sql: ${TABLE}.abandoned_cart_url ;;
  }

  dimension: abandoned_product_1_image_url {
    type: string
    sql: ${TABLE}.abandoned_product_1_image_url ;;
  }

  dimension: abandoned_product_1_name {
    type: string
    sql: ${TABLE}.abandoned_product_1_name ;;
  }

  dimension: abandoned_product_1_price {
    type: string
    sql: ${TABLE}.abandoned_product_1_price ;;
  }

  dimension: abandoned_product_1_url {
    type: string
    sql: ${TABLE}.abandoned_product_1_url ;;
  }

  dimension: abandoned_product_2_image_url {
    type: string
    sql: ${TABLE}.abandoned_product_2_image_url ;;
  }

  dimension: abandoned_product_2_name {
    type: string
    sql: ${TABLE}.abandoned_product_2_name ;;
  }

  dimension: abandoned_product_2_price {
    type: string
    sql: ${TABLE}.abandoned_product_2_price ;;
  }

  dimension: abandoned_product_2_url {
    type: string
    sql: ${TABLE}.abandoned_product_2_url ;;
  }

  dimension: abandoned_product_3_image_url {
    type: string
    sql: ${TABLE}.abandoned_product_3_image_url ;;
  }

  dimension: abandoned_product_3_name {
    type: string
    sql: ${TABLE}.abandoned_product_3_name ;;
  }

  dimension: abandoned_product_3_price {
    type: string
    sql: ${TABLE}.abandoned_product_3_price ;;
  }

  dimension: abandoned_product_3_url {
    type: string
    sql: ${TABLE}.abandoned_product_3_url ;;
  }

  dimension: accepts_marketing {
    type: string
    sql: ${TABLE}.accepts_marketing ;;
  }

  dimension: account_creation_date {
    type: string
    sql: ${TABLE}.account_creation_date ;;
  }

  dimension: additional_comments_request_for_notification_about_purple_bed_size_additions {
    type: string
    sql: ${TABLE}.additional_comments_request_for_notification_about_purple_bed_size_additions ;;
  }

  dimension: additional_feedback_on_customer_service_feedback_form {
    type: string
    sql: ${TABLE}.additional_feedback_on_customer_service_feedback_form ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: affirm_approval_amount {
    type: string
    sql: ${TABLE}.affirm_approval_amount ;;
  }

  dimension: affirm_checkout_token {
    type: string
    sql: ${TABLE}.affirm_checkout_token ;;
  }

  dimension: affirm_created_time_stamp {
    type: string
    sql: ${TABLE}.affirm_created_time_stamp ;;
  }

  dimension: affirm_event_timestamp {
    type: string
    sql: ${TABLE}.affirm_event_timestamp ;;
  }

  dimension: affirm_event_type {
    type: string
    sql: ${TABLE}.affirm_event_type ;;
  }

  dimension: affirm_progressive_abandoned_cart_recovery_workflow_conversion {
    type: string
    sql: ${TABLE}.affirm_progressive_abandoned_cart_recovery_workflow_conversion ;;
  }

  dimension: affirm_progressive_abandoned_cart_recovery_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.affirm_progressive_abandoned_cart_recovery_workflow_conversion_amount ;;
  }

  dimension: affirm_progressive_abandoned_cart_recovery_workflow_conversion_date {
    type: string
    sql: ${TABLE}.affirm_progressive_abandoned_cart_recovery_workflow_conversion_date ;;
  }

  dimension: affirm_progressive_abandoned_cart_recovery_workflow_start_date {
    type: string
    sql: ${TABLE}.affirm_progressive_abandoned_cart_recovery_workflow_start_date ;;
  }

  dimension: age {
    type: string
    sql: ${TABLE}.age ;;
  }

  dimension: age_of_mattress {
    type: string
    sql: ${TABLE}.age_of_mattress ;;
  }

  dimension: all_stores {
    type: string
    sql: ${TABLE}.all_stores ;;
  }

  dimension: asknicely_comment {
    type: string
    sql: ${TABLE}.asknicely_comment ;;
  }

  dimension: asknicely_date {
    type: string
    sql: ${TABLE}.asknicely_date ;;
  }

  dimension: asknicely_score {
    type: string
    sql: ${TABLE}.asknicely_score ;;
  }

  dimension: asknicely_segment {
    type: string
    sql: ${TABLE}.asknicely_segment ;;
  }

  dimension: asknicely_tag {
    type: string
    sql: ${TABLE}.asknicely_tag ;;
  }

  dimension: author_name {
    type: string
    sql: ${TABLE}.author_name ;;
  }

  dimension: average_days_between_orders {
    type: string
    sql: ${TABLE}.average_days_between_orders ;;
  }

  dimension: average_order_value {
    type: string
    sql: ${TABLE}.average_order_value ;;
  }

  dimension: bb_alcohol_frequency {
    type: string
    sql: ${TABLE}.bb_alcohol_frequency ;;
  }

  dimension: bb_back_pain_sufferer {
    type: string
    sql: ${TABLE}.bb_back_pain_sufferer ;;
  }

  dimension: bb_bed_population {
    type: string
    sql: ${TABLE}.bb_bed_population ;;
  }

  dimension: bb_bedroom_tidiness {
    type: string
    sql: ${TABLE}.bb_bedroom_tidiness ;;
  }

  dimension: bb_caffeine_amount {
    type: string
    sql: ${TABLE}.bb_caffeine_amount ;;
  }

  dimension: bb_do_you_smoke {
    type: string
    sql: ${TABLE}.bb_do_you_smoke ;;
  }

  dimension: bb_eat_around_bed {
    type: string
    sql: ${TABLE}.bb_eat_around_bed ;;
  }

  dimension: bb_exercise_amount {
    type: string
    sql: ${TABLE}.bb_exercise_amount ;;
  }

  dimension: bb_financial_situation {
    type: string
    sql: ${TABLE}.bb_financial_situation ;;
  }

  dimension: bb_how_long_to_fall_asleep_at_night {
    type: string
    sql: ${TABLE}.bb_how_long_to_fall_asleep_at_night ;;
  }

  dimension: bb_nightly_sleep_qty {
    type: string
    sql: ${TABLE}.bb_nightly_sleep_qty ;;
  }

  dimension: bb_previous_injury_comfort_issues {
    type: string
    sql: ${TABLE}.bb_previous_injury_comfort_issues ;;
  }

  dimension: bb_quiz_title {
    type: string
    sql: ${TABLE}.bb_quiz_title ;;
  }

  dimension: bb_rate_your_current_sleep {
    type: string
    sql: ${TABLE}.bb_rate_your_current_sleep ;;
  }

  dimension: bb_severe_injury {
    type: string
    sql: ${TABLE}.bb_severe_injury ;;
  }

  dimension: bb_sex {
    type: string
    sql: ${TABLE}.bb_sex ;;
  }

  dimension: bb_sleep_report_result {
    type: string
    sql: ${TABLE}.bb_sleep_report_result ;;
  }

  dimension: bb_smoke_quantity {
    type: string
    sql: ${TABLE}.bb_smoke_quantity ;;
  }

  dimension: bb_suffer_from_chronic_pain {
    type: string
    sql: ${TABLE}.bb_suffer_from_chronic_pain ;;
  }

  dimension: bb_typical_stress_level {
    type: string
    sql: ${TABLE}.bb_typical_stress_level ;;
  }

  dimension: bb_typical_wake_up_time {
    type: string
    sql: ${TABLE}.bb_typical_wake_up_time ;;
  }

  dimension: bb_wake_up_with_stiffness {
    type: string
    sql: ${TABLE}.bb_wake_up_with_stiffness ;;
  }

  dimension: bb_weekend_sleep_type {
    type: string
    sql: ${TABLE}.bb_weekend_sleep_type ;;
  }

  dimension: bb_where_does_the_pain_effect_you_most {
    type: string
    sql: ${TABLE}.bb_where_does_the_pain_effect_you_most ;;
  }

  dimension: bb_why_do_you_have_a_hard_time_falling_asleep {
    type: string
    sql: ${TABLE}.bb_why_do_you_have_a_hard_time_falling_asleep ;;
  }

  dimension: billing_address_line_1 {
    type: string
    sql: ${TABLE}.billing_address_line_1 ;;
  }

  dimension: billing_address_line_2 {
    type: string
    sql: ${TABLE}.billing_address_line_2 ;;
  }

  dimension: billing_address_province {
    type: string
    sql: ${TABLE}.billing_address_province ;;
  }

  dimension: billing_city {
    type: string
    sql: ${TABLE}.billing_city ;;
  }

  dimension: billing_country {
    type: string
    sql: ${TABLE}.billing_country ;;
  }

  dimension: billing_phone {
    type: string
    sql: ${TABLE}.billing_phone ;;
  }

  dimension: billing_postal_code {
    type: string
    sql: ${TABLE}.billing_postal_code ;;
  }

  dimension: billing_state {
    type: string
    sql: ${TABLE}.billing_state ;;
  }

  dimension: blog_default_hubspot_blog_subscription {
    type: string
    sql: ${TABLE}.blog_default_hubspot_blog_subscription ;;
  }

  dimension: categories_bought {
    type: string
    sql: ${TABLE}.categories_bought ;;
  }

  dimension: categories_bought_text {
    type: string
    sql: ${TABLE}.categories_bought_text ;;
  }

  dimension: chat_bot_test_collection {
    type: string
    sql: ${TABLE}.chat_bot_test_collection ;;
  }

  dimension: checkout_token {
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: closedate {
    type: string
    sql: ${TABLE}.closedate ;;
  }

  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_dropdown {
    type: string
    sql: ${TABLE}.country_dropdown ;;
  }

  dimension: coupon_code_abandoned_cart_expiration_date {
    type: string
    sql: ${TABLE}.coupon_code_abandoned_cart_expiration_date ;;
  }

  dimension: coupon_code_abandoned_cart_offered {
    type: string
    sql: ${TABLE}.coupon_code_abandoned_cart_offered ;;
  }

  dimension: coupon_codes_used {
    type: string
    sql: ${TABLE}.coupon_codes_used ;;
  }

  dimension: coupon_codes_used_text {
    type: string
    sql: ${TABLE}.coupon_codes_used_text ;;
  }

  dimension: createdate {
    type: string
    sql: ${TABLE}.createdate ;;
  }

  dimension: current_abandoned_cart {
    type: string
    sql: ${TABLE}.current_abandoned_cart ;;
  }

  dimension: current_roi_campaign {
    type: string
    sql: ${TABLE}.current_roi_campaign ;;
  }

  dimension: currentlyinworkflow {
    type: string
    sql: ${TABLE}.currentlyinworkflow ;;
  }

  dimension: custom_sleep_report_workflow_start_date {
    type: string
    sql: ${TABLE}.custom_sleep_report_workflow_start_date ;;
  }

  dimension: customer_group {
    type: string
    sql: ${TABLE}.customer_group ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_service_agent_name {
    type: string
    sql: ${TABLE}.customer_service_agent_name ;;
  }

  dimension: customer_total_spent {
    type: string
    sql: ${TABLE}.customer_total_spent ;;
  }

  dimension: days_since_buying_the_pillow {
    type: string
    sql: ${TABLE}.days_since_buying_the_pillow ;;
  }

  dimension: days_to_close {
    type: string
    sql: ${TABLE}.days_to_close ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: email_double_opt_in {
    type: string
    sql: ${TABLE}.email_double_opt_in ;;
  }

  dimension: engagements_last_meeting_booked {
    type: string
    sql: ${TABLE}.engagements_last_meeting_booked ;;
  }

  dimension: enter_store_website_name_purchased_at {
    type: string
    sql: ${TABLE}.enter_store_website_name_purchased_at ;;
  }

  dimension: exit_intent_opt_in_to_text_message {
    type: string
    sql: ${TABLE}.exit_intent_opt_in_to_text_message ;;
  }

  dimension: first_conversion_date {
    type: string
    sql: ${TABLE}.first_conversion_date ;;
  }

  dimension: first_conversion_event_name {
    type: string
    sql: ${TABLE}.first_conversion_event_name ;;
  }

  dimension: first_deal_created_date {
    type: string
    sql: ${TABLE}.first_deal_created_date ;;
  }

  dimension: first_order_date {
    type: string
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: first_order_value {
    type: string
    sql: ${TABLE}.first_order_value ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: followercount {
    type: string
    sql: ${TABLE}.followercount ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: handle {
    type: string
    sql: ${TABLE}.handle ;;
  }

  dimension: have_you_ever_purchased_shoe_insoles_before_ {
    type: string
    sql: ${TABLE}.have_you_ever_purchased_shoe_insoles_before_ ;;
  }

  dimension: how_did_would_you_learn_what_the_best_type_or_brand_of_insole_is_for_you_ {
    type: string
    sql: ${TABLE}.how_did_would_you_learn_what_the_best_type_or_brand_of_insole_is_for_you_ ;;
  }

  dimension: how_often_do_you_normally_purchase_insoles_ {
    type: string
    sql: ${TABLE}.how_often_do_you_normally_purchase_insoles_ ;;
  }

  dimension: hs_analytics_first_referrer {
    type: string
    sql: ${TABLE}.hs_analytics_first_referrer ;;
  }

  dimension: hs_analytics_first_timestamp {
    type: string
    sql: ${TABLE}.hs_analytics_first_timestamp ;;
  }

  dimension: hs_analytics_first_touch_converting_campaign {
    type: string
    sql: ${TABLE}.hs_analytics_first_touch_converting_campaign ;;
  }

  dimension: hs_analytics_first_url {
    type: string
    sql: ${TABLE}.hs_analytics_first_url ;;
  }

  dimension: hs_analytics_first_visit_timestamp {
    type: string
    sql: ${TABLE}.hs_analytics_first_visit_timestamp ;;
  }

  dimension: hs_analytics_last_timestamp {
    type: string
    sql: ${TABLE}.hs_analytics_last_timestamp ;;
  }

  dimension: hs_analytics_last_touch_converting_campaign {
    type: string
    sql: ${TABLE}.hs_analytics_last_touch_converting_campaign ;;
  }

  dimension: hs_analytics_last_url {
    type: string
    sql: ${TABLE}.hs_analytics_last_url ;;
  }

  dimension: hs_analytics_last_visit_timestamp {
    type: string
    sql: ${TABLE}.hs_analytics_last_visit_timestamp ;;
  }

  dimension: hs_analytics_num_visits {
    type: string
    sql: ${TABLE}.hs_analytics_num_visits ;;
  }

  dimension: hs_analytics_revenue {
    type: string
    sql: ${TABLE}.hs_analytics_revenue ;;
  }

  dimension: hs_analytics_source {
    type: string
    sql: ${TABLE}.hs_analytics_source ;;
  }

  dimension: hs_analytics_source_data_1 {
    type: string
    sql: ${TABLE}.hs_analytics_source_data_1 ;;
  }

  dimension: hs_analytics_source_data_2 {
    type: string
    sql: ${TABLE}.hs_analytics_source_data_2 ;;
  }

  dimension: hs_email_bounce {
    type: string
    sql: ${TABLE}.hs_email_bounce ;;
  }

  dimension: hs_email_click {
    type: string
    sql: ${TABLE}.hs_email_click ;;
  }

  dimension: hs_email_delivered {
    type: string
    sql: ${TABLE}.hs_email_delivered ;;
  }

  dimension: hs_email_first_click_date {
    type: string
    sql: ${TABLE}.hs_email_first_click_date ;;
  }

  dimension: hs_email_first_open_date {
    type: string
    sql: ${TABLE}.hs_email_first_open_date ;;
  }

  dimension: hs_email_first_send_date {
    type: string
    sql: ${TABLE}.hs_email_first_send_date ;;
  }

  dimension: hs_email_last_click_date {
    type: string
    sql: ${TABLE}.hs_email_last_click_date ;;
  }

  dimension: hs_email_last_email_name {
    type: string
    sql: ${TABLE}.hs_email_last_email_name ;;
  }

  dimension: hs_email_last_open_date {
    type: string
    sql: ${TABLE}.hs_email_last_open_date ;;
  }

  dimension: hs_email_last_send_date {
    type: string
    sql: ${TABLE}.hs_email_last_send_date ;;
  }

  dimension: hs_email_open {
    type: string
    sql: ${TABLE}.hs_email_open ;;
  }

  dimension: hs_email_optout {
    type: string
    sql: ${TABLE}.hs_email_optout ;;
  }

  dimension: hs_email_optout_1236014 {
    type: string
    sql: ${TABLE}.hs_email_optout_1236014 ;;
  }

  dimension: hs_email_optout_1242328 {
    type: string
    sql: ${TABLE}.hs_email_optout_1242328 ;;
  }

  dimension: hs_email_optout_3023142 {
    type: string
    sql: ${TABLE}.hs_email_optout_3023142 ;;
  }

  dimension: hs_email_quarantined {
    type: string
    sql: ${TABLE}.hs_email_quarantined ;;
  }

  dimension: hs_email_sends_since_last_engagement {
    type: string
    sql: ${TABLE}.hs_email_sends_since_last_engagement ;;
  }

  dimension: hs_emailconfirmationstatus {
    type: string
    sql: ${TABLE}.hs_emailconfirmationstatus ;;
  }

  dimension: hs_lead_status {
    type: string
    sql: ${TABLE}.hs_lead_status ;;
  }

  dimension: hs_legal_basis {
    type: string
    sql: ${TABLE}.hs_legal_basis ;;
  }

  dimension: hs_lifecyclestage_customer_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_customer_date ;;
  }

  dimension: hs_lifecyclestage_lead_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_lead_date ;;
  }

  dimension: hs_lifecyclestage_marketingqualifiedlead_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_marketingqualifiedlead_date ;;
  }

  dimension: hs_lifecyclestage_opportunity_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_opportunity_date ;;
  }

  dimension: hs_lifecyclestage_salesqualifiedlead_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_salesqualifiedlead_date ;;
  }

  dimension: hs_lifecyclestage_subscriber_date {
    type: string
    sql: ${TABLE}.hs_lifecyclestage_subscriber_date ;;
  }

  dimension: hs_predictivecontactscore {
    type: string
    sql: ${TABLE}.hs_predictivecontactscore ;;
  }

  dimension: hs_predictivecontactscore_v2 {
    type: string
    sql: ${TABLE}.hs_predictivecontactscore_v2 ;;
  }

  dimension: hs_predictivecontactscorebucket {
    type: string
    sql: ${TABLE}.hs_predictivecontactscorebucket ;;
  }

  dimension: hs_predictivescoringtier {
    type: string
    sql: ${TABLE}.hs_predictivescoringtier ;;
  }

  dimension: hs_sales_email_last_clicked {
    type: string
    sql: ${TABLE}.hs_sales_email_last_clicked ;;
  }

  dimension: hs_sales_email_last_opened {
    type: string
    sql: ${TABLE}.hs_sales_email_last_opened ;;
  }

  dimension: hs_sales_email_last_replied {
    type: string
    sql: ${TABLE}.hs_sales_email_last_replied ;;
  }

  dimension: hubspot_owner_assigneddate {
    type: string
    sql: ${TABLE}.hubspot_owner_assigneddate ;;
  }

  dimension: hubspot_owner_id {
    type: string
    sql: ${TABLE}.hubspot_owner_id ;;
  }

  dimension: hubspot_team_id {
    type: string
    sql: ${TABLE}.hubspot_team_id ;;
  }

  dimension: hubspotscore {
    type: string
    sql: ${TABLE}.hubspotscore ;;
  }

  dimension: identity {
    type: string
    sql: ${TABLE}.identity ;;
  }

  dimension: if_you_regularly_re_purchase_insoles_what_is_the_primary_reason_for_re_purchase_ {
    type: string
    sql: ${TABLE}.if_you_regularly_re_purchase_insoles_what_is_the_primary_reason_for_re_purchase_ ;;
  }

  dimension: if_you_ve_never_purchased_before_why_not_and_don_t_hold_back_ {
    type: string
    sql: ${TABLE}.if_you_ve_never_purchased_before_why_not_and_don_t_hold_back_ ;;
  }

  dimension: initial_browser_type {
    type: string
    sql: ${TABLE}.initial_browser_type ;;
  }

  dimension: initial_continent {
    type: string
    sql: ${TABLE}.initial_continent ;;
  }

  dimension: initial_marketing_channel {
    type: string
    sql: ${TABLE}.initial_marketing_channel ;;
  }

  dimension: initial_marketing_channel_default_ {
    type: string
    sql: ${TABLE}.initial_marketing_channel_default_ ;;
  }

  dimension: initial_questions {
    type: string
    sql: ${TABLE}.initial_questions ;;
  }

  dimension: initial_sales_contact_reason {
    type: string
    sql: ${TABLE}.initial_sales_contact_reason ;;
  }

  dimension: initial_search_engine {
    type: string
    sql: ${TABLE}.initial_search_engine ;;
  }

  dimension: initial_social_network {
    type: string
    sql: ${TABLE}.initial_social_network ;;
  }

  dimension: insole_survey_any_additional_comments_or_suggestions_or_good_jokes_you_ve_heard_recently_ {
    type: string
    sql: ${TABLE}.insole_survey_any_additional_comments_or_suggestions_or_good_jokes_you_ve_heard_recently_ ;;
  }

  dimension: insole_tracking_number {
    type: string
    sql: ${TABLE}.insole_tracking_number ;;
  }

  dimension: internal_sales_team_actively_working_with {
    type: string
    sql: ${TABLE}.internal_sales_team_actively_working_with ;;
  }

  dimension: internal_sales_team_actively_working_with_counter {
    type: string
    sql: ${TABLE}.internal_sales_team_actively_working_with_counter ;;
  }

  dimension: internal_sales_team_actively_working_with_start_date {
    type: string
    sql: ${TABLE}.internal_sales_team_actively_working_with_start_date ;;
  }

  dimension: internal_sales_team_closed_abandoned_cart {
    type: string
    sql: ${TABLE}.internal_sales_team_closed_abandoned_cart ;;
  }

  dimension: internal_sales_team_converted_sale {
    type: string
    sql: ${TABLE}.internal_sales_team_converted_sale ;;
  }

  dimension: internal_sales_team_converted_sale_date {
    type: string
    sql: ${TABLE}.internal_sales_team_converted_sale_date ;;
  }

  dimension: internal_sales_team_original_working_with_start_date {
    type: string
    sql: ${TABLE}.internal_sales_team_original_working_with_start_date ;;
  }

  dimension: ip__ecomm_bridge__ecomm_synced {
    type: string
    sql: ${TABLE}.ip__ecomm_bridge__ecomm_synced ;;
  }

  dimension: jobtitle {
    type: string
    sql: ${TABLE}.jobtitle ;;
  }

  dimension_group: joindate {
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
    sql: ${TABLE}.joindate ;;
  }

  dimension: kloutscoregeneral {
    type: string
    sql: ${TABLE}.kloutscoregeneral ;;
  }

  dimension: last_abandoned_cart_date {
    type: string
    sql: ${TABLE}.last_abandoned_cart_date ;;
  }

  dimension: last_categories_bought {
    type: string
    sql: ${TABLE}.last_categories_bought ;;
  }

  dimension: last_categories_bought_text {
    type: string
    sql: ${TABLE}.last_categories_bought_text ;;
  }

  dimension: last_coupon_code_used {
    type: string
    sql: ${TABLE}.last_coupon_code_used ;;
  }

  dimension: last_disposition {
    type: string
    sql: ${TABLE}.last_disposition ;;
  }

  dimension_group: last_modified {
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
    sql: ${TABLE}.last_modified ;;
  }

  dimension: last_order_date {
    type: string
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: last_order_fulfillment_status {
    type: string
    sql: ${TABLE}.last_order_fulfillment_status ;;
  }

  dimension: last_order_order_number {
    type: string
    sql: ${TABLE}.last_order_order_number ;;
  }

  dimension: last_order_shipment_carrier {
    type: string
    sql: ${TABLE}.last_order_shipment_carrier ;;
  }

  dimension: last_order_shipment_date {
    type: string
    sql: ${TABLE}.last_order_shipment_date ;;
  }

  dimension: last_order_shopify_order_source {
    type: string
    sql: ${TABLE}.last_order_shopify_order_source ;;
  }

  dimension: last_order_status {
    type: string
    sql: ${TABLE}.last_order_status ;;
  }

  dimension: last_order_tracking_number {
    type: string
    sql: ${TABLE}.last_order_tracking_number ;;
  }

  dimension: last_order_tracking_url {
    type: string
    sql: ${TABLE}.last_order_tracking_url ;;
  }

  dimension: last_order_value {
    type: string
    sql: ${TABLE}.last_order_value ;;
  }

  dimension: last_product_bought {
    type: string
    sql: ${TABLE}.last_product_bought ;;
  }

  dimension: last_product_bought_text {
    type: string
    sql: ${TABLE}.last_product_bought_text ;;
  }

  dimension: last_product_types_bought {
    type: string
    sql: ${TABLE}.last_product_types_bought ;;
  }

  dimension: last_product_types_bought_text {
    type: string
    sql: ${TABLE}.last_product_types_bought_text ;;
  }

  dimension: last_products_bought {
    type: string
    sql: ${TABLE}.last_products_bought ;;
  }

  dimension: last_products_bought_html {
    type: string
    sql: ${TABLE}.last_products_bought_html ;;
  }

  dimension: last_products_bought_product_1_image_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_1_image_url ;;
  }

  dimension: last_products_bought_product_1_name {
    type: string
    sql: ${TABLE}.last_products_bought_product_1_name ;;
  }

  dimension: last_products_bought_product_1_price {
    type: string
    sql: ${TABLE}.last_products_bought_product_1_price ;;
  }

  dimension: last_products_bought_product_1_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_1_url ;;
  }

  dimension: last_products_bought_product_2_image_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_2_image_url ;;
  }

  dimension: last_products_bought_product_2_name {
    type: string
    sql: ${TABLE}.last_products_bought_product_2_name ;;
  }

  dimension: last_products_bought_product_2_price {
    type: string
    sql: ${TABLE}.last_products_bought_product_2_price ;;
  }

  dimension: last_products_bought_product_2_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_2_url ;;
  }

  dimension: last_products_bought_product_3_image_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_3_image_url ;;
  }

  dimension: last_products_bought_product_3_name {
    type: string
    sql: ${TABLE}.last_products_bought_product_3_name ;;
  }

  dimension: last_products_bought_product_3_price {
    type: string
    sql: ${TABLE}.last_products_bought_product_3_price ;;
  }

  dimension: last_products_bought_product_3_url {
    type: string
    sql: ${TABLE}.last_products_bought_product_3_url ;;
  }

  dimension: last_products_bought_text {
    type: string
    sql: ${TABLE}.last_products_bought_text ;;
  }

  dimension: last_skus_bought {
    type: string
    sql: ${TABLE}.last_skus_bought ;;
  }

  dimension: last_skus_bought_text {
    type: string
    sql: ${TABLE}.last_skus_bought_text ;;
  }

  dimension: last_store {
    type: string
    sql: ${TABLE}.last_store ;;
  }

  dimension: last_total_number_of_products_bought {
    type: string
    sql: ${TABLE}.last_total_number_of_products_bought ;;
  }

  dimension: last_vendors_bought_text {
    type: string
    sql: ${TABLE}.last_vendors_bought_text ;;
  }

  dimension: lastmodifieddate {
    type: string
    sql: ${TABLE}.lastmodifieddate ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: lead_capture_source {
    type: string
    sql: ${TABLE}.lead_capture_source ;;
  }

  dimension: lease_status {
    type: string
    sql: ${TABLE}.lease_status ;;
  }

  dimension: lifecyclestage {
    type: string
    sql: ${TABLE}.lifecyclestage ;;
  }

  dimension: linkedinbio {
    type: string
    sql: ${TABLE}.linkedinbio ;;
  }

  dimension: linkedinconnections {
    type: string
    sql: ${TABLE}.linkedinconnections ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: mattress_nurture_workflow_conversion {
    type: string
    sql: ${TABLE}.mattress_nurture_workflow_conversion ;;
  }

  dimension: mattress_nurture_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.mattress_nurture_workflow_conversion_amount ;;
  }

  dimension: mattress_nurture_workflow_conversion_date {
    type: string
    sql: ${TABLE}.mattress_nurture_workflow_conversion_date ;;
  }

  dimension: mattress_nurture_workflow_start_date {
    type: string
    sql: ${TABLE}.mattress_nurture_workflow_start_date ;;
  }

  dimension: mattress_purchase_driver1 {
    type: string
    sql: ${TABLE}.mattress_purchase_driver1 ;;
  }

  dimension: mattress_purchase_driver2 {
    type: string
    sql: ${TABLE}.mattress_purchase_driver2 ;;
  }

  dimension: mattress_purchase_driver3 {
    type: string
    sql: ${TABLE}.mattress_purchase_driver3 ;;
  }

  dimension: mattress_purchase_driver4 {
    type: string
    sql: ${TABLE}.mattress_purchase_driver4 ;;
  }

  dimension: mattress_purchase_driver5 {
    type: string
    sql: ${TABLE}.mattress_purchase_driver5 ;;
  }

  dimension: mattress_size_desired {
    type: string
    sql: ${TABLE}.mattress_size_desired ;;
  }

  dimension: mattress_upsell_to_pillow_workflow_conversion {
    type: string
    sql: ${TABLE}.mattress_upsell_to_pillow_workflow_conversion ;;
  }

  dimension: mattress_upsell_to_pillow_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.mattress_upsell_to_pillow_workflow_conversion_amount ;;
  }

  dimension: mattress_upsell_to_pillow_workflow_conversion_date {
    type: string
    sql: ${TABLE}.mattress_upsell_to_pillow_workflow_conversion_date ;;
  }

  dimension: mattress_upsell_to_pillow_workflow_start_date {
    type: string
    sql: ${TABLE}.mattress_upsell_to_pillow_workflow_start_date ;;
  }

  dimension: mobilephone {
    type: string
    sql: ${TABLE}.mobilephone ;;
  }

  dimension: monetary_rating {
    type: string
    sql: ${TABLE}.monetary_rating ;;
  }

  dimension: mql_capture_nurture_conversion_conversion {
    type: string
    sql: ${TABLE}.mql_capture_nurture_conversion_conversion ;;
  }

  dimension: mql_capture_nurture_conversion_conversion_amount {
    type: string
    sql: ${TABLE}.mql_capture_nurture_conversion_conversion_amount ;;
  }

  dimension: mql_capture_nurture_conversion_conversion_date {
    type: string
    sql: ${TABLE}.mql_capture_nurture_conversion_conversion_date ;;
  }

  dimension: mql_capture_nurture_conversion_start_date {
    type: string
    sql: ${TABLE}.mql_capture_nurture_conversion_start_date ;;
  }

  dimension: n100_off_new_mattress_upgrade_coupon_code {
    type: string
    sql: ${TABLE}.n100_off_new_mattress_upgrade_coupon_code ;;
  }

  dimension: neverbouncevalidationresult {
    type: string
    sql: ${TABLE}.neverbouncevalidationresult ;;
  }

  dimension: new_customer_workflow {
    type: string
    sql: ${TABLE}.new_customer_workflow ;;
  }

  dimension: new_customer_workflow_conversion {
    type: string
    sql: ${TABLE}.new_customer_workflow_conversion ;;
  }

  dimension: new_customer_workflow_conversion_date {
    type: string
    sql: ${TABLE}.new_customer_workflow_conversion_date ;;
  }

  dimension: new_customer_workflow_start_date {
    type: string
    sql: ${TABLE}.new_customer_workflow_start_date ;;
  }

  dimension: newsletter_subscriber_nurture_conversion_conversion {
    type: string
    sql: ${TABLE}.newsletter_subscriber_nurture_conversion_conversion ;;
  }

  dimension: newsletter_subscriber_nurture_conversion_conversion_amount {
    type: string
    sql: ${TABLE}.newsletter_subscriber_nurture_conversion_conversion_amount ;;
  }

  dimension: newsletter_subscriber_nurture_conversion_conversion_date {
    type: string
    sql: ${TABLE}.newsletter_subscriber_nurture_conversion_conversion_date ;;
  }

  dimension: newsletter_subscriber_nurture_conversion_start_date {
    type: string
    sql: ${TABLE}.newsletter_subscriber_nurture_conversion_start_date ;;
  }

  dimension: newsletter_subscription {
    type: string
    sql: ${TABLE}.newsletter_subscription ;;
  }

  dimension: notes_last_contacted {
    type: string
    sql: ${TABLE}.notes_last_contacted ;;
  }

  dimension: notes_last_updated {
    type: string
    sql: ${TABLE}.notes_last_updated ;;
  }

  dimension: notes_next_activity_date {
    type: string
    sql: ${TABLE}.notes_next_activity_date ;;
  }

  dimension: nps_feedback_on_customer_service_agent {
    type: string
    sql: ${TABLE}.nps_feedback_on_customer_service_agent ;;
  }

  dimension: nps_feedback_on_rating_purple_mattress_protector {
    type: string
    sql: ${TABLE}.nps_feedback_on_rating_purple_mattress_protector ;;
  }

  dimension: nps_feedback_on_rating_purple_pillow {
    type: string
    sql: ${TABLE}.nps_feedback_on_rating_purple_pillow ;;
  }

  dimension: nps_feedback_on_rating_purple_platform_base {
    type: string
    sql: ${TABLE}.nps_feedback_on_rating_purple_platform_base ;;
  }

  dimension: nps_feedback_on_rating_purple_sheets {
    type: string
    sql: ${TABLE}.nps_feedback_on_rating_purple_sheets ;;
  }

  dimension: nps_feedback_on_rating_ultimate_purple_seat_cushion {
    type: string
    sql: ${TABLE}.nps_feedback_on_rating_ultimate_purple_seat_cushion ;;
  }

  dimension: nps_product_meet_expectations_purple_mattress_protector {
    type: string
    sql: ${TABLE}.nps_product_meet_expectations_purple_mattress_protector ;;
  }

  dimension: nps_product_meet_expectations_purple_pillow {
    type: string
    sql: ${TABLE}.nps_product_meet_expectations_purple_pillow ;;
  }

  dimension: nps_product_meet_expectations_purple_platform_base {
    type: string
    sql: ${TABLE}.nps_product_meet_expectations_purple_platform_base ;;
  }

  dimension: nps_product_meet_expectations_purple_sheets {
    type: string
    sql: ${TABLE}.nps_product_meet_expectations_purple_sheets ;;
  }

  dimension: nps_product_meet_expectations_ultimate_purple_seat_cushion {
    type: string
    sql: ${TABLE}.nps_product_meet_expectations_ultimate_purple_seat_cushion ;;
  }

  dimension: nps_product_rated {
    type: string
    sql: ${TABLE}.nps_product_rated ;;
  }

  dimension: nps_rating_scale {
    type: string
    sql: ${TABLE}.nps_rating_scale ;;
  }

  dimension: nps_rating_scale_purple_mattress_protector {
    type: string
    sql: ${TABLE}.nps_rating_scale_purple_mattress_protector ;;
  }

  dimension: nps_rating_scale_purple_pillow {
    type: string
    sql: ${TABLE}.nps_rating_scale_purple_pillow ;;
  }

  dimension: nps_rating_scale_purple_sheets {
    type: string
    sql: ${TABLE}.nps_rating_scale_purple_sheets ;;
  }

  dimension: nps_rating_scale_ultimate_purple_seat_cushion {
    type: string
    sql: ${TABLE}.nps_rating_scale_ultimate_purple_seat_cushion ;;
  }

  dimension: nps_review_source_on_customer_service_form {
    type: string
    sql: ${TABLE}.nps_review_source_on_customer_service_form ;;
  }

  dimension: nps_score_on_customer_service_form {
    type: string
    sql: ${TABLE}.nps_score_on_customer_service_form ;;
  }

  dimension: nps_survey_list {
    type: string
    sql: ${TABLE}.nps_survey_list ;;
  }

  dimension: num_associated_deals {
    type: string
    sql: ${TABLE}.num_associated_deals ;;
  }

  dimension: num_contacted_notes {
    type: string
    sql: ${TABLE}.num_contacted_notes ;;
  }

  dimension: num_notes {
    type: string
    sql: ${TABLE}.num_notes ;;
  }

  dimension: numemployees {
    type: string
    sql: ${TABLE}.numemployees ;;
  }

  dimension: order_frequency_rating {
    type: string
    sql: ${TABLE}.order_frequency_rating ;;
  }

  dimension: order_recency_rating {
    type: string
    sql: ${TABLE}.order_recency_rating ;;
  }

  dimension: order_token {
    type: string
    sql: ${TABLE}.order_token ;;
  }

  dimension: orders_count {
    type: string
    sql: ${TABLE}.orders_count ;;
  }

  dimension: out_of_stock_product_name {
    type: string
    sql: ${TABLE}.out_of_stock_product_name ;;
  }

  dimension: pet_bed_survey_tracking_number {
    type: string
    sql: ${TABLE}.pet_bed_survey_tracking_number ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: pillow_upsell_to_mattress_workflow_conversion {
    type: string
    sql: ${TABLE}.pillow_upsell_to_mattress_workflow_conversion ;;
  }

  dimension: pillow_upsell_to_mattress_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.pillow_upsell_to_mattress_workflow_conversion_amount ;;
  }

  dimension: pillow_upsell_to_mattress_workflow_conversion_date {
    type: string
    sql: ${TABLE}.pillow_upsell_to_mattress_workflow_conversion_date ;;
  }

  dimension: pillow_upsell_to_mattress_workflow_start_date {
    type: string
    sql: ${TABLE}.pillow_upsell_to_mattress_workflow_start_date ;;
  }

  dimension: powerbase_nurture_workflow_conversion {
    type: string
    sql: ${TABLE}.powerbase_nurture_workflow_conversion ;;
  }

  dimension: powerbase_nurture_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.powerbase_nurture_workflow_conversion_amount ;;
  }

  dimension: powerbase_nurture_workflow_conversion_date {
    type: string
    sql: ${TABLE}.powerbase_nurture_workflow_conversion_date ;;
  }

  dimension: powerbase_nurture_workflow_start_date {
    type: string
    sql: ${TABLE}.powerbase_nurture_workflow_start_date ;;
  }

  dimension: preferred_sleeping_position {
    type: string
    sql: ${TABLE}.preferred_sleeping_position ;;
  }

  dimension: product_reviewed {
    type: string
    sql: ${TABLE}.product_reviewed ;;
  }

  dimension: product_types_bought {
    type: string
    sql: ${TABLE}.product_types_bought ;;
  }

  dimension: product_types_bought_text {
    type: string
    sql: ${TABLE}.product_types_bought_text ;;
  }

  dimension: products_bought {
    type: string
    sql: ${TABLE}.products_bought ;;
  }

  dimension: products_bought_text {
    type: string
    sql: ${TABLE}.products_bought_text ;;
  }

  dimension: progressive_2nd_contact {
    type: string
    sql: ${TABLE}.progressive_2nd_contact ;;
  }

  dimension: progressive_approval_amount {
    type: string
    sql: ${TABLE}.progressive_approval_amount ;;
  }

  dimension: progressive_email_to_expire_approval {
    type: string
    sql: ${TABLE}.progressive_email_to_expire_approval ;;
  }

  dimension: progressive_funded_date {
    type: string
    sql: ${TABLE}.progressive_funded_date ;;
  }

  dimension: progressive_initial_contact {
    type: string
    sql: ${TABLE}.progressive_initial_contact ;;
  }

  dimension: progressive_order_amount {
    type: string
    sql: ${TABLE}.progressive_order_amount ;;
  }

  dimension: progressive_order_date {
    type: string
    sql: ${TABLE}.progressive_order_date ;;
  }

  dimension: recent_conversion_date {
    type: string
    sql: ${TABLE}.recent_conversion_date ;;
  }

  dimension: recent_conversion_event_name {
    type: string
    sql: ${TABLE}.recent_conversion_event_name ;;
  }

  dimension: recent_deal_amount {
    type: string
    sql: ${TABLE}.recent_deal_amount ;;
  }

  dimension: recent_deal_close_date {
    type: string
    sql: ${TABLE}.recent_deal_close_date ;;
  }

  dimension: ref_id_ {
    type: string
    sql: ${TABLE}.ref_id_ ;;
  }

  dimension: review_body_text {
    type: string
    sql: ${TABLE}.review_body_text ;;
  }

  dimension: review_title {
    type: string
    sql: ${TABLE}.review_title ;;
  }

  dimension: roi_tracking_last_order_date {
    type: string
    sql: ${TABLE}.roi_tracking_last_order_date ;;
  }

  dimension: roi_tracking_test_workflow_total_order_numbers {
    type: string
    sql: ${TABLE}.roi_tracking_test_workflow_total_order_numbers ;;
  }

  dimension: seat_cushion_product_purchased {
    type: string
    sql: ${TABLE}.seat_cushion_product_purchased ;;
  }

  dimension: seat_cushion_upsell_to_mattress_start_date {
    type: string
    sql: ${TABLE}.seat_cushion_upsell_to_mattress_start_date ;;
  }

  dimension: seat_cushion_upsell_to_mattress_workflow_conversion {
    type: string
    sql: ${TABLE}.seat_cushion_upsell_to_mattress_workflow_conversion ;;
  }

  dimension: seat_cushion_upsell_to_mattress_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.seat_cushion_upsell_to_mattress_workflow_conversion_amount ;;
  }

  dimension: seat_cushion_upsell_to_mattress_workflow_conversion_date {
    type: string
    sql: ${TABLE}.seat_cushion_upsell_to_mattress_workflow_conversion_date ;;
  }

  dimension: sh_account_creation_date {
    type: string
    sql: ${TABLE}.sh_account_creation_date ;;
  }

  dimension: sh_average_days_between_orders {
    type: string
    sql: ${TABLE}.sh_average_days_between_orders ;;
  }

  dimension: sh_average_order_value {
    type: string
    sql: ${TABLE}.sh_average_order_value ;;
  }

  dimension: sh_first_order_date {
    type: string
    sql: ${TABLE}.sh_first_order_date ;;
  }

  dimension: sh_first_order_value {
    type: string
    sql: ${TABLE}.sh_first_order_value ;;
  }

  dimension: sh_last_order_date {
    type: string
    sql: ${TABLE}.sh_last_order_date ;;
  }

  dimension: sh_last_order_value {
    type: string
    sql: ${TABLE}.sh_last_order_value ;;
  }

  dimension: sh_total_number_of_orders {
    type: string
    sql: ${TABLE}.sh_total_number_of_orders ;;
  }

  dimension: sh_total_value_of_order {
    type: string
    sql: ${TABLE}.sh_total_value_of_order ;;
  }

  dimension: shipping_address_line_1 {
    type: string
    sql: ${TABLE}.shipping_address_line_1 ;;
  }

  dimension: shipping_address_line_2 {
    type: string
    sql: ${TABLE}.shipping_address_line_2 ;;
  }

  dimension: shipping_city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: shipping_country {
    type: string
    sql: ${TABLE}.shipping_country ;;
  }

  dimension: shipping_method {
    type: string
    sql: ${TABLE}.shipping_method ;;
  }

  dimension: shipping_phone {
    type: string
    sql: ${TABLE}.shipping_phone ;;
  }

  dimension: shipping_postal_code {
    type: string
    sql: ${TABLE}.shipping_postal_code ;;
  }

  dimension: shipping_state {
    type: string
    sql: ${TABLE}.shipping_state ;;
  }

  dimension: shopify_customer_tags {
    type: string
    sql: ${TABLE}.shopify_customer_tags ;;
  }

  dimension: shopify_customer_tags_text {
    type: string
    sql: ${TABLE}.shopify_customer_tags_text ;;
  }

  dimension: shopping_cart_customer_id {
    type: string
    sql: ${TABLE}.shopping_cart_customer_id ;;
  }

  dimension: skus_bought {
    type: string
    sql: ${TABLE}.skus_bought ;;
  }

  dimension: skus_bought_text {
    type: string
    sql: ${TABLE}.skus_bought_text ;;
  }

  dimension: sleep_system_upsell_workflow_conversion {
    type: string
    sql: ${TABLE}.sleep_system_upsell_workflow_conversion ;;
  }

  dimension: sleep_system_upsell_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.sleep_system_upsell_workflow_conversion_amount ;;
  }

  dimension: sleep_system_upsell_workflow_conversion_date {
    type: string
    sql: ${TABLE}.sleep_system_upsell_workflow_conversion_date ;;
  }

  dimension: sleep_system_upsell_workflow_start_date {
    type: string
    sql: ${TABLE}.sleep_system_upsell_workflow_start_date ;;
  }

  dimension: sm_nck {
    type: string
    sql: ${TABLE}.sm_nck ;;
  }

  dimension: squeeze_my_leads_dispositions {
    type: string
    sql: ${TABLE}.squeeze_my_leads_dispositions ;;
  }

  dimension: squeeze_my_leads_loaded_date {
    type: string
    sql: ${TABLE}.squeeze_my_leads_loaded_date ;;
  }

  dimension: squishy_order_date {
    type: string
    sql: ${TABLE}.squishy_order_date ;;
  }

  dimension: squishy_ship_date {
    type: string
    sql: ${TABLE}.squishy_ship_date ;;
  }

  dimension: squishy_shipped {
    type: string
    sql: ${TABLE}.squishy_shipped ;;
  }

  dimension: stamped_io_review {
    type: string
    sql: ${TABLE}.stamped_io_review ;;
  }

  dimension: stardust_survey_coupon_code {
    type: string
    sql: ${TABLE}.stardust_survey_coupon_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: state_list {
    type: string
    sql: ${TABLE}.state_list ;;
  }

  dimension: street_address_2 {
    type: string
    sql: ${TABLE}.street_address_2 ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}.tags ;;
  }

  dimension: talkable_campaign_name {
    type: string
    sql: ${TABLE}.talkable_campaign_name ;;
  }

  dimension: total_number_of_cart_products {
    type: string
    sql: ${TABLE}.total_number_of_cart_products ;;
  }

  dimension: total_number_of_current_orders {
    type: string
    sql: ${TABLE}.total_number_of_current_orders ;;
  }

  dimension: total_number_of_orders {
    type: string
    sql: ${TABLE}.total_number_of_orders ;;
  }

  dimension: total_revenue {
    type: string
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: total_spent {
    type: string
    sql: ${TABLE}.total_spent ;;
  }

  dimension: total_value_of_abandoned_cart {
    type: string
    sql: ${TABLE}.total_value_of_abandoned_cart ;;
  }

  dimension: total_value_of_orders {
    type: string
    sql: ${TABLE}.total_value_of_orders ;;
  }

  dimension: tr_ {
    type: string
    sql: ${TABLE}.tr_ ;;
  }

  dimension: twitterbio {
    type: string
    sql: ${TABLE}.twitterbio ;;
  }

  dimension: twitterhandle {
    type: string
    sql: ${TABLE}.twitterhandle ;;
  }

  dimension: twitterprofilephoto {
    type: string
    sql: ${TABLE}.twitterprofilephoto ;;
  }

  dimension: usps_leads_workflow_conversion {
    type: string
    sql: ${TABLE}.usps_leads_workflow_conversion ;;
  }

  dimension: usps_leads_workflow_conversion_amount {
    type: string
    sql: ${TABLE}.usps_leads_workflow_conversion_amount ;;
  }

  dimension: usps_leads_workflow_conversion_date {
    type: string
    sql: ${TABLE}.usps_leads_workflow_conversion_date ;;
  }

  dimension: usps_leads_workflow_start_date {
    type: string
    sql: ${TABLE}.usps_leads_workflow_start_date ;;
  }

  dimension: usps_rent_or_own {
    type: string
    sql: ${TABLE}.usps_rent_or_own ;;
  }

  dimension: vendors_bought_text {
    type: string
    sql: ${TABLE}.vendors_bought_text ;;
  }

  dimension: wedding_date {
    type: string
    sql: ${TABLE}.wedding_date ;;
  }

  dimension: what_brand_do_did_you_usually_purchase_ {
    type: string
    sql: ${TABLE}.what_brand_do_did_you_usually_purchase_ ;;
  }

  dimension: what_brand_is_your_current_mattress_ {
    type: string
    sql: ${TABLE}.what_brand_is_your_current_mattress_ ;;
  }

  dimension: where_do_did_you_mainly_purchase_your_shoe_insoles_ {
    type: string
    sql: ${TABLE}.where_do_did_you_mainly_purchase_your_shoe_insoles_ ;;
  }

  dimension: why_do_did_you_mainly_purchase_insoles_ {
    type: string
    sql: ${TABLE}.why_do_did_you_mainly_purchase_insoles_ ;;
  }

  dimension: would_you_be_interested_in_joining_our_purple_tastic_customer_research_team_ {
    type: string
    sql: ${TABLE}.would_you_be_interested_in_joining_our_purple_tastic_customer_research_team_ ;;
  }

  dimension: wow_get_2nd_order_1st_conversion_did_not_use_incentive {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_1st_conversion_did_not_use_incentive ;;
  }

  dimension: wow_get_2nd_order_active_last_clicked {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_active_last_clicked ;;
  }

  dimension: wow_get_2nd_order_active_last_opened {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_active_last_opened ;;
  }

  dimension: wow_get_2nd_order_campaign_version {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_campaign_version ;;
  }

  dimension: wow_get_2nd_order_conversion_date {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_conversion_date ;;
  }

  dimension: wow_get_2nd_order_converted {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_converted ;;
  }

  dimension: wow_get_2nd_order_last_click_conversion_attribution {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_last_click_conversion_attribution ;;
  }

  dimension: wow_get_2nd_order_last_clicked_date {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_last_clicked_date ;;
  }

  dimension: wow_get_2nd_order_last_open_conversion_attribution {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_last_open_conversion_attribution ;;
  }

  dimension: wow_get_2nd_order_last_opened_date {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_last_opened_date ;;
  }

  dimension: wow_get_2nd_order_roi {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_roi ;;
  }

  dimension: wow_get_2nd_order_start_date {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_start_date ;;
  }

  dimension: wow_get_2nd_order_times_roi_calculated {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_times_roi_calculated ;;
  }

  dimension: wow_get_2nd_order_unique_emails_clicked {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_unique_emails_clicked ;;
  }

  dimension: wow_get_2nd_order_unique_emails_opened {
    type: string
    sql: ${TABLE}.wow_get_2nd_order_unique_emails_opened ;;
  }

  dimension: xpo_tracking_number {
    type: string
    sql: ${TABLE}.xpo_tracking_number ;;
  }

  dimension: xpo_tracking_url {
    type: string
    sql: ${TABLE}.xpo_tracking_url ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      user_id,
      author_name,
      out_of_stock_product_name,
      customer_service_agent_name,
      last_products_bought_product_3_name,
      last_products_bought_product_2_name,
      abandoned_product_3_name,
      abandoned_product_2_name,
      abandoned_product_1_name,
      last_products_bought_product_1_name,
      first_conversion_event_name,
      recent_conversion_event_name,
      hs_email_last_email_name,
      lastname,
      firstname,
      talkable_campaign_name,
      full_name,
      abandoned_carts.count,
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
      core_segments_all_users.count,
      core_segments_daily_active_users.count,
      core_segments_monthly_active_users.count,
      core_segments_weekly_active_users.count,
      customers.count,
      desktop_users.count,
      email_abandon_cart_purchasers.count,
      homepage_hp_featured_on_bar.count,
      homepage_hp_watch_video_clicks.count,
      homepage_viewed_page_homepage.count,
      hubspot_email_opened_email.count,
      mattress_viewed_page_compare.count,
      mattress_viewed_page_mattress_science.count,
      mattress_viewed_page_sleep_cool.count,
      mobile_users.count,
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
      sessions.count,
      support_page_support_call_us.count,
      support_page_support_email_us.count,
      support_page_support_live_chat.count
    ]
  }
}
