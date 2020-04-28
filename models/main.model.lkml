#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

  connection: "analytics_warehouse"
    include: "/views/**/*.view"

week_start_day: monday

datagroup: gross_to_net_sales_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"}

persist_with: gross_to_net_sales_default_datagroup

datagroup: temp_ipad_database_default_datagroup {
  max_cache_age: "1 hour"}

persist_with: temp_ipad_database_default_datagroup

# Rebuilds at 6:00am MDT / 13:00 UTC
datagroup: pdt_refresh_6am {
  sql_trigger: SELECT FLOOR((DATE_PART('EPOCH_SECOND', CURRENT_TIMESTAMP) - 60*60*13)/(60*60*24)) ;;
  max_cache_age: "24 hours"
}


#-------------------------------------------------------------------
#
# Production Explores
#
#-------------------------------------------------------------------



access_grant: can_view_pii {
  user_attribute: can_view_pii
  allowed_values: ["yes"]
}

explore: production_report {
  label: "iPad Production Data"
  group_label: "Production"
  description: "Connection to the iPad database owned by IT, Machine level production data is stored here"
}

explore: jarom_location_data {
  hidden:  yes
}

explore: current_oee {
  hidden:  yes
  label: "Current OEE Table"
  description: "Automatic OEE Dataset in Snowflake"
  join: iPad_Machine_Table {
    sql_on: ${iPad_Machine_Table.machine_id} = ${current_oee.machine_id} ;;
    relationship: many_to_one
  }
}

explore: oee {
  hidden:  yes
  label: "Historical OEE Table"
  description: "Static OEE Dataset in Snowflake"
}

explore: dispatch_info{
  hidden:  yes
  group_label: "Production"
  label: "L2L Dispatch Data"
  description: "The log of all L2L dispatches"
  join: ltol_line {
    type: left_outer
    sql_on: ${ltol_line.line_id} = ${dispatch_info.MACHINE_LINE_ID} ;;
    relationship: many_to_one
  }
}

explore: v_dispatch {
  hidden: no
  group_label: "Production"
  label: "L2L Dispatch Data"
  description: "The log of all L2L dispatches"
}

explore: ltol_pitch {
  label: "L2L Production Pitch Data"
  group_label: "Production"
  description: "The Pitch hourly data from L2L"
  join: ltol_line {
    type: left_outer
    sql_on: ${ltol_line.line_id} = ${ltol_pitch.line} ;;
    relationship: many_to_one
  }
}

explore: assembly_build {
  hidden: no
  group_label: "Production"
  label: "Production Assembly Data"
  description: "NetSuite Header Level Assembly and Unbuild Data. Adding in the Unbuilds provides a better final number of what is produced."
  always_filter: {
    filters: {
      field: scrap
      value: "0"
    }
    filters: {
      field: item.merchandise
      value: "0"
    }
  }
  join: item {
    type: left_outer
    sql_on: ${assembly_build.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }
  join: warehouse_location {
    sql_on: ${assembly_build.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one
  }
}

explore: max_machine_capacity {
  hidden: yes
  label: "Max Machine Capacity"
  description: "Total capacity of Max machines by day and machine. Sourced from Engineering based on ideal cycle times"
}

explore: project_config {
  label: "Engineering Projects"
  description: "Status of engineering projects"
  hidden: yes
  join: project_report {
    type: inner
    relationship: one_to_many
    sql_on: ${project_config.project_id} = ${project_report.project_id} ;;
  }
}

explore: workorder_reconciliation {
  label: "Assembly Build Reconcilation"
  hidden: yes
  description: "NetSuite Assembly Build consumed parts checked against the ideal consumption"
  join: item {
    type: left_outer
    view_label: "Part Item Information"
    relationship: many_to_one
    sql_on: ${workorder_reconciliation.part_item_id} = ${item.item_id} ;;
  }
  join: assembly_build {
    type: left_outer
    relationship: many_to_one
    sql_on: ${workorder_reconciliation.assembly_build_id} = ${assembly_build.assembly_build_id} ;;
  }
}

explore: warehouse_transfer {
  label: "Warehouse Transactions"
  group_label: "Production"
  description: "Transactions by warehousing for bin and inventory transfers"
  hidden: yes
  join: warehouse_transfer_line {
    type: inner
    relationship: one_to_many
    sql_on: ${warehouse_transfer.warehouse_transfer_id} = ${warehouse_transfer_line.warehouse_transfer_id} ;;
  }
  join: warehouse_location {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer.SHIPPING_LOCATION_ID} = ${warehouse_location.location_id} ;;
  }
  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer_line.item_id} = ${item.item_id} ;;
  }
}

explore: v_fit {
  hidden: yes
  group_label: "Accounting"}
explore: fit_problem {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_affirm {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_amazon {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_axomo {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_braintree {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_first_data {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_paypal {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_shopify_payment {
  hidden: yes
  group_label: "Accounting"}
explore: v_fit_stripe {
  hidden: yes
  group_label: "Accounting"}


explore: finance_bill{
  hidden: yes
  group_label: "Accounting"
  label: "Finance Bill Items"
  description: "A joined view of finance bill headers and bill line items"
  join: finance_bill_line {
    type: left_outer
    sql_on: ${finance_bill.bill_id}=${finance_bill_line.bill_id} ;;
    relationship: one_to_many
    }
  join: finance_bill_payment {
    type:  inner
    sql_on: ${finance_bill.bill_id}=${finance_bill_payment.bill_payment_id} ;;
    relationship: one_to_one
  }
  join: finance_bill_payment_line {
    type: full_outer
    sql_on: ${finance_bill.bill_id}=${finance_bill_payment_line.bill_payment_id} ;;
    relationship:  one_to_many
  }
}

explore: inventory {
  group_label: "Production"
  label: "Current Inventory"
  description: "Inventory positions, by item by location"
  always_filter: {
    filters: {field: warehouse_location.location_Active      value: "No"}}
  join: item {
    type: left_outer
    sql_on: ${inventory.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: warehouse_location {
    sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one}
}

explore: inventory_snap {
  group_label: "Production"
  label: "Historical Inventory"
  description: "Inventory positions, by item by location over time"
  always_filter: {
    filters: {field: warehouse_location.location_Active      value: "No"}}
  join: item {
    type: left_outer
    sql_on: ${inventory_snap.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: warehouse_location {
    sql_on: ${inventory_snap.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one}
}

explore: production_goal {
  group_label: "Production"
  label: "Production Goals"
  description: "Production goals by forecast date, item, etc"
  join: production_goal_by_item {
    type: left_outer
    sql_on: ${production_goal.pk} = ${production_goal_by_item.pk} ;;
    relationship: one_to_many}
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${production_goal_by_item.item_id} = ${item.item_id} and ${production_goal_by_item.sku_id} = ${item.sku_id} ;;
    relationship: many_to_one }
}

explore: inventory_available_report {
  hidden: yes
  group_label: "Production"
  label: "Invnetory Available Report"
  description: "A Inventory Available Report created for Mike S./Andrew C."
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${inventory_available_report.sku_id} = ${item.sku_id} ;;
    relationship: many_to_one }
}

explore: inventory_adjustment {
  group_label: "Production"
  label: "Inventory Adjustment"
  description: "Inventory Adjustment by Item, Line, etc"
  join: inventory_adjustment_line {
    type: left_outer
    sql_on: ${inventory_adjustment.inventory_adjustment_id} = ${inventory_adjustment_line.inventory_adjustment_id} ;;
    relationship: one_to_many }
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on:  ${inventory_adjustment_line.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }
}

explore: bom_demand_matrix {
  hidden:  yes
  group_label: "Production"
  label: "Bom Demand Matrix"
  description: "Number of products we can currently build with remaining components/resources"
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${bom_demand_matrix.item_id} = ${item.item_id} ;;
    relationship: one_to_one
  }
}

explore: buildable_quantity {
  hidden: yes
  group_label: "Production"
  label: "Buildable Quantity"
  description: "Number of products we can currently build with remaining components/resources"
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${buildable_quantity.item_id} = ${item.item_id} ;;
    relationship: one_to_one
  }
  join: bom_demand_matrix {
    view_label: "Buildable Quantity"
    type: left_outer
    sql_on: ${buildable_quantity.item_id} = ${bom_demand_matrix.component_id} ;;
    relationship: one_to_one
  }
}

explore: l2_l_checklist_answers {hidden: yes}
explore: l2_l_checklists {hidden: yes}
explore: l2l_qpc_mattress_audit {hidden: yes}
explore: l2l_quality_yellow_card {hidden: yes}
explore: l2l_shift_line_1_glue_process {hidden: yes}
explore: l2l_machine_downtime {hidden: yes}
explore: inventory_reconciliation { hidden: yes}
explore: po_and_to_inbound {hidden: yes}
explore: inventory_recon_sub_locations {hidden:yes}
explore: change_mgmt {hidden:yes}
explore: outbound {hidden:yes}
explore: pilot_daily_report {hidden:yes}
# explore: mainchain_transaction_outwards_detail {hidden:yes
#   join: sales_order{
#     type: left_outer
#     sql_on: ${sales_order.tranid} = ${mainchain_transaction_outwards_detail.tranid} ;;
#     relationship: many_to_one}
#   join: item {
#     type: left_outer
#     sql_on: ${item.sku_id} = ${mainchain_transaction_outwards_detail.sku_id} ;;
#     relationship: one_to_many}
#  join: sales_order_line {
#    type: left_outer
#    sql_on: ${item.item_id} = ${sales_order_line.item_id} and ${sales_order.order_id} = ${sales_order_line.order_id} and ${sales_order.system} = ${sales_order_line.system} ;;
#    relationship:many_to_one}
#  }

explore: v_demand_planning {
  hidden: yes
  view_label: "Demand Planning"
  label: "Demand Planning"
  description: ""
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${v_demand_planning.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }
  join: inventory {
    type: left_outer
    sql_on: ${v_demand_planning.item_id} = ${inventory.item_id} ;;
    relationship: many_to_one
  }
  join: warehouse_location {
    sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one
  }
}

explore: v_usertime_minutes {
  hidden: yes
  view_label: "Usertime"
  label: "Usertime"
  description: "Shows the amount of time and line an operator worked"
}

#-------------------------------------------------------------------
#
# Operations Explores
#
#-------------------------------------------------------------------

explore: purcahse_and_transfer_ids {
  label: "Transfer and Purchase Orders"
  group_label: "Operations"
  description: "Netsuite data on Transfer and purchase orders"
  hidden: no
  join: purchase_order {
    view_label: "Purchase Order"
    type: left_outer
    sql_on: ${purchase_order.purchase_order_id} = ${purcahse_and_transfer_ids.id} ;;
    relationship: one_to_one}
  join: purchase_order_line {
    view_label: "Purchase Order"
    type: left_outer
    sql_on: ${purchase_order.purchase_order_id} = ${purchase_order_line.purchase_order_id} ;;
    relationship: one_to_many}
  join: bills {
    view_label: "Bills"
    type:  left_outer
    sql_on: ${purchase_order.purchase_order_id} = ${bills.purchase_order_id} ;;
    relationship: one_to_many}
  join: transfer_order {
    view_label: "Transfer Order"
    type:  left_outer
    sql_on: ${transfer_order.transfer_order_id} = ${purcahse_and_transfer_ids.id} ;;
    relationship: one_to_one}
  join: transfer_order_line {
    view_label: "Transfer Order"
    type:  full_outer
    sql_on: ${transfer_order_line.transfer_order_id} = ${transfer_order.transfer_order_id} ;;
    relationship: one_to_many}
  join: Receiving_Location{
    from:warehouse_location
    type:  left_outer
    sql_on:  ${Receiving_Location.location_id} = coalesce(${transfer_order.receiving_location_id},${purchase_order.location_id}) ;;
    relationship: many_to_one}
  join: Transfer_Fulfilling_Location{
    from:warehouse_location
    type:  left_outer
    sql_on: ${transfer_order.shipping_location_id} = ${Transfer_Fulfilling_Location.location_id} ;;
    relationship: many_to_one}
  join: item {
    view_label: "Item"
    type:  left_outer
    sql_on: ${item.item_id} = coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id});;
    relationship: many_to_one}
  join: vendor {
    type:  left_outer
    sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;;
    relationship: many_to_one}}

explore: v_fedex_to_xpo {
  hidden:  yes
  group_label: "Production"
}

#  explore: fulfillment_snowflake{
#    from: fulfillment
#    hidden:  yes
#    group_label: "Production"
#  }

  explore: fulfillment_amazon{
    hidden:  yes
    group_label: "Production"
  }

explore: starship_fulfillment {
  label: "Starship Fulfillments"
  group_label: "Operations"
  hidden: yes
  description: "Starship fulfillment data with user logs"
  join: Created_user {
    from: starship_users
    view_label: "Created By User"
    type: left_outer
    sql_on: ${starship_fulfillment.createdbyid} = ${Created_user.id};;
    relationship: many_to_one
  }
  join: Processed_user {
    from: starship_users
    view_label: "Processed By User"
    type: left_outer
    sql_on: ${starship_fulfillment.processedbyid} = ${Processed_user.id};;
    relationship: many_to_one
  }
  join: Deleted_user {
    from: starship_users
    view_label: "Deleted By User"
    type: left_outer
    sql_on: ${starship_fulfillment.deletedbyid} = ${Deleted_user.id};;
    relationship: many_to_one  }
  join: shippedby_user {
    from: starship_users
    view_label: "Shipped By User"
    type: left_outer
    sql_on: ${starship_fulfillment.shippedbyid} = ${shippedby_user.id};;
    relationship: many_to_one  }
}

  explore: forecast_combined {
    label: "Forecast"
    description: "Combined Forecast including units and dollars forecasted for DTC, Wholesale, Retail, and Amazon"
    group_label: "Operations"
    #hidden: yes
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${forecast_combined.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one}
    join:fg_to_sfg{
      view_label: "FG to SFG"
      sql_on: ${fg_to_sfg.fg_item_id}=${item.item_id} ;;
      type: left_outer
      relationship: one_to_one
    }
  }

  explore: forecast_combined_legacy {
    label: "Forecast Old"
    description: "Combined wholesale and dtc forecast of units and dollars."
    group_label: "Operations"
    hidden: yes
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${forecast_combined_legacy.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one}
    join:fg_to_sfg{
      view_label: "FG to SFG"
      sql_on: ${fg_to_sfg.fg_item_id}=${item.item_id} ;;
      type: left_outer
      relationship: one_to_one
    }
  }

  explore: day_pending { hidden:yes}

  explore: at_risk_amount {
    hidden: yes
    label: "At Risk Orders"
  }

#-------------------------------------------------------------------
#
# Marketing explores
#
#-------------------------------------------------------------------


explore: daily_adspend {
  from:  daily_adspend
  group_label: "Marketing"
  description: "Adspend by platform aggregated by date"
  hidden: no
  join: adspend_target {
    type: full_outer
    sql_on: ${adspend_target.target_date} = ${daily_adspend.ad_date} and ${adspend_target.medium} = ${daily_adspend.medium} ;;
    relationship: many_to_one}
  join: temp_attribution {
    type: left_outer
    sql_on: ${temp_attribution.ad_date} = ${daily_adspend.ad_date} and ${temp_attribution.partner} = ${daily_adspend.Spend_platform_condensed} ;;
    relationship: many_to_one}
}

#explore: adspend_target { hidden:yes }

explore: zipcode_radius {
  hidden: yes
  group_label: "Marketing"
}

explore: shawn_ryan_view {
  hidden: yes
  group_label: "Marketing"
}

explore: weekly_acquisition_report_snapchat  {
  hidden: yes
  group_label: "Marketing"
}


explore: hotjar_data {
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
    relationship:  one_to_one}
  join: sales_order_line {
    type:  left_outer
    sql_on: ${sales_order.order_id}= ${sales_order_line.order_id} ;;
    relationship: one_to_many
    fields: [sales_order_line.zip]
  }
  join: sf_zipcode_facts {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${sales_order_line.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
    relationship: many_to_one}
  join: zcta5 {
    view_label: "Geography"
    type:  left_outer
    sql_on: ${sales_order_line.zip_1}::varchar = (${zcta5.zipcode})::varchar AND ${sales_order_line.state} = ${zcta5.state};;
    relationship: many_to_one}
  join: dma {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
    relationship: many_to_many}
  }

explore: all_events {
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
    relationship: one_to_one
  }
  join: date_meta {
    type: left_outer
    sql_on: ${date_meta.date}::date = ${sessions.time_date}::date;;
    relationship: one_to_many
  }
}

explore: cordial_activity {
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
}

explore: c3_roa {hidden: yes}
explore: spend_sessions_ndt {hidden: yes}
explore: adspend_out_of_range_yesterday {group_label: "Marketing" label: "Adspend Out of Range Yesterday" description: "Platform daily Adspend outside of the 95% Confidence Interval." hidden: yes}
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
explore: promotion {hidden:yes}

explore: narvarcustomer{hidden:yes}
explore: narvar_dashboard_track_metrics {
  group_label: "Marketing"
  hidden: yes
  label: "Narvar Track Metrics"
}

explore: narvar_dashboard_clicks_by_campaign {
  group_label: "Marketing"
  hidden: yes
  label: "Narvar clicks by campaign"
}

explore: narvar_dashboard_emails_accepted_by_campaign {
  group_label: "Marketing"
  hidden: yes
  label: "Narvar emails accepted by campaign"
}

explore: narvar_dashboard_notification_clicks_by_category {
  group_label: "Marketing"
  hidden: yes
  label: "Narvar clicks by category"
}

explore: narvar_dashboard_notify_metrics {
  group_label: "Marketing"
  hidden: yes
  label: "Narvar notify metrics"
}

explore: narvar_customer_feedback {
  group_label: "Marketing"
  hidden: no
  label: "Narvar customer feedback"
}

  explore: cordial_bulk_message {
    group_label: "Cordial"
    hidden: yes
    label: "Cordial Information"
    join: cordial_activity{
      type: left_outer
      sql_on: ${cordial_bulk_message.bm_id} = ${cordial_activity.bm_id} ;;
      relationship: one_to_many
    }}

#-------------------------------------------------------------------
#
# Customer Care Explores
#
#-------------------------------------------------------------------

explore: customer_satisfaction_survey {
  label: "Agent CSAT"
  group_label: "Customer Care"
  hidden: yes
  description: "Customer satisfaction of interactions with Customer Care agents"
    join: agent_lkp {
      type: left_outer
      sql_on: ${customer_satisfaction_survey.agent_id}=${agent_lkp.zendesk_id} ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${customer_satisfaction_survey.created_date}
        AND ${team_lead_name.end_date}>=${customer_satisfaction_survey.created_date};;
      relationship: many_to_one
    }
    join: stella_connect_request {
      type: left_outer
      sql_on: ${stella_connect_request.employee_id} = ${agent_lkp.incontact_id}  ;;
      relationship: many_to_one
    }
}
explore: rpt_agent_stats {
  hidden: yes
  label: "InContact Agent Stats"
  group_label: "Customer Care"
  description: "From InContact Agent Stats Daily."
}

explore: refund_mismatch {
  label: "Refund Mismatch"
  group_label: "Customer Care"
  hidden: yes
  description: "NetSuite refunds missing in Shopify"
}

explore: shopify_coupon_code {
  label: "Shopify Coupon Code"
  group_label: "Customer Care"
  hidden: yes
  description: "Shopify Orders with Coupon Code"
}

explore: shopify_net_payment {
  label: "Shopify Net Payment"
  group_label: "Customer Care"
  hidden: yes
  description: "Shopify Orders with Customer's Net Payment Under $10"
}

explore: amazon_orphan_orders {
  label: "Amazon Orphan Orders"
  group_label: "Customer Care"
  hidden: yes
  description: "Amazon orders not showing up in Netsuite"
}

explore: rma_status_log {
  label: "RMA Status Log"
  group_label: "Customer Care"
  description: "Log of RMA status change"
  join: item {
    type: left_outer
    sql_on: ${rma_status_log.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
}

explore: zendesk_chats {
  label: "Zendesk Website Chats"
  group_label: "Customer Care"
  hidden: yes
}

explore: ticket {
  hidden: yes
  group_label: "Customer Care"
  label: "Zendesk Tickets"
  description: "Customer ticket details from Zendesk"
  join: group {
    type: full_outer
    sql_on: ${group.id} = ${ticket.group_id} ;;
    relationship: many_to_one
  }
  join: user {
    view_label: "Assignee"
    type: left_outer
    sql_on: ${user.id} = ${ticket.assignee_id} ;;
    relationship: many_to_one
  }
#     join: ticket_form_history {
#       type: full_outer
#       sql_on: ${group.id} = ${ticket.group_id} ;;
#       relationship: many_to_one
#     }
}

explore: daily_disposition_counts {
  group_label: "Customer Care"
  description: "Count of tickets and calls by disposition"
  hidden: yes
}

explore: rpt_skill_with_disposition_count {
  label: "Inbound Calls"
  group_label: "Customer Care"
  description: "All inbound calls segmented by skill and disposition (rpt skills with dispositions)"
}

explore: agent_lkp {
  hidden: yes
  label: "Agents"
  group_label: "Customer Care"
  join: agent_company_value {
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${agent_company_value.agent_id} ;;
    relationship: one_to_many}
  join: agent_evaluation {
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${agent_evaluation.evaluated_id} ;;
    relationship: one_to_many}
  join: rpt_agent_stats {
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${rpt_agent_stats.agent_id} ;;
    relationship: one_to_many}
  join: v_agent_state {
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${v_agent_state.agent_id} ;;
    relationship: one_to_many}
  join: agent_attendance{
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${agent_attendance.agent_id} ;;
    relationship: one_to_many}
  join: agent_draft_orders {
    type: left_outer
    sql_on: ${agent_lkp.shopify_id} = ${agent_draft_orders.user_id} ;;
    relationship: one_to_many}
  join: customer_satisfaction_survey {
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${customer_satisfaction_survey.agent_id}  ;;
    relationship:  one_to_many
  }
  join: stella_connect_request {
    type: left_outer
    sql_on: ${stella_connect_request.employee_id} = ${agent_lkp.incontact_id}  ;;
    relationship: many_to_one
  }
  join: team_lead_name {
    type:  left_outer
    sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${customer_satisfaction_survey.created_date}
        AND ${team_lead_name.end_date}>=${customer_satisfaction_survey.created_date};;
    relationship: many_to_one
  }
  required_access_grants: [is_customer_care_manager]
}

access_grant: is_customer_care_manager{
  user_attribute: is_customer_care_manager
  allowed_values: [ "yes" ]
}

explore: cc_agent_data {
  hidden: yes
  from:  agent_lkp
  label: "CC Agent Data"
  group_label: "Customer Care"
  join: agent_company_value {
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${agent_company_value.agent_id} ;;
    relationship: one_to_many}
  join: agent_evaluation {
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${agent_evaluation.evaluated_id};;
    relationship: one_to_one}
  join: rpt_agent_stats {
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${rpt_agent_stats.agent_id} ;;
    relationship: one_to_many}
  join: agent_attendance{
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${agent_attendance.agent_id} ;;
    relationship: one_to_many}
  join: agent_draft_orders {
    type: left_outer
    sql_on: ${cc_agent_data.shopify_id} = ${agent_draft_orders.user_id} ;;
    relationship: one_to_many}
  join: v_agent_state {
    type: full_outer
    sql_on:  ${cc_agent_data.incontact_id}= ${v_agent_state.agent_id};;
    relationship:  one_to_many}
  join: customer_satisfaction_survey {
    type: left_outer
    sql_on: ${cc_agent_data.zendesk_id} = ${customer_satisfaction_survey.agent_id}  ;;
    relationship:  one_to_many}
  join: team_lead_name {
    type:  left_outer
    sql_on:  ${team_lead_name.incontact_id}=${cc_agent_data.incontact_id}
       and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
      #and ${cc_agent_data.created_date}::date >= ${team_lead_name.start_date}::date;;
    relationship: one_to_one
  }
  required_access_grants: [is_customer_care_manager]
}

explore: agent_company_value {  hidden: yes  label: "Agent Company Value"  group_label: "Customer Care"}
explore: agent_evaluation {  hidden: yes  label: "Agent Evaluation"  group_label: "Customer Care"}
explore: agent_attendance {  hidden: yes  label: "Agent Attendance"  group_label: "Customer Care"}
explore: v_agent_state  { hidden:  yes  label: "Agent Time States"  group_label: "Customer Care"}
explore: stella_response {hidden:yes}
explore: zendesk_sell_contact {hidden:yes}
explore: zendesk_sell_deal {hidden:yes}
explore: zendesk_sell_user {hidden:yes}
explore: exchange_items {hidden: yes
  join: item {
      type:  left_outer
      sql_on:  ${item.item_id} = ${exchange_items.original_order_item_id} ;;
      relationship: many_to_one
      view_label: "Original Item"}
  join: item_2 {
    from: item
    type:  left_outer
    sql_on:  ${item.item_id} = ${exchange_items.exchange_order_item_id} ;;
    relationship: many_to_one
    view_label: "Exchange Item"}}
explore: qualtrics {hidden:yes
  from: qualtrics_answer
    view_label: "Answer"
  join: qualtrics_response {
    type: left_outer
    sql_on: ${qualtrics.response_id = ${qualtrics_response.response_id} and ${qualtrics.survey_id = ${qualtrics_response.survey_id} ;;
    relationship: many_to_one
    view_label: "Response"}
  join: qualtrics_customer {
    type: left_outer
    sql_on: ${qualtrics_response.recipient_email} = ${qualtrics_customer.email} ;;
    relationship: many_to_one
    view_label: "Customer"}
  join: qualtrics_survey {
    type: left_outer
    sql_on: ${qualtrics.survey_id} = ${qualtrics_survey.id} ;;
    relationship: many_to_one
    view_label: "Survey"}}

  explore: cc_call_service_level_csl { description: "Calculated service levels" hidden: yes group_label: "Customer Care" }

#-------------------------------------------------------------------
#
# Sales Explores
#
#-------------------------------------------------------------------




  explore: mattress_firm_sales {hidden:no
    label: "Mattress Firm"
    group_label: " Sales"
    view_label: "Store Details"
    join: mattress_firm_store_details {
      view_label: "Store Details"
      sql_on: ${mattress_firm_store_details.store_id} = ${mattress_firm_sales.store} ;;
      type: left_outer
      relationship: many_to_one}
    join: mattress_firm_item {
      view_label: "Store Details"
      sql_on: ${mattress_firm_item.mf_sku} = ${mattress_firm_sales.product_id} ;;
      type:  left_outer
      relationship: many_to_one}
    join: item {
      view_label: "Product"
      sql_on: ${item.item_id} = ${mattress_firm_item.item_id} ;;
      type: left_outer
      relationship: many_to_one}
}

explore: mattress_firm_po_detail {
  hidden: yes
  label: "Mattress Firm POD"
  group_label: "Wholesale"
}

explore: wholesale_mfrm_manual_asn  {
  hidden:  yes
  label: "Wholesale Mattress Firm Manual ASN"
  group_label: "Wholesale"
}

explore: sales_order_line{
  from:  sales_order_line
  label:  "DTC"
  group_label: " Sales"
  view_label: "Sales Order Line"
  view_name: sales_order_line
  description:  "All sales orders for DTC channel"
  always_join: [fulfillment]
  always_filter: {
    filters: {field: sales_order.channel      value: "DTC"}
    filters: {field: item.merchandise         value: "No"}
    filters: {field: item.finished_good_flg   value: "Yes"}
    filters: {field: item.modified            value: "Yes"}}
  join: sf_zipcode_facts {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${sales_order_line.zip_1}::varchar = (${sf_zipcode_facts.zipcode})::varchar ;;
    relationship: many_to_one}
  join: zcta5 {
    view_label: "Geography"
    type:  left_outer
    sql_on: ${sales_order_line.zip_1}::varchar = (${zcta5.zipcode})::varchar AND ${sales_order_line.state} = ${zcta5.state};;
    relationship: many_to_one}
  join: dma {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
    relationship: many_to_many}
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${sales_order_line.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: fulfillment {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} and ${fulfillment.status} = 'Shipped' ;;
    relationship: one_to_many}
  join: visible {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${sales_order_line.order_id} = ${visible.order_id} and ${sales_order_line.item_id} = ${visible.item_id} ;;
    relationship: one_to_many}
  join: sales_order {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
    relationship: many_to_one}
  join: wholesale_customer_warehouses {
    view_label: "Wholesale Warehouses"
    type: left_outer
    sql_on: ${sales_order_line.street_address} = ${wholesale_customer_warehouses.street_address} and ${wholesale_customer_warehouses.customer_id} = ${sales_order.customer_id} ;;
    relationship: many_to_one}
  join: shopify_orders {
    view_label: "Sales Order Line"
    type:  left_outer
    fields: [shopify_orders.call_in_order_Flag]
    sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    relationship:  many_to_many}
  join: return_order_line {
    view_label: "Returns"
    type: full_outer
    sql_on: ${sales_order_line.item_order} = ${return_order_line.item_order} ;;
    relationship: one_to_many}
  join: return_order {
    view_label: "Returns"
    type: full_outer
    required_joins: [return_order_line]
    sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
    relationship: many_to_one}
  join: return_reason {
    view_label: "Returns"
    type: full_outer
    sql_on: ${return_reason.list_id} = ${return_order.return_reason_id} ;;
    relationship: many_to_one}
  join: return_option {
    view_label: "Returns"
    type: left_outer
    sql_on: ${return_option.list_id} = ${return_order.return_option_id} ;;
    relationship: many_to_one}
  join: restocked_warranties {
    from: restocked_returns
    view_label: "Warranties"
    # This view is used to calculate the total Restocked Units for items from both Warranties and Returns.
    # This view is joined in twice to display the same measure under the Returns and Warranties Views.
    type: left_outer
    relationship: one_to_one
    required_joins: [warranty_order_line]
    sql_on:
    ( ${restocked_warranties.original_transaction_id} = ${return_order_line.return_order_id} and ${restocked_warranties.item_id} = ${return_order_line.item_id} ) OR
    ( ${restocked_warranties.original_transaction_id} = ${warranty_order_line.warranty_order_id} and ${restocked_warranties.item_id} = ${warranty_order_line.item_id} ) ;; }
  join: restocked_returns {
    from: restocked_returns
    view_label: "Returns"
    # This view is used to calculate the total Restocked Units for items from both Warranties and Returns.
    # This view is joined in twice to display the same measure under the Returns and Warranties Views.
    type: left_outer
    relationship: one_to_one
    required_joins: [warranty_order_line]
    sql_on:
    ( ${restocked_returns.original_transaction_id} = ${return_order_line.return_order_id} and ${restocked_returns.item_id} = ${return_order_line.item_id} ) OR
    ( ${restocked_returns.original_transaction_id} = ${warranty_order_line.warranty_order_id} and ${restocked_returns.item_id} = ${warranty_order_line.item_id} ) ;; }
  join: customer_table {
    view_label: "Customer"
    type: left_outer
    sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
    relationship: many_to_one}
  join: retroactive_discount {
    view_label: "Retro Discounts"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${retroactive_discount.item_order_refund} ;;
    relationship: one_to_many}
  join: discount_code {
    view_label: "Retro Discounts"
    type:  left_outer
    sql_on: ${retroactive_discount.discount_code_id} = ${discount_code.discount_code_id} ;;
    relationship: many_to_one}
  join: cancelled_order {
    view_label: "Cancellations"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${cancelled_order.item_order} ;;
    relationship: one_to_one }
  join: NETSUITE_cancelled_reason {
    view_label: "Cancellations"
    type: left_outer
    sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.shopify_cancel_reason_id} ;;
    relationship: many_to_one}
  join: order_flag {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one}
  join: fulfillment_dates {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${fulfillment_dates.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one}
  join: fedex_tracking {
    view_label: "Fulfillment"
    type: full_outer
    sql_on: ${fulfillment.tracking_numbers} = ${fedex_tracking.tracking_number} ;;
    relationship: many_to_one}
  join: state_tax_reconciliation {
    view_label: "State Tax Reconciliation"
    type: left_outer
    sql_on: ${state_tax_reconciliation.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_many}
  join: shopify_discount_codes {
    view_label: "Promo"
    type: left_outer
    sql_on: ${shopify_discount_codes.shopify_order_name} = ${sales_order.related_tranid} ;;
    relationship: many_to_many}
  join: marketing_sms_codes {
    view_label: "Promo"
    type: left_outer
    sql_on: lower(coalesce(${sales_order.shopify_discount_code},${shopify_discount_codes.promo})) = lower(${marketing_sms_codes.sms}) ;;
    relationship:many_to_many}
  join: marketing_promo_codes {
    view_label: "Promo"
    type: left_outer
    sql_on: lower(${marketing_promo_codes.promo}) = lower(coalesce(${marketing_sms_codes.promo},${sales_order.shopify_discount_code},${shopify_discount_codes.promo})) ;;
    relationship: many_to_one}
  join: first_order_flag {
    view_label: "Sales Header"
    type: left_outer
    sql_on: ${first_order_flag.pk} = ${sales_order.order_system} ;;
    relationship: one_to_one}
  join: account_manager { from: entity view_label: "Customer" type:left_outer relationship:many_to_one
    sql_on: ${customer_table.account_manager_id} = ${account_manager.entity_id} ;;}
    join: sales_manager { from: entity view_label: "Customer" type:left_outer relationship:many_to_one
      sql_on: ${customer_table.sales_manager_id} = ${sales_manager.entity_id} ;;}
  join: warranty_order {
      view_label: "Warranties"
      type: full_outer
      #required_joins: [warranty_order_line]
      sql_on: ${sales_order.order_id} = ${warranty_order.order_id} and ${sales_order.system} = ${warranty_order.original_system} ;;
      #sql_on: ${warranty_order_line.order_id} = ${warranty_order.order_id} ;;
      relationship: one_to_many}
  join: warranty_order_line {
    view_label: "Warranties"
    type:  full_outer
    sql_on: ${warranty_order_line.system} = ${warranty_order.original_system} and ${warranty_order_line.order_id} = ${warranty_order.order_id} ;;
    #sql_on: ${warranty_order_line.item_order} = ${sales_order_line.item_order};;
    relationship: many_to_many}
  join: warranty_reason {
    view_label: "Warranties"
    type: left_outer
    required_joins: [warranty_order]
    sql_on: ${warranty_order.warranty_reason_code_id} = ${warranty_reason.list_id} ;;
    relationship: many_to_one}
  join: c3_conversion_ft_lt {
    view_label: "Marketing Attribution"
    type:  full_outer
    sql_on: ${sales_order.order_id}=${c3_conversion_ft_lt.analytics_order_id} ;;
    relationship: one_to_one}
  join: mymove {
    view_label: "Marketing Attribution"
    type: left_outer
    sql_on: ${mymove.order_id} = ${sales_order.order_id} and ${mymove.system} = ${sales_order.system} ;;
    relationship: one_to_one
  }
  join : slicktext_textword {
    view_label: "Promo"
    type:full_outer
    sql_on:  ${slicktext_textword.word}=${shopify_discount_codes.promo} ;;
    relationship: many_to_many}
  join: slicktext_contact {
    view_label: "Promo"
    type: full_outer
    sql_on: ${slicktext_textword.id}=${slicktext_contact.textword_id} ;;
    relationship: one_to_many}
  join: slicktext_opt_out {
    view_label: "Promo"
    type: full_outer
    sql_on: ${slicktext_contact.email}=${slicktext_opt_out.email} ;;
    relationship: many_to_many}
  join: standard_cost {
    view_label: "Product"
    type: left_outer
    sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
    relationship: one_to_one}
  join: referral_sales_orders {
    type: left_outer
    sql_on: ${sales_order.order_id}=${referral_sales_orders.order_id_referral} ;;
    relationship: one_to_one
  }
  join: affiliate_sales_order {
    type: left_outer
    sql_on: ${sales_order.related_tranid}=${affiliate_sales_order.order_id} ;;
    relationship: one_to_one
  }
  join: zipcode_radius {
    type: left_outer
    sql_on: ${sf_zipcode_facts.zipcode}=${zipcode_radius.zipcode} ;;
    relationship: one_to_many
  }
  join: shopify_discount_titles {
    type: left_outer
    sql_on: ${shopify_discount_titles.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one
  }
  join: mainchain_transaction_outwards_detail {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${mainchain_transaction_outwards_detail.order_id} = ${sales_order.order_id} and ${sales_order_line.item_id} = ${mainchain_transaction_outwards_detail.item_id}
      and ${mainchain_transaction_outwards_detail.system} = ${sales_order.system} ;;
    relationship: one_to_many
  }
  join: calls_to_orders {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${calls_to_orders.order_id}::string =  ${sales_order.etail_order_id}::string;;
    relationship: many_to_one
  }
  join: exchange_order_line {
    view_label: "Returns"
    type: left_outer
    sql_on: ${sales_order_line.order_id} = ${exchange_order_line.order_id} and ${sales_order_line.item_id} = ${exchange_order_line.item_id}
    and ${sales_order_line.system} = ${exchange_order_line.system} ;;
    relationship: one_to_many
  }
  join: exchange_order {
    view_label: "Returns"
    type: left_outer
    sql_on: ${exchange_order_line.exchange_order_id} = ${exchange_order.exchange_order_id} and ${exchange_order_line.replacement_order_id} = ${exchange_order.replacement_order_id} ;;
    relationship: many_to_one
  }
  join: zendesk_sell {
    view_label: "Zendesk Sell"
    type: full_outer
    sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
    relationship: one_to_one
  }
  join: warranty_original_information {
    view_label: "Warranties"
    type: left_outer
    sql_on: ${sales_order.order_id} = ${warranty_original_information.replacement_order_id} and ${item.sku_merged} = ${warranty_original_information.sku_merged} ;;
    relationship: one_to_one
  }
  join: first_purchase_date {
    view_label: "Customer"
    type: left_outer
    sql_on: ${first_purchase_date.email} = ${sales_order.email} ;;
    relationship: one_to_one
  }
  join: agent_name {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${agent_name.shopify_id}=${shopify_orders.user_id} ;;
    relationship: many_to_one
  }
  join: promotions_combined {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${sales_order_line.created_date} = ${promotions_combined.promotion_date} ;;
  relationship: one_to_one
  }
  join: highjump_fulfillment {
    view_label: "Highjump"
    type: left_outer
    sql_on: ${sales_order.tranid} = ${highjump_fulfillment.transaction_number} AND ${item.sku_clean} = ${highjump_fulfillment.sku} ;;
    relationship: one_to_many
  }
  join: v_transmission_dates {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${sales_order_line.order_id} = ${v_transmission_dates.order_id} and ${sales_order_line.system} = ${v_transmission_dates.system} and ${sales_order_line.item_id} = ${v_transmission_dates.item_id} ;;
    relationship: one_to_one
  }
  join: pilot_daily {
    view_label: "Fulfillment"
    type: full_outer
    relationship: many_to_one
    sql_on: ${pilot_daily.order_id} =  ${sales_order.order_id};;
  }
  join: optimizely_experiment_lookup {
    view_label: "Sales Order"
    type: left_outer
    relationship: one_to_many
    sql_on: ${sales_order.related_tranid} = ${optimizely_experiment_lookup.shopify_order_id} ;;
  }
  join: item_price {
    view_label: "Product"
    type: left_outer
    relationship: many_to_many
    sql_on: ${sales_order_line.item_id} = ${item_price.item_id} and ${sales_order.trandate_date} between ${item_price.start_date} and ${item_price.end_date} ;;
  }
    join: v_chat_sales {
      view_label: "Zendesk Chats"
      type: left_outer
      relationship: one_to_one
      sql_on: ${v_chat_sales.order_id} = ${sales_order.order_id} and ${v_chat_sales.system} = ${sales_order.system};;
  }
    join: zendesk_chats {
      view_label: "Zendesk Chats"
      type: left_outer
      relationship: many_to_many
      sql_on: ${v_chat_sales.chat_id} = ${zendesk_chats.chat_id};;
  }
    join: item_return_rate {
      type: left_outer
      relationship: one_to_one
      sql_on: ${item.sku_id} = ${item_return_rate.sku_id}  ;;
    }
    join: shipping {
      type: left_outer
      relationship: one_to_one
      sql_on: ${sales_order_line.item_id} = ${shipping.item_id} and ${sales_order_line.order_id} = ${shipping.order_id}  ;;
    }
}

explore: v_intransit { hidden: yes  label: "In-Transit Report"  group_label: " Sales"}
explore: accessory_products_to_mattress {hidden: yes label: "Accessory Products to Mattress" group_label: " Sales"}
explore: store_locations_3_mar2020 {hidden: yes label:"Wholesale and Retail Locations"}

explore: wholesale {
  extends: [sales_order_line]
  label:  "Wholesale"
  group_label: " Sales"
  view_label: "Sales Order Line"
  description:  "All sales orders for wholesale channel"
  always_join: [fulfillment]
  always_filter: {
    filters: {field: sales_order.channel      value: "Wholesale"}
  }
}

explore: wholesale_legacy {
  from: sales_order_line
  label:  "Wholesale"
  hidden: yes
  group_label: " Sales"
  view_label: "Sales Order Line"
  description:  "All sales orders for wholesale channel"
  always_join: [fulfillment]
  always_filter: {
    filters: {field: sales_order.channel      value: "Wholesale"}
    filters: {field: item.merchandise         value: "No"}
    filters: {field: item.finished_good_flg   value: "Yes"}
    filters: {field: item.modified            value: "Yes"}}
  join: sales_order_line
    {type:left_outer
      sql_on:${shopify_orders.order_ref}=${sales_order_line.order_id}::string;;
      relationship: one_to_one
      fields:[total_units]}
  join: sf_zipcode_facts {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${wholesale_legacy.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
    relationship: many_to_one}
  join: dma {
    view_label: "Customer"
    type:  left_outer
    sql_on: ${wholesale_legacy.zip} = ${dma.zip} ;;
    relationship: many_to_one}
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${wholesale_legacy.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: fulfillment {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${wholesale_legacy.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
    relationship: one_to_many}
  join: sales_order {
    view_label: "Sales Header"
    type: left_outer
    sql_on: ${wholesale_legacy.order_system} = ${sales_order.order_system} ;;
    relationship: many_to_one}
  join: shopify_orders {
    view_label: "Sales Order Line"
    type:  left_outer
    fields: [shopify_orders.call_in_order_Flag]
    sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    relationship:  one_to_one}
  join: return_order_line {
    view_label: "Returns"
    type: full_outer
    sql_on: ${wholesale_legacy.item_order} = ${return_order_line.item_order} ;;
    relationship: one_to_many}
  join: return_order {
    view_label: "Returns"
    type: full_outer
    required_joins: [return_order_line]
    sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
    relationship: many_to_one}
  join: return_reason {
    view_label: "Returns"
    type: full_outer
    sql_on: ${return_reason.list_id} = ${return_order.return_reason_id} ;;
    relationship: many_to_one}
  join: return_option {
    view_label: "Returns"
    type: left_outer
    sql_on: ${return_option.list_id} = ${return_order.return_option_id} ;;
    relationship: many_to_one}
  join: restocked_returns {
    view_label: "Returns"
    type: left_outer
    relationship: one_to_one
    required_joins: [return_order_line]
    sql_on: ${restocked_returns.return_order_id} = ${return_order_line.return_order_id} and ${restocked_returns.item_id} = ${return_order_line.item_id};;}
  join: customer_table {
    view_label: "Customer"
    type: left_outer
    sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
    relationship: many_to_one}
  join: retroactive_discount {
    view_label: "Retro Discounts"
    type: left_outer
    sql_on: ${wholesale_legacy.item_order} = ${retroactive_discount.item_order_refund} ;;
    relationship: one_to_many}
  join: discount_code {
    view_label: "Retro Discounts"
    type:  left_outer
    sql_on: ${retroactive_discount.discount_code_id} = ${discount_code.discount_code_id} ;;
    relationship: many_to_one}
  join: cancelled_order {
    view_label: "Cancellations"
    type: left_outer
    sql_on: ${wholesale_legacy.item_order} = ${cancelled_order.item_order} ;;
    relationship: one_to_many}
  join: NETSUITE_cancelled_reason {
    view_label: "Cancellations"
    type: left_outer
    sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.shopify_cancel_reason_id} ;;
    relationship: many_to_one}
  join: order_flag {
    view_label: "Sales Header"
    type: left_outer
    sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one}
  join: fulfillment_dates {
    view_label: "Fulfillment"
    type: left_outer
    sql_on: ${fulfillment_dates.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one}
  join: account_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
    sql_on: ${customer_table.account_manager_id} = ${account_manager.entity_id} ;;}
  join: sales_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
    sql_on: ${customer_table.sales_manager_id} = ${sales_manager.entity_id} ;;}
    join: standard_cost {
      view_label: "Product"
      type: left_outer
      sql_on: ${standard_cost.item_id} = ${item.item_id};;
      relationship:one_to_one}
  join: v_transmission_dates {
    view_label: "V Transmission Dates"
    type: left_outer
    sql_on: ${sales_order_line.order_id} = ${v_transmission_dates.order_id} and ${sales_order_line.system} = ${v_transmission_dates.system} and ${sales_order_line.item_id} = ${v_transmission_dates.item_id} ;;
    relationship: one_to_one}
  join: zendesk_sell {
    view_label: "Zendesk Sell"
    type: full_outer
    sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
    relationship: one_to_one
  }
  join: affiliate_sales_order {
    type: left_outer
    sql_on: ${sales_order.related_tranid}=${affiliate_sales_order.order_id} ;;
    relationship: one_to_one
  }
  join: item_return_rate {
    type: left_outer
    relationship: one_to_one
    sql_on: ${item.sku_id} = ${item_return_rate.sku_id}  ;;
  }
  join: agent_name {
    view_label: "Sales Order"
    type: left_outer
    sql_on: ${agent_name.shopify_id}=${shopify_orders.user_id} ;;
    relationship: many_to_one
  }
}


explore: warranty {
from: warranty_order
fields: [ALL_FIELDS*, -warranty_order_line.quantity_complete]
label: "Warranty"
group_label: " Sales"
description: "Current warranty information (not tied back to original sales orders yet)"
join: warranty_reason {
  type: left_outer
  sql_on: ${warranty.warranty_reason_code_id} = ${warranty_reason.list_id} ;;
  relationship: many_to_one}
join: warranty_order_line {
  type:  left_outer
  sql_on: ${warranty.warranty_order_id} = ${warranty_order_line.warranty_order_id};;
  relationship: one_to_many}
join: item {
  type:  left_outer
  sql_on: ${warranty_order_line.item_id} = ${item.item_id} ;;
  required_joins: [warranty_order_line]
  relationship: many_to_one}
}

explore: logan_fulfillment {
  description: "Stop gap on fulfillment data"
  hidden: yes
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${logan_fulfillment.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
}

explore: return_form_entry {
  hidden: yes
  label: "Return Form"
  description: "Entries from Customer Care Return Forms"
  join: return_form_reason {
    type: left_outer
    sql_on: ${return_form_entry.entry_id} = ${return_form_reason.entry_id} ;;
    relationship: one_to_many}
}

explore: affirm_daily_lto_funnel {hidden:yes}
explore: v_first_data_order_num {label: "FD Order Numbers" group_label: "Accounting" hidden:yes}
explore: v_affirm_order_num {label: "Affirm Order Numbers" group_label: "Accounting" hidden:yes}
explore: v_amazon_order_num {label: "Amazon Order Numbers" group_label: "Accounting" hidden:yes}
explore: v_paypal_order_num {label: "Paypal Order Numbers" group_label: "Accounting" hidden:yes}
explore: v_braintree_order_num {label: "Braintree Order Numbers" group_label: "Accounting" hidden:yes}
explore: v_braintree_to_netsuite {label: "Braintree to Netsuite" group_label: "Accounting" hidden:yes}
explore: v_affirm_to_netsuite {label: "Affirm to Netsuite" group_label: "Accounting" hidden:yes}
explore: v_shopify_payment_to_netsuite {label: "Shopify Payment to Netsuite" group_label: "Accounting" hidden:yes}
explore: v_amazon_pay_to_netsuite {label: "Amazon Pay to Netsuite" group_label: "Accounting" hidden:yes}
explore: v_stripe_to_netsuite {label: "Amazon Pay to Netsuite" group_label: "Accounting" hidden:yes}
explore: v_first_data_to_netsuite {label: "First Data to Netsuite" group_label: "Accounting" hidden:yes}
explore: warranty_timeline {
  label: "Warranty Timeline"
  group_label: "Accounting"
  hidden:yes
  join: item {
    view_label: "Item"
    type:  left_outer
    sql_on: ${item.item_id} = ${warranty_timeline.item_id};;
    relationship: many_to_one}
  }


explore: day_aggregations {
  label: "Data By Date"
  description: "Sales, Forecast, Adspend, aggregated to a day (for calculating ROAs, and % to Goal)"
  from: day_aggregations
  group_label: " Sales"
  hidden:no }


#-------------------------------------------------------------------
#
# Retail Explores
#
#-------------------------------------------------------------------


explore: procom_security_daily_customer {
  label: "Procom Customers"
  group_label: "Retail"
  hidden:yes
  }

#-------------------------------------------------------------------
#
# eCommerce Explore
#
#-------------------------------------------------------------------

  explore: ecommerce {
    from: sessions
    group_label: "Marketing"
    label: "eCommerce"
    view_label: "Sessions"
    description: "Combined Website and Sales Data - Has Shopify US, doesn't have Amazon, Draft orders, others not related to a website visit"
    hidden: no
    join: session_facts {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${ecommerce.session_id}::string = ${session_facts.session_id}::string ;;
      relationship: one_to_one }
## event_flow not currently used in content.
#   join: event_flow {
#     sql_on: ${all_events.event_id}::string = ${event_flow.unique_event_id}::string ;;
#     relationship: one_to_one }
      join: zip_codes_city {
        type: left_outer
        sql_on: ${ecommerce.city} = ${zip_codes_city.city} and ${ecommerce.region} = ${zip_codes_city.state_name} ;;
        relationship: one_to_one }
      join: dma {
        type:  left_outer
        sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
        relationship: one_to_one }
      join: date_meta {
        type: left_outer
        sql_on: ${date_meta.date}::date = ${ecommerce.time_date}::date;;
        relationship: one_to_many }
      join: heap_page_views {
        type: left_outer
        sql_on: ${heap_page_views.session_id} = ${ecommerce.session_id} ;;
        relationship: one_to_many }
      join: users {
        type: left_outer
        sql_on: ${ecommerce.user_id}::string = ${users.user_id}::string ;;
        relationship: many_to_one }
      join: heap_all_events_subset {
        type: left_outer
        sql_on: ${ecommerce.user_id}::string = ${heap_all_events_subset.user_id}::string ;;
        relationship: many_to_one }


      join: ecommerce1 {
        type: left_outer
        sql_on: ${ecommerce.session_id}::string = ${ecommerce1.session_id}::string ;;
        relationship: many_to_one
        #and order id = ${ecommerce1.order_number} ? combination of session id and order number is the primary key
    }
      join: sales_order {
        type:  left_outer
        sql_on: ${ecommerce1.order_number} = ${sales_order.related_tranid} ;;
        fields: [sales_order.tranid,sales_order.system,sales_order.related_tranid,sales_order.source,sales_order.payment_method,sales_order.order_id,sales_order.warranty_order_flg,sales_order.is_upgrade,sales_order.Amazon_fulfillment,sales_order.gross_amt,sales_order.dtc_channel_sub_category,sales_order.total_orders,sales_order.payment_method_flag,sales_order.channel2,sales_order.channel_source,sales_order.Order_size_buckets,sales_order.max_order_size,sales_order.min_order_size,sales_order.average_order_size,sales_order.tax_amt_total]
        relationship: one_to_one }

      join: order_flag {
        type: left_outer
        sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
        relationship:  one_to_one }

      join: sales_order_line_base {
        type:  left_outer
        sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} ;;
        relationship: one_to_many
         }

      join: item {
        view_label: "Product"
        type: left_outer
        sql_on: ${sales_order_line_base.item_id} = ${item.item_id} ;;
        relationship: many_to_one}

      join: hotjar_data {
        view_label: "Post-Purchase Survey"
        type: left_outer
        sql_on:  sales email = hotjar email ;;
        relationship: one_to_one }

      join: hotjar_whenheard {
        view_label: "Post-Purchase Survey"
        type:  left_outer
        sql_on: ${hotjar_data.token} = ${hotjar_whenheard.token} ;;
        relationship: many_to_one}
      join: daily_qualified_site_traffic_goals {
        view_label: "Sessions"
        type: full_outer
        sql_on: ${daily_qualified_site_traffic_goals.date}::date = ${ecommerce.time_date}::date ;;
        relationship: many_to_one
        }

        # added after table was built
      join: customer_table {
        view_label: "Customer"
        type: left_outer
        sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
        fields: [customer_table.customer_id,customer_table.customer_id,customer_table.email,customer_table.full_name,customer_table.shipping_hold,customer_table.phone,customer_table.hold_reason_id,customer_table.shipping_hold]
        relationship: many_to_one}
      join: first_purchase_date {
        view_label: "Customer"
        type: left_outer
        sql_on: ${first_purchase_date.email} = ${sales_order.email} ;;
        relationship: one_to_one}
      join: shopify_discount_codes {
        view_label: "Promo"
        type: left_outer
        sql_on: ${shopify_discount_codes.shopify_order_name} = ${sales_order.related_tranid} ;;
        relationship: many_to_many}

  }

#-------------------------------------------------------------------
# Old/Bad Explores
#-------------------------------------------------------------------

  explore: forecast_historical_legacy {label: "Historical Forecasts" group_label: "Sales" description: "Unioned forecasts with a forecast made date for separating"
    hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${forecast_historical_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: forecast_wholesale_dim_legacy {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${forecast_wholesale_dim_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  #explore: forecast_dtc { from: forecast label: "Combined Forecast" group_label: "Sales"  hidden: yes
   # join: forecast_wholesale_legacy {type: full_outer sql_on: ${forecast_dtc.sku_id} = ${forecast_wholesale_legacy.sku_id} and ${forecast_dtc.date_date} = ${forecast_wholesale_legacy.date_date};; relationship: one_to_one}
    #join: item {view_label: "Product" type: left_outer sql_on: coalesce(${forecast_wholesale_legacy.sku_id},${forecast_dtc.sku_id}) = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: forecast_retail_legacy {label: "Retail Forecast" group_label: "In Testing"  hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${forecast_retail_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: forecast_legacy_amazon {hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${forecast_legacy_amazon.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: forecast_legacy {label: "DTC Forecast" group_label: "In Testing"  hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${forecast_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: forecast_wholesale_legacy {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
      join: item {view_label: "Product" type: left_outer sql_on: ${forecast_wholesale_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: wholesale_stores {hidden: yes}
  explore: deleted_fulfillment {hidden: yes}
  explore: problem_order {hidden: yes label: "List of orders that are problematic, either for fraud, or excessive refunds/returns"}
  explore: fraud_warning_list {hidden: yes label: "List of orders that could be fraud, and should be checked manually"}
  explore: emp_add {hidden: yes label: "List of employee addresses for mapping purposes"}
  explore: agg_check {hidden: yes  label: "data accuracy"}
  explore: cac {hidden: yes  group_label: "Marketing"  label: "CAC"}
  explore: attribution {hidden: yes  label: "HEAP attribution"  group_label: "Marketing"}
  explore: progressive {hidden: yes  label: "Progressive"  group_label: "x - Accounting"  description: "Progressive lease information."
    join: progressive_funded_lease {type:  left_outer sql_on:  ${progressive.lease_id} = ${progressive_funded_lease.lease_id} ;;
      relationship: one_to_one}}
  explore: sales_targets {hidden:  yes label: "Finance targets"  description: "Monthly finance targets, spread by day"}

  explore: nps_survey_06_dec2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead

  explore: customer_nps_dec_2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead

  explore: product_csat_dec_2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead
  explore: shopify_orders
    { hidden:  yes
      label: "Shopify sales simple"
      description: "Shopify header level information"
    join: sales_order
      {type:left_outer
      sql_on: ${sales_order.etail_order_id}::text = ${shopify_orders.id}::text ;;
      relationship: one_to_one }
    join: sales_order_line
      {type:left_outer
      sql_on:${shopify_orders.order_ref}=${sales_order_line.order_id}::string;;
      relationship: one_to_one
      fields:[total_units]}
    }

  explore: overall_nps_survey_dec2019 {hidden:yes}

  explore:  nps_survey_dec2019 {
    hidden: yes
    label: "NPS Survey"
    join: item {type: full_outer
      sql_on: ${item.item_id} = ${nps_survey_dec2019.item_id};;
      relationship: many_to_one}
  }

  explore: orphan_orders {
    hidden:  yes
    group_label: "Customer Care"
    label: "Orphan orders"
    description: "Orders that exist in Shopify that aren't yet in Netsuite"}
  explore: refund {hidden: yes  group_label: "x - Accounting"  label: "Accounting Refunds"  description: "Refunds on sales at an order level, for accounting."}
  explore: shopify_warranties {hidden: yes  from: orphaned_shopify_warranties  group_label: "x - Accounting"
    label: "Shopify Warranties"  description: "Ties the original order data to NetSuite Warranty Orders where the original order does not exist in NetSuite"
    always_filter: {filters: {field: warranty_created_date value: "last month"}}}
  explore: netsuite_warranty_exceptions { hidden: yes group_label: "x - Accounting" label: "Warranty ModCode Cleanup"
    description: "Provides a list of suspected warranty orders in NetSuite with incorrect references to the original order and/or that are missing a modification code"}


  explore: item {hidden:  yes label: "Transfer and Purchase Orders --old" group_label: "Operations"
    description: "Netsuite data on Transfer and purchase orders"
    join: purchase_order_line {view_label: "Purchase Order"  type: full_outer
      sql_on: ${item.item_id} = ${purchase_order_line.item_id} ;;  relationship: one_to_many}
    join: purchase_order {view_label: "Purchase Order" type:  left_outer
      sql_on: ${purchase_order_line.purchase_order_id} = ${purchase_order.purchase_order_id}  ;; relationship: many_to_one}
    join: bills {view_label: "Bills"  type:  left_outer
      sql_on: ${purchase_order.purchase_order_id} = ${bills.purchase_order_id} ;; relationship: many_to_one}
    join: transfer_order_line {view_label: "Transfer Order" type:  full_outer
      sql_on: ${transfer_order_line.item_id} = ${item.item_id} ;; relationship: one_to_many}
    join: transfer_order {view_label: "Transfer Order"  type:  left_outer required_joins: [transfer_order_line]
      sql_on: ${transfer_order.transfer_order_id} = ${transfer_order_line.transfer_order_id} ;; relationship: many_to_one}
    join: Receiving_Location{from:warehouse_location type:  left_outer
      sql_on: ${transfer_order.receiving_location_id} = ${Receiving_Location.location_id} or ${purchase_order.location_id} = ${Receiving_Location.location_id};;
      relationship: many_to_one}
    join: Transfer_Fulfilling_Location{from:warehouse_location type:  left_outer
      sql_on: ${transfer_order.shipping_location_id} = ${Transfer_Fulfilling_Location.location_id} ;; relationship: many_to_one}
    join: vendor {type:  left_outer sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;; relationship: many_to_one}}
  explore: inventory_valuation {hidden:  yes group_label: "Operations"   label: "Inventory Valuation Snapshot"
    description: "An exported shapshot of inventory by location from netsuite at the end of each month"
    join: item {type:  left_outer sql_on: ${item.item_id} = ${inventory_valuation.item_id} ;; relationship: many_to_one}
    join: warehouse_location {type: left_outer sql_on: ${warehouse_location.location_id} = ${inventory_valuation.location_id} ;; relationship: many_to_one}}
  explore: shipping_times_for_web { hidden: yes group_label: "In Testing" label: "Estimated Fulfillment Times for Web" description: "For use on the web site to give customers an estimate of how long it will take their products to fulfill"
    join: item { type: inner sql_on: ${shipping_times_for_web.item_id} = ${item.item_id} ;; relationship: one_to_one}}
  explore: executive_report { hidden: yes
    join: item { type:inner  sql_on: ${sku_id} = ${item.sku_id};; relationship: one_to_one}}

    explore: russ_order_validation {
      label: "Order Validation"
      description: "Constructed table comparing orders from different sources"
      hidden:yes }

    explore: hour_assumptions {
      label: "Hour Assumptions"
      description: "% of day's sales by hour for dtc day prediction"
      hidden: yes  }

    explore: v_shopify_refund_status { hidden: yes group_label:" Customer Care" }
    explore: v_ns_deleted_lines {hidden: yes group_label:"Customer Care" }
    explore: owned_retail_target_by_location {
      hidden: yes

    }
