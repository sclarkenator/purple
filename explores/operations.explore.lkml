#-------------------------------------------------------------------
#
# Operations Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

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
    join: account {
      view_label: "Account"
      type: left_outer
      sql_on: coalesce(${purchase_order_line.account_id},${transfer_order_line.account_id}) = ${account.account_id} ;;
      relationship: one_to_many}
    join: bill_purchase_order {
      view_label: "Bills"
      type:  left_outer
      sql_on: ${purchase_order.purchase_order_id} = ${bill_purchase_order.purchase_order_id} ;;
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
      sql_on: ${item.item_id} = coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id},${receipt_line.item_id}) ;;
      relationship: many_to_one}
    join: vendor {
      type:  left_outer
      sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;;
      relationship: many_to_one}
    join: receipt {
      view_label: "Receipt"
      type:  left_outer
      sql_on: ${purcahse_and_transfer_ids.id} = ${receipt.original_transaction_id} ;;
      relationship: many_to_many
    }
    join: receipt_line {
      view_label: "Receipt Line"
      type:  left_outer
      sql_on: ${receipt.receipt_id} = ${receipt_line.receipt_id} and coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id}) = ${receipt_line.item_id} ;;
      relationship: one_to_many
    }
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
    from:  forecast_v2
    label: "Forecast"
    description: "Combined Forecast including units and dollars forecasted for DTC, Wholesale, Retail, and Amazon"
    group_label: "Operations"
    always_filter: {
      filters: [forecast_combined.version: "Current S&OP"]
    }
    #hidden: yes
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${forecast_combined.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one }
    join: v_ai_product{
      view_label: "Product"
      type: left_outer
      sql_on: ${forecast_combined.sku_id} = ${v_ai_product.sku_raw} ;;
      relationship: many_to_one }
    join:fg_to_sfg{
      view_label: "FG to SFG"
      sql_on: ${fg_to_sfg.fg_item_id}=${item.item_id} ;;
      type: left_outer
      relationship: one_to_one }
    join: actual_sales {
      view_label: "Actual Sales by Created Date"
      sql_on: ${forecast_combined.date_date} = ${actual_sales.created_date}
      and ${forecast_combined.channel} = ${actual_sales.channel}
      and ${forecast_combined.sku_id} = ${actual_sales.sku_id} ;;
      type: left_outer
      relationship: many_to_many
      #fields: [actual_sales.channel,actual_sales.item_id,actual_sales.source,actual_sales.total_gross_Amt_amazon,actual_sales.total_gross_Amt_dtc,actual_sales.total_gross_Amt_non_rounded,actual_sales.total_gross_Amt_retail,actual_sales.total_gross_Amt_wholesale,actual_sales.total_sku_ids,actual_sales.total_units,actual_sales.total_units_amazon,actual_sales.total_units_dtc,actual_sales.total_units_retail,actual_sales.total_units_wholesale,actual_sales.tranid,actual_sales.full_name]
    }
    join: actual_sales_by_ship{
      from: actual_sales
      view_label: "Actual Sales by Ship Order By Date"
      sql_on: ${forecast_combined.date_date} = ${actual_sales_by_ship.ship_order_by_date}
              and ${forecast_combined.channel} = ${actual_sales_by_ship.channel}
              and ${forecast_combined.sku_id} = ${actual_sales_by_ship.sku_id} ;;
      type: left_outer
      relationship: many_to_many
      #fields: [actual_sales_by_ship.channel,actual_sales_by_ship.item_id,actual_sales_by_ship.source,actual_sales_by_ship.total_gross_Amt_amazon,actual_sales_by_ship.total_gross_Amt_dtc,actual_sales_by_ship.total_gross_Amt_non_rounded,actual_sales_by_ship.total_gross_Amt_retail,actual_sales_by_ship.total_gross_Amt_wholesale,actual_sales_by_ship.total_sku_ids,actual_sales_by_ship.total_units,actual_sales_by_ship.total_units_amazon,actual_sales_by_ship.total_units_dtc,actual_sales_by_ship.total_units_retail,actual_sales_by_ship.total_units_wholesale,actual_sales_by_ship.tranid,actual_sales_by_ship.full_name]
    }
  }

explore: forecast_v2 {
  label: "Forecast"
  description: "Combined Forecast including units and dollars forecasted for DTC, Wholesale, Retail, and Amazon"
  group_label: "Operations"
  always_filter: {
    filters: [forecast_v2.version: "Current S&OP"]
  }
  hidden: yes
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${forecast_v2.sku_id} = ${item.sku_id} ;;
    relationship: many_to_one }
  join: v_ai_product{
    view_label: "Product"
    type: left_outer
    sql_on: ${forecast_v2.sku_id} = ${v_ai_product.sku_raw} ;;
    relationship: many_to_one }
  join:fg_to_sfg{
    view_label: "FG to SFG"
    sql_on: ${fg_to_sfg.fg_item_id}=${item.item_id} ;;
    type: left_outer
    relationship: one_to_one }
  join: actual_sales {
    view_label: "Actual Sales by Created Date"
    sql_on: ${forecast_v2.date_date} = ${actual_sales.created_date}
      and ${forecast_v2.channel} = ${actual_sales.channel}
      and ${forecast_v2.sku_id} = ${actual_sales.sku_id} ;;
    type: left_outer
    relationship: many_to_many
    #fields: [actual_sales.channel,actual_sales.item_id,actual_sales.source,actual_sales.total_gross_Amt_amazon,actual_sales.total_gross_Amt_dtc,actual_sales.total_gross_Amt_non_rounded,actual_sales.total_gross_Amt_retail,actual_sales.total_gross_Amt_wholesale,actual_sales.total_sku_ids,actual_sales.total_units,actual_sales.total_units_amazon,actual_sales.total_units_dtc,actual_sales.total_units_retail,actual_sales.total_units_wholesale,actual_sales.tranid,actual_sales.full_name]
  }
  join: actual_sales_by_ship{
    from: actual_sales
    view_label: "Actual Sales by Ship Order By Date"
    sql_on: ${forecast_v2.date_date} = ${actual_sales_by_ship.ship_order_by_date}
              and ${forecast_v2.channel} = ${actual_sales_by_ship.channel}
              and ${forecast_v2.sku_id} = ${actual_sales_by_ship.sku_id} ;;
    type: left_outer
    relationship: many_to_many
    #fields: [actual_sales_by_ship.channel,actual_sales_by_ship.item_id,actual_sales_by_ship.source,actual_sales_by_ship.total_gross_Amt_amazon,actual_sales_by_ship.total_gross_Amt_dtc,actual_sales_by_ship.total_gross_Amt_non_rounded,actual_sales_by_ship.total_gross_Amt_retail,actual_sales_by_ship.total_gross_Amt_wholesale,actual_sales_by_ship.total_sku_ids,actual_sales_by_ship.total_units,actual_sales_by_ship.total_units_amazon,actual_sales_by_ship.total_units_dtc,actual_sales_by_ship.total_units_retail,actual_sales_by_ship.total_units_wholesale,actual_sales_by_ship.tranid,actual_sales_by_ship.full_name]
  }
}

explore: forecast_compared_to_actual_sales {
  view_name: forecast_combined
  label: "Forecast Compared to Actual Sales"
  description: "Use this explore to compare entries in Forecast versus Actual Sales."
  group_label: "Operations"
  hidden: yes
  join: actual_sales {
    view_label: "Actual Sales"
    sql_on: ${forecast_combined.date_date} = ${actual_sales.created_date}
      and ${forecast_combined.channel} = ${actual_sales.channel}
      and ${forecast_combined.sku_id} = ${actual_sales.sku_id} ;;
    type: full_outer ## NOTE THE FULL OUTER JOIN
    relationship: many_to_many
  }
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: nvl(${forecast_combined.sku_id},${actual_sales.sku_id}) = ${item.sku_id} ;;
    relationship: many_to_one }
}

  explore:  actual_sales{
    group_label: "Operations"
    hidden: yes
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

  explore: contribution  {
    hidden:yes
    group_label: "Operations"
    join: item {
      type:left_outer
      sql_on: ${item_id} = ${item.item_id};;
      relationship: one_to_one
    }
    join: sales_order {
      type: left_outer
      sql_on: ${order_id} = ${sales_order.order_id}  ;;
      relationship: many_to_one
    }
  }

  explore: v_mattress_cogs {
    hidden: yes
    join: parent {
      from: item
      view_label: "Finished good"
      type:left_outer
      sql_on: ${v_mattress_cogs.item_id} = ${parent.item_id};;
      relationship: many_to_one
    }
    join: subcomponent {
      from: item
      view_label: "Component"
      type:left_outer
      sql_on: ${v_mattress_cogs.sub_component} = ${subcomponent.item_id};;
      relationship: many_to_one}
    }

  explore: bin_location {
    hidden: yes
    group_label:"Production"
    label: "Highjump Bin Location"
    join: item {
      type:left_outer
      sql_on: ${item.sku_id} = ${bin_location.sku};;
      relationship: many_to_one}
    }

# explore: bin {
#   hidden: yes
#   group_label:"Production"
#   label: "Highjump Bin Location"
# }

explore: international_open_po_report {
  hidden: yes
  view_label:"International Open POs"
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${international_open_po_report.item_number} = ${item.sku_id} ;;
    relationship: many_to_one}
  }

explore: day_pending {hidden:yes group_label: "Operations"}
explore: at_risk_amount {hidden: yes group_label: "Operations" label: "At Risk Orders"}
explore: back_ordered {hidden: yes group_label: "Operations" label: "Back Ordered"}
explore: expedited_shipping {hidden:yes group_label: "Operations" label:"Expedited Shipping"}
explore: ai_transaction {hidden:yes group_label: "Operations"}
explore: aop_combined {hidden:yes view_label:"AOP Combined"}
explore: lrp_combined {hidden:yes view_label:"LRP Combined"}
explore: item_raw {from: item hidden:yes}
explore: forecast_snapshot {
  hidden:yes
  join: item {
    view_label: "Product"
    type: left_outer
    sql_on: ${forecast_snapshot.sku_id} = ${item.sku_id} ;;
    relationship: many_to_one }
  join: v_ai_product{
    view_label: "Product"
    type: left_outer
    sql_on: ${forecast_snapshot.sku_id} = ${v_ai_product.sku_raw} ;;
    relationship: many_to_one }
  }
explore: labor_hours {hidden: no group_label: "Operations" label: "Workday Labor Hours"}
explore: etq_scar {hidden: yes label: "ETQ - Scar"}
explore: etq_ncr {
  label: "ETQ - NCR"
  view_label: "NCR"
  hidden: yes
  join: etq_ncr_item {
    view_label: " NCR Details"
    type: left_outer
    sql_on: ${etq_ncr.ncr_number} = ${etq_ncr_item.ncr_number} ;;
    relationship: one_to_many
  }
  join: item {
    view_label: "Item"
    type: left_outer
    sql_on: ${etq_ncr_item.part_number} = ${item.sku_id} ;;
    relationship: one_to_one
  }
  join: standard_cost {
    view_label: "Item"
    type: left_outer
    sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
    relationship: one_to_one
    }
}
explore: slt_logistics {hidden: yes group_label: "Operations" label: "SLT Logistics"}
explore: slt_safety {hidden: yes group_label: "Operations" label: "SLT Safety"}
explore: slt_safety_details {hidden: yes group_label: "Operations" label: "Safety Details"}
# explore: slt_shipping_queue { hidden: yes group_label: "Operations" label: "Shipping Queue"}
# explore: envista {hidden: yes group_label: "Operations" label: "Envista"}
# explore: gtms {hidden: yes group_label: "Operations" label: "GTMS"}

# explore: transaction_detail {
#   label: "High Jump Transactions"
#   view_label: "HJ Transaction Detail"
#   hidden: yes
#   join: transaction_header {
#     view_label: "HJ Transaction Header"
#     type: left_outer
#     sql_on: ${transaction_detail.transaction_number} = ${transaction_header.transaction_number} ;;
#     relationship: many_to_one}
#   join: item {
#     view_label: "Item"
#     type: left_outer
#     sql_on: ${transaction_detail.sku} = ${item.sku_id} ;;
#     relationship: one_to_one}
#   join: standard_cost_direct_materials  {
#     type: left_outer
#     sql_on: ${item.item_id} = ${standard_cost_direct_materials.item_id} ;;
#     relationship: one_to_one}
#   }

  # explore: rf_log {
  #   label: "High Jump RF Logs"
  #   view_label: "HJ RF Log"
  #   hidden: yes
  #   join: bin {
  #     type: left_outer
  #     sql_on: ${rf_log.bin_label} = ${bin.bin_label} ;;
  #     relationship: many_to_one}
  #   join: item {
  #     view_label: "Item"
  #     type: left_outer
  #     sql_on: ${rf_log.sku} = ${item.sku_id} ;;
  #     relationship: one_to_one}
  #   join: standard_cost_direct_materials  {
  #     type: left_outer
  #     sql_on: ${item.item_id} = ${standard_cost_direct_materials.item_id} ;;
  #     relationship: one_to_one}

  # }
