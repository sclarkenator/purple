#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------




include: "*.view.lkml"                       # include all views in this project
include: "marketing.model.lkml"
include: "main.model.lkml"

week_start_day: sunday

#-------------------------------------------------------------------
# Marketing explores
#-------------------------------------------------------------------


explore: daily_adspend {
  #-------------------------------------------------------------------
  # Daily Spend
  #-------------------------------------------------------------------
  group_label: "Marketing"
  label: "Adspend"
  description: "Daily adspend details, including channel, clicks, impressions, spend, device, platform, etc."
  join: temp_attribution {
    type: left_outer
    sql_on: ${temp_attribution.ad_date} = ${daily_adspend.ad_date} and ${temp_attribution.partner} = ${daily_adspend.Spend_platform_condensed} ;;
    relationship: many_to_one}
}



explore: hotjar_data {
  #-------------------------------------------------------------------
  #  Hotjar----------------------
  #       \           \          \
  #      Hotjar      Shopify     Order
  #    WhenHeard      Orders      Flag
  #-------------------------------------------------------------------
  group_label: "Marketing"
  label: "Hotjar Survey Results"
  description: "Results form Hotjar post-purchase survey"
  join: hotjar_whenheard {
    type:  left_outer
    sql_on: ${hotjar_data.token} = ${hotjar_whenheard.token} ;;
    relationship: many_to_one}
  join: shopify_orders {
    type: inner
    sql_on: ${hotjar_data.token} = ${shopify_orders.checkout_token} ;;
    relationship: many_to_one}
  join: sales_order {
    type:  left_outer
    sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    relationship: one_to_one}
  join: order_flag {
    type: left_outer
    sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
    relationship:  one_to_one}}


  explore: all_events {
    #-------------------------------------------------------------------
    #  All Events-----
    #     \           \
    #     Users     Sessions
    #               /   |   \
    #           Session | City to Zip
    #             Facts |     \
    #                 Event   DMA
    #                 Flow
    #-------------------------------------------------------------------
    #hidden: yes
    label: "All Events (heap)"
    group_label: "Marketing"
    description: "All Website Event Data from Heap Block"
    join: users {
      type: left_outer
      sql_on: ${all_events.user_id}::string = ${users.user_id}::string ;;
      relationship: many_to_one }
    join: sessions {
      type: left_outer
      sql_on: ${all_events.session_id}::string = ${sessions.session_id}::string ;;
      relationship: many_to_one }
    join: session_facts {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${sessions.session_id}::string = ${session_facts.session_id}::string ;;
      relationship: one_to_one }
    join: event_flow {
      sql_on: ${all_events.event_id}::string = ${event_flow.unique_event_id}::string ;;
      relationship: one_to_one }
    join: zip_codes_city {
      type: left_outer
      sql_on: ${sessions.city} = ${zip_codes_city.city} and ${sessions.region} = ${zip_codes_city.state_name} ;;
      relationship: one_to_one }
    join: dma {
      type:  left_outer
      sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
      relationship: one_to_one }
    join: heap_page_views {
      type: left_outer
      sql_on: ${heap_page_views.session_id} = ${all_events.session_id} ;;
      relationship: one_to_one
    }
  }



#-------------------------------------------------------------------
# Narvar Explores
#-------------------------------------------------------------------

  explore: narvar_dashboard_track_metrics {
    group_label: "Marketing"
    label: "Narvar Track Metrics"
  }
  explore: narvar_dashboard_clicks_by_campaign {
    group_label: "Marketing"
    label: "Narvar clicks by campaign"
  }
  explore: narvar_dashboard_emails_accepted_by_campaign {
    group_label: "Marketing"
    label: "Narvar emails accepted by campaign"
  }
  explore: narvar_dashboard_notification_clicks_by_category {
    group_label: "Marketing"
    label: "Narvar clicks by category"
  }
  explore: narvar_dashboard_notify_metrics {
    group_label: "Marketing"
    label: "Narvar notify metrics"
  }



#-------------------------------------------------------------------
# Hidden Explores
#-------------------------------------------------------------------

  explore: adspend_out_of_range_yesterday {group_label: "Marketing" label: "Adspend Out of Range Yesterday" description: "Platform daily Adspend outside of the 95% Confidence Interval."}
  explore: marketing_magazine {hidden: yes}
  explore: sessions {hidden: yes}
  explore: impact_radius_autosend {hidden: yes}
  explore: conversions {hidden: yes}
  explore: conversions_by_campaign { hidden:  yes label: "Conversions by Campaign" group_label: "Marketing" description: "Aggregated campaign data by date and campaign"
    join: adspend_by_campaign {type: left_outer sql_on:  ${adspend_by_campaign.campaign_id} = ${conversions_by_campaign.campaign_id} and ${adspend_by_campaign.date} = ${conversions_by_campaign.date_date}
        and ${adspend_by_campaign.platform} = ${conversions_by_campaign.platform};; relationship:one_to_one}
    join: external_campaign {type: left_outer sql_on: ${external_campaign.campaign_id} = coalesce (${conversions_by_campaign.campaign_id}, ${adspend_by_campaign.campaign_id});;
      relationship: many_to_one } }

  explore: target_adspend {hidden: yes}
