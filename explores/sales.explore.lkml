#-------------------------------------------------------------------
#
# Sales Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"


  # explore: sales {
  #   from: sales_base
  #   label: "Sales NEW"
  #   group_label: " Sales"
  #   description: "Simplified view into sales"
  #   hidden: yes
  #   query: sales_last_30 {
  #     dimensions: [sales.order_date]
  #     measures: [sales.gross_amt]
  #     label: "DTC Sales By Day"
  #     description: "Total DTC Sales by Day for the Last 30 Days"
  #     #pivots: [dimension1, dimension2, … ]
  #     sorts: [sales.order_date: asc]
  #     filters: [sales.order_date: "30 days ago for 30 days",sales.channel2: "DTC"]
  #     #timezone: timezone
  #     limit: 100
  #   }
  #   query: sales_product {
  #     dimensions: [sales.category_name]
  #     measures: [sales.total_units]
  #     label: "Units by Product Category"
  #     description: "Total Units Sold by Category in the last 7 Days"
  #     #pivots: [dimension1, dimension2, … ]
  #     sorts: [sales.category_name: asc]
  #     filters: [sales.order_date: "7 days ago for 7 days"]
  #     #timezone: timezone
  #     limit: 100
  #   }
  #   query: period_over_period {
  #     dimensions: [sales.date_in_period_date, sales.period]
  #     measures: [sales.gross_amt]
  #     label: "Period Over Period"
  #     description: "Last 30 days compared to the previous 30"
  #     pivots: [sales.period]
  #     sorts: [sales.date_in_period_date: desc]
  #     filters: [sales.comparison_period: "previous",
  #       sales.date_filter: "30 days",
  #       sales.within_dates: "Yes"]
  #   }
  #   query: retail_sales {
  #     dimensions: [sales.store_name]
  #     measures: [sales.gross_amt]
  #     label: "Sales by Retail Store"
  #     description: "Gross sales by store for each retail store location"
  #     #sorts: [sales.date_in_period_date: desc]
  #     filters: [sales.channel2: "Owned Retail",
  #       sales.order_date: "30 days"]
  #   }
  #   aggregate_table: date_sku {
  #     query: {
  #       dimensions: [order_date,sku_id]
  #       measures: [adj_gross_amt, gm_rate, gross_amt, gross_margin]
  #     }
  #     materialization: {
  #       datagroup_trigger: pdt_refresh_6am
  #     }
  #   }
  # }

  explore: sales_order_line{
    from:  sales_order_line
    label:  " Sales"
    hidden: no
    group_label: " Sales"
    view_label: "Sales Order Line"
    view_name: sales_order_line
    description:  "All sales orders for DTC, Wholesale, Owned Retail channel"
    always_join: [fulfillment]
    always_filter: {
      filters: [sales_order.channel: "DTC, Wholesale, Owned Retail"]
      filters: [sales_order.is_exchange_upgrade_warranty: ""]
    }
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
      fields: [shopify_orders.call_in_order_Flag,shopify_orders.user_id]
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
    join: return_reason_v2 {
      view_label: "Returns"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${return_reason_v2.order_id} ;;
      relationship: one_to_many }
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
    join: customer_order_history {
      view_label: "Customer"
      type: left_outer
      sql_on: ${sales_order.email} = ${customer_order_history.email} ;;
      relationship: many_to_one}
    join: customer_first_order {
      view_label: "Customer"
      type:  left_outer
      sql_on: ${sales_order.email} = ${customer_first_order.email} ;;
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
      sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.cancel_reason_id} ;;
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
    join: fedex_fulfillment_date{
      view_label: "Fulfillment"
      type: full_outer
      sql_on: ${fulfillment.fulfillment_id} = ${fedex_fulfillment_date.fulfillment_id} ;;
      relationship: many_to_one}
    join: ups_tracking {
      view_label: "Fulfillment"
      type: full_outer
      sql_on: ${fulfillment.tracking_numbers} = ${ups_tracking.tracking_number} ;;
      relationship: many_to_one}
    join: state_tax_reconciliation {
      view_label: "State Tax Reconciliation"
      type: left_outer
      sql_on: ${state_tax_reconciliation.order_id} = ${sales_order.order_id} ;;
      relationship: one_to_many}
    join: shopify_discount_codes {
      view_label: "Promo"
      type: left_outer
      sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
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
    # join: c3_conversion_ft_lt {
    #   view_label: "Marketing Attribution"
    #   type:  full_outer
    #   sql_on: ${sales_order.order_id}=${c3_conversion_ft_lt.analytics_order_id} ;;
    #   relationship: one_to_one}
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
    join: cc_deals {
      view_label: "Zendesk"
      type: left_outer
      relationship: one_to_one
      fields: [cc_deals.order_id, cc_deals.source_clean]
      sql_on: ${cc_deals.order_id} = ${sales_order.order_id} ;;
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
    join: team_lead_name {
      view_label: "Zendesk"
      type: left_outer
      sql_on: (${team_lead_name.incontact_id}=${agent_name.incontact_id} or ${team_lead_name.agent_email} = ${zendesk_sell.email})
        and  ${team_lead_name.end_date}::date > '2089-12-31'::date ;;
      relationship: many_to_one
    }
    join: promotions_combined {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${sales_order_line.created_date} = ${promotions_combined.promotion_date} ;;
      relationship: one_to_one
    }
    join: highjump_fulfillment {
      view_label: "Fulfillment"
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
    join: ryder_summary_data {
      view_label: "Fulfillment"
      type: full_outer
      relationship: many_to_one
      sql_on: ${ryder_summary_data.order_id} =  ${sales_order.order_id};;
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
      relationship: many_to_one
      sql_on: ${item.sku_id} = ${item_return_rate.sku_id} and ${item_return_rate.channel} = ${sales_order_line.channel_ret} and ${item_return_rate.order_id} = ${sales_order.order_id};;
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
    join: aura_vision_traffic {
      view_label: "Owned Retail"
      type:  left_outer
      sql_on: ${sales_order.store_id} = ${aura_vision_traffic.showroom_name} and ${sales_order.created_date} = ${aura_vision_traffic.created_date};;
      relationship: many_to_many
    }
    join: privacy_request {
      view_label: "Customer"
      type: left_outer
      sql_on: ${sales_order.email} = ${privacy_request.email_join};;
      relationship: many_to_one
    }
    join: v_financed_retail {
      view_label: "Owned Retail"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${v_financed_retail.order_id};;
      relationship: one_to_one
    }
    join: paycom_labor_hours {
      type: left_outer
      sql_on:${agent_name.email_join} = ${paycom_labor_hours.email_join} and ${sales_order.created_date} = ${paycom_labor_hours.clocked_in_or_date};;
      relationship: many_to_many
      fields: [paycom_labor_hours.clocked_in_or_date,paycom_labor_hours.clocked_in_or_month,paycom_labor_hours.clocked_in_or_week,paycom_labor_hours.department_filter,paycom_labor_hours.hours_or,paycom_labor_hours.department_filter,paycom_labor_hours.location_code_or]
    }
    join: site_slas {
      ##join added by Scott Clark on 11/5/2020 to get website-stated SLA reflected somewhere
      type: left_outer
      sql_on: ${sales_order.trandate_date} >= ${site_slas.start_date} and ${sales_order.trandate_date} < coalesce(${site_slas.end_date},'2050-01-01') and ${site_slas.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one
    }
    join: cordial_id {
      view_label: "Customer"
      type: left_outer
      sql_on: lower(${sales_order.email}) = lower(${cordial_id.email_join});;
      relationship: many_to_one
      fields: [cordial_id.subscribe_status]
    }

    join: fips {
      type: left_outer
      sql_on: right(concat ('00000',${fips.fips}),5)=right(concat ('00000',${dma.FIPS}),5);;
      relationship: many_to_one
    }

    join: retail_order_flag {
      view_label: "Owned Retail"
      type: left_outer
      sql_on: ${sales_order.etail_order_id} = ${retail_order_flag.order_id} ;;
      relationship:  one_to_one
    }
    join: talkable_referral {
      type: full_outer
      sql_on: ${talkable_referral.order_number} = ${sales_order.related_tranid} ;;
      relationship: one_to_one
    }

    join: v_purple_showroom {
      view_label: "Owned Retail"
      type:  left_outer
      sql_on: ${sales_order.store_id} = ${v_purple_showroom.purple_showroom_name};;
      relationship: one_to_one
    }
    join: v_sla_days {
      view_label: "Fulfillment"
      type: left_outer
      sql_on: ${sales_order_line.created_date} = ${v_sla_days.sla_date} and ${sales_order_line.item_id} = ${v_sla_days.item_id} ;;
      relationship: many_to_one
      }
    join: sla {
      view_label: "Fulfillment"
      type: left_outer
      sql_on: ${sales_order_line.created_date} = ${sla.order_date} and ${item.sku_id} = ${sla.sku_id} and ${sales_order.channel_id} in (1,5) ;;
      relationship: many_to_one
    }
    join: system_notes {
      view_label: "System Notes"
      type: left_outer
      sql_on: ${sales_order_line.order_id} = ${system_notes.transaction_id};;
      relationship: many_to_one
    }
  }

  # explore: sales_agent_metrics {
  #   hidden: no
  #   from: employee_lkp
  #   sql_always_where: ${zendesk_id} is not null and ${workday_id} is not null ;;
  #   label: "Sales Agents"
  #   description: "Sales Agents Metrics"
  #   join: zendesk_chat_engagements {
  #     view_label: "Chat Engagements"
  #     sql_on: ${zendesk_chat_engagements.zendesk_id} = ${sales_agent_metrics.zendesk_id}
  #             and ${zendesk_chat_engagements.zendesk_id} is not null
  #             and ${sales_agent_metrics.zendesk_id} is not null
  #             and ${sales_agent_metrics.zendesk_id} != '392176472792'
  #             and ${sales_agent_metrics.zendesk_id} != '369087776231';;
  #     type: left_outer
  #     relationship: one_to_many
  #   }
  #   # join: zendesk_agent_events {
  #   #   view_label: "Zendesk Agent Events"
  #   #   sql_on: ${zendesk_agent_events.zendesk_agent_id} = ${sales_agent_metrics.zendesk_id}
  #   #     and ${sales_agent_metrics.zendesk_id} is not null;;
  #   #   type:  left_outer
  #   #   relationship: many_to_many
  #   # }
  #   join: labor_hours {
  #     view_label: "Labor Hours"
  #     sql_on: ${labor_hours.employee_id} = ${sales_agent_metrics.workday_id}
  #             and ${labor_hours.employee_id} is not null
  #             and ${sales_agent_metrics.workday_id} is not null;;
  #     type: left_outer
  #     relationship: one_to_many
  #   }
  #   join: incontact_phone {
  #     view_label: "Incontact"
  #     sql_on: ${incontact_phone.agent_id} = ${sales_agent_metrics.incontact_id}
  #       and ${incontact_phone.agent_id} is not null
  #       and ${sales_agent_metrics.incontact_id} is not null
  #       and ${sales_agent_metrics.zendesk_id} != '392176472792'
  #       and ${sales_agent_metrics.zendesk_id} != '369087776231';;
  #     type: left_outer
  #     relationship: one_to_many
  #   }
  # }

    explore: sales_agent_metrics {
      hidden: no
      from: warehouse_date_table
      label: "Sales Agent Metrics"
      description: "Sales Agents Metrics"
      join: employee_lkp {
        view_label: "Employee Lookup"
        type: cross
        relationship: many_to_many
      }
      join: zendesk_chat_engagements {
        view_label: "Chat Engagements"
        sql_on: ${sales_agent_metrics.date_date} = ${zendesk_chat_engagements.engagement_start_date}
          and ${employee_lkp.zendesk_id} = ${zendesk_chat_engagements.zendesk_id};;
        type: left_outer
        relationship: one_to_many
      }
      join: incontact_phone {
        view_label: "Incontact Phone"
        sql_on: ${sales_agent_metrics.date_date} = ${incontact_phone.start_ts_mst_date}
          and ${employee_lkp.incontact_id} = ${incontact_phone.agent_id} ;;
        type: left_outer
        relationship: one_to_many
      }
      join: labor_hours {
        view_label: "Labor Hours"
        sql_on: ${sales_agent_metrics.date_date} = ${labor_hours.clocked_in_date}
          and ${employee_lkp.workday_id} = ${labor_hours.employee_id};;
        type: left_outer
        relationship: one_to_many
      }
    #   join: zendesk_agent_events {
    #     view_label: "Zendesk Agent Events"
    #     sql_on: ${sales_agent_metrics_speedtest.date_date} = ${zendesk_agent_events.started_date}
    #       and ${employee_lkp.zendesk_id} = ${zendesk_agent_events.zendesk_agent_id};;
    #     type:  left_outer
    #     relationship: one_to_many
    # }
  }

  # explore: sales_test {
  #   from: sales_order_line
  #   fields: [sales_order_line.is_fulfilled,sales_order_line.return_rate_dollars,sales_order_line.item_id,sales_order_line.item_order,sales_order_line.order_system
  #       ,sales_order_line.return_rate_units,sales_order_line.free_item,sales_order_line.total_gross_Amt_non_rounded,sales_order_line.total_units
  #       ,sales_order_line.created_date, sales_order_line.created_month, sales_order_line.created_quarter, sales_order_line.created_week, sales_order_line.created_year
  #       ,sales_order_line.insidesales_sales,sales_order_line.sub_channel,sales_order_line.upt,sales_order_line.Before_today,sales_order_line.total_gross_Amt
  #       ,item*,fulfillment*,sales_order*,return_order_line*,return_order*,cancelled_order*,order_flag*,shopify_discount_codes*,warranty_order*,warranty_order_line*]
  #   label:  "  Main"
  #   hidden: yes
  #   group_label: " Sales"
  #   view_label: "Sales Order"
  #   view_name: sales_order_line
  #   #description:  "All sales orders for DTC, Wholesale, Owned Retail channel"
  #   #always_join: [fulfillment]
  #   always_filter: {
  #     filters: [sales_order.channel: "DTC, Wholesale, Owned Retail"]
  #     filters: [sales_order.is_exchange_upgrade_warranty: "No"]
  #   }
  #   join: item {
  #     view_label: "Sales Order"
  #     fields: [item.item_id,item.category_name, item.line_raw, item.model_raw, item.product_description_raw,item.sku_id,item.model_raw_order]
  #     type: left_outer
  #     sql_on: ${sales_order_line.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: fulfillment {
  #     view_label: "Sales Order"
  #     fields: [fulfillment.item_id,fulfillment.order_id,fulfillment.system,fulfillment.fulfilled_F_raw]
  #     type: left_outer
  #     sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
  #     relationship: one_to_many
  #   }
  #   join: sales_order {
  #     view_label: "Sales Order"
  #     fields: [sales_order.is_exchange_upgrade_warranty,sales_order.channel,sales_order.unique_customers,sales_order.store_name,sales_order.channel2
  #         ,sales_order.order_id,sales_order.average_order_size,sales_order.order_system,sales_order.related_tranid,sales_order.total_orders,sales_order.system
  #         , sales_order.email,sales_order.transaction_type,sales_order.source,sales_order.created]
  #     type: left_outer
  #     sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
  #     relationship: many_to_one
  #   }
  #   join: return_order_line {
  #     view_label: "Sales Order"
  #     fields: [return_order_line.item_order,return_order_line.return_order_id,return_order_line.total_returns_completed_dollars,return_order_line.total_returns_completed_units
  #       , return_order_line.total_gross_amt]
  #     type: full_outer
  #     sql_on: ${sales_order_line.item_order} = ${return_order_line.item_order} ;;
  #     relationship: one_to_many
  #   }
  #   join: return_order {
  #     view_label: "Sales Order"
  #     fields: [return_order.return_order_id,return_order.return_completed,return_order.status]
  #     type: full_outer
  #     required_joins: [return_order_line]
  #     sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: cancelled_order {
  #     view_label: "Sales Order"
  #     fields: [cancelled_order.item_order]
  #     type: left_outer
  #     sql_on: ${sales_order_line.item_order} = ${cancelled_order.item_order} ;;
  #     relationship: one_to_one
  #   }
  #   join: order_flag {
  #     view_label: "Sales Order"
  #     fields: [order_flag.order_id,order_flag.mattress_flg,order_flag.pillow_flg,order_flag.sheets_flg,order_flag.cushion_flg,order_flag.pet_bed_flg
  #       ,order_flag.protector_flg,order_flag.base_flg,order_flag.average_mattress_order_size,order_flag.average_accessory_order_size]
  #     type: left_outer
  #     sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
  #     relationship: one_to_one
  #   }
  #   join: shopify_discount_codes {
  #     view_label: "Sales Order"
  #     fields: [shopify_discount_codes.etail_order_name,shopify_discount_codes.promo_bucket]
  #     type: left_outer
  #     sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
  #     relationship: many_to_many
  #   }
  #   join: warranty_order {
  #     view_label: "Sales Order"
  #     fields: [warranty_order.order_id,warranty_order.warranty_order_id,warranty_order.original_system,warranty_order.status,warranty_order.warranty_type]
  #     type: full_outer
  #     sql_on: ${sales_order.order_id} = ${warranty_order.order_id} and ${sales_order.system} = ${warranty_order.original_system} ;;
  #     relationship: one_to_many
  #   }
  #   join: warranty_order_line {
  #     view_label: "Sales Order"
  #     fields: [warranty_order_line.warranty_order_id,warranty_order_line.item_id,warranty_order_line.is_warrantied,warranty_order_line.quantity_complete]
  #     type:  full_outer
  #     sql_on: ${warranty_order_line.warranty_order_id} = ${warranty_order.warranty_order_id} and  ${warranty_order_line.item_id} = ${sales_order_line.item_id};;
  #     relationship: many_to_many
  #   }
  #   join: shopify_orders {
  #     view_label: "Sales Order Line"
  #     type:  left_outer
  #     fields: [shopify_orders.call_in_order_Flag]
  #     sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
  #     relationship:  many_to_many
  #   }
  #   join: agent_name {
  #     view_label: "Sales Order"
  #     fields: []
  #     type: left_outer
  #     sql_on: ${agent_name.shopify_id}=${shopify_orders.user_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: zendesk_sell {
  #     view_label: "Zendesk"
  #     fields: []
  #     type: full_outer
  #     sql_on: ${zendesk_sell.order_id}=${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
  #     relationship: one_to_one
  #   }
  # }

  explore: customers {
    from:  v_visitors_view_normailized_ids
    hidden: yes

    join: customer_flags_by_order {
      view_label: "Order History Details"
      from: email_order_flag
      type: left_outer
      relationship: one_to_one
      sql_on: LOWER(${customer_flags_by_order.email}) = LOWER(${customers.vp_customer_email});;
    }
    join: customer_flags_by_sessions {
      view_label: "Web Sessions Details"
      from: v_customer_metrics
      type: left_outer
      relationship: one_to_one
      sql_on: ${customer_flags_by_sessions.visitor_id}::string = ${customers.visitor_id}::string ;;
    }
    join: customer_flags_by_email{
      view_label: "Email Marketing Details"
      from: cordial_customer_activity
      type: left_outer
      relationship: one_to_one
      sql_on: LOWER(${customer_flags_by_email.email}) = LOWER(${customers.vp_customer_email}) ;;
    }
    join: customer_flags_by_audience{
      view_label: "Tealium Audiences"
      from: tealium_visitors_view_normalized
      type: left_outer
      relationship: one_to_one
      sql_on: ${customer_flags_by_audience.visitor_id}::STRING = ${customers.vp_customer_email}::STRING ;;
    }
    join: contact {
      view_label: "Contact"
      from: customer
      type: left_outer
      relationship: one_to_one
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${contact.email_address}) ;;
    }
    # join: customer_order_sequence {
    #   view_label: " Order Sequence"
    #   from: v_customer_order_sequence
    #   type: left_outer
    #   relationship: one_to_many
    #   sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_order_sequence.email}) ;;
    # }
    join: customer_first_order {
      view_label: " 1st Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_first_order.email}) AND ${customer_first_order.order_sequence} = 1 ;;
    }
    join: customer_second_order {
      view_label: " 2nd Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_second_order.email}) AND ${customer_second_order.order_sequence} = 2 ;;
    }
    join: customer_third_order {
      view_label: " 3rd Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_third_order.email}) AND ${customer_third_order.order_sequence} = 3;;
    }
    join: customer_fourth_order {
      view_label: " 4th Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_fourth_order.email}) AND ${customer_fourth_order.order_sequence} = 4;;
    }
    join: customer_fifth_order {
      view_label: " 5th Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_fifth_order.email}) AND ${customer_fifth_order.order_sequence} = 5;;
    }
    join: customer_last_order {
      view_label: " Last Order"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_last_order.email}) AND ${customer_last_order.last_order} = true;;
    }
    join: customer_all_orders {
      view_label: " All Orders"
      from: v_customer_order_sequence
      type: left_outer
      relationship: one_to_many
      sql_on: LOWER(${customers.vp_customer_email}) = LOWER(${customer_all_orders.email});;
    }
    join: customer_journey {
      view_label: "Customer Journey"
      from:  customer_journey
      type:  left_outer
      relationship:  one_to_one
      sql_on:  LOWER(${customers.vp_customer_email}) = LOWER(${customer_journey.email});;
    }
    # join: customer_table {
    #   view_label: "Customers"
    #   type: left_outer
    #   sql_on: ${customer_table.email} = ${customers.vp_customer_email} ;;
    #   relationship: one_to_one}
    # join: customer_first_order {
    #   view_label: "Customers"
    #   type:  left_outer
    #   sql_on: ${customers.vp_customer_email} = ${customer_first_order.email} ;;
    #   relationship: one_to_one}
    # join: heap_id {
    #   from: tealium_v_heap_id
    #   type: left_outer
    #   relationship: one_to_many
    #   sql_on: ${customers.visitor_id}::string = ${heap_id.visitor_id}::string ;;
    # }
    # join: heap_customer{
    #   from: customer
    #   type: left_outer
    #   relationship: one_to_many
    #   sql_on: ${customers.visitor_id} = ${heap_customer.customer_id} ;;
    # }
  }


  explore: warranty {
    from: warranty_order
    hidden: yes
  ##  fields: [ALL_FIELDS*, -warranty_order_line.quantity_complete]
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
   join: restocked_warranties {
      from: restocked_returns
      view_label: "Restocked Warranties"
      # This view is used to calculate the total Restocked Units for items from both Warranties and Returns.
      type: left_outer
      relationship: one_to_one
      sql_on: ${restocked_warranties.original_transaction_id} = ${warranty_order_line.warranty_order_id} and
      ${restocked_warranties.item_id} = ${warranty_order_line.item_id};;}
    join: sales_order_line {
      type:  left_outer
      fields: [sales_order_line.order_id,sales_order_line.system,sales_order_line.gross_amt]
      sql_on: ${sales_order_line.order_id} = ${warranty.order_id} and ${sales_order_line.system} = ${warranty.original_system} ;;
      relationship: many_to_one}
  }

  explore: scc {
    from: sleep_country_canada_sales
    hidden: yes
    #fields: [ALL_FIELDS*]
    label: "SCC Orders"
    group_label: " Orders"
    description: "Sales Orders for SCC"
    join: sleep_country_canada_store {
      type: left_outer
      sql_on: ${scc.store_id} = ${sleep_country_canada_store.store_id} ;;
      relationship: many_to_one}
    join: sleep_country_canada_product {
      type: left_outer
      sql_on: ${scc.sku}  = ${sleep_country_canada_product.scc_sku} ;;
      relationship: many_to_one}
    join: item {
      type: left_outer
      relationship: many_to_one
      sql_on: ${sleep_country_canada_product.item_id} = ${item.item_id} ;;
    }
    join: v_scc_order_flg {
      type: left_outer
      view_label: "Scc"
      relationship:  many_to_one
      sql_on: ${scc.order_id} = ${v_scc_order_flg.order_id} ;;
    }
    join: scc_targets {
      type: full_outer
      view_label: "Targets"
      relationship: many_to_one
      sql_on: ${scc.created_date} = ${scc_targets.date_date} and ${scc_targets.source} = ${sleep_country_canada_store.source} ;;
    }
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

  # explore: logan_fulfillment {
  #   group_label: " Sales"
  #   description: "Stop gap on fulfillment data"
  #   hidden: yes
  #   join: item {
  #     view_label: "Product"
  #     type: left_outer
  #     sql_on: ${logan_fulfillment.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one}
  # }

  explore: day_aggregations {
    label: "Data By Date"
    description: "Sales, Forecast, Adspend, aggregated to a day (for calculating ROAs, and % to Goal)"
    from: day_aggregations
    group_label: " Sales"
    hidden:yes
    query: sales_last_30 {
      dimensions: [day_aggregations.date_date]
      measures: [day_aggregations.total_gross_sales, day_aggregations.forecast_total_amount]
      label: "Sales to Forecast"
      description: "Last 12 months, sales to forecast by month"
      #pivots: [dimension1, dimension2, … ]
      sorts: [day_aggregations.date_date: asc]
      filters: [day_aggregations.date_date: "30 days ago for 30 days"]
      #timezone: timezone
      limit: 100
    }
    query: period_over_period {
      dimensions: [day_aggregations.date_in_period_date, day_aggregations.period]
      measures: [day_aggregations.total_gross_sales]
      label: "Period Over Period"
      description: "Last 30 days sales compared to the previous 30"
      pivots: [day_aggregations.period]
      sorts: [day_aggregations.date_in_period_date: desc]
      filters: [day_aggregations.comparison_period: "previous",
        day_aggregations.date_filter: "30 days",
        day_aggregations.within_dates: "Yes"]
    }
  }

  explore: day_sku {
    from: day_sku_aggregations
    hidden: yes

   join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${item.sku_id} = ${day_sku.sku_id} ;;
      relationship: many_to_one
    }
    join: v_ai_product{
      view_label: "Product"
      type: left_outer
      sql_on: ${day_sku.sku_id} = ${v_ai_product.sku_raw} ;;
      relationship: many_to_one
    }
    join: day_sku_no_channel {
      view_label: "test"
      type: left_outer
      fields: [day_sku_no_channel.purchased_units_recieved,day_sku_no_channel.produced_units,day_sku_no_channel.forecast_units,day_sku_no_channel.units_available]
      sql_on: ${day_sku.date_date} = ${day_sku_no_channel.date_date} and ${day_sku.sku_id} = ${day_sku_no_channel.sku_id} and ${day_sku.channel}<>'NA' ;;
      relationship: many_to_one
    }
    join: sku_summary {
      view_label: "test"
      type: left_outer
      fields: [sku_summary.exception_class,sku_summary.trend_type]
      sql_on: ${sku_summary.sku_id} = ${day_sku.sku_id} ;;
      relationship: many_to_one
    }
  }

  # explore: hour_assumptions {
  #   label: "Hour Assumptions"
  #   description: "% of day's sales by hour for dtc day prediction"
  #   hidden: yes
  # }

  explore: wholesale_open_doors {hidden:yes}
  # explore: target_dtc {hidden: yes}
  explore: sales_targets {hidden:  yes label: "Finance targets"  description: "Monthly finance targets, spread by day"}

  # explore: sales_targets_dim {hidden:  yes
  #   label: "Finance targets"  description: "Monthly finance targets, spread by day"
  # }

  explore: v_intransit { hidden: yes  label: "In-Transit Report"  group_label: " Sales"}
  # explore: accessory_products_to_mattress {hidden: yes label: "Accessory Products to Mattress" group_label: " Sales"}
  # explore: max_by_day {hidden: yes group_label: " Sales" label: "Max by Day"}


  # explore: unbounce {
  #   hidden: yes
  #   extends: [sales_order_line]
  #   label:  "Unbounce"
  #   group_label: " Sales"
  #   view_label: "Sales Order Line"
  #   description:  "All sales orders for wholesale channel"
  #   always_join: [fulfillment]
  #   join: unbounce_lead {
  #     view_label: "Unbounce Leads"
  #     sql_on: lower(${unbounce_lead.email_join}) = lower(${customer_table.email_join}) ;;
  #     type: left_outer
  #     relationship: many_to_many
  #   }
  # }

  explore: optimizely {
    hidden: yes
    extends: [sales_order_line]
    label:  "Optimizely"
    group_label: " Sales"
    view_label: "Sales Order Line"
    description:  "All sales orders for wholesale channel"
    always_join: [fulfillment]
    join: v_optimizely_conversions {
      view_label: "Optimizely"
      sql_on: ${v_optimizely_conversions.related_tranid} = ${sales_order.related_tranid} ;;
      type: left_outer
      relationship: one_to_many
    }
    join: holdout_acquisition_emails  {
      view_label: "Holdout Test"
      sql_on: ${holdout_acquisition_emails.email} = ${customer_table.email} ;;
      type: left_outer
      relationship: many_to_one
    }
    join: optimizely_campaign {
      view_label: "Optimizely"
      sql_on: ${v_optimizely_conversions.campaign_id} = ${optimizely_campaign.campaign_id} ;;
      type: left_outer
      relationship: one_to_many
    }
    join: optimizely_experiment {
      view_label: "Optimizely"
      sql_on: ${v_optimizely_conversions.experiment_id} = ${optimizely_experiment.experiment_id} ;;
      type: left_outer
      relationship: one_to_many
    }
    join: optimizely_variation {
      view_label: "Optimizely"
      sql_on: ${v_optimizely_conversions.experiment_id} = ${optimizely_variation.experiment_id} and ${v_optimizely_conversions.variation_id} = ${optimizely_variation.variation_id} ;;
      type: left_outer
      relationship: one_to_many
    }
  }


# explore: conversion {hidden: yes}
# explore: sessions_in_tests {hidden: yes}

#-------------------------------------------------------------------
#
# Wholesale Explores
#
#-------------------------------------------------------------------

  explore: wholesale {
    extends: [sales_order_line]
    hidden: yes
    label:  "Wholesale"
    group_label: " Sales"
    view_label: "Sales Order Line"
    description:  "All sales orders for wholesale channel"
    always_join: [fulfillment]
    always_filter: {
      filters: {field: sales_order.channel      value: "Wholesale"}
    }
  }

  explore: mattress_firm_sales {
    hidden: yes
    label: "Mattress Firm"
    group_label: " Sales"
    description: "Mattress Firm Units Sold by Store"
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
    join: dma {
      view_label: "Geography"
      type:  left_outer
      sql_on: ${mattress_firm_store_details.zipcode} = ${dma.zip} ;;
      relationship: many_to_many
      fields: [dma.dma_name,dma.dma_mfrm]}
    join: zcta5 {
      view_label: "Geography"
      type:  left_outer
      sql_on: ${mattress_firm_store_details.zipcode} = (${zcta5.zipcode}) AND ${mattress_firm_store_details.state} = ${zcta5.state};;
      relationship: many_to_one
      fields: [zcta5.fulfillment_region_1]}
  }

  # explore: sla {
  #   hidden: yes
  #   join: item {
  #   type: left_outer
  #   sql_on: ${sla.sku_id} = ${item.sku_id} ;;
  #   relationship: one_to_one}
  # }

  explore: v_sla {hidden: yes}
  explore: v_sales_flash {hidden: yes}
  explore: v_new_roa {hidden: yes}
  explore: v_ct_test {hidden: yes}
  # explore: shop_comm_test {hidden: yes}
  # explore: sequential_rules {hidden: yes}
  # explore: mattress_firm_po_detail {hidden: yes label: "Mattress Firm POD" group_label: "Wholesale"}
  # explore: wholesale_mfrm_manual_asn  {hidden:  yes label: "Wholesale Mattress Firm Manual ASN" group_label: "Wholesale"}
  # explore: store_locations_3_mar2020 {hidden: yes label:"Wholesale and Retail Locations"}
  explore: net_rev_daily_forecast {hidden: yes label:"Daily DS forecast"}

  # explore: combined_sellthrough_pdt { hidden: yes label: "Combined Sell-Through PDT" group_label: "Wholesale"

  #   join: dma {
  #     view_label: "Geography"
  #     type:  left_outer
  #     sql_on: ${combined_sellthrough_pdt.zipcode} = ${dma.zip} ;;
  #     relationship: many_to_many
  #     fields: [dma.dma_name,dma.dma_mfrm]}
  #   join: zcta5 {
  #     view_label: "Geography"
  #     type:  left_outer
  #     sql_on: ${combined_sellthrough_pdt.zipcode} = (${zcta5.zipcode})  ;;
  #     relationship: many_to_one
  #     fields: [zcta5.fulfillment_region_1]}
  # }
