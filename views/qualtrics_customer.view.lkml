view: qualtrics_customer {
  sql_table_name: MARKETING.QUALTRICS_CUSTOMER ;;

  dimension: all_devices_used {
    type: string
    sql: ${TABLE}."ALL_DEVICES_USED" ;;
  }

  dimension: all_payment_methods {
    type: string
    sql: ${TABLE}."ALL_PAYMENT_METHODS" ;;
  }

  dimension: all_unique_items_sales_order {
    type: string
    sql: ${TABLE}."ALL_UNIQUE_ITEMS_SALES_ORDER" ;;
  }

  dimension: avg_order_frequency_in_hours {
    type: number
    sql: ${TABLE}."AVG_ORDER_FREQUENCY_IN_HOURS" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: eligible_for_nps_survey {
    type: yesno
    sql: ${TABLE}."ELIGIBLE_FOR_NPS_SURVEY" ;;
  }

  dimension: email {
    type: string
    sql: upper(${TABLE}."EMAIL") ;;
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
    sql: ${TABLE}."FIRST_ENCOUNTER" ;;
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
    sql: ${TABLE}."INSERT_TS" ;;
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
    sql: ${TABLE}."LAST_CANCELLED_ORDER_DATE" ;;
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
    sql: ${TABLE}."LAST_ENCOUNTER" ;;
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
    sql: ${TABLE}."LAST_EXCHANGE_ORDER_DATE" ;;
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
    sql: ${TABLE}."LAST_RETURN_ORDER_DATE" ;;
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
    sql: ${TABLE}."LAST_SALES_ORDER_DATE" ;;
  }

  dimension: last_sales_order_unique_item_categories {
    type: string
    sql: ${TABLE}."LAST_SALES_ORDER_UNIQUE_ITEM_CATEGORIES" ;;
  }

  dimension: last_sales_order_unique_items {
    type: string
    sql: ${TABLE}."LAST_SALES_ORDER_UNIQUE_ITEMS" ;;
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
    sql: ${TABLE}."LAST_WARRANTY_ORDER_DATE" ;;
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

  dimension: netsuite_customer_id {
    type: string
    sql: ${TABLE}."NETSUITE_CUSTOMER_ID" ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
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

  dimension: SURVEY_VALUES {
    type: string
    sql: ${TABLE}."SURVEY_VALUES" ;;
  }

  dimension: total_amount_return_orders {
    type: number
    sql: ${TABLE}."TOTAL_AMOUNT_RETURN_ORDERS" ;;
  }

  dimension: total_amount_sales_orders {
    type: number
    sql: ${TABLE}."TOTAL_AMOUNT_SALES_ORDERS" ;;
  }

  dimension: total_cancelled_orders {
    type: number
    sql: ${TABLE}."TOTAL_CANCELLED_ORDERS" ;;
  }

  dimension: total_items_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_ITEMS_IN_SALES_ORDER" ;;
  }

  dimension: total_sales_orders {
    type: number
    sql: ${TABLE}."TOTAL_SALES_ORDERS" ;;
  }

  dimension: total_support_tickets {
    type: number
    sql: ${TABLE}."TOTAL_SUPPORT_TICKETS" ;;
  }

  dimension: total_unique_item_categories_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEM_CATEGORIES_IN_SALES_ORDER" ;;
  }

  dimension: total_unique_items_in_return_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_RETURN_ORDER" ;;
  }

  dimension: total_unique_items_in_sales_order {
    type: number
    sql: ${TABLE}."TOTAL_UNIQUE_ITEMS_IN_SALES_ORDER" ;;
  }

  dimension: total_warranty_orders {
    type: number
    sql: ${TABLE}."TOTAL_WARRANTY_ORDERS" ;;
  }

  dimension: unsubscribed {
    type: yesno
    sql: ${TABLE}."UNSUBSCRIBED" ;;
  }

  dimension: update_needed {
    type: yesno
    sql: ${TABLE}."UPDATE_NEEDED" ;;
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
    sql: ${TABLE}."UPDATE_TS" ;;
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
    drill_fields: [firstname, lastname]
  }
}
