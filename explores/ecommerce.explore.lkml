#-------------------------------------------------------------------
#
# eCommerce Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

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
      fields: [sales_order.tranid,sales_order.system,sales_order.related_tranid,sales_order.source,sales_order.payment_method,sales_order.order_id,sales_order.warranty_order_flg,sales_order.is_upgrade,sales_order.Amazon_fulfillment,sales_order.gross_amt,sales_order.dtc_channel_sub_category,sales_order.total_orders,sales_order.payment_method_flag,sales_order.channel2,sales_order.channel_source,sales_order.Order_size_buckets,sales_order.max_order_size,sales_order.min_order_size,sales_order.average_order_size,sales_order.tax_amt_total, sales_order.order_type_hyperlink,sales_order.etail_order_id]
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
      sql_on: ${shopify_discount_codes.etail_order_name} = ${sales_order.related_tranid} ;;
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
    join: hour_assumptions {
      view_label: "Hour Assumptions"
      type: left_outer
      sql_on: ${ecommerce.time_hour_of_day} = ${hour_assumptions.hour};;
      relationship: many_to_one
    }
    join: first_order_flag {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${first_order_flag.pk} = ${sales_order.order_system} ;;
      relationship: one_to_one}
  }

  explore: events_view__all_events__all_events {hidden:yes}
