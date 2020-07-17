#-------------------------------------------------------------------
#
# Old or Bad Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

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
  explore: sales_targets_dim {hidden:  yes label: "Finance targets"  description: "Monthly finance targets, spread by day"}
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


  explore: refund {hidden: yes  group_label: "x - Accounting"  label: "Accounting Refunds"  description: "Refunds on sales at an order level, for accounting."}
  explore: shopify_warranties {hidden: yes  from: orphaned_shopify_warranties  group_label: "x - Accounting"
    label: "Shopify Warranties"  description: "Ties the original order data to NetSuite Warranty Orders where the original order does not exist in NetSuite"
    always_filter: {filters: {field: warranty_created_date value: "last month"}}}
  explore: netsuite_warranty_exceptions { hidden: yes group_label: "x - Accounting" label: "Warranty ModCode Cleanup"
    description: "Provides a list of suspected warranty orders in NetSuite with incorrect references to the original order and/or that are missing a modification code"}



  explore: inventory_valuation {hidden:  yes group_label: "Operations"   label: "Inventory Valuation Snapshot"
    description: "An exported shapshot of inventory by location from netsuite at the end of each month"
    join: item {type:  left_outer sql_on: ${item.item_id} = ${inventory_valuation.item_id} ;; relationship: many_to_one}
    join: warehouse_location {type: left_outer sql_on: ${warehouse_location.location_id} = ${inventory_valuation.location_id} ;; relationship: many_to_one}}
  explore: shipping_times_for_web { hidden: yes group_label: "In Testing" label: "Estimated Fulfillment Times for Web" description: "For use on the web site to give customers an estimate of how long it will take their products to fulfill"
    join: item { type: inner sql_on: ${shipping_times_for_web.item_id} = ${item.item_id} ;; relationship: one_to_one}}
  explore: executive_report { hidden: yes
    join: item { type:inner  sql_on: ${sku_id} = ${item.sku_id};; relationship: one_to_one}}

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
    join: vendor {type:  left_outer sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;; relationship: many_to_one}
  }
