#-------------------------------------------------------------------
#
# Other Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: russ_order_validation {
    label: "Order Validation"
    description: "Constructed table comparing orders from different sources"
    hidden:yes
  }

  explore: pii_review {
    group_label: "Legal"
    label: "PII Review"
    description: "This explore is used by Legal for PII.  It is updated every morning."
    hidden: yes
  }

  explore: sku_summary {
  ##Added by Scott Clark 11/8/2020
    hidden: yes
  }

#-------------------------------------------------------------
#
# Paycom hours explore
#
#-------------------------------------------------------------

  explore: paycom_hours {
    from: paycom_labor_hours
    group_label: "HR"
    hidden:  yes
    description: "This has Paycom hourly data by day, by location by department"

  }

  explore: dei {
    group_label: "HR"
    label: "DEI"
    hidden:  yes
    description: "Diversity, Equity, & Inclusion (DEI) data by supervisor and department"
  }


#-------------------------------------------------------------------
#
# Qualtrics Explores
#
#-------------------------------------------------------------------

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
      sql_on: ${item.item_id}::text = ${qualtrics_answer.question_id};;
      # TRY_CAST(${item.item_id} as INTEGER) = TRY_CAST(${qualtrics_answer.question_name} as INTEGER) or TRY_CAST(${qualtrics_answer.question_id} as INTEGER);;
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
    join: first_order_flag {
      view_label: "Sales Header"
      type: left_outer
      sql_on: ${first_order_flag.pk} = ${sales_order.order_system} ;;
      relationship: one_to_one}
  }

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
explore: alert_testing {
  hidden: yes
}

#-------------------------------------------------------------------
#
# Snowflake  Explores
# Created by Blake Walton
# https://looker.com/platform/blocks/source/cost-and-usage-analysis-by-snowflake
#-------------------------------------------------------------------

  explore: login_history {
  }

  explore: query_history {
    join: databases {
      type: left_outer
      sql_on: ${query_history.database_name} = ${databases.database_name} ;;
      relationship: many_to_one
    }

  #   join: schemata {
  #     type: left_outer
  #     sql_on: ${databases.id} = ${schemata.id} ;;
  #     relationship: one_to_many
  #   }
  }

  # explore: schemata {
  #   join: databases {
  #     type: left_outer
  #     sql_on: ${schemata.database_id} = ${databases.id} ;;
  #     relationship: many_to_one
  #   }
  # }

  explore: load_history {
    fields: [ALL_FIELDS*,-tables.table_name,-tables.id]
    join: tables {
      sql_on: ${load_history.table_id} = ${tables.id} ;;
      relationship: many_to_one
    }
  }

  explore: storage_usage {}

  explore: warehouse_metering_history {}

  # explore: columns {}
  #
  # explore: databases {}
  #
  # explore: file_formats {}
  #
  # explore: functions {}
  #
  # explore: referential_constraints {}
  #
  # explore: sequences {}
  #
  # explore: stages {}
  #
  # explore: table_constraints {}
  #
  # explore: table_storage_metrics {}
  #
  # explore: tables {}
  #
  # explore: views {}
