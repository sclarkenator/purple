view: events_view__all_events__all_events {
  sql_table_name: "TEALIUM"."EVENTS_VIEW__ALL_EVENTS__ALL_EVENTS"
    ;;

  dimension: event__client_ip {
    type: string
    sql: ${TABLE}."EVENT - CLIENT IP" ;;
  }

  dimension_group: event__day {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."EVENT - DAY" ;;
  }

  dimension: event__dom__title {
    type: string
    sql: ${TABLE}."EVENT - DOM - TITLE" ;;
  }

  dimension: event__first_party_cookies___ga {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - _GA" ;;
  }

  dimension: event__first_party_cookies__optimizelyenduserid {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - OPTIMIZELYENDUSERID" ;;
  }

  dimension: event__first_party_cookies__quantummetricsessionid {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - QUANTUMMETRICSESSIONID" ;;
  }

  dimension: event__first_party_cookies__quantummetricuserid {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - QUANTUMMETRICUSERID" ;;
  }

  dimension: event__first_party_cookies__utag_main__pn {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN__PN" ;;
  }

  dimension: event__first_party_cookies__utag_main__sn {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN__SN" ;;
  }

  dimension: event__first_party_cookies__utag_main__ss {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN__SS" ;;
  }

  dimension: event__first_party_cookies__utag_main__st {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN__ST" ;;
  }

  dimension: event__first_party_cookies__utag_main_fbcustom {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN_FBCUSTOM" ;;
  }

  dimension: event__first_party_cookies__utag_main_orderid {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN_ORDERID" ;;
  }

  dimension: event__first_party_cookies__utag_main_ses_id {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN_SES_ID" ;;
  }

  dimension: event__first_party_cookies__utag_main_ttd_uuid {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN_TTD_UUID" ;;
  }

  dimension: event__first_party_cookies__utag_main_v_id {
    type: string
    sql: ${TABLE}."EVENT - FIRST PARTY COOKIES - UTAG_MAIN_V_ID" ;;
  }

  dimension: event__id {
    primary_key: yes
    type: string
    sql: ${TABLE}."EVENT - ID" ;;
  }

  dimension: event__js__shopify_checkout_step {
    type: string
    sql: ${TABLE}."EVENT - JS - SHOPIFY.CHECKOUT.STEP" ;;
  }

  dimension: event__page_url__domain {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - DOMAIN" ;;
  }

  dimension: event__page_url__full_url {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - FULL_URL" ;;
  }

  dimension: event__page_url__path {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - PATH" ;;
  }

  dimension: event__page_url__query_params__adset {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - ADSET" ;;
  }

  dimension: event__page_url__query_params__gclid {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - GCLID" ;;
  }

  dimension: event__page_url__query_params__mcid {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - MCID" ;;
  }

  dimension: event__page_url__query_params__utm_campaign {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - UTM_CAMPAIGN" ;;
  }

  dimension: event__page_url__query_params__utm_content {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - UTM_CONTENT" ;;
  }

  dimension: event__page_url__query_params__utm_medium {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - UTM_MEDIUM" ;;
  }

  dimension: event__page_url__query_params__utm_source {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - UTM_SOURCE" ;;
  }

  dimension: event__page_url__query_params__utm_term {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERY PARAMS - UTM_TERM" ;;
  }

  dimension: event__page_url__querystring {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - QUERYSTRING" ;;
  }

  dimension: event__page_url__scheme {
    type: string
    sql: ${TABLE}."EVENT - PAGE URL - SCHEME" ;;
  }

  dimension: event__referrer_url__domain {
    type: string
    sql: ${TABLE}."EVENT - REFERRER URL - DOMAIN" ;;
  }

  dimension: event__referrer_url__full_url {
    type: string
    sql: ${TABLE}."EVENT - REFERRER URL - FULL_URL" ;;
  }

  dimension: event__referrer_url__path {
    type: string
    sql: ${TABLE}."EVENT - REFERRER URL - PATH" ;;
  }

  dimension: event__referrer_url__scheme {
    type: string
    sql: ${TABLE}."EVENT - REFERRER URL - SCHEME" ;;
  }

  dimension: event__tags__acuity_cookie_sync__main_48__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - ACUITY COOKIE SYNC  (MAIN 48) - EXECUTED" ;;
  }

  dimension: event__tags__c3_metrics_main_5__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - C3 METRICS (MAIN 5) - EXECUTED" ;;
  }

  dimension: event__tags__debug_realtime_audit_main_1__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - DEBUG: REAL-TIME AUDIT (MAIN 1) - EXECUTED"
      ;;
  }

  dimension: event__tags__facebook_pixel_main_40__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - FACEBOOK PIXEL (MAIN 40) - EXECUTED" ;;
  }

  dimension: event__tags__floodlight_gtag_js_main_37__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - FLOODLIGHT (GTAG.JS) (MAIN 37) - EXECUTED" ;;
  }

  dimension: event__tags__google_ads_conversion_tracking__remarketing_main_9__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - GOOGLE ADS CONVERSION TRACKING & REMARKETING (MAIN 9) - EXECUTED" ;;
  }

  dimension: event__tags__heap_main_2__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - HEAP (MAIN 2) - EXECUTED" ;;
  }

  dimension: event__tags__ocean_media__unique_tags_main_28__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - OCEAN MEDIA - UNIQUE TAGS (MAIN 28) - EXECUTED" ;;
  }

  dimension: event__tags__ocean_media_base_tag_main_25__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - OCEAN MEDIA BASE TAG (MAIN 25) - EXECUTED" ;;
  }

  dimension: event__tags__outbrain_pixel_main_38__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - OUTBRAIN PIXEL (MAIN 38) - EXECUTED" ;;
  }

  dimension: event__tags__purple_facebook_pixel_main_44__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - PURPLE FACEBOOK PIXEL (MAIN 44) - EXECUTED" ;;
  }

  dimension: event__tags__quantum_metric_main_4__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - QUANTUM METRIC (MAIN 4) - EXECUTED" ;;
  }

  dimension: event__tags__tealium_collect_main_10__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - TEALIUM COLLECT (MAIN 10) - EXECUTED" ;;
  }

  dimension: event__tags__tealium_generic_tag_main_50__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - TEALIUM GENERIC TAG (MAIN 50) - EXECUTED" ;;
  }

  dimension: event__tags__tealium_pixel_or_iframe_container_main_53__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - TEALIUM PIXEL (OR IFRAME) CONTAINER (MAIN 53) - EXECUTED" ;;
  }

  dimension: event__tags__test_google_analytics_gtag_js_main_14__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - TEST GOOGLE ANALYTICS (GTAG.JS) (MAIN 14) - EXECUTED" ;;
  }

  dimension: event__tags__the_trade_desk_cookie_matching_service_main_35__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - THE TRADE DESK COOKIE MATCHING SERVICE (MAIN 35) - EXECUTED" ;;
  }

  dimension: event__tags__the_trade_desk_main_32__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - THE TRADE DESK (MAIN 32) - EXECUTED" ;;
  }

  dimension: event__tags__verizon_media_yahoo_gemini_pixel_main_43__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - VERIZON MEDIA (YAHOO GEMINI) PIXEL (MAIN 43) - EXECUTED" ;;
  }

  dimension: event__tags__yahoo_dot__base_tag_main_47__executed {
    type: yesno
    sql: ${TABLE}."EVENT - TAGS - YAHOO DOT - BASE TAG (MAIN 47) - EXECUTED" ;;
  }

  dimension_group: event_ {
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
    sql: ${TABLE}."EVENT - TIME" ;;
  }

  dimension: event__udo___cbrand {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CBRAND" ;;
  }

  dimension: event__udo___ccat {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCAT" ;;
  }

  dimension: event__udo___ccat2 {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCAT2" ;;
  }

  dimension: event__udo___ccity {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCITY" ;;
  }

  dimension: event__udo___ccountry {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCOUNTRY" ;;
  }

  dimension: event__udo___ccurrency {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCURRENCY" ;;
  }

  dimension: event__udo___ccustid {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CCUSTID" ;;
  }

  dimension: event__udo___corder {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CORDER" ;;
  }

  dimension: event__udo___cpdisc {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CPDISC" ;;
  }

  dimension: event__udo___cprice {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CPRICE" ;;
  }

  dimension: event__udo___cprod {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CPROD" ;;
  }

  dimension: event__udo___cprodname {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CPRODNAME" ;;
  }

  dimension: event__udo___cpromo {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CPROMO" ;;
  }

  dimension: event__udo___cquan {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CQUAN" ;;
  }

  dimension: event__udo___cship {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CSHIP" ;;
  }

  dimension: event__udo___csku {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CSKU" ;;
  }

  dimension: event__udo___cstate {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CSTATE" ;;
  }

  dimension: event__udo___cstore {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CSTORE" ;;
  }

  dimension: event__udo___csubtotal {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CSUBTOTAL" ;;
  }

  dimension: event__udo___ctax {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CTAX" ;;
  }

  dimension: event__udo___ctotal {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CTOTAL" ;;
  }

  dimension: event__udo___ctype {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CTYPE" ;;
  }

  dimension: event__udo___czip {
    type: string
    sql: ${TABLE}."EVENT - UDO - _CZIP" ;;
  }

  dimension: event__udo__acuity_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - ACUITY_ID" ;;
  }

  dimension: event__udo__adwords_conversionid {
    type: string
    sql: ${TABLE}."EVENT - UDO - ADWORDS_CONVERSIONID" ;;
  }

  dimension: event__udo__adwords_conversionlabel {
    type: string
    sql: ${TABLE}."EVENT - UDO - ADWORDS_CONVERSIONLABEL" ;;
  }

  dimension: event__udo__amazon_conversions {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_CONVERSIONS" ;;
  }

  dimension: event__udo__amazon_guid {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_GUID" ;;
  }

  dimension: event__udo__amazon_guid_uppercase {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_GUID_UPPERCASE" ;;
  }

  dimension: event__udo__amazon_tag_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_TAG_ID" ;;
  }

  dimension: event__udo__amazon_tiered_value {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_TIERED_VALUE" ;;
  }

  dimension: event__udo__amazon_trigger {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_TRIGGER" ;;
  }

  dimension: event__udo__amazon_url {
    type: string
    sql: ${TABLE}."EVENT - UDO - AMAZON_URL" ;;
  }

  dimension: event__udo__blog_author {
    type: string
    sql: ${TABLE}."EVENT - UDO - BLOG_AUTHOR" ;;
  }

  dimension: event__udo__blog_date {
    type: string
    sql: ${TABLE}."EVENT - UDO - BLOG_DATE" ;;
  }

  dimension: event__udo__blog_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - BLOG_ID" ;;
  }

  dimension: event__udo__blog_title {
    type: string
    sql: ${TABLE}."EVENT - UDO - BLOG_TITLE" ;;
  }

  dimension: event__udo__brand_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - BRAND_NAME" ;;
  }

  dimension: event__udo__buy_page_view {
    type: string
    sql: ${TABLE}."EVENT - UDO - BUY_PAGE_VIEW" ;;
  }

  dimension: event__udo__c3_ch {
    type: string
    sql: ${TABLE}."EVENT - UDO - C3CH" ;;
  }

  dimension: event__udo__c3_nid {
    type: string
    sql: ${TABLE}."EVENT - UDO - C3NID" ;;
  }

  dimension: event__udo__c3_qs {
    type: string
    sql: ${TABLE}."EVENT - UDO - C3QS" ;;
  }

  dimension: event__udo__c3_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - C3_TYPE" ;;
  }

  dimension: event__udo__cart_or_product_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_OR_PRODUCT_ID" ;;
  }

  dimension: event__udo__cart_product_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_ID" ;;
  }

  dimension: event__udo__cart_product_ids {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_IDS" ;;
  }

  dimension: event__udo__cart_product_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_NAME" ;;
  }

  dimension: event__udo__cart_product_names {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_NAMES" ;;
  }

  dimension: event__udo__cart_product_price {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_PRICE" ;;
  }

  dimension: event__udo__cart_product_price_string {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_PRICE_STRING" ;;
  }

  dimension: event__udo__cart_product_prices {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_PRICES" ;;
  }

  dimension: event__udo__cart_product_quantities {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_QUANTITIES" ;;
  }

  dimension: event__udo__cart_product_quantity {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_QUANTITY" ;;
  }

  dimension: event__udo__cart_product_sku {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_SKU" ;;
  }

  dimension: event__udo__cart_product_skus {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_PRODUCT_SKUS" ;;
  }

  dimension: event__udo__cart_total_items {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_TOTAL_ITEMS" ;;
  }

  dimension: event__udo__cart_total_value {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_TOTAL_VALUE" ;;
  }

  dimension: event__udo__cart_variant_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_VARIANT_ID" ;;
  }

  dimension: event__udo__cart_variant_ids {
    type: string
    sql: ${TABLE}."EVENT - UDO - CART_VARIANT_IDS" ;;
  }

  dimension: event__udo__category_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CATEGORY_ID" ;;
  }

  dimension: event__udo__category_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - CATEGORY_NAME" ;;
  }

  dimension: event__udo__checkout_option {
    type: string
    sql: ${TABLE}."EVENT - UDO - CHECKOUT_OPTION" ;;
  }

  dimension: event__udo__checkout_step {
    type: string
    sql: ${TABLE}."EVENT - UDO - CHECKOUT_STEP" ;;
  }

  dimension: event__udo__cordial_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CORDIAL_ID" ;;
  }

  dimension: event__udo__country_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - COUNTRY_CODE" ;;
  }

  dimension: event__udo__currency_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - CURRENCY_CODE" ;;
  }

  dimension: event__udo__customer_city {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_CITY" ;;
  }

  dimension: event__udo__customer_country {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_COUNTRY" ;;
  }

  dimension: event__udo__customer_email {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_EMAIL" ;;
  }

  dimension: event__udo__customer_email_hash {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_EMAIL_HASH" ;;
  }

  dimension: event__udo__customer_first_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_FIRST_NAME" ;;
  }

  dimension: event__udo__customer_full_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_FULL_NAME" ;;
  }

  dimension: event__udo__customer_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_ID" ;;
  }

  dimension: event__udo__customer_last_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_LAST_NAME" ;;
  }

  dimension: event__udo__customer_phone {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_PHONE" ;;
  }

  dimension: event__udo__customer_postal_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_POSTAL_CODE" ;;
  }

  dimension: event__udo__customer_state {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_STATE" ;;
  }

  dimension: event__udo__customer_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_TYPE" ;;
  }

  dimension: event__udo__customer_zip {
    type: string
    sql: ${TABLE}."EVENT - UDO - CUSTOMER_ZIP" ;;
  }

  dimension: event__udo__dc_activity {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_ACTIVITY" ;;
  }

  dimension: event__udo__dc_activity_group {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_ACTIVITY_GROUP" ;;
  }

  dimension: event__udo__dc_count {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_COUNT" ;;
  }

  dimension: event__udo__dc_event {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_EVENT" ;;
  }

  dimension: event__udo__dc_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_ID" ;;
  }

  dimension: event__udo__dc_values {
    type: string
    sql: ${TABLE}."EVENT - UDO - DC_VALUES" ;;
  }

  dimension: event__udo__dom_url {
    type: string
    sql: ${TABLE}."EVENT - UDO - DOM.URL" ;;
  }

  dimension: event__udo__ea {
    type: string
    sql: ${TABLE}."EVENT - UDO - EA" ;;
  }

  dimension: event__udo__event_action {
    type: string
    sql: ${TABLE}."EVENT - UDO - EVENT_ACTION" ;;
  }

  dimension: event__udo__event_category {
    type: string
    sql: ${TABLE}."EVENT - UDO - EVENT_CATEGORY" ;;
  }

  dimension: event__udo__event_label {
    type: string
    sql: ${TABLE}."EVENT - UDO - EVENT_LABEL" ;;
  }

  dimension: event__udo__event_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - EVENT_NAME" ;;
  }

  dimension: event__udo__fb_content_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - FB_CONTENT_TYPE" ;;
  }

  dimension: event__udo__fb_custom_sent {
    type: string
    sql: ${TABLE}."EVENT - UDO - FB_CUSTOM_SENT" ;;
  }

  dimension: event__udo__heap_app_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - HEAP_APP_ID" ;;
  }

  dimension: event__udo__language_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - LANGUAGE_CODE" ;;
  }

  dimension: event__udo__order_coupon_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_COUPON_CODE" ;;
  }

  dimension: event__udo__order_coupon_discount {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_COUPON_DISCOUNT" ;;
  }

  dimension: event__udo__order_currency {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_CURRENCY" ;;
  }

  dimension: event__udo__order_currency_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_CURRENCY_CODE" ;;
  }

  dimension: event__udo__order_discount {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_DISCOUNT" ;;
  }

  dimension: event__udo__order_discount_amount {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_DISCOUNT_AMOUNT" ;;
  }

  dimension: event__udo__order_grand_total {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_GRAND_TOTAL" ;;
  }

  dimension: event__udo__order_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_ID" ;;
  }

  dimension: event__udo__order_id_no_hash {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_ID_NO_HASH" ;;
  }

  dimension: event__udo__order_merchandise_total {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_MERCHANDISE_TOTAL" ;;
  }

  dimension: event__udo__order_payment_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_PAYMENT_TYPE" ;;
  }

  dimension: event__udo__order_promo_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_PROMO_CODE" ;;
  }

  dimension: event__udo__order_shipping {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_SHIPPING" ;;
  }

  dimension: event__udo__order_shipping_amount {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_SHIPPING_AMOUNT" ;;
  }

  dimension: event__udo__order_shipping_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_SHIPPING_TYPE" ;;
  }

  dimension: event__udo__order_store {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_STORE" ;;
  }

  dimension: event__udo__order_subtotal {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_SUBTOTAL" ;;
  }

  dimension: event__udo__order_subtotal_integer {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_SUBTOTAL_INTEGER" ;;
  }

  dimension: event__udo__order_tax {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_TAX" ;;
  }

  dimension: event__udo__order_tax_amount {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_TAX_AMOUNT" ;;
  }

  dimension: event__udo__order_total {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_TOTAL" ;;
  }

  dimension: event__udo__order_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_TYPE" ;;
  }

  dimension: event__udo__order_variant_ids {
    type: string
    sql: ${TABLE}."EVENT - UDO - ORDER_VARIANT_IDS" ;;
  }

  dimension: event__udo__page_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - PAGE_NAME" ;;
  }

  dimension: event__udo__paid_add_cart {
    type: string
    sql: ${TABLE}."EVENT - UDO - PAID_ADD_CART" ;;
  }

  dimension: event__udo__platform {
    type: string
    sql: ${TABLE}."EVENT - UDO - PLATFORM" ;;
  }

  dimension: event__udo__product_brand {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_BRAND" ;;
  }

  dimension: event__udo__product_category {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_CATEGORY" ;;
  }

  dimension: event__udo__product_discount {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_DISCOUNT" ;;
  }

  dimension: event__udo__product_discount_amount {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_DISCOUNT_AMOUNT" ;;
  }

  dimension: event__udo__product_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_ID" ;;
  }

  dimension: event__udo__product_image_url {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_IMAGE_URL" ;;
  }

  dimension: event__udo__product_list_price {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_LIST_PRICE" ;;
  }

  dimension: event__udo__product_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_NAME" ;;
  }

  dimension: event__udo__product_on_page {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_ON_PAGE" ;;
  }

  dimension: event__udo__product_original_price {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_ORIGINAL_PRICE" ;;
  }

  dimension: event__udo__product_price {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_PRICE" ;;
  }

  dimension: event__udo__product_promo_code {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_PROMO_CODE" ;;
  }

  dimension: event__udo__product_quantity {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_QUANTITY" ;;
  }

  dimension: event__udo__product_sku {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_SKU" ;;
  }

  dimension: event__udo__product_subcategory {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_SUBCATEGORY" ;;
  }

  dimension: event__udo__product_unit_price {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_UNIT_PRICE" ;;
  }

  dimension: event__udo__product_url {
    type: string
    sql: ${TABLE}."EVENT - UDO - PRODUCT_URL" ;;
  }

  dimension: event__udo__promotion_creative {
    type: string
    sql: ${TABLE}."EVENT - UDO - PROMOTION_CREATIVE" ;;
  }

  dimension: event__udo__promotion_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - PROMOTION_ID" ;;
  }

  dimension: event__udo__promotion_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - PROMOTION_NAME" ;;
  }

  dimension: event__udo__promotion_position {
    type: string
    sql: ${TABLE}."EVENT - UDO - PROMOTION_POSITION" ;;
  }

  dimension: event__udo__site_platform {
    type: string
    sql: ${TABLE}."EVENT - UDO - SITE_PLATFORM" ;;
  }

  dimension: event__udo__site_section {
    type: string
    sql: ${TABLE}."EVENT - UDO - SITE_SECTION" ;;
  }

  dimension: event__udo__td_ct {
    type: string
    sql: ${TABLE}."EVENT - UDO - TD_CT" ;;
  }

  dimension: event__udo__tealium_account {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_ACCOUNT" ;;
  }

  dimension: event__udo__tealium_datasource {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_DATASOURCE" ;;
  }

  dimension: event__udo__tealium_environment {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_ENVIRONMENT" ;;
  }

  dimension: event__udo__tealium_event {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_EVENT" ;;
  }

  dimension: event__udo__tealium_event_type {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_EVENT_TYPE" ;;
  }

  dimension: event__udo__tealium_firstparty_visitor_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_FIRSTPARTY_VISITOR_ID" ;;
  }

  dimension: event__udo__tealium_library_name {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_LIBRARY_NAME" ;;
  }

  dimension: event__udo__tealium_library_version {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_LIBRARY_VERSION" ;;
  }

  dimension: event__udo__tealium_profile {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_PROFILE" ;;
  }

  dimension: event__udo__tealium_random {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_RANDOM" ;;
  }

  dimension: event__udo__tealium_session_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_SESSION_ID" ;;
  }

  dimension: event__udo__tealium_thirdparty_visitor_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_THIRDPARTY_VISITOR_ID" ;;
  }

  dimension: event__udo__tealium_timestamp_epoch {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_TIMESTAMP_EPOCH" ;;
  }

  dimension: event__udo__tealium_visitor_id {
    type: string
    sql: ${TABLE}."EVENT - UDO - TEALIUM_VISITOR_ID" ;;
  }

  dimension: event__udo__ttd_uuid {
    type: string
    sql: ${TABLE}."EVENT - UDO - TTD_UUID" ;;
  }

  dimension: event__udo__ut_account {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.ACCOUNT" ;;
  }

  dimension: event__udo__ut_domain {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.DOMAIN" ;;
  }

  dimension: event__udo__ut_env {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.ENV" ;;
  }

  dimension: event__udo__ut_event {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.EVENT" ;;
  }

  dimension: event__udo__ut_profile {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.PROFILE" ;;
  }

  dimension: event__udo__ut_version {
    type: string
    sql: ${TABLE}."EVENT - UDO - UT.VERSION" ;;
  }

  dimension: event__user_agent {
    type: string
    sql: ${TABLE}."EVENT - USER AGENT" ;;
  }

  dimension: event__visitor_id {
    type: string
    sql: ${TABLE}."EVENT - VISITOR ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      event__udo__product_name,
      event__udo__promotion_name,
      event__udo___cprodname,
      event__udo__event_name,
      event__udo__customer_last_name,
      event__udo__cart_product_name,
      event__udo__category_name,
      event__udo__page_name,
      event__udo__brand_name,
      event__udo__customer_full_name,
      event__udo__customer_first_name,
      event__udo__tealium_library_name
    ]
  }
}
