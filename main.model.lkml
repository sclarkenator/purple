#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

  connection: "analytics_warehouse"
    include: "*.view"
    #include: "base.model.lkml"
    #include: "main.model.lkml"
    #include: "marketing.model.lkml"

    #include: "*.dashboard"

  datagroup: gross_to_net_sales_default_datagroup {
    # sql_trigger: SELECT MAX(id) FROM etl_log;;
    max_cache_age: "1 hour"}

  persist_with: gross_to_net_sales_default_datagroup
  week_start_day: sunday

datagroup: temp_ipad_database_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: temp_ipad_database_default_datagroup

week_start_day: sunday

explore: production_report {
  label: "iPad Production Data"
  group_label: "Production"
  description: "Connection to the iPad database owned by IT, Machine level production data is stored here"
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
  hidden:  no
  group_label: "Production"
  label: "L2L Dispatch Data"
  description: "The log of all L2L dispatches"

  join: ltol_line {
    type: left_outer
    sql_on: ${ltol_line.line_id} = ${dispatch_info.MACHINE_LINE_ID} ;;
    relationship: many_to_one
  }
}

explore: ltol_pitch {
  label: "L2L Production Pitch Data"
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
  description: "NetSuite Header Level Assembly Data"


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

explore: finance_bill{
  group_label: "Main"
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
  #-------------------------------------------------------------------
  #  Invetory--------------------
  #       \           \          \
  #      Item      Warehouse     Stock
  #                 Locatoin     Level
  #-------------------------------------------------------------------
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
  #-------------------------------------------------------------------
  #  Invetory Snaphot-----------------------
  #               \             \            \
  #              Item        Warehouse      Stock
  #                           Location      Level
  #-------------------------------------------------------------------
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

explore: purcahse_and_transfer_ids {
  #-------------------------------------------------------------------
  #                     transfers-----purchases
  #                        /            \      \
  #                   order_line    purchase    vendor
  #                 /      /    \      line
  #                /      /      \     /   \
  #       receiving  fulfilling   items    bills
  #        location    location
  #-------------------------------------------------------------------
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



#-------------------------------------------------------------------
# Marketing explores
#-------------------------------------------------------------------


  explore: daily_adspend {
    #-------------------------------------------------------------------
    # Daily Spend
    #-------------------------------------------------------------------
    from:  daily_adspend
    hidden: no
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
  hidden: yes
  label: "Narvar customer feedback"
}


#-------------------------------------------------------------------
# Hidden Explores
#-------------------------------------------------------------------

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


  explore: sales_order_line {
  #-------------------------------------------------------------------
  #  DTC
  #Sales Order Line ------------------------------------------------------
  # \   \   \        \           \          \               \           \
  #  \  Zip  \   Fulfillment      \          Return        Retro      Cancellations
  #   \     Item      \          Sales         Order       Discount        \
  #    \             Dates       Orders         Line            \         Reason
  # Contributions              /   |   \          \           Discount
  #                      Shopify   |  Customer    Returns      Code
  #                              Order    \      |      \
  #                              Flag     DMA  Return    Return
  #                                            Reason    Option
  #-------------------------------------------------------------------
    label:  "DTC"
    group_label: "Sales"
    view_label: "Sales Line"
    description:  "All sales orders for DTC channel"
    always_filter: {
      filters: {field: sales_order.channel      value: "DTC"}
      filters: {field: item.merchandise         value: "No"}
      filters: {field: item.finished_good_flg   value: "Yes"}
      filters: {field: item.modified            value: "Yes"}}
    join: sf_zipcode_facts {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${sales_order_line.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
      relationship: many_to_one}
    join: dma {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
      relationship: many_to_one}
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${sales_order_line.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
    join: fulfillment {
      view_label: "Fulfillment"
      type: left_outer
      sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
      relationship: many_to_many}
    join: visible {
      view_label: "Visible"
      type: left_outer
      sql_on: ${sales_order_line.order_id} = ${visible.order_id} and ${sales_order_line.item_id} = ${visible.item_id} ;;
      relationship: many_to_one}
    join: sales_order {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
      relationship: many_to_one}
    join: xpo_data_3_pl{
      view_label: "XPO Hub Data"
      type: left_outer
      sql_on: substring(${sales_order_line.zip},1,5) = ${xpo_data_3_pl.destinationzip} ;;
      relationship: many_to_one}
    #join: manna_data_pull {
    #  view_label: "Mike Shultz Project Data"
    #  type: left_outer
    #  sql_on: ${sales_order.tranid} = ${manna_data_pull.transaction_id} ;;
    #  relationship: one_to_many}
    join: wholesale_customer_warehouses {
      view_label: "Wholesale Warehouses"
      type: left_outer
      sql_on: ${sales_order_line.street_address} = ${wholesale_customer_warehouses.street_address} and ${wholesale_customer_warehouses.customer_id} = ${sales_order.customer_id} ;;
      relationship: many_to_one}
    join: shopify_orders {
      view_label: "Sales Line"
      type:  left_outer
      fields: [shopify_orders.call_in_order_Flag]
      sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
      relationship:  one_to_one}
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
    join: restocked_returns {
      view_label: "Returns"
      type: left_outer
      relationship: one_to_one
      required_joins: [return_order_line]
      sql_on: ${restocked_returns.return_order_id} = ${return_order_line.return_order_id} and ${restocked_returns.item_id} = ${return_order_line.item_id};;
    }
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
    join: fedex_tracking {
      view_label: "Fulfillment"
      type: full_outer
      sql_on: ${fulfillment.tracking_numbers} = ${fedex_tracking.tracking_number} ;;
      relationship: one_to_one}
#    join: contribution {
#      type: left_outer
#      sql_on: ${contribution.contribution_pk} = ${sales_order_line.item_order} ;;
#      relationship: one_to_one}
#    join: cm_pivot {
#      view_label: "x-CM waterfall"
#      type: left_outer
#      sql_on: ${cm_pivot.contribution_pk} = ${sales_order_line.item_order} ;;
#      relationship: one_to_many}
    join: state_tax_reconciliation {
      view_label: "State Tax Reconciliation"
      type: left_outer
      sql_on: ${state_tax_reconciliation.order_id} = ${sales_order.order_id} ;;
      relationship: one_to_one}
    join: shopify_discount_codes {
      view_label: "Promo"
      type: left_outer
      sql_on: ${shopify_discount_codes.shopify_order_name} = ${sales_order.related_tranid} ;;
      relationship: many_to_one}
    join: marketing_sms_codes {
      view_label: "Promo"
      type: left_outer
      sql_on: lower(coalesce(${sales_order.shopify_discount_code},${shopify_discount_codes.promo})) = lower(${marketing_sms_codes.sms}) ;;
      relationship:many_to_one}
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
    join: account_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
      sql_on: ${customer_table.account_manager_id} = ${account_manager.entity_id} ;;}
      join: sales_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
        sql_on: ${customer_table.sales_manager_id} = ${sales_manager.entity_id} ;;}
    join: warranty_order_line {
      view_label: "Warranties"
      type:  full_outer
      sql_on: ${warranty_order_line.item_order} = ${sales_order_line.item_order};;
      relationship: one_to_many}
    join: warranty_order {
      view_label: "Warranties"
      type: full_outer
      required_joins: [warranty_order_line]
      sql_on: ${warranty_order_line.order_id} = ${warranty_order.order_id} ;;
      relationship: many_to_one}
    join: warranty_reason {
      view_label: "Warranties"
      type: left_outer
      required_joins: [warranty_order]
      sql_on: ${warranty_order.warranty_reason_code_id} = ${warranty_reason.list_id} ;;
      relationship: many_to_one}
    }

  explore: wholesale {
    #-------------------------------------------------------------------
    #  Wholesale - for details see DTC ^
    #-------------------------------------------------------------------
      from: sales_order_line
      label:  "Wholesale"
      group_label: "Sales"
      view_label: "Sales Line"
      description:  "All sales orders for wholesale channel"
      always_filter: {
        filters: {field: sales_order.channel      value: "Wholesale"}
        filters: {field: item.merchandise         value: "No"}
        filters: {field: item.finished_good_flg   value: "Yes"}
        filters: {field: item.modified            value: "Yes"}}
    join: sf_zipcode_facts {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${wholesale.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
      relationship: many_to_one}
    join: dma {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${wholesale.zip} = ${dma.zip} ;;
      relationship: many_to_one}
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${wholesale.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
    join: fulfillment {
      view_label: "Fulfillment"
      type: left_outer
      sql_on: ${wholesale.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
      relationship: many_to_many}
    join: sales_order {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${wholesale.order_system} = ${sales_order.order_system} ;;
      relationship: many_to_one}
    join: shopify_orders {
      view_label: "Sales Line"
      type:  left_outer
      fields: [shopify_orders.call_in_order_Flag]
      sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
      relationship:  one_to_one}
    join: return_order_line {
      view_label: "Returns"
      type: full_outer
      sql_on: ${wholesale.item_order} = ${return_order_line.item_order} ;;
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
      sql_on: ${restocked_returns.return_order_id} = ${return_order_line.return_order_id} and ${restocked_returns.item_id} = ${return_order_line.item_id};;
    }
    join: customer_table {
      view_label: "Customer"
      type: left_outer
      sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
      relationship: many_to_one}
    join: retroactive_discount {
      view_label: "Retro Discounts"
      type: left_outer
      sql_on: ${wholesale.item_order} = ${retroactive_discount.item_order_refund} ;;
      relationship: one_to_many}
    join: discount_code {
      view_label: "Retro Discounts"
      type:  left_outer
      sql_on: ${retroactive_discount.discount_code_id} = ${discount_code.discount_code_id} ;;
      relationship: many_to_one}
    join: cancelled_order {
      view_label: "Cancellations"
      type: left_outer
      sql_on: ${wholesale.item_order} = ${cancelled_order.item_order} ;;
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
    }

    explore: sales_order_line_unfiltered {
      view_name: sales_order_line
      description:  "All sales orders for all channels"
      hidden: yes
      #-------------------------------------------------------------------
      #Sales Order Line ------------------------------------------------------
      # \   \   \        \           \          \               \           \
      #  \  Zip  \   Fulfillment      \          Return        Retro      Cancellations
      #   \     Item      \          Sales         Order       Discount        \
      #    \             Dates       Orders         Line            \         Reason
      # Contributions              /   |   \          \           Discount
      #                      Shopify   |  Customer    Returns      Code
      #                              Order    \      |      \
      #                              Flag     DMA  Return    Return
      #                                            Reason    Option
      #-------------------------------------------------------------------"
      always_filter: {
        #filters: {field: sales_order.channel      value: "DTC"}
        filters: {field: item.merchandise         value: "No"}
        filters: {field: item.finished_good_flg   value: "Yes"}
        filters: {field: item.modified            value: "Yes"}}
      join: sf_zipcode_facts {
        view_label: "Customer"
        type:  left_outer
        sql_on: ${sales_order_line.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
        relationship: many_to_one}
      join: dma {
        view_label: "Customer"
        type:  left_outer
        sql_on: ${sales_order_line.zip} = ${dma.zip} ;;
        relationship: many_to_one}
      join: item {
        view_label: "Product"
        type: left_outer
        sql_on: ${sales_order_line.item_id} = ${item.item_id} ;;
        relationship: many_to_one}
      join: fulfillment {
        view_label: "Fulfillment"
        type: left_outer
        sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
        relationship: many_to_many}
      join: visible {
        view_label: "Visible"
        type: left_outer
        sql_on: ${sales_order_line.order_id} = ${visible.order_id} and ${sales_order_line.item_id} = ${visible.item_id} ;;
        relationship: many_to_one}
      join: sales_order {
        view_label: "Sales Header"
        type: left_outer
        sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
        relationship: many_to_one}
      #join: manna_data_pull {
      #  view_label: "Mike Shultz Project Data"
      #  type: left_outer
      #  sql_on: ${sales_order.tranid} = ${manna_data_pull.transaction_id} ;;
      #  relationship: one_to_many}
      join: wholesale_customer_warehouses {
        view_label: "Wholesale Warehouses"
        type: left_outer
        sql_on: ${sales_order_line.street_address} = ${wholesale_customer_warehouses.street_address} and ${wholesale_customer_warehouses.customer_id} = ${sales_order.customer_id} ;;
        relationship: many_to_one}
      join: shopify_orders {
        view_label: "Sales Line"
        type:  left_outer
        fields: [shopify_orders.call_in_order_Flag]
        sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
        relationship:  one_to_one}
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
      join: fedex_tracking {
        view_label: "Fulfillment"
        type: full_outer
        sql_on: ${fulfillment.tracking_numbers} = ${fedex_tracking.tracking_number} ;;
        relationship: one_to_one}
      join: contribution {
        type: left_outer
        sql_on: ${contribution.contribution_pk} = ${sales_order_line.item_order} ;;
        relationship: one_to_one}
      join: cm_pivot {
        view_label: "x-CM waterfall"
        type: left_outer
        sql_on: ${cm_pivot.contribution_pk} = ${sales_order_line.item_order} ;;
        relationship: one_to_many}
      join: state_tax_reconciliation {
        view_label: "State Tax Reconciliation"
        type: left_outer
        sql_on: ${state_tax_reconciliation.order_id} = ${sales_order.order_id} ;;
        relationship: one_to_one}
      join: shopify_discount_codes {
        view_label: "Promo"
        type: left_outer
        sql_on: ${shopify_discount_codes.shopify_order_name} = ${sales_order.related_tranid} ;;
        relationship: many_to_one}
      join: marketing_sms_codes {
        view_label: "Promo"
        type: left_outer
        sql_on: lower(coalesce(${sales_order.shopify_discount_code},${shopify_discount_codes.promo})) = lower(${marketing_sms_codes.sms}) ;;
        relationship:many_to_one}
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
      join: account_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
        sql_on: ${customer_table.account_manager_id} = ${account_manager.entity_id} ;;}
      join: sales_manager { from: entity view_label: "Customer" type:left_outer relationship:one_to_one
        sql_on: ${customer_table.sales_manager_id} = ${sales_manager.entity_id} ;;}
      join: warranty_order_line {
        view_label: "Warranties"
        type:  full_outer
        sql_on: ${warranty_order_line.item_order} = ${sales_order_line.item_order};;
        relationship: one_to_many}
      join: warranty_order {
        view_label: "Warranties"
        type: full_outer
        required_joins: [warranty_order_line]
        sql_on: ${warranty_order_line.order_id} = ${warranty_order.order_id} ;;
        relationship: many_to_one}
      join: warranty_reason {
        view_label: "Warranties"
        type: left_outer
        required_joins: [warranty_order]
        sql_on: ${warranty_order.warranty_reason_code_id} = ${warranty_reason.list_id} ;;
        relationship: many_to_one}
    }

    explore: wholesale_sales {
      extends: [sales_order_line_unfiltered]
      label:  "Wholesale Extended"
      group_label: "Sales"
      description:  "All sales orders for wholesale channel"
      hidden: yes
      always_filter: {
        filters: {field: sales_order.channel      value: "Wholesale"}
      }
    }

    explore: dtc_sales {
      extends: [sales_order_line_unfiltered]
      label:  "DTC Extended"
      group_label: "Sales"
      description:  "All sales orders for DTC channel"
      hidden: yes
      always_filter: {
        filters: {field: sales_order.channel      value: "DTC"}
      }
    }

  explore: warranty {
  #-------------------------------------------------------------------
  #  Warranty--------------------
  #       \           \          \
  #      Warranty   Warranty     Item
  #       Reason     Order Line
  #-------------------------------------------------------------------
    from: warranty_order
    fields: [ALL_FIELDS*, -warranty_order_line.quantity_complete]
    label: "Warranty"
    group_label: "Sales"
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
      relationship: many_to_one}}



  explore: tim_forecast_combined {
      label: "Forecast"
      description: "Combined wholesale and dtc forecast of units and dollars."
      group_label: "Sales"
      #hidden: yes
      join: item {
        view_label: "Product"
        type: left_outer
        sql_on: ${tim_forecast_combined.sku_id} = ${item.sku_id} ;;
        relationship: many_to_one}}



    explore: starship_fulfillment {
      label: "Starship Fulfillments"
      group_label: "Operations"
      hidden: no
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
        relationship: many_to_one

      }

      join: shippedby_user {
        from: starship_users
        view_label: "Shipped By User"
        type: left_outer
        sql_on: ${starship_fulfillment.shippedbyid} = ${shippedby_user.id};;
        relationship: many_to_one

      }
    }

  explore: DTC_prices{
    from:  item_price
    label: "DTC Prices"
    group_label: "Sales"
  }


#    explore: rpt_skill_with_disposition_count {
#      #hidden: yes
#      group_label: "Customer Care"
#      label: "Disposition Volume"
#      description: "Call and ticket volume by disposition from Zendesk and InContact"
#      join: ticket {
#        type: full_outer
#        relationship: many_to_many
#        sql_on: lower(${rpt_skill_with_disposition_count.disposition}) = lower(${ticket.custom_disposition})
#                and ${rpt_skill_with_disposition_count.reported_date} = ${ticket.created_at_date};;
#      }
#      join: group {
#        type: full_outer
#        required_joins: [ticket]
#        sql_on: ${group.id} = ${ticket.group_id} ;;
#        relationship: many_to_one
#      }
#    }

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

  explore: v_first_data_order_num {label: "FD Order Numbers" group_label: "Accounting"}
  explore: v_affirm_order_num {label: "Affirm Order Numbers" group_label: "Accounting"}
  explore: v_amazon_order_num {label: "Amazon Order Numbers" group_label: "Accounting"}
  explore: v_paypal_order_num {label: "Paypal Order Numbers" group_label: "Accounting"}
  explore: v_braintree_order_num {label: "Braintree Order Numbers" group_label: "Accounting"}
  explore: v_braintree_to_netsuite {label: "Braintree to Netsuite" group_label: "Accounting"}
  explore: v_affirm_to_netsuite {label: "Affirm to Netsuite" group_label: "Accounting"}
  explore: v_shopify_payment_to_netsuite {label: "Shopify Payment to Netsuite" group_label: "Accounting"}

#-------------------------------------------------------------------
# Hidden Explores
#-------------------------------------------------------------------



  explore: tim_forecast_historical {label: "Historical Forecasts" group_label: "Sales" description: "Unioned forecasts with a forecast made date for separating"
    hidden: no
    join: item {view_label: "Product" type: left_outer sql_on: ${tim_forecast_historical.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: tim_forecast_wholesale_dim {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${tim_forecast_wholesale_dim.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}

  explore: tim_forecast_dtc { from: tim_forecast label: "Combined Forecast" group_label: "Sales"  hidden: yes
    join: tim_forecast_wholesale {type: full_outer sql_on: ${tim_forecast_dtc.sku_id} = ${tim_forecast_wholesale.sku_id} and ${tim_forecast_dtc.date_date} = ${tim_forecast_wholesale.date_date};; relationship: one_to_one}
    join: item {view_label: "Product" type: left_outer sql_on: coalesce(${tim_forecast_wholesale.sku_id},${tim_forecast_dtc.sku_id}) = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: day_aggregations { from: day_aggregations  group_label: "Sales" hidden:no }
  explore: tim_forecast {label: "DTC Forecast" group_label: "In Testing"  hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${tim_forecast.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
  explore: tim_forecast_wholesale {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
      join: item {view_label: "Product" type: left_outer sql_on: ${tim_forecast_wholesale.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
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
  explore: shopify_orders { hidden:  yes  label: "Shopify sales simple"  description: "Shopify header level information"
    join: sales_order{type:left_outer sql_on: ${sales_order.etail_order_id}::text = ${shopify_orders.id}::text ;; relationship: one_to_one }}
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
  explore: Mattress_Firm {hidden: yes from: mattress_firm_store_details  group_label: "Wholesale"
    join: mattress_firm_sales {type: left_outer
      sql_on:   ${Mattress_Firm.store_id} = ${mattress_firm_sales.store_id} and ${mattress_firm_sales.finalized_date_date} is not null ;;
      relationship: one_to_many }
    join: mattress_firm_item {type:  left_outer sql_on: ${mattress_firm_item.mf_sku} = ${mattress_firm_sales.mf_sku} ;; relationship:  many_to_one}
    join: mattress_firm_master_store_list {type:  full_outer  sql_on: ${Mattress_Firm.store_id} = ${mattress_firm_master_store_list.store_id} ;;
      relationship:  one_to_one}
    join: item {type:  left_outer sql_on: ${mattress_firm_item.item_id} = ${item.item_id} ;; relationship:  many_to_one}}
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
  explore: bom_demand_matrix {hidden:  yes  label: "Demand Matrix"  group_label: "Operations"
    description: "Showing components in final products and what's available"
    join: item {view_label: "Item" type: left_outer sql_on: ${item.item_id} = ${bom_demand_matrix.component_id} ;; relationship: one_to_one}}
  explore: shipping_times_for_web { hidden: yes group_label: "In Testing" label: "Estimated Fulfillment Times for Web" description: "For use on the web site to give customers an estimate of how long it will take their products to fulfill"
    join: item { type: inner sql_on: ${shipping_times_for_web.item_id} = ${item.item_id} ;; relationship: one_to_one}}
