#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: users {
  derived_table: {
    sql: select * from analytics.heap.v_ecommerce_users;;
    datagroup_trigger: pdt_refresh_6am
  }
  #sql_table_name: heap.users ;;

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: _email {
    group_label: "User Info"
    label: "Email"
    description: "Source: HEAP.users"
    type: string
    #sql: upper(coalesce(${TABLE}._email,${TABLE}.email)) ;;
    sql: upper(${TABLE}.email) ;;
  }

#   dimension: address {
#     group_label: "Geo"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.address ;;
#   }

#   dimension: billing_address_line_1 {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_address_line_1 ;;
#   }

#   dimension: billing_address_line_2 {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_address_line_2 ;;
#   }

#   dimension: billing_address_province {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_address_province ;;
#   }

#   dimension: billing_city {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_city ;;
#   }

#   dimension: billing_country {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_country ;;
#   }

#   dimension: billing_phone {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_phone ;;
#   }

#   dimension: billing_postal_code {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_postal_code ;;
#   }

#   dimension: billing_state {
#     group_label: "Billing Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.billing_state ;;
#   }

#   dimension: city {
#     group_label: "Geo"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.city ;;
#   }

#   dimension: closedate {
#     group_label: "User Orders"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.closedate ;;
#   }

#   dimension: company {
#     group_label: "User Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.company ;;
#   }

#   dimension: country {
#     group_label: "Geo"
#     description: "Source: HEAP.users"
#     type: string
#     map_layer_name: countries
#     sql: ${TABLE}.country ;;
#   }

#   dimension: country_dropdown {
#     group_label: "Geo"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.country_dropdown ;;
#   }

#     dimension: coupon_codes_used {
#       group_label: "User Orders"
#       description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.coupon_codes_used ;;
#   }

#   dimension: coupon_codes_used_text {
#     group_label: "User Orders"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.coupon_codes_used_text ;;
#   }

#   dimension: createdate {
#     group_label: "User Orders"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.createdate ;;
#   }

#   dimension: customer_group {
#     group_label: "User Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.customer_group ;;
#   }

#   dimension: customer_id {
#     group_label: "User Info"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.customer_id ;;
#   }

# dimension: customer_total_spent {
#     group_label: "User Orders"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.customer_total_spent ;;
#   }

#   dimension: days_to_close {
#     group_label: "User Orders"
#     description: "Source: HEAP.users"
#     type: string
#     sql: ${TABLE}.days_to_close ;;
#   }

  dimension: email {
    hidden:yes
    group_label: "User Info"
    description: "Source: HEAP.users"
    type: string
    sql: ${TABLE}.email ;;
  }

  # dimension: first_order_date {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   sql: ${TABLE}.first_order_date ;;
  # }

  # dimension: first_order_value {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.first_order_value ;;
  # }

  # dimension: firstname {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.firstname ;;
  # }

  # dimension: full_name {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.full_name ;;
  # }

  # dimension: handle {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.handle ;;
  # }

  # dimension: hs_lead_status {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.hs_lead_status ;;
  # }

  # dimension: hubspotscore {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.hubspotscore ;;
  # }

  # dimension: initial_browser_type {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.initial_browser_type ;;
  # }

  # dimension: initial_marketing_channel {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.initial_marketing_channel ;;
  # }

  # dimension: initial_marketing_channel_default_ {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.initial_marketing_channel_default_ ;;
  # }

  dimension_group: joindate {
    description: "Source: HEAP.users"
    type: time
    timeframes: [ raw, time, date, week, month, quarter, year ]
    sql: ${TABLE}.joindate ;;
  }

  # dimension: last_coupon_code_used {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_coupon_code_used ;;
  # }

  # dimension: last_disposition {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_disposition ;;
  # }

  # dimension_group: last_modified {
  #   description: "Source: HEAP.users"
  #   type: time
  #   timeframes: [ raw, time, date, week, month, quarter, year ]
  #   sql: ${TABLE}.last_modified ;;
  # }

  # dimension: last_order_date {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_date ;;
  # }

  # dimension: last_order_shopify_order_source {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_shopify_order_source ;;
  # }

  # dimension: last_order_status {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_status ;;
  # }

  # dimension: last_order_tracking_number {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_tracking_number ;;
  # }

  # dimension: last_order_tracking_url {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_tracking_url ;;
  # }

  # dimension: last_order_value {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_order_value ;;
  # }

  # dimension: last_product_bought {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_product_bought ;;
  # }

  # dimension: last_skus_bought {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_skus_bought ;;
  # }

  # dimension: last_store {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_store ;;
  # }

  # dimension: last_total_number_of_products_bought {
  #   group_label: "Last Order"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.last_total_number_of_products_bought ;;
  # }

  # dimension: lastname {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.lastname ;;
  # }

  # dimension: mattress_size_desired {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.mattress_size_desired ;;
  # }

  # dimension: mobilephone {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.mobilephone ;;
  # }

  # dimension: order_token {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.order_token ;;
  # }

  # dimension: orders_count {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.orders_count ;;
  # }

  # dimension: out_of_stock_product_name {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.out_of_stock_product_name ;;
  # }

  # dimension: phone {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.phone ;;
  # }

  # dimension: shipping_address_line_1 {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_address_line_1 ;;
  # }

  # dimension: shipping_address_line_2 {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_address_line_2 ;;
  # }

  # dimension: shipping_city {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_city ;;
  # }

  # dimension: shipping_country {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_country ;;
  # }

  # dimension: shipping_method {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_method ;;
  # }

  # dimension: shipping_phone {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_phone ;;
  # }

  # dimension: shipping_postal_code {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_postal_code ;;
  # }

  # dimension: shipping_state {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.shipping_state ;;
  # }

  # dimension: skus_bought {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.skus_bought ;;
  # }

  # dimension: skus_bought_text {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.skus_bought_text ;;
  # }

  # dimension: state {
  #   group_label: "Geo"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.state ;;
  # }

  # dimension: state_list {
  #   group_label: "Geo"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.state_list ;;
  # }

  # dimension: street_address_2 {
  #   group_label: "Geo"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.street_address_2 ;;
  # }

  # dimension: tags {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.tags ;;
  # }

  # dimension: talkable_campaign_name {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.talkable_campaign_name ;;
  # }

  # dimension: total_number_of_cart_products {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_number_of_cart_products ;;
  # }

  # dimension: total_number_of_current_orders {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_number_of_current_orders ;;
  # }

  # dimension: total_number_of_orders {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_number_of_orders ;;
  # }

  # dimension: total_spent {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_spent ;;
  # }

  # dimension: total_value_of_abandoned_cart {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_value_of_abandoned_cart ;;
  # }

  # dimension: total_value_of_orders {
  #   group_label: "User Orders"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.total_value_of_orders ;;
  # }

  # dimension: wedding_date {
  #   group_label: "User Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.wedding_date ;;
  # }

  # dimension: xpo_tracking_number {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.xpo_tracking_number ;;
  # }

  # dimension: xpo_tracking_url {
  #   group_label: "Shipping Info"
  #   description: "Source: HEAP.users"
  #   type: string
  #   sql: ${TABLE}.xpo_tracking_url ;;
  # }

  # dimension: zip {
  #   group_label: "Geo"
  #   description: "Source: HEAP.users"
  #   type: zipcode
  #   map_layer_name: us_zipcode_tabulation_areas
  #   sql: ${TABLE}.zip ;;
  # }

  measure: count {
    label: "Count of Users"
    description: "Source: HEAP.users"
    type: count
  }

}
