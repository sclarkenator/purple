#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

  connection: "analytics_warehouse"
    include: "/views/**/*.view"
    include: "/dashboards/**/*.dashboard"
    include: "/explores/**/*.lkml"

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

named_value_format: curr {
  value_format: "#,##0.00 \" USD\""
}
named_value_format: curr_0 {
  value_format: "#,##0 \" USD\""
}

#-------------------------------------------------------------------
#
# Access Grants
#
#-------------------------------------------------------------------

access_grant: can_view_pii {
  user_attribute: can_view_pii
  allowed_values: ["yes"]
}

access_grant: is_customer_care_manager{
  user_attribute: is_customer_care_manager
  allowed_values: [ "yes" ]
}

#-------------------------------------------------------------------
#
# Production Explores
#
#-------------------------------------------------------------------

# I moved the Production Explores to Production.lkml -- Blake

#-------------------------------------------------------------------
#
# Accounting Explores
#
#-------------------------------------------------------------------

# I moved the Accounting Explores to Accounting.lkml -- Blake

#-------------------------------------------------------------------
#
# Operations Explores
#
#-------------------------------------------------------------------

# I moved the Operations Explores to Operations.lkml -- Blake

#-------------------------------------------------------------------
#
# Marketing explores
#
#-------------------------------------------------------------------

# I moved the Marketing Explores to Marketing.lkml -- Blake

#-------------------------------------------------------------------
#
# Customer Care Explores
#
#-------------------------------------------------------------------

# I moved the Customer Care Explores to customer_care.lkml -- Blake

#-------------------------------------------------------------------

  explore: target_dtc {hidden: yes}

  explore: qualtrics {
    hidden:yes
    from: qualtrics_survey
    view_label: "Survey"
    join: qualtrics_response {
      type: left_outer
      sql_on: ${qualtrics.id} = ${qualtrics_response.survey_id} ;;
      relationship: one_to_many
      view_label: "Response"}
    join: qualtrics_customer {
      type: left_outer
      sql_on: ${qualtrics_response.recipient_email} = ${qualtrics_customer.email} ;;
      relationship: many_to_one
      view_label: "Qualtrics Customer"}
    join: qualtrics_answer {
      type: left_outer
      sql_on: ${qualtrics.id} = ${qualtrics_answer.survey_id} AND ${qualtrics_answer.response_id} = ${qualtrics_response.response_id} ;;
      relationship: one_to_many
      view_label: "Answer"}
    join: item {
      view_label: "Product"
      sql_on: ${item.item_id}::text = ${qualtrics_answer.question_name} ;;
      type: left_outer
      relationship: many_to_one}
   join: customer_table {
    view_label: "Customer"
    type: left_outer
    sql_on: ${customer_table.customer_id}::text = ${qualtrics_response.netsuite_customer_id} ;;
    relationship: many_to_one}
   join: sales_order {
      type:  left_outer
      sql_on: ${qualtrics_response.order_id}::text = ${sales_order.order_id}::text ;;
      relationship: one_to_one }
   join: sales_order_line_base {
      type:  left_outer
      sql_on: ${qualtrics_response.order_id}::text = ${sales_order_line_base.order_id}::text and ${sales_order.system}::text = ${sales_order_line_base.system}::text ;;
      relationship: one_to_many}
    }

  explore: events_view__all_events__all_events {hidden:yes}



      explore: qualtrics1 {
        hidden:yes
        from: qualtrics_survey
        view_label: "Survey"
        join: qualtrics_response {
          type: inner
          sql_on: ${qualtrics1.id} = ${qualtrics_response.survey_id} ;;
          relationship: one_to_many
          view_label: "Response"}
        join: qualtrics_customer {
          type: inner
          sql_on: ${qualtrics_response.recipient_email} = ${qualtrics_customer.email} ;;
          relationship: many_to_one
          view_label: "Qualtrics Customer"}
        join: qualtrics_answer {
          type: inner
          sql_on: ${qualtrics1.id} = ${qualtrics_answer.survey_id} AND ${qualtrics_answer.response_id} = ${qualtrics_response.response_id} ;;
          relationship: one_to_many
          view_label: "Answer"}
        join: sales_order {
          type:  inner
          sql_on: upper(${qualtrics_response.recipient_email}) = upper(${sales_order.email}) ;;
          relationship: many_to_many }
        join: sales_order_line_base {
          type:  inner
          sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} and ${sales_order.system}::text = ${sales_order_line_base.system}::text ;;
          relationship: one_to_many}
        join: item {
          view_label: "Product"
          sql_on: ${item.item_id} = ${sales_order_line_base.item_id} ;;
          type: inner
          relationship: many_to_one}
        join: zendesk_sell {
          view_label: "Zendesk Sell"
          type: full_outer
          sql_on: ${zendesk_sell.order_id} = ${sales_order.order_id} and ${sales_order.system}='NETSUITE' ;;
          relationship: one_to_one}

          join: users {
            type: left_outer
            sql_on: upper(${qualtrics_response.recipient_email}) = ${users._email} ;;
            relationship: one_to_one }
          join: all_events {
            type: left_outer
            sql_on: ${users.user_id}::string = ${all_events.user_id}::string ;;
            relationship: one_to_many }

          join: sessions {
            type: left_outer
            sql_on: ${all_events.session_id}::string = ${sessions.session_id}::string ;;
            relationship: many_to_one }
          join: session_facts {
            view_label: "Sessions"
            type: left_outer
            sql_on: ${sessions.session_id}::string = ${session_facts.session_id}::string ;;
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
              relationship: one_to_many
            }
            join: date_meta {
              type: left_outer
              sql_on: ${date_meta.date}::date = ${sessions.time_date}::date;;
              relationship: one_to_many
            }
        join: qualtrics_answer_flag {
          type: left_outer
          sql_on: ${qualtrics_response.response_id} = ${qualtrics_answer_flag.response_id} ;;
          relationship: one_to_one
          view_label: "Response"}

      }


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

explore: v_intransit { hidden: yes  label: "In-Transit Report"  group_label: " Sales"}
explore: accessory_products_to_mattress {hidden: yes label: "Accessory Products to Mattress" group_label: " Sales"}
explore: store_locations_3_mar2020 {hidden: yes label:"Wholesale and Retail Locations"}
explore: max_by_day {hidden: yes label: "Max by Day"}

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
  join: v_wholesale_manager {
    view_label: "Customer"
    type:left_outer
    relationship:one_to_one
    sql_on: ${sales_order.order_id} = ${v_wholesale_manager.order_id} and ${sales_order.system} = ${v_wholesale_manager.system};;
  }
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
explore: v_shopify_gift_card {label: "Shopify Gift Card Transactions" group_label: "Accounting" hidden:yes}

explore: v_gift_card {
  label: "Gift Card Transactions"
  group_label: "Accounting"
  hidden:yes
  join: sales_order {
    type: left_outer
    sql_on:  ${sales_order.related_tranid} = ${v_gift_card.order_number} ;;
    relationship: one_to_one}
  }


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
        fields: [sales_order.tranid,sales_order.system,sales_order.related_tranid,sales_order.source,sales_order.payment_method,sales_order.order_id,sales_order.warranty_order_flg,sales_order.is_upgrade,sales_order.Amazon_fulfillment,sales_order.gross_amt,sales_order.dtc_channel_sub_category,sales_order.total_orders,sales_order.payment_method_flag,sales_order.channel2,sales_order.channel_source,sales_order.Order_size_buckets,sales_order.max_order_size,sales_order.min_order_size,sales_order.average_order_size,sales_order.tax_amt_total, sales_order.order_type_hyperlink]
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
        sql_on:  ${ecommerce1.checkout_token} = ${hotjar_data.token} ;;
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
      # join: return_order_line {
      #   view_label: "Returns"
      #   type: full_outer
      #   sql_on: ${sales_order_line_base.item_order} = ${return_order_line.item_order} ;;
      #   relationship: one_to_many}
      # join: return_order {
      #   view_label: "Returns"
      #   type: full_outer
      #   required_joins: [return_order_line]
      #   sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
      #   fields: [return_order.return_order_id,return_order.assigned_to,return_order.channel_id,return_order.yesterday_flag,return_order.created_date_filter,return_order.entity_id,return_order.item_receipt_condition_id,return_order.last_modified,return_order.memo,return_order.order_id,return_order.payment_method_reference_id,return_order.priority_id,return_order.related_tranid,return_order.replacement_order_link_id,return_order.return_option_id,return_order.return_reason_id,return_order.return_ref_id,return_order.rma_return_form_sent,return_order.rma_return_type,return_order.rma_stretchy_sheet_id,return_order.rmawarranty_ticket_number,return_order.shipping_item_id,return_order.status,return_order.was_returned,return_order.tracking_number,return_order.transaction_number,return_order.warranty_order,return_order.return_completed,return_order.return_completed,return_order.return_life,return_order.law_tag]
      #   relationship: many_to_one}
#       join: return_reason {
#         view_label: "Returns"
#         type: full_outer
#         sql_on: ${return_reason.list_id} = ${return_order.return_reason_id} ;;
#         relationship: many_to_one}
#       join: return_option {
#         view_label: "Returns"
#         type: left_outer
#         sql_on: ${return_option.list_id} = ${return_order.return_option_id} ;;
#         relationship: many_to_one}
#       join: cancelled_order {
#         view_label: "Cancellations"
#         type: left_outer
#         sql_on: ${sales_order_line_base.item_order} = ${cancelled_order.item_order};;
#         relationship: one_to_one }
      join: veritone_pixel_matchback {
        view_label: "Veritone"
        type: left_outer
        sql_on:  ${veritone_pixel_matchback.order_id} = ${sales_order.related_tranid} ;;
        relationship: many_to_one}
      join: qualtrics_response {
        type: inner
        sql_on: upper(${sales_order.email}) = upper(${qualtrics_response.recipient_email}) ;;
        relationship: many_to_many
        view_label: "Response"}
      join: qualtrics_survey {
        type: inner
        sql_on: ${qualtrics_response.survey_id} = ${qualtrics_survey.id};;
        relationship: one_to_many
        view_label: "Survey"}
      join: qualtrics_customer {
        type: inner
        sql_on: ${qualtrics_response.recipient_email} = ${qualtrics_customer.email} ;;
        relationship: many_to_one
        view_label: "Qualtrics Customer"}
      join: qualtrics_answer {
        type: inner
        sql_on: ${qualtrics_survey.id} = ${qualtrics_answer.survey_id} AND ${qualtrics_answer.response_id} = ${qualtrics_response.response_id} ;;
        relationship: one_to_many
        view_label: "Answer"}
  }

  explore: veritone_pixel_matchback { hidden:yes}

#-------------------------------------------------------------------
#
# Affinity Analysis Block Explore
#
#-------------------------------------------------------------------

  explore: order_purchase_affinity {
    hidden: yes
    group_label: "Marketing"
    label: "🔗 Item Affinity"
    view_label: "Item Affinity"

    always_filter: {
      filters: {
        field: affinity_timeframe
        value: "last 90 days"
      }
      filters: {
        field: order_items_base.product_level
        #### TO DO: Replace with your most used hierarchy level (defined in the affinity_analysis view)
        value: "SKU"
      }
    }

    join: order_items_base {}

    join: total_orders {
      type: cross
      relationship: many_to_one
    }
  }

#-------------------------------------------------------------------
# Old/Bad Explores
#-------------------------------------------------------------------

# I moved the Old/Bad Explores to Old_or_Bad.lkml -- Blake

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
    explore: owned_retail_target_by_location {hidden: yes }
