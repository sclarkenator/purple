view: ecommerce1 {
  sql_table_name: analytics.marketing.v_ecommerce  ;;
  #this view is currently being built by Nathan Hollingworth and is not ready to use

  dimension: uid {
    type: number
    description: "User ID"
    sql: ${TABLE}.uid ;;
    hidden:  yes
  }

  dimension: order_number {
    type: string
    description: "Netsuite's Related Tran ID"
    sql: ${TABLE}.order_number ;;
    hidden:  yes
  }

  dimension: etail_amt {
    type: number
    description: "Order amount in Shopify"
    sql: ${TABLE}.etail_amt ;;
    hidden:  yes
  }

  dimension: ordered {
    #this is used for the heap_checkout_abandonment explore
    hidden: yes
    type: string
    sql: ${TABLE}.ordered ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
    hidden:  yes
  }

  dimension: checkout_platform {
    type: string
    description: "Shopify or CommerceTools"
    sql: ${TABLE}.checkout_platform ;;
    hidden:  yes
  }

  measure: total_cvr {
    description: "% of all Sessions that resulted in an order. Source: looker.calculation"
    label: "CVR - All Sessions"
    type: number
    view_label: "Sessions"
    sql: 1.0*(${sales_order.total_orders})/NULLIF(${heap_page_views.Sum_bounced_session}+${heap_page_views.Sum_non_bounced_session},0) ;;
    value_format_name: percent_2
  }

  measure: qualified_cvr {
    description: "% of all Non-bounced Sessions that resulted in an order. Source: looker.calculation"
    label: "CVR - Qualified Sessions"
    type: number
    view_label: "Sessions"
    sql: 1.0*(${sales_order.total_orders})/NULLIF(${heap_page_views.Sum_non_bounced_session},0) ;;
    value_format_name: percent_2
  }

  # dimension: user_id {
  #   type: number
  #   description: "All User IDs related to this session ID and order number"
  #   sql: ${TABLE}.user_id ;;
  #   hidden:  yes
  # }

  # dimension: session_id_order_number {
  #   type: string
  #   description: "Unique combination of Session ID and Order Number"
  #   sql: concat(${TABLE}.order_number,${TABLE}.session_id) ;;
  #   primary_key: yes
  #   hidden: yes
  # }

  # dimension: checkout_token {
  #   type: string
  #   description: "Unique url string identifying a checkout"
  #   sql: ${TABLE}.checkout_token ;;
  #   hidden:  yes
  # }

  dimension: created {
    type: date
    description: "Date the session record was created in the data warehouse"
    sql: ${TABLE}.created ;;
    hidden:  yes
  }

  dimension: created_ts {
    type: date_time
    description: "Time the session record was created in the data warehouse"
    sql: ${TABLE}.created_ts ;;
    hidden:  yes
  }

  dimension: cosco_time {
    type: date_time
    label: "Shopify Confirmed Order Time"
    description: "Time Date for cart orders shopify confirmed order "
    sql: ${TABLE}.cosco_time ;;
    hidden:  yes
  }

  dimension: copo_time {
    type: date_time
    label: "Shopify Order Time"
    description: "Time date a cart order placed order"
    sql: ${TABLE}.copo_time ;;
    hidden:  yes
  }

  dimension: p_time {
    type: date_time
    description: "Time of Purchase - Heap"
    sql: ${TABLE}.p_time ;;
    hidden:  yes
  }

  dimension: shopify_processed_at {
    type: date_time
    sql: ${TABLE}.shopify_processed_at ;;
    hidden:  yes
  }

  dimension: shopify_created_at {
    type: date_time
    sql: ${TABLE}.shopify_created_at ;;
    hidden:  yes
  }

#  dimension: cosco_event_id {
#    type: string
#    description: "id for the event: cart orders shopify confirmed order "
#    sql: ${TABLE}.cosco_event_id ;;
#    hidden:  yes }

#  dimension: cosco_session_id {
#    type: string
#    description: ""
#    sql: ${TABLE}.cosco_session_id ;;
#    hidden:  yes }

#  dimension: copo_event_id {
#    type: string
#    description: "ID for the event: cart order placed order"
#    sql: ${TABLE}.copo_event_id ;;
#    hidden:  yes }

#  dimension: copo_session_id {
#    type: string
#    description: ""
#    sql: ${TABLE}.copo_session_id ;;
#    hidden:  yes }

#  dimension: purchase_event_id {
#    type: string
#    sql: ${TABLE}.purchase_event_id ;;
#    hidden:  yes }

#  dimension: purchase_session_id {
#    type: number
#    sql: ${TABLE}.purchase_session_id ;;
#    hidden:  yes }

  # dimension: device_type {
  #   type: number
  #   sql: ${TABLE}.device_type ;;
  #   hidden:  yes
  # }

  # dimension: event_id {
  #   type: string
  #   sql: ${TABLE}.event_id ;;
  #   hidden:  yes
  # }

  dimension: time {
    type: date_time
    description: "Session start time"
    sql: ${TABLE}.time ;;
    hidden:  yes
  }

  # dimension: platform {
  #   type: string
  #   description: "Operating system of device"
  #   sql: ${TABLE}.platform ;;
  #   hidden:  yes
  # }

#  dimension: session_device_type {
#    type: number
#    sql: ${TABLE}.session_device_type ;;
#    hidden:  yes }

  # dimension: country {
  #   type: string
  #   group_label: "Geography"
  #   sql: ${TABLE}.country ;;
  #   hidden:  yes
  # }

  # dimension: region {
  #   type: string
  #   group_label: "Geography"
  #   sql: ${TABLE}.region ;;
  #   hidden:  yes
  # }

  # dimension: city {
  #   type: string
  #   group_label: "Geography"
  #   sql: ${TABLE}.city ;;
  #   hidden:  yes
  # }

  # dimension: ip {
  #   type: string
  #   sql: ${TABLE}.ip ;;
  #   hidden:  yes
  # }

  # dimension: referrer {
  #   type: string
  #   sql: ${TABLE}.referrer ;;
  #   hidden:  yes
  # }

  # dimension: landing_page {
  #   type: string
  #   sql: ${TABLE}.landing_page ;;
  #   hidden:  yes
  # }

  # dimension: browser {
  #   type: string
  #   sql: ${TABLE}.browser ;;
  #   hidden:  yes
  # }

  # dimension: search_keyword {
  #   type: string
  #   sql: ${TABLE}.search_keyword ;;
  #   hidden:  yes
  # }

  dimension: utm_source {
    type: string
    view_label: "Sessions"
    group_label: "UTM"
    sql: ${TABLE}.utm_source ;;
    hidden:  yes
  }

  dimension: utm_campaign {
    type: string
    view_label: "Sessions"
    group_label: "UTM"
    sql: ${TABLE}.utm_campaign ;;
    hidden:  yes
  }

  dimension: utm_medium {
    type: string
    view_label: "Sessions"
    group_label: "UTM"
    sql: ${TABLE}.utm_medium ;;
    hidden:  yes
  }

  dimension: utm_term {
    type: string
    view_label: "Sessions"
    group_label: "UTM"
    sql: ${TABLE}.utm_term ;;
    hidden:  yes
  }

  dimension: utm_content {
    type: string
    view_label: "Sessions"
    group_label: "UTM"
    sql: ${TABLE}.utm_content ;;
    hidden:  yes
  }

  # dimension: device {
  #   type: string
  #   sql: ${TABLE}.device ;;
  #   hidden:  yes
  # }

  # dimension: carrier {
  #   type: string
  #   description: "Mobile Network Carrier"
  #   sql: ${TABLE}.carrier ;;
  #   hidden:  yes
  # }

  # dimension: app_name {
  #   type: string
  #   description: "Mobile App Name"
  #   sql: ${TABLE}.app_name ;;
  #   hidden:  yes
  # }

  # dimension: app_version {
  #   type: string
  #   description: "Mobile App Version"
  #   sql: ${TABLE}.app_version ;;
  #   hidden:  yes
  # }



 }
