#-------------------------------------------------------------------
#
# Marketing Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: daily_adspend {
    from:  daily_adspend
    group_label: "Marketing"
    description: "Adspend by platform aggregated by date"
    hidden: no
    join: adspend_target {
      type: full_outer
      sql_on: ${adspend_target.target_date} = ${daily_adspend.ad_date} and ${adspend_target.medium} = ${daily_adspend.medium} ;;
      relationship: many_to_one}
  }

  explore: c3 {
    from: c3_conversion
    group_label: "Marketing"
    hidden: yes
    label: "Attribution (C3)"
    view_label: "C3 Data"
    description: "Each touch point from marketing leading up to an order"

    join: c3_conversion_count {
      view_label: "C3 Data"
      type: left_outer
      sql_on: ${c3.order_id} = ${c3_conversion_count.order_id} ;;
      relationship: one_to_many
    }
  }

  explore: hotjar_data {
    group_label: "Marketing"
    label: "Post-purchase survey results"
    description: "Results form Hotjar post-purchase survey"
    view_label: "Survey Data"
    join: hotjar_whenheard {
      view_label: "Survey Data"
      type:  left_outer
      sql_on: ${hotjar_data.token} = ${hotjar_whenheard.token} ;;
      relationship: many_to_one}
    join: shopify_orders {
      type: inner
      sql_on: ${hotjar_data.token} = ${shopify_orders.checkout_token} ;;
      relationship: many_to_one
      fields: [shopify_orders.call_in_order_Flag, shopify_orders.created_at_date, shopify_orders.gross_sales]}
    join: sales_order {
      type:  left_outer
      sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
      relationship: one_to_one
      fields: [-unique_customers,sales_order.is_exchange,sales_order.is_upgrade,sales_order.payment_method_flag,sales_order.warranty_order_flg, sales_order.order_id, sales_order.order_type_hyperlink, sales_order.average_order_size, sales_order.Order_size_buckets, sales_order.created_date, sales_order.gross_amt]}
    join: order_flag {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
      relationship:  one_to_one}
    join: first_order_flag {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${sales_order.order_id}||'-'||${sales_order.system} = ${first_order_flag.pk} ;;
      relationship:  one_to_one}
    join: sales_order_line {
      type:  left_outer
      sql_on: ${sales_order.order_id}= ${sales_order_line.order_id} ;;
      relationship: one_to_many
      fields: []}
    join: sf_zipcode_facts {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${sales_order_line.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
      relationship: many_to_one
      fields: []}
    join: zcta5 {
      view_label: "Geography"
      type:  left_outer
      sql_on: ${sales_order_line.zip_1}::varchar = (${zcta5.zipcode})::varchar AND ${sales_order_line.state} = ${zcta5.state};;
      relationship: many_to_one
      fields: [zcta5.fulfillment_region_1,zcta5.state_1]}
    join: dma {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
      relationship: many_to_many
      fields: [dma.dma_name]}
    join: shopify_discount_codes {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
      relationship: many_to_many}
  }

  explore: cordial_activity {
    hidden: yes
    group_label: "Marketing"
    label: "Email (cordial)"
    join: cordial_message_analytic {
      type: left_outer
      sql_on: ${cordial_activity.bm_id} = ${cordial_message_analytic.message_id} ;;
      relationship: many_to_one
    }
    join: cordial_bulk_message {
      type: left_outer
      sql_on: ${cordial_activity.bm_id} = ${cordial_bulk_message.bm_id} ;;
      relationship: many_to_one
    }
    join: order_utm {
      type: left_outer
      sql_on: lower(${cordial_activity.email}) = lower(${order_utm.email})
        and ${cordial_activity.time_time} < ${order_utm.created} and ${cordial_activity.time_time} >= dateadd('hour',-48,${order_utm.created})
        and ${cordial_activity.action} in ('message-sent','open');;
      relationship: many_to_one
    }
  }

  explore: email_contact_merged {
    hidden: yes
    join: sales_order {
      type: left_outer
      sql_on: lower(${sales_order.email}) = lower(${email_contact_merged.email_join});;
      relationship: many_to_one
    }
    join: sales_order_line_base {
      type: left_outer
      sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id} and ${sales_order_line_base.system} = ${sales_order.system};;
      relationship: one_to_many
    }
    join: item {
      type: left_outer
      sql_on:  ${item.item_id} = ${sales_order_line_base.item_id} ;;
      relationship: many_to_one
    }
    join: order_flag {
      type: left_outer
      sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
      relationship: many_to_one
    }
  }

explore: email_mymove_contact {
  #don't use this, use the one above
  hidden: yes
  join: sales_order {
    type: left_outer
    sql_on: ${sales_order.email} = ${email_mymove_contact.email} ;;
    relationship: many_to_one
  }
  join: sales_order_line_base {
    type: left_outer
    sql_on: ${sales_order_line_base.order_id} = ${sales_order.order_id} and ${sales_order_line_base.system} = ${sales_order.system};;
    relationship: one_to_many
  }
  join: item {
    type: left_outer
    sql_on:  ${item.item_id} = ${sales_order_line_base.item_id} ;;
    relationship: many_to_one
  }
  join: order_flag {
    type: left_outer
    sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
    relationship: many_to_one
  }
}

  explore: cordial_bulk_message {
    group_label: "Cordial"
    hidden: yes
    label: "Cordial Information"
    join: cordial_activity{
      type: left_outer
      sql_on: ${cordial_bulk_message.bm_id} = ${cordial_activity.bm_id} ;;
      relationship: one_to_many
    }
  }

  explore: conversions_by_campaign {
    hidden:  yes
    label: "Conversions by Campaign"
    group_label: "Marketing"
    description: "Aggregated campaign data by date and campaign"
    join: adspend_by_campaign {
      type: left_outer
      sql_on:  ${adspend_by_campaign.campaign_id} = ${conversions_by_campaign.campaign_id} and ${adspend_by_campaign.date} = ${conversions_by_campaign.date_date}
        and ${adspend_by_campaign.platform} = ${conversions_by_campaign.platform};;
      relationship:one_to_one
    }
    join: external_campaign {
      type: left_outer
      sql_on: ${external_campaign.campaign_id} = coalesce (${conversions_by_campaign.campaign_id}, ${adspend_by_campaign.campaign_id});;
      relationship: many_to_one
    }
  }

  explore: roas_pdt { hidden: yes group_label: "Marketing"}
  #explore: adspend_target { hidden:yes group_label: "Marketing"}
  explore: zipcode_radius {hidden: yes group_label: "Marketing"}
  explore: shawn_ryan_view {hidden: yes group_label: "Marketing"}
  explore: weekly_acquisition_report_snapchat  {hidden: yes group_label: "Marketing"}
  explore: c3_roa {hidden: yes group_label: "Marketing"}
  explore: spend_sessions_ndt {hidden: yes group_label: "Marketing"}
  explore: adspend_out_of_range_yesterday {group_label: "Marketing" label: "Adspend Out of Range Yesterday" description: "Platform daily Adspend outside of the 95% Confidence Interval." hidden: yes}
  explore: marketing_magazine {hidden: yes group_label: "Marketing"}
  explore: sessions {hidden: yes group_label: "Marketing"}
  explore: impact_radius_autosend {hidden: yes group_label: "Marketing"}
  explore: conversions {hidden: yes group_label: "Marketing"}
  explore: veritone_pixel_matchback { hidden:yes group_label: "Marketing"}
  explore: target_adspend {hidden: yes group_label: "Marketing"}
  explore: promotion {hidden:yes group_label: "Marketing"}

  explore: narvarcustomer{hidden:yes}
  explore: narvar_dashboard_track_metrics {hidden: yes group_label: "Marketing" label: "Narvar Track Metrics"}
  explore: narvar_customer_feedback {hidden: yes group_label: "Marketing" label: "Narvar customer feedback"}

#-------------------------------------------------------------------
#
# HEAP Explores
#
#-------------------------------------------------------------------

explore: all_events {
  hidden: yes
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
## event_flow not currently used in content.
#   join: event_flow {
#     sql_on: ${all_events.event_id}::string = ${event_flow.unique_event_id}::string ;;
#     relationship: one_to_one }
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
      relationship: one_to_many
    }
    join: date_meta {
      type: left_outer
      sql_on: ${date_meta.date}::date = ${sessions.time_date}::date;;
      relationship: one_to_many
    }
## I commented this out to see if performance changes
### Blake
#   aggregate_table: rollup__sessions_time_week_of_year__sessions_time_year {
#     query: {
#       dimensions: [sessions.time_week_of_year, sessions.time_year]
#       measures: [heap_page_views.Sum_non_bounced_session, sessions.count]
#       filters: [sessions.current_week_num: "Yes", sessions.time_date: "after 2019/01/01"]
#       timezone: "America/Denver"
#     }
#
#     materialization: {
#       datagroup_trigger: pdt_refresh_6am
#     }
#   }

  }

  explore: funnel_explorer {
    hidden: yes
    group_label: "Marketing"
    label: "HEAP Funnel"
    join: sessions {
      type: left_outer
      sql_on: ${funnel_explorer.session_unique_id} = ${sessions.session_unique_id} ;;
      relationship: one_to_one
    }
    join: session_facts {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${sessions.session_unique_id} = ${session_facts.session_unique_id} ;;
      relationship: one_to_one
    }
  }

  explore: pageviews_bounced_pdt {hidden: yes group_label: "Marketing" label: "Pageviews Bounced"}
  explore: heap_page_views_web_analytics {hidden:yes label: "Web Analytics Test"  group_label: "Marketing"  description: "Test for Web Analytics"}
  explore: heap_page_views {hidden:yes label: "HEAP Page Views"  group_label: "Marketing"  description: "Page View Only Explore"}
