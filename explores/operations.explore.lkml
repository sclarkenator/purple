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
      sql_on: ${item.item_id} = coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id},${receipt_line.item_id});;
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
      type:  inner
      sql_on: ${receipt.receipt_id} = ${receipt_line.receipt_id} and coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id}) = ${receipt_line.item_id}
      ;;
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

#   explore: forecast_combined {
#     label: "Forecast"
#     description: "Combined Forecast including units and dollars forecasted for DTC, Wholesale, Retail, and Amazon"
#     group_label: "Operations"
#     #hidden: yes
#     join: item {
#       view_label: "Product"
#       type: left_outer
#       sql_on: ${forecast_combined.sku_id} = ${item.sku_id} ;;
#       relationship: many_to_one}
#     join:fg_to_sfg{
#       view_label: "FG to SFG"
#       sql_on: ${fg_to_sfg.fg_item_id}=${item.item_id} ;;
#       type: left_outer
#       relationship: one_to_one
#     }
#     join: actual_sales {
#       view_label: "Actual Sales"
#       sql_on: ${forecast_combined.date_month} = ${actual_sales.created_month}
#       and ${forecast_combined.channel} = ${actual_sales.channel}
#       and ${item.item_id} = ${actual_sales.item_id}
#       --and ${forecast_combined.sku_id} = ${actual_sales.sku_id}
#       ;;
#       #
#       type: full_outer
#       relationship: many_to_many
#     }
#   }

  explore: forecast_combined {
    label: "Forecast New"
    view_name: date_meta
    description: "Combined Forecast including units and dollars forecasted for DTC, Wholesale, Retail, and Amazon"
    group_label: "Operations"
    join: forecast_combined {
      type: left_outer
      sql_on: ${date_meta.date_group_month} = ${forecast_combined.date_month} ;;
      relationship: one_to_many
    }
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
    join: actual_sales {
      view_label: "Actual Sales"
      sql_on: ${date_meta.date_group_month} = ${actual_sales.created_month}
              --and ${forecast_combined.channel} = ${actual_sales.channel}
              --and ${item.item_id} = ${actual_sales.item_id}
              --and ${forecast_combined.sku_id} = ${actual_sales.sku_id}
              ;;
              #
        type: full_outer
        relationship: many_to_many
      }
  }

  explore:  actual_sales{
    group_label: "Operations"
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

  explore: day_pending {hidden:yes group_label: "Operations"}
  explore: at_risk_amount {hidden: yes group_label: "Operations" label: "At Risk Orders"}
