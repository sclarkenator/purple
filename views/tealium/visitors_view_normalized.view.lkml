view: visitors_view_normalized {
  sql_table_name: purple.purple__main.visitors_view_normalized ;;

  dimension: visitor__id {
    primary_key: yes
    type: string
    sql: ${TABLE}."visitor - id" ;;
  }

  dimension_group: expire__day {
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
    sql: ${TABLE}."expire - day" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated ;;
  }

  dimension_group: visit__day {
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
    sql: ${TABLE}."visit - day" ;;
  }

  dimension: visitor__audience__acquisition_test__segment_a__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - acquisition test - segment a - with email" ;;
  }

  dimension: visitor__audience__acquisition_test__segment_b__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - acquisition test - segment b - with email" ;;
  }

  dimension: visitor__audience__added_mattress_to_cart_visit {
    type: yesno
    sql: ${TABLE}."visitor - audience - added mattress to cart (visit)" ;;
  }

  dimension: visitor__audience__affirm_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - affirm purchasers" ;;
  }

  dimension: visitor__audience__affirm_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - affirm purchasers - with email" ;;
  }

  dimension: visitor__audience__affirm_purchasers_with_acuity_id {
    type: yesno
    sql: ${TABLE}."visitor - audience - affirm purchasers with acuity id" ;;
  }

  dimension: visitor__audience__all_visitors__for_audience_store {
    type: yesno
    sql: ${TABLE}."visitor - audience - all visitors - for audience store" ;;
  }

  dimension: visitor__audience__amazon_pay_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - amazon pay purchaser" ;;
  }

  dimension: visitor__audience__amobee_base_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: base purchasers"
      ;;
  }

  dimension: visitor__audience__amobee_bedding_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: bedding purchaser"
      ;;
  }

  dimension: visitor__audience__amobee_harmony_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: harmony purchasers"
      ;;
  }

  dimension: visitor__audience__amobee_lifetime_orders_12 {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: lifetime orders 1-2"
      ;;
  }

  dimension: visitor__audience__amobee_lifetime_orders_3_ {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: lifetime orders 3+ "
      ;;
  }

  dimension: visitor__audience__amobee_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: mattress purchaser"
      ;;
  }

  dimension: visitor__audience__amobee_pet_bed_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: pet bed purchaser"
      ;;
  }

  dimension: visitor__audience__amobee_pillow_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: pillow purchasers"
      ;;
  }

  dimension: visitor__audience__amobee_purple_pillow_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: purple pillow purchasers"
      ;;
  }

  dimension: visitor__audience__amobee_the_purple_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - amobee: the purple mattress purchaser"
      ;;
  }

  dimension: visitor__audience__axomo_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - axomo purchaser" ;;
  }

  dimension: visitor__audience__base_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - base purchasers" ;;
  }

  dimension: visitor__audience__base_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - base purchasers - with email" ;;
  }

  dimension: visitor__audience__bases_ltv_0999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - bases ltv 0-999" ;;
  }

  dimension: visitor__audience__bases_ltv_10001999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - bases ltv 1000-1999" ;;
  }

  dimension: visitor__audience__bases_ltv_2000 {
    type: yesno
    sql: ${TABLE}."visitor - audience - bases ltv 2000+" ;;
  }

  dimension: visitor__audience__bedding_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - bedding purchaser" ;;
  }

  dimension: visitor__audience__bedding_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - bedding purchaser - with email" ;;
  }

  dimension: visitor__audience__blanket_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - blanket fans" ;;
  }

  dimension: visitor__audience__blanket_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - blanket fans - with email" ;;
  }

  dimension: visitor__audience__braintree_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - braintree purchaser" ;;
  }

  dimension: visitor__audience__bundle_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - bundle fans" ;;
  }

  dimension: visitor__audience__bundle_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - bundle fans - with email" ;;
  }

  dimension: visitor__audience__called_customer_service_general {
    type: yesno
    sql: ${TABLE}."visitor - audience - called customer service general" ;;
  }

  dimension: visitor__audience__called_for_mattress_return {
    type: yesno
    sql: ${TABLE}."visitor - audience - called for mattress return" ;;
  }

  dimension: visitor__audience__called_for_warranty {
    type: yesno
    sql: ${TABLE}."visitor - audience - called for warranty" ;;
  }

  dimension: visitor__audience__called_inbound_sales {
    type: yesno
    sql: ${TABLE}."visitor - audience - called inbound sales" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__base {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - base" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__bedding {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - bedding" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - mattress" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__pet {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - pet" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - pillow" ;;
  }

  dimension: visitor__audience__cancelled_order_category_contains__seating {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order category contains - seating" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__harmony {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - harmony" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__hybrid_2 {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - hybrid 2" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__hybrid_premier {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - hybrid premier" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__plush_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - plush pillow" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__purple_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - purple pillow" ;;
  }

  dimension: visitor__audience__cancelled_order_contains__the_purple_mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order contains - the purple mattress" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_15_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 15 days" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_1_year {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 1 year" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_30_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 30 days" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_6_months {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 6 months" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_7_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 7 days" ;;
  }

  dimension: visitor__audience__cancelled_order_in_past_90_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - cancelled order in past 90 days" ;;
  }

  dimension: visitor__audience__cart_abandoner {
    type: yesno
    sql: ${TABLE}."visitor - audience - cart abandoner" ;;
  }

  dimension: visitor__audience__cart_abandoner__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - cart abandoner - with email" ;;
  }

  dimension: visitor__audience__ccpa {
    type: yesno
    sql: ${TABLE}."visitor - audience - ccpa" ;;
  }

  dimension: visitor__audience__contacted_support {
    type: yesno
    sql: ${TABLE}."visitor - audience - contacted support" ;;
  }

  dimension: visitor__audience__cordial_email_is_assigned_delete {
    type: yesno
    sql: ${TABLE}."visitor - audience - cordial email is assigned (delete)" ;;
  }

  dimension: visitor__audience__cordial_email_subscriber {
    type: yesno
    sql: ${TABLE}."visitor - audience - cordial email subscriber" ;;
  }

  dimension: visitor__audience__cushion_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - cushion purchaser" ;;
  }

  dimension: visitor__audience__cushion_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - cushion purchaser - with email" ;;
  }

  dimension: visitor__audience__dissatisfied_with_delivery_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - dissatisfied with delivery experience" ;;
  }

  dimension: visitor__audience__dissatisfied_with_shopping_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - dissatisfied with shopping experience" ;;
  }

  dimension: visitor__audience__duvet_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - duvet fans" ;;
  }

  dimension: visitor__audience__duvet_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - duvet fans - with email" ;;
  }

  dimension: visitor__audience__duvet_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - duvet purchaser" ;;
  }

  dimension: visitor__audience__duvet_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - duvet purchaser - with email" ;;
  }

  dimension: visitor__audience__email_source__evite {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - evite" ;;
  }

  dimension: visitor__audience__email_source__find_keep_love {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - find keep love" ;;
  }

  dimension: visitor__audience__email_source__fluent {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - fluent" ;;
  }

  dimension: visitor__audience__email_source__mymove {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - mymove" ;;
  }

  dimension: visitor__audience__email_source__purchase {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - purchase" ;;
  }

  dimension: visitor__audience__email_source__purple_com {
    type: yesno
    sql: ${TABLE}."visitor - audience - email source - purple.com" ;;
  }

  dimension: visitor__audience__employee {
    type: yesno
    sql: ${TABLE}."visitor - audience - employee" ;;
  }

  dimension: visitor__audience__employee__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - employee - with email" ;;
  }

  dimension: visitor__audience__financing_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - financing fans" ;;
  }

  dimension: visitor__audience__financing_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - financing fans - with email" ;;
  }

  dimension: visitor__audience__first_responder_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - first responder purchaser" ;;
  }

  dimension: visitor__audience__first_responder_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - first responder purchaser - with email" ;;
  }

  dimension: visitor__audience__foundation_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - foundation fans" ;;
  }

  dimension: visitor__audience__foundation_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - foundation fans - with email" ;;
  }

  dimension: visitor__audience__foundation_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - foundation purchasers" ;;
  }

  dimension: visitor__audience__foundation_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - foundation purchasers - with email" ;;
  }

  dimension: visitor__audience__frequent_visitor {
    type: yesno
    sql: ${TABLE}."visitor - audience - frequent visitor" ;;
  }

  dimension: visitor__audience__frequent_visitor__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - frequent visitor - with email" ;;
  }

  dimension: visitor__audience__harmony_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - harmony purchasers" ;;
  }

  dimension: visitor__audience__harmony_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - harmony purchasers - with email" ;;
  }

  dimension: visitor__audience__has_cancelled_2_orders {
    type: yesno
    sql: ${TABLE}."visitor - audience - has cancelled 2+ orders" ;;
  }

  dimension: visitor__audience__has_cancelled_order {
    type: yesno
    sql: ${TABLE}."visitor - audience - has cancelled order" ;;
  }

  dimension: visitor__audience__has_email_address_for_connector_testing {
    type: yesno
    sql: ${TABLE}."visitor - audience - has email address (for connector testing)" ;;
  }

  dimension: visitor__audience__has_email_address_for_connector_testing__cordial {
    type: yesno
    sql: ${TABLE}."visitor - audience - has email address (for connector testing) - cordial" ;;
  }

  dimension: visitor__audience__has_financed {
    type: yesno
    sql: ${TABLE}."visitor - audience - has financed" ;;
  }

  dimension: visitor__audience__has_purchased {
    type: yesno
    sql: ${TABLE}."visitor - audience - has purchased" ;;
  }

  dimension: visitor__audience__has_purchased_1_harmony_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - has purchased 1 harmony pillow" ;;
  }

  dimension: visitor__audience__has_purchased__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - has purchased - with email" ;;
  }

  dimension: visitor__audience__has_returned_1_order {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned 1 order" ;;
  }

  dimension: visitor__audience__has_returned_2_orders {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned 2+ orders" ;;
  }

  dimension: visitor__audience__has_returned_base {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned base" ;;
  }

  dimension: visitor__audience__has_returned_bedding {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned bedding" ;;
  }

  dimension: visitor__audience__has_returned_mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned mattress" ;;
  }

  dimension: visitor__audience__has_returned_order {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned order" ;;
  }

  dimension: visitor__audience__has_returned_order_in_past_6_months {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned order in past 6 months" ;;
  }

  dimension: visitor__audience__has_returned_pet {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned pet" ;;
  }

  dimension: visitor__audience__has_returned_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned pillow" ;;
  }

  dimension: visitor__audience__has_returned_seating {
    type: yesno
    sql: ${TABLE}."visitor - audience - has returned seating" ;;
  }

  dimension: visitor__audience__heard_source__facebook {
    type: yesno
    sql: ${TABLE}."visitor - audience - heard source - facebook" ;;
  }

  dimension: visitor__audience__heard_source__instagram {
    type: yesno
    sql: ${TABLE}."visitor - audience - heard source - instagram" ;;
  }

  dimension: visitor__audience__heard_source__word_of_mouth {
    type: yesno
    sql: ${TABLE}."visitor - audience - heard source - word of mouth" ;;
  }

  dimension: visitor__audience__holdout_test__control {
    type: yesno
    sql: ${TABLE}."visitor - audience - holdout test - control" ;;
  }

  dimension: visitor__audience__holdout_test__test {
    type: yesno
    sql: ${TABLE}."visitor - audience - holdout test - test" ;;
  }

  dimension: visitor__audience__hybrid_premier_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid premier fans" ;;
  }

  dimension: visitor__audience__hybrid_premier_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid premier fans - with email" ;;
  }

  dimension: visitor__audience__hybrid_premier_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid premier purchaser" ;;
  }

  dimension: visitor__audience__hybrid_premier_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid premier purchaser - with email" ;;
  }

  dimension: visitor__audience__hybrid_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid purchaser" ;;
  }

  dimension: visitor__audience__hybrid_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - hybrid purchaser - with email" ;;
  }

  dimension: visitor__audience__kid_accessories_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - kid accessories purchaser" ;;
  }

  dimension: visitor__audience__kid_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - kid mattress purchaser" ;;
  }

  dimension: visitor__audience__kid_product_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - kid product purchaser" ;;
  }

  dimension: visitor__audience__last_clicked_email_tags__promotional {
    type: yesno
    sql: ${TABLE}."visitor - audience - last clicked email tags - promotional" ;;
  }

  dimension: visitor__audience__last_opened_email_tags__promotional {
    type: yesno
    sql: ${TABLE}."visitor - audience - last opened email tags - promotional" ;;
  }

  dimension: visitor__audience__last_order_contains__base {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - base" ;;
  }

  dimension: visitor__audience__last_order_contains__bedding {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - bedding" ;;
  }

  dimension: visitor__audience__last_order_contains__harmony {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - harmony" ;;
  }

  dimension: visitor__audience__last_order_contains__hybrid_2 {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - hybrid 2" ;;
  }

  dimension: visitor__audience__last_order_contains__hybrid_premier {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - hybrid premier" ;;
  }

  dimension: visitor__audience__last_order_contains__mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - mattress" ;;
  }

  dimension: visitor__audience__last_order_contains__pet {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - pet" ;;
  }

  dimension: visitor__audience__last_order_contains__pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - pillow" ;;
  }

  dimension: visitor__audience__last_order_contains__plush_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - plush pillow" ;;
  }

  dimension: visitor__audience__last_order_contains__purple_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - purple pillow" ;;
  }

  dimension: visitor__audience__last_order_contains__seating {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - seating" ;;
  }

  dimension: visitor__audience__last_order_contains__the_purple_mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - last order contains - the purple mattress" ;;
  }

  dimension: visitor__audience__last_sale_order_amount__0999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - last sale order amount - 0-999" ;;
  }

  dimension: visitor__audience__last_sale_order_amount__10001999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - last sale order amount - 1000-1999" ;;
  }

  dimension: visitor__audience__last_sale_order_amount__2000 {
    type: yesno
    sql: ${TABLE}."visitor - audience - last sale order amount - 2000+" ;;
  }

  dimension: visitor__audience__late_orders {
    type: yesno
    sql: ${TABLE}."visitor - audience - late orders" ;;
  }

  dimension: visitor__audience__lifetime_orders_12 {
    type: yesno
    sql: ${TABLE}."visitor - audience - lifetime orders 1-2" ;;
  }

  dimension: visitor__audience__lifetime_orders_3 {
    type: yesno
    sql: ${TABLE}."visitor - audience - lifetime orders 3+" ;;
  }

  dimension: visitor__audience__likelihood_of_purchasing_mattress_in_next_30_days_70 {
    type: yesno
    sql: ${TABLE}."visitor - audience - likelihood of purchasing mattress in next 30 days (70+)" ;;
  }

  dimension: visitor__audience__ltv_0999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - ltv 0-999" ;;
  }

  dimension: visitor__audience__ltv_10001999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - ltv 1000-1999" ;;
  }

  dimension: visitor__audience__ltv_2000 {
    type: yesno
    sql: ${TABLE}."visitor - audience - ltv 2000+" ;;
  }

  dimension: visitor__audience__made_purchase_that_doesnt_include_mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - made purchase that doesnt include mattress" ;;
  }

  dimension: visitor__audience__made_purchase_that_doesnt_include_mattress__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - made purchase that doesnt include mattress - with email" ;;
  }

  dimension: visitor__audience__mask_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - mask fans" ;;
  }

  dimension: visitor__audience__mask_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - mask fans - with email" ;;
  }

  dimension: visitor__audience__mattress_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress fans" ;;
  }

  dimension: visitor__audience__mattress_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress fans - with email" ;;
  }

  dimension: visitor__audience__mattress_ltv_0999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress ltv 0-999" ;;
  }

  dimension: visitor__audience__mattress_ltv_10001999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress ltv 1000-1999" ;;
  }

  dimension: visitor__audience__mattress_ltv_2000 {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress ltv 2000+" ;;
  }

  dimension: visitor__audience__mattress_only_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress only purchaser" ;;
  }

  dimension: visitor__audience__mattress_only_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress only purchaser - with email" ;;
  }

  dimension: visitor__audience__mattress_protector_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress protector purchasers" ;;
  }

  dimension: visitor__audience__mattress_protector_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress protector purchasers - with email" ;;
  }

  dimension: visitor__audience__mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress purchaser" ;;
  }

  dimension: visitor__audience__mattress_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - mattress purchaser - with email" ;;
  }

  dimension: visitor__audience__military_discount_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - military discount purchasers" ;;
  }

  dimension: visitor__audience__military_discount_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - military discount purchasers - with email" ;;
  }

  dimension: visitor__audience__neutral_shopping_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - neutral shopping experience" ;;
  }

  dimension: visitor__audience__neutral_with_delivery_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - neutral with delivery experience" ;;
  }

  dimension: visitor__audience__nps_detractor {
    type: yesno
    sql: ${TABLE}."visitor - audience - nps detractor" ;;
  }

  dimension: visitor__audience__nps_neutral {
    type: yesno
    sql: ${TABLE}."visitor - audience - nps neutral" ;;
  }

  dimension: visitor__audience__nps_promoter {
    type: yesno
    sql: ${TABLE}."visitor - audience - nps promoter" ;;
  }

  dimension: visitor__audience__opened_email_in_past_15_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 15 days" ;;
  }

  dimension: visitor__audience__opened_email_in_past_1_year {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 1 year" ;;
  }

  dimension: visitor__audience__opened_email_in_past_30_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 30 days" ;;
  }

  dimension: visitor__audience__opened_email_in_past_6_months {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 6 months" ;;
  }

  dimension: visitor__audience__opened_email_in_past_7_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 7 days" ;;
  }

  dimension: visitor__audience__opened_email_in_past_90_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - opened email in past 90 days" ;;
  }

  dimension: visitor__audience__paypal_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - paypal purchaser" ;;
  }

  dimension: visitor__audience__pet_bed_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - pet bed fans" ;;
  }

  dimension: visitor__audience__pet_bed_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - pet bed fans - with email" ;;
  }

  dimension: visitor__audience__pet_bed_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - pet bed purchaser" ;;
  }

  dimension: visitor__audience__pet_bed_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - pet bed purchaser - with email" ;;
  }

  dimension: visitor__audience__pillow_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow fans" ;;
  }

  dimension: visitor__audience__pillow_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow fans - with email" ;;
  }

  dimension: visitor__audience__pillow_ltv_0999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow ltv 0-999" ;;
  }

  dimension: visitor__audience__pillow_ltv_10001999 {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow ltv 1000-1999" ;;
  }

  dimension: visitor__audience__pillow_ltv_2000 {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow ltv 2000+" ;;
  }

  dimension: visitor__audience__pillow_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow purchasers" ;;
  }

  dimension: visitor__audience__pillow_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - pillow purchasers - with email" ;;
  }

  dimension: visitor__audience__placed_draft_order {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed draft order" ;;
  }

  dimension: visitor__audience__placed_order_in_past_15_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 15 days" ;;
  }

  dimension: visitor__audience__placed_order_in_past_1_year {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 1 year" ;;
  }

  dimension: visitor__audience__placed_order_in_past_30_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 30 days" ;;
  }

  dimension: visitor__audience__placed_order_in_past_6_months {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 6 months" ;;
  }

  dimension: visitor__audience__placed_order_in_past_7_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 7 days" ;;
  }

  dimension: visitor__audience__placed_order_in_past_90_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - placed order in past 90 days" ;;
  }

  dimension: visitor__audience__platform_bed_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - platform bed purchasers" ;;
  }

  dimension: visitor__audience__platform_bed_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - platform bed purchasers - with email" ;;
  }

  dimension: visitor__audience__platform_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - platform fans" ;;
  }

  dimension: visitor__audience__platform_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - platform fans - with email" ;;
  }

  dimension: visitor__audience__plush_pillow_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - plush pillow purchaser" ;;
  }

  dimension: visitor__audience__plush_pillow_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - plush pillow purchaser - with email" ;;
  }

  dimension: visitor__audience__powerbase_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - powerbase fans" ;;
  }

  dimension: visitor__audience__powerbase_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - powerbase fans - with email" ;;
  }

  dimension: visitor__audience__powerbase_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - powerbase purchasers" ;;
  }

  dimension: visitor__audience__powerbase_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - powerbase purchasers - with email" ;;
  }

  dimension: visitor__audience__protector_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - protector fans" ;;
  }

  dimension: visitor__audience__protector_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - protector fans - with email" ;;
  }

  dimension: visitor__audience__purple_hybrid_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - purple hybrid purchaser" ;;
  }

  dimension: visitor__audience__purple_hybrid_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - purple hybrid purchaser - with email" ;;
  }

  dimension: visitor__audience__purple_pillow_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - purple pillow purchasers" ;;
  }

  dimension: visitor__audience__purple_pillow_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - purple pillow purchasers - with email" ;;
  }

  dimension: visitor__audience__queen_or_king_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - queen or king mattress purchaser" ;;
  }

  dimension: visitor__audience__returned_harmony {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned harmony" ;;
  }

  dimension: visitor__audience__returned_hybrid_2 {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned hybrid 2" ;;
  }

  dimension: visitor__audience__returned_hybrid_premier {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned hybrid premier" ;;
  }

  dimension: visitor__audience__returned_order_in_past_15_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned order in past 15 days" ;;
  }

  dimension: visitor__audience__returned_order_in_past_1_year {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned order in past 1 year" ;;
  }

  dimension: visitor__audience__returned_order_in_past_30_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned order in past 30 days" ;;
  }

  dimension: visitor__audience__returned_order_in_past_7_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned order in past 7 days" ;;
  }

  dimension: visitor__audience__returned_order_in_past_90_days {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned order in past 90 days" ;;
  }

  dimension: visitor__audience__returned_purple_pillow {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned purple pillow" ;;
  }

  dimension: visitor__audience__returned_the_purple_mattress {
    type: yesno
    sql: ${TABLE}."visitor - audience - returned the purple mattress" ;;
  }

  dimension: visitor__audience__satisfied_shopping_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - satisfied shopping experience" ;;
  }

  dimension: visitor__audience__satisfied_with_delivery_experience {
    type: yesno
    sql: ${TABLE}."visitor - audience - satisfied with delivery experience" ;;
  }

  dimension: visitor__audience__seat_cushion_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - seat cushion fans" ;;
  }

  dimension: visitor__audience__seat_cushion_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - seat cushion fans - with email" ;;
  }

  dimension: visitor__audience__seating_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - seating purchasers" ;;
  }

  dimension: visitor__audience__seating_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - seating purchasers - with email" ;;
  }

  dimension: visitor__audience__sheets_fans {
    type: yesno
    sql: ${TABLE}."visitor - audience - sheets fans" ;;
  }

  dimension: visitor__audience__sheets_fans__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - sheets fans - with email" ;;
  }

  dimension: visitor__audience__sheets_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - sheets purchasers" ;;
  }

  dimension: visitor__audience__sheets_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - sheets purchasers - with email" ;;
  }

  dimension: visitor__audience__shopify_credit_cardpayments_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - shopify credit card/payments purchaser" ;;
  }

  dimension: visitor__audience__sleep_mask_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - sleep mask purchasers" ;;
  }

  dimension: visitor__audience__sleep_mask_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - sleep mask purchasers - with email" ;;
  }

  dimension: visitor__audience__splitit_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - splitit purchaser" ;;
  }

  dimension: visitor__audience__the_purple_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - audience - the purple mattress purchaser" ;;
  }

  dimension: visitor__audience__the_purple_mattress_purchaser__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - the purple mattress purchaser - with email" ;;
  }

  dimension: visitor__audience__used_discount {
    type: yesno
    sql: ${TABLE}."visitor - audience - used discount" ;;
  }

  dimension: visitor__audience__used_discount_on_last_order {
    type: yesno
    sql: ${TABLE}."visitor - audience - used discount on last order" ;;
  }

  dimension: visitor__audience__vip {
    type: yesno
    sql: ${TABLE}."visitor - audience - vip" ;;
  }

  dimension: visitor__audience__visited_cushion_but_did_not_purchase {
    type: yesno
    sql: ${TABLE}."visitor - audience - visited cushion but did not purchase" ;;
  }

  dimension: visitor__audience__visited_pillow_but_did_not_purchase {
    type: yesno
    sql: ${TABLE}."visitor - audience - visited pillow but did not purchase" ;;
  }

  dimension: visitor__audience__weighted_blanket_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - audience - weighted blanket purchasers" ;;
  }

  dimension: visitor__audience__weighted_blanket_purchasers__with_email {
    type: yesno
    sql: ${TABLE}."visitor - audience - weighted blanket purchasers - with email" ;;
  }

  dimension: visitor__badge__blanket_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - blanket fans" ;;
  }

  dimension: visitor__badge__cart_abandoner {
    type: yesno
    sql: ${TABLE}."visitor - badge - cart abandoner" ;;
  }

  dimension: visitor__badge__duvet_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - duvet fans" ;;
  }

  dimension: visitor__badge__fan {
    type: yesno
    sql: ${TABLE}."visitor - badge - fan" ;;
  }

  dimension: visitor__badge__financing_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - financing fans" ;;
  }

  dimension: visitor__badge__foundation_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - foundation fans" ;;
  }

  dimension: visitor__badge__frequent_visitor {
    type: yesno
    sql: ${TABLE}."visitor - badge - frequent visitor" ;;
  }

  dimension: visitor__badge__has_purchased_online {
    type: yesno
    sql: ${TABLE}."visitor - badge - has purchased online" ;;
  }

  dimension: visitor__badge__has_purchased_online_1_time {
    type: yesno
    sql: ${TABLE}."visitor - badge - has purchased online (1 time)" ;;
  }

  dimension: visitor__badge__has_purchased_online_2_or_more_times {
    type: yesno
    sql: ${TABLE}."visitor - badge - has purchased online (2 or more times)" ;;
  }

  dimension: visitor__badge__initiate_checkout_abandoner {
    type: yesno
    sql: ${TABLE}."visitor - badge - initiate checkout abandoner" ;;
  }

  dimension: visitor__badge__kids_accesories_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - badge - kids accesories purchaser" ;;
  }

  dimension: visitor__badge__kids_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - badge - kids mattress purchaser" ;;
  }

  dimension: visitor__badge__mask_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - mask fans" ;;
  }

  dimension: visitor__badge__mattress_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - mattress fans" ;;
  }

  dimension: visitor__badge__mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - badge - mattress purchaser" ;;
  }

  dimension: visitor__badge__pet_bed_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - pet bed fans" ;;
  }

  dimension: visitor__badge__pillow_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - pillow fans" ;;
  }

  dimension: visitor__badge__placed_order_in_past_15_days {
    type: yesno
    sql: ${TABLE}."visitor - badge - placed order in past 15 days" ;;
  }

  dimension: visitor__badge__placed_order_in_past_7_days {
    type: yesno
    sql: ${TABLE}."visitor - badge - placed order in past 7 days" ;;
  }

  dimension: visitor__badge__platform_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - platform fans" ;;
  }

  dimension: visitor__badge__powerbase_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - powerbase fans" ;;
  }

  dimension: visitor__badge__protector_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - protector fans" ;;
  }

  dimension: visitor__badge__purchased_queen_or_king_mattress {
    type: yesno
    sql: ${TABLE}."visitor - badge - purchased queen or king mattress" ;;
  }

  dimension: visitor__badge__seat_cushion_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - seat cushion fans" ;;
  }

  dimension: visitor__badge__seating_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - badge - seating purchaser" ;;
  }

  dimension: visitor__badge__sheets_fans {
    type: yesno
    sql: ${TABLE}."visitor - badge - sheets fans" ;;
  }

  dimension: visitor__badge__unbadged {
    type: yesno
    sql: ${TABLE}."visitor - badge - unbadged" ;;
  }

  dimension: visitor__badge__vip {
    type: yesno
    sql: ${TABLE}."visitor - badge - vip" ;;
  }

  dimension_group: visitor__created {
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
    sql: ${TABLE}."visitor - created" ;;
  }

  dimension_group: visitor__date__first_visit {
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
    sql: ${TABLE}."visitor - date - first visit" ;;
  }

  dimension_group: visitor__date__last_visit {
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
    sql: ${TABLE}."visitor - date - last visit" ;;
  }

  dimension_group: visitor__date__order_date__most_recent {
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
    sql: ${TABLE}."visitor - date - order date - most recent" ;;
  }

  dimension_group: visitor__expire {
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
    sql: ${TABLE}."visitor - expire at" ;;
  }

  dimension: visitor__flag__first_responder_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - first responder purchaser" ;;
  }

  dimension: visitor__flag__foundation_purchasers {
    type: yesno
    sql: ${TABLE}."visitor - flag - foundation purchasers" ;;
  }

  dimension: visitor__flag__has_purchased_with_affirm {
    type: yesno
    sql: ${TABLE}."visitor - flag - has purchased with affirm" ;;
  }

  dimension: visitor__flag__hybrid_premier_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - hybrid premier purchaser" ;;
  }

  dimension: visitor__flag__hybrid_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - hybrid purchaser" ;;
  }

  dimension: visitor__flag__mattress_only_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - mattress only purchaser" ;;
  }

  dimension: visitor__flag__mattress_protector_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - mattress protector purchaser" ;;
  }

  dimension: visitor__flag__military_discount_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - military discount purchaser" ;;
  }

  dimension: visitor__flag__pet_bed_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - pet bed purchaser" ;;
  }

  dimension: visitor__flag__platform_bed_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - platform bed purchaser" ;;
  }

  dimension: visitor__flag__powerbase_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - powerbase purchaser" ;;
  }

  dimension: visitor__flag__purple_hybrid_mattress_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - purple hybrid mattress purchaser" ;;
  }

  dimension: visitor__flag__purple_hybrid_premier_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - purple hybrid premier purchaser" ;;
  }

  dimension: visitor__flag__purple_pillow_purchaser {
    type: yesno
    sql: ${TABLE}."visitor - flag - purple pillow purchaser" ;;
  }

  dimension: visitor__flag__returning_visitor {
    type: yesno
    sql: ${TABLE}."visitor - flag - returning visitor" ;;
  }

  dimension: visitor__metric__average_visit_duration_in_minutes {
    type: number
    sql: ${TABLE}."visitor - metric - average visit duration in minutes" ;;
  }

  dimension: visitor__metric__average_visits_per_week {
    type: number
    sql: ${TABLE}."visitor - metric - average visits per week" ;;
  }

  dimension: visitor__metric__lifetime_event_count {
    type: number
    sql: ${TABLE}."visitor - metric - lifetime event count" ;;
  }

  dimension: visitor__metric__lifetime_visit_count {
    type: number
    sql: ${TABLE}."visitor - metric - lifetime visit count" ;;
  }

  dimension: visitor__metric__order_total__most_recent {
    type: number
    sql: ${TABLE}."visitor - metric - order total - most recent" ;;
  }

  dimension: visitor__metric__total_direct_visits {
    type: number
    sql: ${TABLE}."visitor - metric - total direct visits" ;;
  }

  dimension: visitor__metric__total_referred_visits {
    type: number
    sql: ${TABLE}."visitor - metric - total referred visits" ;;
  }

  dimension: visitor__metric__total_time_spent_on_site_in_minutes {
    type: number
    sql: ${TABLE}."visitor - metric - total time spent on site in minutes" ;;
  }

  dimension: visitor__metric__weeks_since_first_visit {
    type: number
    sql: ${TABLE}."visitor - metric - weeks since first visit" ;;
  }

  dimension: visitor__property__acquisition_test_1_segment {
    type: string
    sql: ${TABLE}."visitor - property - acquisition test 1 segment" ;;
  }

  dimension: visitor__property__cagetory_name_tally_favorite {
    type: string
    sql: ${TABLE}."visitor - property - cagetory name tally (favorite)" ;;
  }

  dimension: visitor__property__cordial_id_cid__string {
    type: string
    sql: ${TABLE}."visitor - property - cordial id (cid) - string" ;;
  }

  dimension: visitor__property__customer_email_string {
    type: string
    sql: ${TABLE}."visitor - property - customer email (string)" ;;
  }

  dimension: visitor__property__holdout_test {
    type: string
    sql: ${TABLE}."visitor - property - holdout test" ;;
  }

  dimension: visitor__property__last_event_url {
    type: string
    sql: ${TABLE}."visitor - property - last event url" ;;
  }

  dimension: visitor__property__lifetime_browser_types_used_favorite {
    type: string
    sql: ${TABLE}."visitor - property - lifetime browser types used (favorite)" ;;
  }

  dimension: visitor__property__lifetime_browser_versions_used_favorite {
    type: string
    sql: ${TABLE}."visitor - property - lifetime browser versions used (favorite)" ;;
  }

  dimension: visitor__property__lifetime_devices_used_favorite {
    type: string
    sql: ${TABLE}."visitor - property - lifetime devices used (favorite)" ;;
  }

  dimension: visitor__property__lifetime_operating_systems_used_favorite {
    type: string
    sql: ${TABLE}."visitor - property - lifetime operating systems used (favorite)" ;;
  }

  dimension: visitor__property__lifetime_platforms_used_favorite {
    type: string
    sql: ${TABLE}."visitor - property - lifetime platforms used (favorite)" ;;
  }

  dimension: visitor__property__order_number__most_recent {
    type: string
    sql: ${TABLE}."visitor - property - order number - most recent" ;;
  }

  dimension: visitor__secondary_id__cordial_id {
    type: string
    sql: ${TABLE}."visitor - secondary id - cordial id" ;;
  }

  dimension: visitor__secondary_id__customer_email_id {
    type: string
    sql: ${TABLE}."visitor - secondary id - customer email (id)" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
