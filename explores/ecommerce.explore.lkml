#-------------------------------------------------------------------
#
# eCommerce Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: ecommerce {
    from: sessions
    group_label: "Marketing"
    label: "eCommerce"
    view_label: "Sessions"
    description: "Combined Website and Sales Data - Has Shopify US, doesn't have Amazon, Draft orders, others not related to a website visit"
    hidden: yes
    join: session_facts {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ecommerce.session_id} = ${session_facts.session_id} ;;
      relationship: one_to_one
    }
    join: zip_codes_city {
      type: left_outer
      sql_on: ${ecommerce.city} = ${zip_codes_city.city} and ${ecommerce.region} = ${zip_codes_city.state_name} ;;
      relationship: one_to_one
    }
    join: dma {
      type:  left_outer
      sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
      relationship: one_to_one
    }
    join: heap_page_views {
      type: left_outer
      sql_on: ${heap_page_views.session_id} = ${ecommerce.session_id} ;;
      relationship: one_to_many
    }
    join: users {
      type: left_outer
      sql_on: ${ecommerce.user_id}::string = ${users.user_id}::string ;;
      relationship: many_to_one
    }
    join: heap_all_events_subset {
      type: left_outer
      sql_on: ${ecommerce.user_id}::string = ${heap_all_events_subset.user_id}::string ;;
      relationship: many_to_one
    }
    join: ecommerce1 {
      type: left_outer
      sql_on: ${ecommerce.session_id} = ${ecommerce1.session_id} ;;
      relationship: many_to_one
    }
    join: sales_order {
      view_label: "Sales Order"
      type:  full_outer
      sql_on: ${ecommerce1.order_number} = ${sales_order.related_tranid} and ${sales_order.channel_id} = 1 ;;
      fields: [sales_order.tranid,sales_order.system,sales_order.related_tranid,sales_order.source,sales_order.payment_method,sales_order.order_id,sales_order.warranty_order_flg,sales_order.is_upgrade,sales_order.Amazon_fulfillment,sales_order.gross_amt,sales_order.dtc_channel_sub_category,sales_order.total_orders,sales_order.payment_method_flag,sales_order.channel2,sales_order.channel_source,sales_order.Order_size_buckets,sales_order.max_order_size,sales_order.min_order_size,sales_order.average_order_size,sales_order.tax_amt_total, sales_order.order_type_hyperlink,sales_order.etail_order_id]
      relationship: one_to_one
    }
    join: order_flag {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
      relationship:  one_to_one
    }
    join: sales_order_line_base {
      view_label: "Sales Order Line"
      type:  left_outer
      sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} ;;
      relationship: one_to_many
    }
    join: sales_order_line {
      view_label: "Sales Order Line"
      type: left_outer
      sql_on: ${sales_order_line.order_id} = ${sales_order_line_base.order_id} and ${sales_order_line.item_id} = ${sales_order_line_base.item_id} ;;
      relationship: one_to_one
      fields: [mattress_sales]
    }
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${sales_order_line_base.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }
    join: daily_qualified_site_traffic_goals {
      view_label: "Sessions"
      type: full_outer
      sql_on: ${daily_qualified_site_traffic_goals.date}::date = ${ecommerce.time_date}::date ;;
      relationship: many_to_one
    }
    join: customer_table {
      view_label: "Customer"
      type: left_outer
      sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
      fields: [customer_table.customer_id,customer_table.customer_id,customer_table.email,customer_table.full_name,customer_table.shipping_hold,customer_table.phone,customer_table.hold_reason_id,customer_table.shipping_hold,customer_table.email_signup_test]
      relationship: many_to_one
    }
    join: first_purchase_date {
      view_label: "Customer"
      type: left_outer
      sql_on: ${first_purchase_date.email} = ${sales_order.email} ;;
      relationship: one_to_one
    }
    join: shopify_discount_codes {
      view_label: "Promo"
      type: left_outer
      sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
      relationship: many_to_many
    }
    join: veritone_pixel_matchback {
      view_label: "Veritone"
      type: left_outer
      sql_on:  ${veritone_pixel_matchback.order_id} = ${sales_order.related_tranid} ;;
      relationship: many_to_one
    }
    join: hour_assumptions {
      view_label: "Hour Assumptions"
      type: left_outer
      sql_on: ${ecommerce.time_hour_of_day} = ${hour_assumptions.hour};;
      relationship: many_to_one
    }
    join: first_order_flag {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${first_order_flag.pk} = ${sales_order.order_system} ;;
      relationship: one_to_one
    }
    join: standard_cost {
      view_label: "Product"
      type: left_outer
      sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
      relationship: one_to_one
    }
    join: heap_banner_click {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ecommerce.session_id} = ${heap_banner_click.session_id} ;;
      relationship: many_to_many
    }

    join: campaign_name_lookup {
      type: left_outer
      sql_on: ${campaign_name_lookup.campaign_id}::string = ${ecommerce.utm_campaign_raw}::string;;
      relationship: many_to_one
    }
    join: heap_banner_view {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ecommerce.session_id} = ${heap_banner_view.session_id} ;;
      relationship: many_to_many
    }
    join: core_events_click_any_element {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ecommerce.session_id} = ${core_events_click_any_element.session_id} ;;
      relationship: many_to_many
    }
    join: ct_session {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ct_session.session_id}=${ecommerce.session_id} and ${ct_session.user_id}=${ecommerce.user_id} ;;
      relationship: one_to_one
    }
    join: zendesk_sell {
      view_label: "Zendesk"
      type: full_outer
      sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
      relationship: one_to_one
    }
    join: aov_driver {
      view_label: "Sessions"
      type: left_outer
      sql_on:  ${aov_driver.session_id}=${ecommerce.session_id} and ${aov_driver.user_id}=${ecommerce.user_id} ;;
      relationship: one_to_one
    }
  }

  # explore: ecommerce_canada {
  #   from: heap_ca_sessions
  #   group_label: "Marketing"
  #   label: "eCommerce Canada"
  #   view_label: "Sessions"
  #   description: "Combined Website and Sales Data for Canada (Sleep Country)"
  #   hidden: yes
  #   join: heap_ca_page_views {
  #     type: left_outer
  #     sql_on: ${heap_ca_page_views.session_id} = ${ecommerce_canada.session_id} ;;
  #     relationship: one_to_many
  #   }
  #   join: heap_ca_purchase {
  #     view_label: "Purchase"
  #     type: left_outer
  #     sql_on: ${heap_ca_purchase.session_id} = ${ecommerce_canada.session_id} ;;
  #     relationship: one_to_many
  #   }


  # }

  #Created for Mason on 2020-11-18
  explore: heap_checkout_abandonment {hidden:yes group_label: "Marketing" description:"Check abandonment details"}

  # explore: heap_page_views_holiday {
  #   hidden: yes
  #   group_label: "Marketing"
  #   description:"This data updates every two hours during holiday periods"
  #   join: holiday_sessions {
  #     type: left_outer
  #     sql_on: ${holiday_sessions.session_id} = ${heap_page_views_holiday.session_id} ;;
  #     relationship: many_to_one
  #   }
  # }

#  explore:v_site_feedback{hidden: yes}
#  explore: v_session_hour_projection {hidden:yes}

#   explore: ecommerce_qualtrics {
#     hidden: yes
#     extends: [ecommerce]
#     label:  "eCommerce Qualtrics"
#     group_label: "Marketing"
#     view_label: "Sessions"
#     description:  "All sales orders for wholesale channel"
#     join: qualtrics_response {
#       type: inner
#       sql_on: upper(${sales_order.email}) = upper(${qualtrics_response.recipient_email}) ;;
#       relationship: many_to_many
#       view_label: "Qualtrics Response"
#     }
#     join: qualtrics_survey {
#       type: inner
#       sql_on: ${qualtrics_response.survey_id} = ${qualtrics_survey.id};;
#       relationship: one_to_many
#       view_label: "Qualtrics Survey"
#     }
#     join: qualtrics_customer {
#       type: inner
#       sql_on: ${qualtrics_response.recipient_email} = ${qualtrics_customer.email} ;;
#       relationship: many_to_one
#       view_label: "Qualtrics Customer"
#     }
#     join: qualtrics_answer {
#       type: inner
#       sql_on: ${qualtrics_survey.id} = ${qualtrics_answer.survey_id} AND ${qualtrics_answer.response_id} = ${qualtrics_response.response_id} ;;
#       relationship: one_to_many
#       view_label: "Qualtrics Answer"
#     }
#   }
