#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

  connection: "analytics_warehouse"
    include: "*.view"
    #include: "*.dashboard"

  datagroup: gross_to_net_sales_default_datagroup {
    # sql_trigger: SELECT MAX(id) FROM etl_log;;
    max_cache_age: "1 hour"}

  persist_with: gross_to_net_sales_default_datagroup
  week_start_day: sunday


#-------------------------------------------------------------------
# Production Explores
#-------------------------------------------------------------------


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

  explore: inventory {
  #-------------------------------------------------------------------
  #  Invetory--------------------
  #       \           \          \
  #      Item      Warehouse     Stock
  #                 Locatoin     Level
  #-------------------------------------------------------------------
    group_label: "Operations"
    label: "Current Inventory"
    description: "Inventory positions, by item by location"
    join: item {
      type: left_outer
      sql_on: ${inventory.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
    join: warehouse_location {
      sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
      relationship: many_to_one}
    join: stock_level {
      type: full_outer
      sql_on: ${inventory.item_id} = ${stock_level.item_id} and ${inventory.location_id} = ${stock_level.location_id} ;;
      relationship: many_to_one}}

  explore: inventory_snap {
  #-------------------------------------------------------------------
  #  Invetory Snaphot-----------------------
  #               \             \            \
  #              Item        Warehouse      Stock
  #                           Location      Level
  #-------------------------------------------------------------------
    group_label: "Operations"
    label: "Historical Inventory"
    description: "Inventory positions, by item by location over time"
    join: item {
      type: left_outer
      sql_on: ${inventory_snap.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
    join: warehouse_location {
      sql_on: ${inventory_snap.location_id} = ${warehouse_location.location_id} ;;
      relationship: many_to_one}
    join: stock_level {
      type: full_outer
      sql_on: ${inventory_snap.item_id} = ${stock_level.item_id} and ${inventory_snap.location_id} = ${stock_level.location_id} ;;
      relationship: many_to_one}}

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
    label:  "DTC sales"
    group_label: "Sales"
    view_label: "Sales Line"
    description:  "All sales orders for all channels"
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
    join: sales_order {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
      relationship: many_to_one}
    join: manna_data_pull {
      view_label: "Mike Shultz Project Data"
      type: left_outer
      sql_on: ${sales_order.tranid} = ${manna_data_pull.transaction_id} ;;
      relationship: one_to_many}
    join: wholesale_customer_warehouses {
      view_label: "Wholesale Warehouses"
      type: left_outer
      sql_on: ${sales_order_line.street_address} = ${wholesale_customer_warehouses.street_address} ;;
      relationship: many_to_one
    }
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
    join: contribution {
      type: left_outer
      sql_on: ${contribution.contribution_pk} = ${sales_order_line.item_order} ;;
      relationship: one_to_one}
    join: cm_pivot {
      view_label: "x-CM waterfall"
      type: left_outer
      sql_on: ${cm_pivot.contribution_pk} = ${sales_order_line.item_order} ;;
      relationship: one_to_many}}

  explore: wholesale {
    #-------------------------------------------------------------------
    #  Wholesale - for details see DTC ^
    #-------------------------------------------------------------------
      from: sales_order_line
      label:  "Wholesale"
      group_label: "Sales"
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
      relationship: one_to_one} }

  explore: warranty {
  #-------------------------------------------------------------------
  #  Warranty--------------------
  #       \           \          \
  #      Warranty   Warranty     Item
  #       Reason     Order Line
  #-------------------------------------------------------------------
    from: warranty_order
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
      relationship: many_to_one}}

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
      sql_on:  ${Receiving_Location.location_id} = coalese(${transfer_order.receiving_location_id},${purchase_order.location_id}) ;;
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
      sql_on: ${all_events.user_id} = ${users.user_id} ;;
      relationship: many_to_one }
    join: sessions {
      type: left_outer
      sql_on: ${all_events.session_id} = ${sessions.session_id} ;;
      relationship: many_to_one }
    join: session_facts {
      view_label: "Sessions"
      type: left_outer
      sql_on: ${sessions.session_id} = ${session_facts.session_unique_id} ;;
      relationship: one_to_one }
    join: event_flow {
      sql_on: ${all_events.event_id} = ${event_flow.unique_event_id} ;;
      relationship: one_to_one }
    join: zip_codes_city {
      type: left_outer
      sql_on: ${sessions.city} = ${zip_codes_city.city} and ${sessions.region} = ${zip_codes_city.state_name} ;;
      relationship: one_to_one }
    join: dma {
      type:  left_outer
      sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
      relationship: one_to_one
    }
  }


#-------------------------------------------------------------------
# Hidden Explores
#-------------------------------------------------------------------

#     explore: sales_test {
#       extends: [wholesale]
#       group_label: "Sales"
#       label: "Sales - TEST"
#       hidden:  yes
#       always_filter: {
#         filters: {field: sales_order.channel      value: "DTC,Wholesale"}
#         filters: {field: item.merchandise         value: "No"}
#         filters: {field: item.finished_good_flg   value: "Yes"}
#         filters: {field: item.modified            value: "Yes"}} }

    explore: conversions_by_campaign {
      hidden:  yes
      label: "Conversions by Campaign"
      group_label: "Marketing"
      description: "Aggregated campaign data by date and campaign"
      join: adspend_by_campaign {
        type: left_outer
        sql_on:  ${adspend_by_campaign.campaign_id} = ${conversions_by_campaign.campaign_id} and ${adspend_by_campaign.date} = ${conversions_by_campaign.date_date}
          and ${adspend_by_campaign.platform} = ${conversions_by_campaign.platform};;
        relationship:one_to_one}
      join: external_campaign {
        type: left_outer
        sql_on: ${external_campaign.campaign_id} = coalesce (${conversions_by_campaign.campaign_id}, ${adspend_by_campaign.campaign_id});;
        relationship: many_to_one } }
  explore: tim_forecast {hidden: yes
    join: item {view_label: "Product" type: left_outer sql_on: ${tim_forecast.item_id} = ${item.item_id} ;;  relationship: many_to_one}}
  explore: sessions {hidden: yes}
  explore: emp_add {hidden: yes label: "List of employee addresses for mapping purposes"}
  explore: retail_stores {hidden:  yes  label: "list of retail outlets as of Nov 1, 2018"}
  explore: agg_check {hidden: yes  label: "data accuracy"}
  explore: cac {hidden: yes  group_label: "Marketing"  label: "CAC"}
  explore: attribution {hidden: yes  label: "HEAP attribution"  group_label: "Marketing"}
  explore: progressive {hidden: yes  label: "Progressive"  group_label: "x - Accounting"  description: "Progressive lease information."
    join: progressive_funded_lease {type:  left_outer sql_on:  ${progressive.lease_id} = ${progressive_funded_lease.lease_id} ;;
      relationship: one_to_one}}
  explore: sales_targets {hidden:  yes label: "Finance targets"  description: "Monthly finance targets, spread by day"}
  explore: shopify_orders { hidden:  yes  label: "Shopify sales simple"  description: "Shopify header level information"
    join: sales_order{type:left_outer sql_on: ${sales_order.etail_order_id}::text = ${shopify_orders.id}::text ;; relationship: one_to_one }}
  explore: orphan_orders {hidden:  yes  label: "Orphan orders"  description: "Orders that exist in Shopify that aren't yet in Netsuite"}
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
