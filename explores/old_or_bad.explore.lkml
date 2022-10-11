# DEPRECATED

#-------------------------------------------------------------------
#
# Old or Bad Explores
#
#-------------------------------------------------------------------
# include: "/views/**/*.view"
# include: "/dashboards/**/*.dashboard"

#   explore: forecast_historical_legacy {label: "Historical Forecasts" group_label: "Sales" description: "Unioned forecasts with a forecast made date for separating"
#     hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_historical_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: forecast_wholesale_dim_legacy {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_wholesale_dim_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   #explore: forecast_dtc { from: forecast label: "Combined Forecast" group_label: "Sales"  hidden: yes
#   # join: forecast_wholesale_legacy {type: full_outer sql_on: ${forecast_dtc.sku_id} = ${forecast_wholesale_legacy.sku_id} and ${forecast_dtc.date_date} = ${forecast_wholesale_legacy.date_date};; relationship: one_to_one}
#   #join: item {view_label: "Product" type: left_outer sql_on: coalesce(${forecast_wholesale_legacy.sku_id},${forecast_dtc.sku_id}) = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: forecast_retail_legacy {label: "Retail Forecast" group_label: "In Testing"  hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_retail_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: forecast_legacy_amazon {hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_legacy_amazon.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: forecast_legacy {label: "DTC Forecast" group_label: "In Testing"  hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: forecast_wholesale_legacy {label: "Wholesale Forecast" group_label: "In Testing"  hidden: yes
#     join: item {view_label: "Product" type: left_outer sql_on: ${forecast_wholesale_legacy.sku_id} = ${item.sku_id} ;;  relationship: many_to_one}}
#   explore: wholesale_stores {hidden: yes}
#   explore: deleted_fulfillment {hidden: yes}
#   explore: problem_order {hidden: yes label: "List of orders that are problematic, either for fraud, or excessive refunds/returns"}
#   explore: fraud_warning_list {hidden: yes label: "List of orders that could be fraud, and should be checked manually"}
#   explore: emp_add {hidden: yes label: "List of employee addresses for mapping purposes"}
#   explore: agg_check {hidden: yes  label: "data accuracy"}
#   explore: cac {hidden: yes  group_label: "Marketing"  label: "CAC"}
#   explore: attribution {hidden: yes  label: "HEAP attribution"  group_label: "Marketing"}
#   explore: progressive {hidden: yes  label: "Progressive"  group_label: "x - Accounting"  description: "Progressive lease information."
#     join: progressive_funded_lease {type:  left_outer sql_on:  ${progressive.lease_id} = ${progressive_funded_lease.lease_id} ;;
#       relationship: one_to_one}}

#   explore: nps_survey_06_dec2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead

#   explore: customer_nps_dec_2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead

#   explore: product_csat_dec_2019 {hidden:yes} #old explore, use nps_survey_dec2019 instead
#   explore: shopify_orders
#   { hidden:  yes
#     label: "Shopify sales simple"
#     description: "Shopify header level information"
#     join: sales_order
#     {type:left_outer
#       sql_on: ${sales_order.etail_order_id}::text = ${shopify_orders.id}::text ;;
#       relationship: one_to_one }
#     join: sales_order_line
#     {type:left_outer
#       sql_on:${shopify_orders.order_ref}=${sales_order_line.order_id}::string;;
#       relationship: one_to_one
#       fields:[total_units,is_cancelled_wholesale]}
#   }

#   explore: overall_nps_survey_dec2019 {hidden:yes}

#   explore:  nps_survey_dec2019 {
#     hidden: yes
#     label: "NPS Survey"
#     join: item {type: full_outer
#       sql_on: ${item.item_id} = ${nps_survey_dec2019.item_id};;
#       relationship: many_to_one}
#   }


#   explore: refund {hidden: yes  group_label: "x - Accounting"  label: "Accounting Refunds"  description: "Refunds on sales at an order level, for accounting."}
#   explore: shopify_warranties {hidden: yes  from: orphaned_shopify_warranties  group_label: "x - Accounting"
#     label: "Shopify Warranties"  description: "Ties the original order data to NetSuite Warranty Orders where the original order does not exist in NetSuite"
#     always_filter: {filters: {field: warranty_created_date value: "last month"}}}
#   explore: netsuite_warranty_exceptions { hidden: yes group_label: "x - Accounting" label: "Warranty ModCode Cleanup"
#     description: "Provides a list of suspected warranty orders in NetSuite with incorrect references to the original order and/or that are missing a modification code"}




  # explore: shipping_times_for_web { hidden: yes group_label: "In Testing" label: "Estimated Fulfillment Times for Web" description: "For use on the web site to give customers an estimate of how long it will take their products to fulfill"
  #   join: item { type: inner sql_on: ${shipping_times_for_web.item_id} = ${item.item_id} ;; relationship: one_to_one}}
  # explore: executive_report { hidden: yes
  #   join: item { type:inner  sql_on: ${sku_id} = ${item.sku_id};; relationship: one_to_one}}

  # explore: item {hidden:  yes label: "Transfer and Purchase Orders --old" group_label: "Operations"
  #   description: "Netsuite data on Transfer and purchase orders"
  #   join: purchase_order_line {view_label: "Purchase Order"  type: full_outer
  #     sql_on: ${item.item_id} = ${purchase_order_line.item_id} ;;  relationship: one_to_many}
  #   join: purchase_order {view_label: "Purchase Order" type:  left_outer
  #     sql_on: ${purchase_order_line.purchase_order_id} = ${purchase_order.purchase_order_id}  ;; relationship: many_to_one}
  #   join: bill_purchase_order {view_label: "Bills"  type:  left_outer
  #     sql_on: ${purchase_order.purchase_order_id} = ${bill_purchase_order.purchase_order_id} ;; relationship: many_to_one}
  #   join: transfer_order_line {view_label: "Transfer Order" type:  full_outer
  #     sql_on: ${transfer_order_line.item_id} = ${item.item_id} ;; relationship: one_to_many}
  #   join: transfer_order {view_label: "Transfer Order"  type:  left_outer required_joins: [transfer_order_line]
  #     sql_on: ${transfer_order.transfer_order_id} = ${transfer_order_line.transfer_order_id} ;; relationship: many_to_one}
  #   join: Receiving_Location{from:warehouse_location type:  left_outer
  #     sql_on: ${transfer_order.receiving_location_id} = ${Receiving_Location.location_id} or ${purchase_order.location_id} = ${Receiving_Location.location_id};;
  #     relationship: many_to_one}
  #   join: Transfer_Fulfilling_Location{from:warehouse_location type:  left_outer
  #     sql_on: ${transfer_order.shipping_location_id} = ${Transfer_Fulfilling_Location.location_id} ;; relationship: many_to_one}
  #   join: vendor {type:  left_outer sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;; relationship: many_to_one}
  # }

    # explore: wholesale_legacy {
    #   from: sales_order_line
    #   label:  "Wholesale"
    #   hidden: yes
    #   group_label: " Sales"
    #   view_label: "Sales Order Line"
    #   description:  "All sales orders for wholesale channel"
    #   always_join: [fulfillment]
    #   always_filter: {
    #     filters: {field: sales_order.channel      value: "Wholesale"}
    #     filters: {field: item.merchandise         value: "No"}
    #     filters: {field: item.finished_good_flg   value: "Yes"}
    #     filters: {field: item.modified            value: "Yes"}}
    #   join: sales_order_line
    #   {type:left_outer
    #     sql_on:${shopify_orders.order_ref}=${sales_order_line.order_id}::string;;
    #     relationship: one_to_one
    #     fields:[total_units]}
    #   join: sf_zipcode_facts {
    #     view_label: "Customer"
    #     type:  left_outer
    #     sql_on: ${wholesale_legacy.zip} = (${sf_zipcode_facts.zipcode})::varchar ;;
    #     relationship: many_to_one}
    #   join: dma {
    #     view_label: "Customer"
    #     type:  left_outer
    #     sql_on: ${wholesale_legacy.zip} = ${dma.zip} ;;
    #     relationship: many_to_one}
    #   join: item {
    #     view_label: "Product"
    #     type: left_outer
    #     sql_on: ${wholesale_legacy.item_id} = ${item.item_id} ;;
    #     relationship: many_to_one}
    #   join: fulfillment {
    #     view_label: "Fulfillment"
    #     type: left_outer
    #     sql_on: ${wholesale_legacy.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
    #     relationship: one_to_many}
    #   join: sales_order {
    #     view_label: "Sales Header"
    #     type: left_outer
    #     sql_on: ${wholesale_legacy.order_system} = ${sales_order.order_system} ;;
    #     relationship: many_to_one}
    #   join: shopify_orders {
    #     view_label: "Sales Order Line"
    #     type:  left_outer
    #     fields: [shopify_orders.call_in_order_Flag]
    #     sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    #     relationship:  one_to_one}
    #   join: return_order_line {
    #     view_label: "Returns"
    #     type: full_outer
    #     sql_on: ${wholesale_legacy.item_order} = ${return_order_line.item_order} ;;
    #     relationship: one_to_many}
    #   join: return_order {
    #     view_label: "Returns"
    #     type: full_outer
    #     required_joins: [return_order_line]
    #     sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
    #     relationship: many_to_one}
    #   join: return_reason {
    #     view_label: "Returns"
    #     type: full_outer
    #     sql_on: ${return_reason.list_id} = ${return_order.return_reason_id} ;;
    #     relationship: many_to_one}
    #   join: return_option {
    #     view_label: "Returns"
    #     type: left_outer
    #     sql_on: ${return_option.list_id} = ${return_order.return_option_id} ;;
    #     relationship: many_to_one}
    #   join: restocked_returns {
    #     view_label: "Returns"
    #     type: left_outer
    #     relationship: one_to_one
    #     required_joins: [return_order_line]
    #     sql_on: ${restocked_returns.return_order_id} = ${return_order_line.return_order_id} and ${restocked_returns.item_id} = ${return_order_line.item_id};;}
    #   join: customer_table {
    #     view_label: "Customer"
    #     type: left_outer
    #     sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
    #     relationship: many_to_one}
    #   join: retroactive_discount {
    #     view_label: "Retro Discounts"
    #     type: left_outer
    #     sql_on: ${wholesale_legacy.item_order} = ${retroactive_discount.item_order_refund} ;;
    #     relationship: one_to_many}
    #   join: discount_code {
    #     view_label: "Retro Discounts"
    #     type:  left_outer
    #     sql_on: ${retroactive_discount.discount_code_id} = ${discount_code.discount_code_id} ;;
    #     relationship: many_to_one}
    #   join: cancelled_order {
    #     view_label: "Cancellations"
    #     type: left_outer
    #     sql_on: ${wholesale_legacy.item_order} = ${cancelled_order.item_order} ;;
    #     relationship: one_to_many}
    #   join: NETSUITE_cancelled_reason {
    #     view_label: "Cancellations"
    #     type: left_outer
    #     sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.shopify_cancel_reason_id} ;;
    #     relationship: many_to_one}
    #   join: order_flag {
    #     view_label: "Sales Header"
    #     type: left_outer
    #     sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
    #     relationship: one_to_one}
    #   join: fulfillment_dates {
    #     view_label: "Fulfillment"
    #     type: left_outer
    #     sql_on: ${fulfillment_dates.order_id} = ${sales_order.order_id} ;;
    #     relationship: one_to_one}
    #   join: v_wholesale_manager {
    #     view_label: "Customer"
    #     type:left_outer
    #     relationship:one_to_one
    #     sql_on: ${sales_order.order_id} = ${v_wholesale_manager.order_id} and ${sales_order.system} = ${v_wholesale_manager.system};;
    #   }
    #   join: standard_cost {
    #     view_label: "Product"
    #     type: left_outer
    #     sql_on: ${standard_cost.item_id} = ${item.item_id};;
    #     relationship:one_to_one}
    #   join: v_transmission_dates {
    #     view_label: "V Transmission Dates"
    #     type: left_outer
    #     sql_on: ${sales_order_line.order_id} = ${v_transmission_dates.order_id} and ${sales_order_line.system} = ${v_transmission_dates.system} and ${sales_order_line.item_id} = ${v_transmission_dates.item_id} ;;
    #     relationship: one_to_one}
    #   join: zendesk_sell {
    #     view_label: "Zendesk Sell"
    #     type: full_outer
    #     sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
    #     relationship: one_to_one
    #   }
    #   join: affiliate_sales_order {
    #     type: left_outer
    #     sql_on: ${sales_order.related_tranid}=${affiliate_sales_order.order_id} ;;
    #     relationship: one_to_one
    #   }
    #   join: item_return_rate {
    #     type: left_outer
    #     relationship: one_to_one
    #     sql_on: ${item.sku_id} = ${item_return_rate.sku_id}  ;;
    #   }
    #   join: agent_name {
    #     view_label: "Sales Order"
    #     type: left_outer
    #     sql_on: ${agent_name.shopify_id}=${shopify_orders.user_id} ;;
    #     relationship: many_to_one
    #   }
    #   join: exchange_order_line {
    #     view_label: "Returns"
    #     type: left_outer
    #     sql_on: ${sales_order_line.order_id} = ${exchange_order_line.order_id} and ${sales_order_line.item_id} = ${exchange_order_line.item_id}
    #       and ${sales_order_line.system} = ${exchange_order_line.system} ;;
    #     relationship: one_to_many
    #   }
    #   join: exchange_order {
    #     view_label: "Returns"
    #     type: left_outer
    #     sql_on: ${exchange_order_line.exchange_order_id} = ${exchange_order.exchange_order_id} and ${exchange_order_line.replacement_order_id} = ${exchange_order.replacement_order_id} ;;
    #     relationship: many_to_one
    #   }
    #   join: sla_hist {
    #     ##join added by Scott Clark on 11/5/2020 to get website-stated SLA reflected somewhere
    #     type: left_outer
    #     sql_on: ${sales_order.trandate_date} >= ${sla_hist.start_date} and ${sales_order.trandate_date} < ${sla_hist.end_date} and ${sla_hist.sku_id} = ${item.sku_id} ;;
    #     relationship: many_to_one

    #   }
    # }
