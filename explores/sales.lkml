#-------------------------------------------------------------------
#
# Sales Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

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
      filters: {field: item.finished_good_flg   value: "Yes"}}
    #filters: {field: item.modified            value: "Yes"}}
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
      sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
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
    join: v_wholesale_manager {
      view_label: "Customer"
      type:left_outer
      sql_on: ${sales_order.order_id} = ${v_wholesale_manager.order_id} and ${sales_order.system} = ${v_wholesale_manager.system};;
      relationship:one_to_one}
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
      sql_on: ${warranty_order_line.warranty_order_id} = ${warranty_order.warranty_order_id} and  ${warranty_order_line.item_id} = ${sales_order_line.item_id};;
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
      view_label: "Zendesk"
      type: full_outer
      sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
      relationship: one_to_one
    }
    join: zendesk_sell_deal {
      view_label: "Zendesk"
      type: full_outer
      sql_on: ${zendesk_sell.deal_id}=${zendesk_sell_deal.deal_id};;
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
      view_label: "Zendesk"
      type: left_outer
      relationship: one_to_one
      sql_on: ${v_chat_sales.order_id} = ${sales_order.order_id} and ${v_chat_sales.system} = ${sales_order.system};;
    }
    join: zendesk_chats {
      view_label: "Zendesk"
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
    join: acquisition_recent_customer_test_segments {
      type: left_outer
      relationship: one_to_one
      sql_on: ${acquisition_recent_customer_test_segments.customer_email} = ${customer_table.email_join} ;;
      view_label: "Customer"
    }
    join: acquisition_test_purchasers {
      type: left_outer
      relationship: one_to_one
      sql_on: ${sales_order.order_system} = ${acquisition_test_purchasers.order_system} ;;
      view_label: "Customer"
    }
    join: us_zipcode_mapping {
      view_label: "Geography"
      type:  left_outer
      sql_on: ${sales_order_line.zip} = ${us_zipcode_mapping.zip} ;;
      relationship: many_to_many
    }
    join: us_zipcode {
      view_label: "Geography"
      type:  left_outer
      sql_on: ${us_zipcode_mapping.parent_zcta} = ${us_zipcode.zip} ;;
      relationship: many_to_many
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

  explore: return_form_entry {
    hidden: yes
    group_label: " Sales"
    label: "Return Form"
    description: "Entries from Customer Care Return Forms"
    join: return_form_reason {
      type: left_outer
      sql_on: ${return_form_entry.entry_id} = ${return_form_reason.entry_id} ;;
      relationship: one_to_many}
  }

  explore: logan_fulfillment {
    group_label: " Sales"
    description: "Stop gap on fulfillment data"
    hidden: yes
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${logan_fulfillment.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
  }

  explore: day_aggregations {
    label: "Data By Date"
    description: "Sales, Forecast, Adspend, aggregated to a day (for calculating ROAs, and % to Goal)"
    from: day_aggregations
    group_label: " Sales"
    hidden:no
  }

  explore: hour_assumptions {
    label: "Hour Assumptions"
    description: "% of day's sales by hour for dtc day prediction"
    hidden: yes
  }

  explore: v_intransit { hidden: yes  label: "In-Transit Report"  group_label: " Sales"}
  explore: accessory_products_to_mattress {hidden: yes label: "Accessory Products to Mattress" group_label: " Sales"}
  explore: max_by_day {hidden: yes group_label: " Sales" label: "Max by Day"}

#-------------------------------------------------------------------
#
# Wholesale Explores
#
#-------------------------------------------------------------------

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

  explore: mattress_firm_po_detail {hidden: yes label: "Mattress Firm POD" group_label: "Wholesale"}
  explore: wholesale_mfrm_manual_asn  {hidden:  yes label: "Wholesale Mattress Firm Manual ASN" group_label: "Wholesale"}
  explore: store_locations_3_mar2020 {hidden: yes label:"Wholesale and Retail Locations"}
