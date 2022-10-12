#-------------------------------------------------------------------
#
# Marketing Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

# explore: daily_adspend {
#   from:  daily_adspend
#   group_label: "Marketing"
#   description: "Adspend by platform aggregated by date"
#   hidden: yes
#   join: adspend_target {
#     type: full_outer
#     sql_on: ${adspend_target.target_date} = ${daily_adspend.ad_date}
#     and ${adspend_target.medium} = ${daily_adspend.medium}
#     and ${adspend_target.country} = ${daily_adspend.country};;
#     relationship: many_to_one}
# }

# explore: attribution_temp {
#   from: v_attribution_temp
#   hidden: yes
# }

# explore: c3 {
#   from: c3_conversion
#   group_label: "Marketing"
#   hidden: yes
#   label: "Attribution (C3)"
#   view_label: "C3 Data"
#   description: "Each touch point from marketing leading up to an order"

#   join: c3_conversion_count {
#     view_label: "C3 Data"
#     type: left_outer
#     sql_on: ${c3.order_id} = ${c3_conversion_count.order_id} ;;
#     relationship: one_to_many
#   }
# }

# explore: hotjar_data {
#   group_label: "Marketing"
#   hidden: no
#   label: "Post-purchase survey results"
#   description: "Results form Hotjar post-purchase survey"
#   view_label: "Survey Data"
#   join: hotjar_whenheard {
#     view_label: "Survey Data"
#     type:  left_outer
#     sql_on: ${hotjar_data.token} = ${hotjar_whenheard.token} ;;
#     relationship: many_to_one}
#   join: shopify_orders {
#     type: inner
#     sql_on: ${hotjar_data.token} = ${shopify_orders.checkout_token} ;;
#     relationship: many_to_one
#     fields: [shopify_orders.call_in_order_Flag, shopify_orders.created_date, shopify_orders.gross_sales]}
#   join: sales_order {
#     type:  left_outer
#     sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
#     relationship: one_to_one
#     fields: [-unique_customers,sales_order.is_exchange,sales_order.is_upgrade,sales_order.payment_method_flag,sales_order.warranty_order_flg, sales_order.order_id, sales_order.order_type_hyperlink, sales_order.average_order_size, sales_order.Order_size_buckets, sales_order.created_date, sales_order.gross_amt]}
#   join: order_flag {
#     view_label: "Sales Order"
#     type: left_outer
#     sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
#     relationship:  one_to_one}
#   join: first_order_flag {
#     view_label: "Sales Order"
#     type: left_outer
#     sql_on: ${sales_order.order_id}||'-'||${sales_order.system} = ${first_order_flag.pk} ;;
#     relationship:  one_to_one}
#   join: sales_order_line {
#     type:  left_outer
#     sql_on: ${sales_order.order_id}= ${sales_order_line.order_id} ;;
#     relationship: one_to_many
#     fields: []}
#   join: sf_zipcode_facts {
#     view_label: "Customer"
#     type:  left_outer
#     sql_on: ${sales_order_line.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
#     relationship: many_to_one
#     fields: []}
#   join: zcta5 {
#     view_label: "Geography"
#     type:  left_outer
#     sql_on: ${sales_order_line.zip_1}::varchar = (${zcta5.zipcode})::varchar AND ${sales_order_line.state} = ${zcta5.state};;
#     relationship: many_to_one
#     fields: [zcta5.fulfillment_region_1,zcta5.state_1]}
#   join: dma {
#     view_label: "Customer"
#     type:  left_outer
#     sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
#     relationship: many_to_many
#     fields: [dma.dma_name]}
#   join: shopify_discount_codes {
#     view_label: "Sales Order"
#     type: left_outer
#     sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
#     relationship: many_to_many}
# }

# explore: cordial_activity {
#   hidden: yes
#   group_label: "Marketing"
#   label: "Email (cordial)"
#   join:cordial_id  {
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${cordial_id.email_join} = lower(${cordial_activity.email}) ;;
#   }
#   join: cordial_subscribe {
#     type: left_outer
#     relationship: one_to_many
#     sql_on: ${cordial_id.email_join} = lower(${cordial_subscribe.email}) ;;
#   }
#   join: cordial_message_analytic {
#     type: left_outer
#     sql_on: ${cordial_activity.bm_id} = ${cordial_message_analytic.message_id} ;;
#     relationship: many_to_one
#   }
#   join: cordial_analytic_sms {
#     type: left_outer
#     sql_on: ${cordial_activity.bm_id} = ${cordial_analytic_sms.message_id} ;;
#     relationship: many_to_one
#   }
#   join: cordial_bulk_message {
#     type: left_outer
#     sql_on: ${cordial_activity.bm_id} = ${cordial_bulk_message.bm_id} ;;
#     relationship: many_to_one
#   }
#   join: order_utm {
#     type: left_outer
#     sql_on: lower(${cordial_activity.email}) = lower(${order_utm.email})
#       and ${cordial_activity.time_time} < ${order_utm.created} and ${cordial_activity.time_time} >= dateadd('day',-7,${order_utm.created})
#       and ${cordial_activity.action} in ('message-sent','open');;
#     relationship: many_to_one
#   }
#   # Added 12/10/2020 to get new/repeat customers - Mason
#   join: first_order_flag {
#     type: left_outer
#     sql_on: ${order_utm.pk} = ${first_order_flag.pk} ;;
#     relationship: many_to_one
#   }
# # Added 12/30/2020 to get orders and items - Mason
# # 07/08/2021 - Exposed full sales_order_line to explore
#   join: sales_order_line {
#     type: left_outer
#     sql_on: ${order_utm.order_id} = ${sales_order_line.order_id} ;;
#     # fields: [sales_order_line.order_id,sales_order_line.item_id]
#     fields: []
#     relationship: one_to_one
#   }
#   # Added 12/30/2020 to get products - Mason
#   join: item {
#     type: left_outer
#     view_label: "Product"
#     sql_on: ${item.item_id} = ${sales_order_line.item_id} ;;
#     relationship: many_to_one
#   }
#   join: v_email_nps  {
#     type: left_outer
#     view_label: "NPS"
#     sql_on: lower(${cordial_activity.email}) = lower(${v_email_nps.email}) ;;
#     relationship: many_to_one
#   }
#   join: cordial_propensity_scores {
#     type: left_outer
#     view_label: "Cordial Propensity Scores"
#     sql_on: lower(${cordial_activity.email}) = lower(${cordial_propensity_scores.email});;
#     relationship: many_to_one
#   }
# }

# explore: email_contact_merged { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
#   hidden: yes
#   join: sales_order {
#     type: left_outer
#     sql_on: lower(${sales_order.email}) = lower(${email_contact_merged.email_join});;
#     relationship: one_to_many
#   }
#   join: sales_order_line_base {
#     type: left_outer
#     sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id} and ${sales_order_line_base.system} = ${sales_order.system};;
#     relationship: one_to_many
#   }
#   join: item {
#     type: left_outer
#     sql_on:  ${item.item_id} = ${sales_order_line_base.item_id} ;;
#     relationship: many_to_one
#   }
#   join: order_flag {
#     type: left_outer
#     sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
#     relationship: one_to_one
#   }
#   join: first_order_flag {
#     type: left_outer
#     sql_on: LOWER(${email_contact_merged.email_join}) =  LOWER(${first_order_flag.email});;
#     relationship: one_to_one
#   }
# }

# explore: email_mymove_contact { -- Deprecated on 8/19/22 because row 204 has a note that says do not use this. There are no assets in Looker that use this.
#   #don't use this, use the one above
#   hidden: yes
#   join: sales_order {
#     type: left_outer
#     sql_on: ${sales_order.email} = ${email_mymove_contact.email} ;;
#     relationship: many_to_one
#   }
#   join: sales_order_line_base {
#     type: left_outer
#     sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id} and ${sales_order_line_base.system} = ${sales_order.system};;
#     relationship: one_to_many
#   }
#   join: item {
#     type: left_outer
#     sql_on:  ${item.item_id} = ${sales_order_line_base.item_id} ;;
#     relationship: many_to_one
#   }
#   join: order_flag {
#     type: left_outer
#     sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
#     relationship: many_to_one
#   }
# }

# explore: cordial_bulk_message { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
#   group_label: "Cordial"
#   hidden: yes
#   label: "Cordial Information"
#   join: cordial_activity{
#     type: left_outer
#     sql_on: ${cordial_bulk_message.bm_id} = ${cordial_activity.bm_id} ;;
#     relationship: one_to_many
#   }
# }

# explore: conversions_by_campaign { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
#   hidden:  yes
#   label: "Conversions by Campaign"
#   group_label: "Marketing"
#   description: "Aggregated campaign data by date and campaign"
#   join: adspend_by_campaign {
#     type: left_outer
#     sql_on:  ${adspend_by_campaign.campaign_id} = ${conversions_by_campaign.campaign_id} and ${adspend_by_campaign.date} = ${conversions_by_campaign.date_date}
#       and ${adspend_by_campaign.platform} = ${conversions_by_campaign.platform};;
#     relationship:one_to_one
#   }
#   join: external_campaign {
#     type: left_outer
#     sql_on: ${external_campaign.campaign_id} = coalesce (${conversions_by_campaign.campaign_id}, ${adspend_by_campaign.campaign_id});;
#     relationship: many_to_one
#   }
# }

# dimension: order_system {
#   primary_key:  yes
#   type: string
#   hidden:  yes
#   sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }

#   explore: email_crm { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
#     from:  sales_order_line_base
#     label:  " Sales"
#     hidden: yes
#     group_label: " Sales"
#     view_label: "Sales Order Line"
#     view_name: sales_order_line
#     # fields: [sales_order_details*]
#     description:  "All sales orders for DTC, Wholesale, Owned Retail channel"
#     #always_join: [fulfillment]
#     # always_filter: {
#     #   filters: [sales_order.channel: "DTC, Wholesale, Owned Retail"]
#     #   filters: [sales_order.is_exchange_upgrade_warranty: ""]
#     join: sales_order {
#       view_label: "Sales Order"
#       type: left_outer
#       sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
#       relationship: one_to_one}
#     join: cordial_activity {
#       type: left_outer
#       sql_on: lower(${cordial_activity.email}) = lower(${sales_order.email})
#       and ${cordial_activity.time_time} < ${sales_order.created} and ${cordial_activity.time_time} >= dateadd('day',-7,${sales_order.created})
#       and ${cordial_activity.action} in ('message-sent','open');;
#       relationship: many_to_one
#     }
#     join:cordial_id  {
#       type: left_outer
#       relationship: one_to_many
#       sql_on: ${cordial_id.email_join} = lower(${cordial_activity.email}) ;;
#     }
#     join: cordial_bulk_message {
#       type: left_outer
#       relationship: one_to_one
#       sql_on: ${cordial_activity.bm_id} = ${cordial_bulk_message.bm_id} ;;
#     }
#     join: item {
#       type: left_outer
#       relationship: many_to_one
#       sql_on: ${item.item_id} = ${sales_order_line.item_id} ;;
#     }
#     join: order_flag_v2 {
#       view_label: "Order Flags"
#       type: left_outer
#       sql_on: ${sales_order.order_id} = ${order_flag_v2.order_id} ;;
#       relationship: one_to_one
#     }
#     join: first_order_flag {
#       view_label: "Order Flag"
#       relationship: one_to_one
#       sql_on: ${sales_order.order_id}||'-'||${sales_order.system} = ${first_order_flag.pk} ;;
#     }
# }

  # explore: talkable_referral { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  #   hidden: yes
  #   join: sales_order {
  #     type: left_outer
  #     relationship: one_to_one
  #     sql_on: ${sales_order.email} = ${talkable_referral.referred_email} ;;
  #   }
  #   join: sales_order_line_base {
  #     type: left_outer
  #     relationship: one_to_many
  #     sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id}
  #       and ${sales_order_line_base.system} = ${sales_order.system};;
  #   }
  #   join: item {
  #     type: left_outer
  #     relationship: many_to_one
  #     sql_on: ${item.item_id} = ${sales_order_line_base.item_id} ;;
  #   }
  #   join: customer_table {
  #     type: left_outer
  #     relationship: many_to_one
  #     sql_on: ${sales_order.customer_id} = ${customer_table.customer_id} ;;
  #   }
  # }

  # explore: crm_customer_health {
  #   hidden:yes
  #   label: "CRM: Customer Health"
  #   group_label: "Marketing"
  #   view_label:"Customer Health"
  #   join: crm_customer_health_lifetime {
  #     view_label: "Customer Lifetime"
  #     type: left_outer
  #     relationship: many_to_one
  #     sql_on: ${crm_customer_health.email_join} =  ${crm_customer_health_lifetime.email_join} ;;
  #   }
  #   join: order_utm {
  #     view_label: "Orders"
  #     type: left_outer
  #     relationship: one_to_many
  #     sql_on: lower(${crm_customer_health.email}) = lower(${order_utm.email}) ;;
  #   }
  #   join: sales_order {
  #     type: left_outer
  #     sql_on: lower(${sales_order.email}) = ${crm_customer_health.email_join} ;;
  #     relationship: many_to_one
  #     #fields: []
  #   }
  #   join: sales_order_line_base {
  #     type: left_outer
  #     sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id} and ${sales_order_line_base.system} = ${sales_order.system};;
  #     relationship: one_to_many
  #     fields: []
  #   }
  #   join: item {
  #     type: left_outer
  #     sql_on:  ${item.item_id} = ${sales_order_line_base.item_id} ;;
  #     relationship: many_to_one
  #   }
  # }


  # explore: v_fb_adset_freq_weekly {hidden: yes}
  # explore: v_fb_all {hidden: yes}
  # explore: v_fb_all_breakdown {hidden: yes} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: v_google_search_site_report {hidden: yes}
  # explore: v_google_keyword_page_report {hidden: yes}
  # explore: fb_attribution { hidden: yes} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: fb_attribution_v2 { hidden: yes} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: roas_pdt { hidden: yes group_label: "Marketing"}
  #explore: adspend_target { hidden:yes group_label: "Marketing"}
  # explore: zipcode_radius {hidden: yes group_label: "Marketing"}
  # explore: shawn_ryan_view {hidden: yes group_label: "Marketing"} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: weekly_acquisition_report_snapchat  {hidden: yes group_label: "Marketing"} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: c3_roa {hidden: yes group_label: "Marketing"}
  # explore: spend_sessions_ndt {hidden: yes group_label: "Marketing"}
  # explore: adspend_out_of_range_yesterday {group_label: "Marketing" label: "Adspend Out of Range Yesterday" description: "Platform daily Adspend outside of the 95% Confidence Interval." hidden: yes}
  # explore: marketing_magazine {hidden: yes group_label: "Marketing"} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: sessions {hidden: yes group_label: "Marketing"}
  # explore: impact_radius_autosend {hidden: yes group_label: "Marketing"}
  # explore: conversions {hidden: yes group_label: "Marketing"} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: veritone_pixel_matchback { hidden:yes group_label: "Marketing"}-- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: target_adspend {hidden: yes group_label: "Marketing"}
  # explore: promotion {hidden:yes group_label: "Marketing"}
  # explore: crm_customer_health {hidden:yes group_label: "Marketing" label:"CRM: Customer Health"}

  # explore: narvarcustomer{hidden:yes}
  # explore: narvar_dashboard_track_metrics {hidden: yes group_label: "Marketing" label: "Narvar Track Metrics"} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  # explore: narvar_customer_feedback {
  #   hidden: yes
  #   group_label: "Marketing"
  #   label: "Narvar customer feedback"
  #   join: sales_order {
  #     type: left_outer
  #     sql_on: ${narvar_customer_feedback.tranid} = ${sales_order.tranid}  ;;
  #     relationship: one_to_one }
  #   join: v_qualtrics_delivery_survey {
  #     type: left_outer
  #     sql_on:  ${narvar_customer_feedback.tranid} = ${v_qualtrics_delivery_survey.tranid} ;;
  #     relationship: one_to_one}
  #   join: item {
  #     view_label: "Product"
  #     type: left_outer
  #     sql_on: ${v_qualtrics_delivery_survey.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one}
  #   }

#-------------------------------------------------------------------
#
# HEAP Explores
#
#-------------------------------------------------------------------

# explore: all_events {
#   hidden: yes
#   label: "All Events (heap)"
#   group_label: "Marketing"
#   description: "All Website Event Data from Heap Block"
#   join: users {
#     type: left_outer
#     sql_on: ${all_events.user_id}::string = ${users.user_id}::string ;;
#     relationship: many_to_one }
#   join: sessions {
#     type: left_outer
#     sql_on: ${all_events.session_id}::string = ${sessions.session_id}::string ;;
#     relationship: many_to_one }
#   join: session_facts {
#     view_label: "Sessions"
#     type: left_outer
#     sql_on: ${sessions.session_id}::string = ${session_facts.session_id}::string ;;
#     relationship: one_to_one }
# ## event_flow not currently used in content.
# #   join: event_flow {
# #     sql_on: ${all_events.event_id}::string = ${event_flow.unique_event_id}::string ;;
# #     relationship: one_to_one }
#     join: zip_codes_city {
#       type: left_outer
#       sql_on: ${sessions.city} = ${zip_codes_city.city} and ${sessions.region} = ${zip_codes_city.state_name} ;;
#       relationship: one_to_one }
#     join: dma {
#       type:  left_outer
#       sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
#       relationship: one_to_one }
#     join: heap_page_views {
#       type: left_outer
#       sql_on: ${heap_page_views.session_id} = ${all_events.session_id} ;;
#       relationship: one_to_many
#     }
#     join: date_meta {
#       type: left_outer
#       sql_on: ${date_meta.date}::date = ${sessions.time_date}::date;;
#       relationship: one_to_many
#     }
# # I commented this out to see if performance changes
# ## Blake

# # UPDATE: It looks like performance went to pot becuase I see that the aggregate table and materialization are no longer commented out.
# ## Rho

#   aggregate_table: rollup__sessions_time_week_of_year__sessions_time_year {
#     query: {
#       dimensions: [sessions.time_week_of_year, sessions.time_year]
#       measures: [heap_page_views.Sum_non_bounced_session, sessions.count]
#       filters: [sessions.current_week_num: "Yes", sessions.time_date: "after 2019/01/01"]
#       timezone: "America/Denver"
#     }

#     materialization: {
#       datagroup_trigger: pdt_refresh_6am
#     }
#   }

#   }

  # explore: funnel_explorer { -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  #   hidden: yes
  #   group_label: "Marketing"
  #   label: "HEAP Funnel"
  #   join: sessions {
  #     type: left_outer
  #     sql_on: ${funnel_explorer.session_unique_id} = ${sessions.session_unique_id} ;;
  #     relationship: one_to_one
  #   }
  #   join: session_facts {
  #     view_label: "Sessions"
  #     type: left_outer
  #     sql_on: ${sessions.session_unique_id} = ${session_facts.session_unique_id} ;;
  #     relationship: one_to_one
  #   }
  # }
  # explore: scorecard {hidden:yes} -- Deprecated on 8/18/22 because i see no assets in Looker using this explore. RL
  explore: pageviews_bounced_pdt {hidden: yes group_label: "Marketing" label: "Pageviews Bounced"}
  # explore: heap_page_views_web_analytics {hidden:yes label: "Web Analytics Test"  group_label: "Marketing"  description: "Test for Web Analytics"}
  explore: heap_page_views {hidden:yes label: "HEAP Page Views"  group_label: "Marketing"  description: "Page View Only Explore"}
