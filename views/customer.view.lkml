view: customer {
  sql_table_name: "SALES"."CUSTOMER"
    ;;
  drill_fields: [netsuite_customer_id]

  dimension: netsuite_customer_id {
    hidden: yes
    group_label: " Contact"
    type: string
    sql: ${TABLE}."NETSUITE_CUSTOMER_ID" ;;
  }

  dimension: address_line_1 {
    type: string
    sql: ${TABLE}."ADDRESS_LINE_1" ;;
  }

  dimension: address_line_2 {
    type: string
    sql: ${TABLE}."ADDRESS_LINE_2" ;;
  }

  dimension: all_devices_used {
    type: string
    sql: ${TABLE}."ALL_DEVICES_USED" ;;
  }

  dimension: all_payment_methods {
    type: string
    sql: ${TABLE}."ALL_PAYMENT_METHODS" ;;
  }

  dimension: all_unique_items_exchange_order {
    type: string
    sql: ${TABLE}."ALL_UNIQUE_ITEMS_EXCHANGE_ORDER" ;;
  }

  dimension: all_unique_items_return_order {
    type: string
    sql: ${TABLE}."ALL_UNIQUE_ITEMS_RETURN_ORDER" ;;
  }

  dimension: all_unique_items_sales_order {
    type: string
    sql: ${TABLE}."ALL_UNIQUE_ITEMS_SALES_ORDER" ;;
  }

  dimension: all_unique_items_warranty_order {
    type: string
    sql: ${TABLE}."ALL_UNIQUE_ITEMS_WARRANTY_ORDER" ;;
  }

  dimension: avg_order_frequency_in_hours {
    type: number
    sql: ${TABLE}."AVG_ORDER_FREQUENCY_IN_HOURS" ;;
  }

  dimension: ccpa {
    type: yesno
    sql: ${TABLE}."CCPA" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}."EMAIL" ;;
    primary_key: yes
  }

  dimension: email_is_disposable {
    type: yesno
    sql: ${TABLE}."EMAIL_IS_DISPOSABLE" ;;
  }

  dimension: email_is_role_address {
    type: yesno
    sql: ${TABLE}."EMAIL_IS_ROLE_ADDRESS" ;;
  }

  dimension: email_verified {
    type: string
    sql: ${TABLE}."EMAIL_VERIFIED" ;;
  }

  dimension_group: first_encounter {
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
    sql: CAST(${TABLE}."FIRST_ENCOUNTER" AS TIMESTAMP_NTZ) ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."FIRSTNAME" ;;
  }

  dimension: has_cancelled_order {
    type: yesno
    sql: ${TABLE}."HAS_CANCELLED_ORDER" ;;
  }

  dimension: has_contacted_support {
    type: yesno
    sql: ${TABLE}."HAS_CONTACTED_SUPPORT" ;;
  }

  dimension: has_draft_orders {
    type: yesno
    sql: ${TABLE}."HAS_DRAFT_ORDERS" ;;
  }

  dimension: has_ecommerce_orders {
    type: yesno
    sql: ${TABLE}."HAS_ECOMMERCE_ORDERS" ;;
  }

  dimension: has_exchange_orders {
    type: yesno
    sql: ${TABLE}."HAS_EXCHANGE_ORDERS" ;;
  }

  dimension: has_financed {
    type: yesno
    sql: ${TABLE}."HAS_FINANCED" ;;
  }

  dimension: has_general_orders {
    type: yesno
    sql: ${TABLE}."HAS_GENERAL_ORDERS" ;;
  }

  dimension: has_late_orders {
    type: yesno
    sql: ${TABLE}."HAS_LATE_ORDERS" ;;
  }

  dimension: has_return_orders {
    type: yesno
    sql: ${TABLE}."HAS_RETURN_ORDERS" ;;
  }

  dimension: has_sales_orders {
    type: yesno
    sql: ${TABLE}."HAS_SALES_ORDERS" ;;
  }

  dimension: has_used_discounts {
    type: yesno
    sql: ${TABLE}."HAS_USED_DISCOUNTS" ;;
  }

  dimension: has_warranty_orders {
    type: yesno
    sql: ${TABLE}."HAS_WARRANTY_ORDERS" ;;
  }

  dimension_group: insert_ts {
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: is_hubspot_user {
    type: yesno
    sql: ${TABLE}."IS_HUBSPOT_USER" ;;
  }

  dimension: is_in_shopify {
    type: yesno
    sql: ${TABLE}."IS_IN_SHOPIFY" ;;
  }

  dimension: is_netsuite_customer {
    type: yesno
    sql: ${TABLE}."IS_NETSUITE_CUSTOMER" ;;
  }

  dimension: is_netsuite_deleted {
    type: yesno
    sql: ${TABLE}."IS_NETSUITE_DELETED" ;;
  }

  dimension: is_netsuite_entity {
    type: yesno
    sql: ${TABLE}."IS_NETSUITE_ENTITY" ;;
  }

  dimension: is_netsuite_sub_customer {
    type: yesno
    sql: ${TABLE}."IS_NETSUITE_SUB_CUSTOMER" ;;
  }

  dimension: is_zendesk_user {
    type: yesno
    sql: ${TABLE}."IS_ZENDESK_USER" ;;
  }

  dimension: last_cancelled_order_amount {
    type: number
    sql: ${TABLE}."LAST_CANCELLED_ORDER_AMOUNT" ;;
  }

  dimension_group: last_cancelled_order {
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
    sql: CAST(${TABLE}."LAST_CANCELLED_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_device_used {
    type: string
    sql: ${TABLE}."LAST_DEVICE_USED" ;;
  }

  dimension_group: last_encounter {
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
    sql: CAST(${TABLE}."LAST_ENCOUNTER" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_exchange_order {
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
    sql: CAST(${TABLE}."LAST_EXCHANGE_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_exchange_order_unique_item_categories {
    type: string
    sql: ${TABLE}."LAST_EXCHANGE_ORDER_UNIQUE_ITEM_CATEGORIES" ;;
  }

  dimension: last_exchange_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_EXCHANGE_ORDER_UNIQUE_ITEMS" ;;
  }

  dimension: last_return_order_amount {
    type: number
    sql: ${TABLE}."LAST_RETURN_ORDER_AMOUNT" ;;
  }

  dimension_group: last_return_order {
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
    sql: CAST(${TABLE}."LAST_RETURN_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_return_order_unique_item_categories {
    type: string
    sql: ${TABLE}."LAST_RETURN_ORDER_UNIQUE_ITEM_CATEGORIES" ;;
  }

  dimension: last_return_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_RETURN_ORDER_UNIQUE_ITEMS" ;;
  }

  dimension: last_sales_order_amount {
    type: number
    sql: ${TABLE}."LAST_SALES_ORDER_AMOUNT" ;;
  }

  dimension_group: last_sales_order {
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
    sql: CAST(${TABLE}."LAST_SALES_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_sales_order_unique_item_categories {
    type: string
    sql: ${TABLE}."LAST_SALES_ORDER_UNIQUE_ITEM_CATEGORIES" ;;
  }

  dimension: last_sales_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_SALES_ORDER_UNIQUE_ITEMS" ;;
  }

  dimension: last_sales_order_used_discount {
    type: yesno
    sql: ${TABLE}."LAST_SALES_ORDER_USED_DISCOUNT" ;;
  }

  dimension_group: last_warranty_order {
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
    sql: CAST(${TABLE}."LAST_WARRANTY_ORDER_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_warranty_order_unique_item_categories {
    type: string
    sql: ${TABLE}."LAST_WARRANTY_ORDER_UNIQUE_ITEM_CATEGORIES" ;;
  }

  dimension: last_warranty_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_WARRANTY_ORDER_UNIQUE_ITEMS" ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."LASTNAME" ;;
  }

  dimension_group: latest_fulfilled {
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
    sql: ${TABLE}."LATEST_FULFILLED_DATE" ;;
  }

  dimension: latest_order_unfulfilled {
    type: yesno
    sql: ${TABLE}."LATEST_ORDER_UNFULFILLED" ;;
  }

  dimension: latest_sales_order_id {
    type: string
    sql: ${TABLE}."LATEST_SALES_ORDER_ID" ;;
  }

  dimension: netsuite_cancelled_orders {
    type: string
    sql: ${TABLE}."NETSUITE_CANCELLED_ORDERS" ;;
  }

  dimension: netsuite_exchange_orders {
    type: string
    sql: ${TABLE}."NETSUITE_EXCHANGE_ORDERS" ;;
  }

  dimension: netsuite_return_orders {
    type: string
    sql: ${TABLE}."NETSUITE_RETURN_ORDERS" ;;
  }

  dimension: netsuite_sales_orders {
    type: string
    sql: ${TABLE}."NETSUITE_SALES_ORDERS" ;;
  }

  dimension: netsuite_warranty_orders {
    type: string
    sql: ${TABLE}."NETSUITE_WARRANTY_ORDERS" ;;
  }

  dimension_group: opted_in_email {
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
    sql: CAST(${TABLE}."OPTED_IN_EMAIL_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
  }

  dimension: qualtrics_survey_count {
    type: number
    sql: ${TABLE}."QUALTRICS_SURVEY_COUNT" ;;
  }

  dimension: qualtrics_surveys {
    type: string
    sql: ${TABLE}."QUALTRICS_SURVEYS" ;;
  }

  dimension: shopify_customer_id {
    type: string
    sql: ${TABLE}."SHOPIFY_CUSTOMER_ID" ;;
  }

  dimension: sources {
    type: string
    sql: ${TABLE}."SOURCES" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: total_amount_return_orders {
    type: number
    sql: ${TABLE}."TOTAL_AMOUNT_RETURN_ORDERS" ;;
  }

  dimension: total_amount_sales_orders {
    type: number
    sql: ${TABLE}."TOTAL_AMOUNT_SALES_ORDERS" ;;
  }

  dimension: total_blank_email_orders {
    type: number
    sql: ${TABLE}."TOTAL_BLANK_EMAIL_ORDERS" ;;
  }

  dimension: total_cancelled_orders {
    type: number
    sql: ${TABLE}."TOTAL_CANCELLED_ORDERS" ;;
  }

  dimension: total_discount_applied {
    type: number
    sql: ${TABLE}."TOTAL_DISCOUNT_APPLIED" ;;
  }

  dimension: total_exchange_orders {
    type: number
    sql: ${TABLE}."TOTAL_EXCHANGE_ORDERS" ;;
  }

  dimension: total_items_in_exchange_order {
    type: number
    sql: ${TABLE}."TOTAL_ITEMS_IN_EXCHANGE_ORDER" ;;
  }

  dimension: total_items_in_return_order {
    type: number
    sql: ${TABLE}."TOTAL_ITEMS_IN_RETURN_ORDER" ;;
  }

  dimension: total_items_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_ITEMS_IN_SALES_ORDER" ;;
  }

  dimension: total_items_in_warranty_order {
    type: number
    sql: ${TABLE}."TOTAL_ITEMS_IN_WARRANTY_ORDER" ;;
  }

  dimension: total_return_orders {
    type: number
    sql: ${TABLE}."TOTAL_RETURN_ORDERS" ;;
  }

  dimension: total_sales_orders {
    type: number
    sql: ${TABLE}."TOTAL_SALES_ORDERS" ;;
  }

  dimension: total_support_tickets {
    type: number
    sql: ${TABLE}."TOTAL_SUPPORT_TICKETS" ;;
  }

  dimension: total_unique_item_categories_in_exchange_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEM_CATEGORIES_IN_EXCHANGE_ORDER" ;;
  }

  dimension: total_unique_item_categories_in_return_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEM_CATEGORIES_IN_RETURN_ORDER" ;;
  }

  dimension: total_unique_item_categories_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEM_CATEGORIES_IN_SALES_ORDER" ;;
  }

  dimension: total_unique_item_categories_in_warranty_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEM_CATEGORIES_IN_WARRANTY_ORDER" ;;
  }

  dimension: total_unique_items_in_exchange_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_EXCHANGE_ORDER" ;;
  }

  dimension: total_unique_items_in_return_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_RETURN_ORDER" ;;
  }

  dimension: total_unique_items_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_SALES_ORDER" ;;
  }

  dimension: total_unique_items_in_warranty_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_WARRANTY_ORDER" ;;
  }

  dimension: total_warranty_orders {
    type: number
    sql: ${TABLE}."TOTAL_WARRANTY_ORDERS" ;;
  }

  dimension_group: update_ts {
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: zendesk_id {
    type: string
    sql: ${TABLE}."ZENDESK_ID" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."ZIPCODE" ;;
  }

  measure: count {
    type: count
    drill_fields: [netsuite_customer_id, firstname, lastname]
  }
}
