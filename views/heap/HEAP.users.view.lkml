#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: users {
  derived_table: {
    sql: select * from heap.users;;
    datagroup_trigger: pdt_refresh_745am
  }
  #sql_table_name: heap.users ;;

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

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
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

  dimension: customer_group {
    type: string
    sql: ${TABLE}.customer_group ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

 dimension: customer_total_spent {
    type: string
    sql: ${TABLE}.customer_total_spent ;;
  }

  dimension: days_to_close {
    type: string
    sql: ${TABLE}.days_to_close ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
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

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: handle {
    type: string
    sql: ${TABLE}.handle ;;
  }

  dimension: hs_lead_status {
    type: string
    sql: ${TABLE}.hs_lead_status ;;
  }

  dimension: hubspotscore {
    type: string
    sql: ${TABLE}.hubspotscore ;;
  }

  dimension: initial_browser_type {
    type: string
    sql: ${TABLE}.initial_browser_type ;;
  }

  dimension: initial_marketing_channel {
    type: string
    sql: ${TABLE}.initial_marketing_channel ;;
  }

  dimension: initial_marketing_channel_default_ {
    type: string
    sql: ${TABLE}.initial_marketing_channel_default_ ;;
  }

  dimension_group: joindate {
    type: time
    timeframes: [ raw, time, date, week, month, quarter, year ]
    sql: ${TABLE}.joindate ;;
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
    timeframes: [ raw, time, date, week, month, quarter, year ]
    sql: ${TABLE}.last_modified ;;
  }

  dimension: last_order_date {
    type: string
    sql: ${TABLE}.last_order_date ;;
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

  dimension: last_skus_bought {
    type: string
    sql: ${TABLE}.last_skus_bought ;;
  }

  dimension: last_store {
    type: string
    sql: ${TABLE}.last_store ;;
  }

  dimension: last_total_number_of_products_bought {
    type: string
    sql: ${TABLE}.last_total_number_of_products_bought ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: mattress_size_desired {
    type: string
    sql: ${TABLE}.mattress_size_desired ;;
  }

  dimension: mobilephone {
    type: string
    sql: ${TABLE}.mobilephone ;;
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

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
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

  dimension: skus_bought {
    type: string
    sql: ${TABLE}.skus_bought ;;
  }

  dimension: skus_bought_text {
    type: string
    sql: ${TABLE}.skus_bought_text ;;
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

  dimension: wedding_date {
    type: string
    sql: ${TABLE}.wedding_date ;;
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
  }

}
