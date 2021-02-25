view: tealium_contact {
  sql_table_name: "MARKETING"."TEALIUM_CONTACT"
    ;;

  dimension: email_address {
    group_label: "Customer Details"
    primary_key: yes
    type: string
    sql: ${TABLE}."EMAIL_ADDRESS" ;;
  }

  dimension: offl_first_name {
    group_label: "Customer Details"
    label: "First Name"
    type: string
    sql: ${TABLE}."OFFL_FIRST_NAME" ;;
  }

  dimension: offl_last_name {
    group_label: "Customer Details"
    label: "Last Name"
    type: string
    sql: ${TABLE}."OFFL_LAST_NAME" ;;
  }


  dimension: cordial_id {
    group_label: "Customer Details"
    type: string
    sql: ${TABLE}."CORDIAL_ID" ;;
  }

  dimension: offl_phone_number {
    group_label: "Customer Details"
    label: "Phone"
    type: string
    sql: ${TABLE}."OFFL_PHONE_NUMBER" ;;
  }

  dimension: offl_city {
    group_label: "Customer Details"
    label: "City"
    type: string
    sql: ${TABLE}."OFFL_CITY" ;;
  }

  dimension: offl_state {
    group_label: "Customer Details"
    label: "State"
    type: string
    sql: ${TABLE}."OFFL_STATE" ;;
  }

  dimension: offl_zipcode {
    group_label: "Customer Details"
    label: "Zip"
    type: string
    sql: ${TABLE}."OFFL_ZIPCODE" ;;
  }

  dimension: all_time_sales_base_ltv {
    group_label: "LTV"
    label: "Base LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_BASE_LTV" ;;
  }

  dimension: all_time_sales_bedding_ltv {
    group_label: "LTV"
    label: "Bedding LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_BEDDING_LTV" ;;
  }

  dimension: all_time_sales_mattress_ltv {
    group_label: "LTV"
    label: "Mattress LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_MATTRESS_LTV" ;;
  }

  dimension: all_time_sales_pet_ltv {
    group_label: "LTV"
    label: "Pet LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_PET_LTV" ;;
  }

  dimension: all_time_sales_pillow_ltv {
    group_label: "LTV"
    label: "Pillow LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_PILLOW_LTV" ;;
  }

  dimension: all_time_sales_seating_ltv {
    group_label: "LTV"
    label: "Seating LTV"
    type: number
    sql: ${TABLE}."ALL_TIME_SALES_SEATING_LTV" ;;
  }

  dimension_group: last_retail_order {
    group_label: "Last Sales Order Details"
    label: "Last Retail Order"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_RETAIL_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: offl_all_payment_methods {
    group_label: "Customer Details"
    label: "Payment Methods Used"
    type: string
    sql: ${TABLE}."OFFL_ALL_PAYMENT_METHODS" ;;
  }

  dimension: offl_all_time_exchange_orders {
    group_label: "Exchanged Order Details"
    label: "Exchanged Orders Count"
    type: number
    sql: ${TABLE}."OFFL_ALL_TIME_EXCHANGE_ORDERS" ;;
  }

  dimension: offl_all_time_return_orders {
    group_label: "Returned Order Details"
    label: "Returned Orders Count"
    type: number
    sql: ${TABLE}."OFFL_ALL_TIME_RETURN_ORDERS" ;;
  }

  dimension: offl_customer_source {
    group_label: "Customer Details"
    label: "Customer Source"
    type: string
    sql: ${TABLE}."OFFL_CUSTOMER_SOURCE" ;;
  }

  dimension: offl_first_touch_platform {
    group_label: "Marketing"
    label: "First Touch Platform"
    type: string
    sql: ${TABLE}."OFFL_FIRST_TOUCH_PLATFORM" ;;
  }

  dimension: offl_first_touch_source {
    group_label: "Marketing"
    label: "First Touch Source"
    type: string
    sql: ${TABLE}."OFFL_FIRST_TOUCH_SOURCE" ;;
  }

  dimension: offl_has_contacted_support {
    label: "Has Contacted Support"
    group_label: "Customer Details"
    type: yesno
    sql: ${TABLE}."OFFL_HAS_CONTACTED_SUPPORT" ;;
  }

  dimension: offl_has_draft_orders {
    group_label: "Customer Details"
    label: "Has Draft Orders"
    type: yesno
    sql: ${TABLE}."OFFL_HAS_DRAFT_ORDERS" ;;
  }

  dimension: offl_has_used_discounts {
    group_label: "Customer Details"
    label: "Has Used Discount"
    type: yesno
    sql: ${TABLE}."OFFL_HAS_USED_DISCOUNTS" ;;
  }

  dimension: offl_heard_source {
    group_label: "Customer Details"
    label: "Heard Source"
    description: "Hotjar survey on purchase"
    type: string
    sql: LTRIM(${TABLE}."OFFL_HEARD_SOURCE",'["') ;;
  }

  dimension_group: offl_last_order_cancelled {
    group_label: "Cancelled Order Details"
    label: "Last Order Cancelled"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OFFL_LAST_ORDER_CANCELLED_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: offl_last_order_exchange {
    group_label: "Exchanged Order Details"
    label: "Last Order Exchanged"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OFFL_LAST_ORDER_EXCHANGE_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: offl_last_order_sales_amount {
    group_label: "Last Sales Order Details"
    label: "Last Order Sales Amount"
    type: number
    sql: ${TABLE}."OFFL_LAST_ORDER_SALES_AMOUNT" ;;
  }

  dimension: offl_last_order_sales_category {
    group_label: "Last Sales Order Details"
    label: "Last Order Sales Category"
    type: string
    sql: ${TABLE}."OFFL_LAST_ORDER_SALES_CATEGORY" ;;
  }

  dimension_group: offl_last_return_order {
    group_label: "Returned Order Details"
    label: "Last Returned Order"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OFFL_LAST_RETURN_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }



  dimension_group: offl_last_sales_order {
    group_label: "Last Sales Order Details"
    label: "Last Sales Order"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."OFFL_LAST_SALES_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: offl_last_touch_platform {
    group_label: "Marketing"
    label: "Last Touch Platform"
    type: string
    sql: ${TABLE}."OFFL_LAST_TOUCH_PLATFORM" ;;
  }

  dimension: offl_last_touch_source {
    group_label: "Marketing"
    label: "Last Touch Source"
    type: string
    sql: ${TABLE}."OFFL_LAST_TOUCH_SOURCE" ;;
  }

  dimension_group: offl_latest_in_hand {
    group_label: "Customer Details"
    label: "Latest in Hand"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."OFFL_LATEST_IN_HAND_DATE" ;;
  }


  dimension: offl_latest_order_unfulfilled {
    group_label: "Customer Order Details"
    label: "Lastest order unfulfilled"
    type: yesno
    sql: ${TABLE}."OFFL_LATEST_ORDER_UNFULFILLED" ;;
  }

  dimension: offl_lifetime_value {
    group_label: "LTV"
    label: "Overall Lifetime Value"
    type: number
    sql: ${TABLE}."OFFL_LIFETIME_VALUE" ;;
  }

  dimension: offl_nps {
    group_label: "Customer Details"
    label: "NPS"
    type: string
    sql: ${TABLE}."OFFL_NPS" ;;
  }

  dimension: offl_total_warranty_orders {
    group_label: "Warranty Order Details"
    label: "Total Warranty Orders"
    type: number
    sql: ${TABLE}."OFFL_TOTAL_WARRANTY_ORDERS" ;;
  }

  dimension: offl_zendesk_id {
    group_label: "Customer Details"
    label: "Zendesk ID"
    type: string
    sql: ${TABLE}."OFFL_ZENDESK_ID" ;;
  }



}
