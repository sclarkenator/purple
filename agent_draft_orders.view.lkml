view: agent_draft_orders {
  derived_table: {
    sql:  select
  ID,BILLING_ADDRESS_ID,CUSTOMER_ID,LOCATION_ID,USER_ID,NUMBER,ORDER_NUMBER,NAME,CURRENCY,
  EMAIL,FINANCIAL_STATUS,FULFILLMENT_STATUS,CREATED_AT,UPDATED_AT,PROCESSED_AT,PROCESSING_METHOD,
  REFERRING_SITE,LANDING_SITE,CANCEL_REASON,CANCELLED_AT,CLOSED_AT,SUBTOTAL_PRICE,TOTAL_DISCOUNTS,
  TOTAL_LINE_ITEMS_PRICE,TOTAL_PRICE,TOTAL_TAX,TOTAL_WEIGHT,TAXES_INCLUDED,SOURCE_NAME,BROWSER_IP,
  BUYER_ACCEPTS_MARKETING,TOKEN,SHIPPING_ADDRESS_NAME,SHIPPING_ADDRESS_FIRST_NAME,SHIPPING_ADDRESS_LAST_NAME,
  SHIPPING_ADDRESS_COMPANY,SHIPPING_ADDRESS_PHONE,SHIPPING_ADDRESS_ADDRESS_1,SHIPPING_ADDRESS_ADDRESS_2,
  SHIPPING_ADDRESS_CITY,SHIPPING_ADDRESS_COUNTRY,SHIPPING_ADDRESS_COUNTRY_CODE,SHIPPING_ADDRESS_PROVINCE,
  SHIPPING_ADDRESS_PROVINCE_CODE,SHIPPING_ADDRESS_ZIP,SHIPPING_ADDRESS_LATITUDE,SHIPPING_ADDRESS_LONGITUDE,
  _FIVETRAN_SYNCED,BILLING_ADDRESS_CITY,BILLING_ADDRESS_COMPANY,BILLING_ADDRESS_PROVINCE_CODE,
  BILLING_ADDRESS_ADDRESS_2,BILLING_ADDRESS_COUNTRY_CODE,BILLING_ADDRESS_FIRST_NAME,BILLING_ADDRESS_ADDRESS_1,
  BILLING_ADDRESS_LONGITUDE,BILLING_ADDRESS_ZIP,BILLING_ADDRESS_PHONE,BILLING_ADDRESS_LATITUDE,
  BILLING_ADDRESS_PROVINCE,BILLING_ADDRESS_NAME,BILLING_ADDRESS_COUNTRY,BILLING_ADDRESS_LAST_NAME,
  CHECKOUT_TOKEN,CART_TOKEN,NOTE,LANDING_SITE_BASE_URL
from analytics_stage.shopify_us_ft."ORDER"
union
select
  ID,BILLING_ADDRESS_ID,CUSTOMER_ID,LOCATION_ID,USER_ID,NUMBER,ORDER_NUMBER,NAME,CURRENCY,
  EMAIL,FINANCIAL_STATUS,FULFILLMENT_STATUS,CREATED_AT,UPDATED_AT,PROCESSED_AT,PROCESSING_METHOD,
  REFERRING_SITE,LANDING_SITE,CANCEL_REASON,CANCELLED_AT,CLOSED_AT,SUBTOTAL_PRICE,TOTAL_DISCOUNTS,
  TOTAL_LINE_ITEMS_PRICE,TOTAL_PRICE,TOTAL_TAX,TOTAL_WEIGHT,TAXES_INCLUDED,SOURCE_NAME,BROWSER_IP,
  BUYER_ACCEPTS_MARKETING,TOKEN,SHIPPING_ADDRESS_NAME,SHIPPING_ADDRESS_FIRST_NAME,SHIPPING_ADDRESS_LAST_NAME,
  SHIPPING_ADDRESS_COMPANY,SHIPPING_ADDRESS_PHONE,SHIPPING_ADDRESS_ADDRESS_1,SHIPPING_ADDRESS_ADDRESS_2,
  SHIPPING_ADDRESS_CITY,SHIPPING_ADDRESS_COUNTRY,SHIPPING_ADDRESS_COUNTRY_CODE,SHIPPING_ADDRESS_PROVINCE,
  SHIPPING_ADDRESS_PROVINCE_CODE,SHIPPING_ADDRESS_ZIP,SHIPPING_ADDRESS_LATITUDE,SHIPPING_ADDRESS_LONGITUDE,
  _FIVETRAN_SYNCED,BILLING_ADDRESS_CITY,BILLING_ADDRESS_COMPANY,BILLING_ADDRESS_PROVINCE_CODE,
  BILLING_ADDRESS_ADDRESS_2,BILLING_ADDRESS_COUNTRY_CODE,BILLING_ADDRESS_FIRST_NAME,BILLING_ADDRESS_ADDRESS_1,
  BILLING_ADDRESS_LONGITUDE,BILLING_ADDRESS_ZIP,BILLING_ADDRESS_PHONE,BILLING_ADDRESS_LATITUDE,
  BILLING_ADDRESS_PROVINCE,BILLING_ADDRESS_NAME,BILLING_ADDRESS_COUNTRY,BILLING_ADDRESS_LAST_NAME,
  CHECKOUT_TOKEN,CART_TOKEN,NOTE,LANDING_SITE_BASE_URL
from analytics_stage.shopify_ca_ft."ORDER"
select
  ID,null as BILLING_ADDRESS_ID,CUSTOMER_ID,LOCATION_ID,USER_ID,NUMBER,ORDER_NUMBER,NAME,CURRENCY,
  EMAIL,FINANCIAL_STATUS,FULFILLMENT_STATUS,CREATED_AT,UPDATED_AT,PROCESSED_AT,PROCESSING_METHOD,
  REFERRING_SITE,null as LANDING_SITE,CANCEL_REASON,CANCELLED_AT,CLOSED_AT,SUBTOTAL_PRICE,TOTAL_DISCOUNTS,
  TOTAL_LINE_ITEMS_PRICE,TOTAL_PRICE,TOTAL_TAX,TOTAL_WEIGHT,TAXES_INCLUDED,SOURCE_NAME,BROWSER_IP,
  BUYER_ACCEPTS_MARKETING,TOKEN,SHIPPING_ADDRESS_NAME,SHIPPING_ADDRESS_FIRST_NAME,SHIPPING_ADDRESS_LAST_NAME,
  SHIPPING_ADDRESS_COMPANY,SHIPPING_ADDRESS_PHONE,SHIPPING_ADDRESS_ADDRESS_1,SHIPPING_ADDRESS_ADDRESS_2,
  SHIPPING_ADDRESS_CITY,SHIPPING_ADDRESS_COUNTRY,SHIPPING_ADDRESS_COUNTRY_CODE,SHIPPING_ADDRESS_PROVINCE,
  SHIPPING_ADDRESS_PROVINCE_CODE,SHIPPING_ADDRESS_ZIP,SHIPPING_ADDRESS_LATITUDE,SHIPPING_ADDRESS_LONGITUDE,
  _FIVETRAN_SYNCED,BILLING_ADDRESS_CITY,BILLING_ADDRESS_COMPANY,BILLING_ADDRESS_PROVINCE_CODE,
  BILLING_ADDRESS_ADDRESS_2,BILLING_ADDRESS_COUNTRY_CODE,BILLING_ADDRESS_FIRST_NAME,BILLING_ADDRESS_ADDRESS_1,
  BILLING_ADDRESS_LONGITUDE,BILLING_ADDRESS_ZIP,BILLING_ADDRESS_PHONE,BILLING_ADDRESS_LATITUDE,
  BILLING_ADDRESS_PROVINCE,BILLING_ADDRESS_NAME,BILLING_ADDRESS_COUNTRY,BILLING_ADDRESS_LAST_NAME,
  CHECKOUT_TOKEN,CART_TOKEN,NOTE,LANDING_SITE_BASE_URL
from analytics_stage.shopify_outlet."ORDER";;


  }

  measure: count {
    type: count
  }

  dimension: id {
    label: "Shopify Order ID"
    type: number
    primary_key: yes
    sql: ${TABLE}."ID" ;;
  }

  measure: shopify_count{
    type: count
  }

  measure: dollars_sold{
    type: sum
    sql: ${TABLE}."TOTAL_PRICE";;
    value_format: "$#,##0.00"
  }



  dimension: billing_address_id {
    type: number
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_ID" ;;
  }

  dimension: customer_id {
    type: number
    hidden: yes
    sql: ${TABLE}."CUSTOMER_ID" ;;
  }

  dimension: location_id {
    type: number
    hidden: yes
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: number {
    type: number
    hidden: yes
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: order_number {
    type: number
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: name {
    type: string
    label: "Shopify Reference ID"
    sql: ${TABLE}."NAME" ;;
  }

  dimension: currency {
    type: string
    hidden: yes
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: financial_status {
    type: string
    sql: ${TABLE}."FINANCIAL_STATUS" ;;
  }

  dimension: fulfillment_status {
    type: string
    sql: ${TABLE}."FULFILLMENT_STATUS" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension_group: processed_at {
    type: time
    sql: ${TABLE}."PROCESSED_AT" ;;
  }

  dimension: processing_method {
    type: string
    sql: ${TABLE}."PROCESSING_METHOD" ;;
  }

  dimension: referring_site {
    type: string
    sql: ${TABLE}."REFERRING_SITE" ;;
  }

  dimension: landing_site {
    type: string
    sql: ${TABLE}."LANDING_SITE" ;;
  }

  dimension: cancel_reason {
    type: string
    sql: ${TABLE}."CANCEL_REASON" ;;
  }

  dimension_group: cancelled_at {
    type: time
    sql: ${TABLE}."CANCELLED_AT" ;;
  }

  dimension_group: closed_at {
    type: time
    sql: ${TABLE}."CLOSED_AT" ;;
  }

  dimension: subtotal_price {
    type: number
    sql: ${TABLE}."SUBTOTAL_PRICE" ;;
  }

  dimension: total_discounts {
    type: number
    sql: ${TABLE}."TOTAL_DISCOUNTS" ;;
  }

  dimension: total_line_items_price {
    type: number
    sql: ${TABLE}."TOTAL_LINE_ITEMS_PRICE" ;;
  }

  dimension: total_price {
    type: number
    sql: ${TABLE}."TOTAL_PRICE" ;;
  }

  dimension: total_tax {
    type: number
    sql: ${TABLE}."TOTAL_TAX" ;;
  }

  dimension: total_weight {
    type: number
    hidden: yes
    sql: ${TABLE}."TOTAL_WEIGHT" ;;
  }

  dimension: taxes_included {
    type: string
    sql: ${TABLE}."TAXES_INCLUDED" ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}."SOURCE_NAME" ;;
  }

  dimension: browser_ip {
    type: string
    sql: ${TABLE}."BROWSER_IP" ;;
  }

  dimension: buyer_accepts_marketing {
    type: string
    sql: ${TABLE}."BUYER_ACCEPTS_MARKETING" ;;
  }

  dimension: token {
    type: string
    hidden: yes
    sql: ${TABLE}."TOKEN" ;;
  }

  dimension: shipping_address_name {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_NAME" ;;
  }

  dimension: shipping_address_first_name {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_FIRST_NAME" ;;
  }

  dimension: shipping_address_last_name {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_LAST_NAME" ;;
  }

  dimension: shipping_address_company {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_COMPANY" ;;
  }

  dimension: shipping_address_phone {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_PHONE" ;;
  }

  dimension: shipping_address_address_1 {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_ADDRESS_1" ;;
  }

  dimension: shipping_address_address_2 {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_ADDRESS_2" ;;
  }

  dimension: shipping_address_city {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_CITY" ;;
  }

  dimension: shipping_address_country {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_COUNTRY" ;;
  }

  dimension: shipping_address_country_code {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_COUNTRY_CODE" ;;
  }

  dimension: shipping_address_province {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_PROVINCE" ;;
  }

  dimension: shipping_address_province_code {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_PROVINCE_CODE" ;;
  }

  dimension: shipping_address_zip {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_ZIP" ;;
  }

  dimension: shipping_address_latitude {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_LATITUDE" ;;
  }

  dimension: shipping_address_longitude {
    type: string
    hidden: yes
    sql: ${TABLE}."SHIPPING_ADDRESS_LONGITUDE" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  dimension: note_attribute_require_signature_on_delivery {
    type: string
    hidden: yes
    sql: ${TABLE}."NOTE_ATTRIBUTE_REQUIRE_SIGNATURE_ON_DELIVERY" ;;
  }

  dimension: note_attribute_hubspotutk {
    type: string
    hidden: yes
    sql: ${TABLE}."NOTE_ATTRIBUTE_HUBSPOTUTK" ;;
  }

  dimension: note_attribute_hubspot_utk_ {
    type: string
    hidden: yes
    sql: ${TABLE}."NOTE_ATTRIBUTE_HUBSPOT_UTK_" ;;
  }

  dimension: note_attribute_hubspotutk_ {
    type: string
    hidden: yes
    sql: ${TABLE}."NOTE_ATTRIBUTE_HUBSPOTUTK_" ;;
  }

  dimension: billing_address_city {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_CITY" ;;
  }

  dimension: billing_address_company {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_COMPANY" ;;
  }

  dimension: billing_address_province_code {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_PROVINCE_CODE" ;;
  }

  dimension: billing_address_address_2 {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_ADDRESS_2" ;;
  }

  dimension: billing_address_country_code {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_COUNTRY_CODE" ;;
  }

  dimension: billing_address_first_name {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_FIRST_NAME" ;;
  }

  dimension: billing_address_address_1 {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_ADDRESS_1" ;;
  }

  dimension: billing_address_longitude {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_LONGITUDE" ;;
  }

  dimension: billing_address_zip {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_ZIP" ;;
  }

  dimension: billing_address_phone {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_PHONE" ;;
  }

  dimension: billing_address_latitude {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_LATITUDE" ;;
  }

  dimension: billing_address_province {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_PROVINCE" ;;
  }

  dimension: billing_address_name {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_NAME" ;;
  }

  dimension: billing_address_country {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_COUNTRY" ;;
  }

  dimension: billing_address_last_name {
    type: string
    hidden: yes
    sql: ${TABLE}."BILLING_ADDRESS_LAST_NAME" ;;
  }

  dimension: checkout_token {
    type: string
    hidden: yes
    sql: ${TABLE}."CHECKOUT_TOKEN" ;;
  }

  dimension: cart_token {
    type: string
    hidden: yes
    sql: ${TABLE}."CART_TOKEN" ;;
  }

  dimension: note {
    hidden: yes
    type: string
    sql: ${TABLE}."NOTE" ;;
  }

  dimension: landing_site_base_url {
    type: string
    sql: ${TABLE}."LANDING_SITE_BASE_URL" ;;
  }



#   set: detail {
#     fields: [
#       id,
#       billing_address_id,
#       customer_id,
#       location_id,
#       user_id,
#       number,
#       order_number,
#       name,
#       currency,
#       email,
#       financial_status,
#       fulfillment_status,
#       created_at_time,
#       updated_at_time,
#       processed_at_time,
#       processing_method,
#       referring_site,
#       landing_site,
#       cancel_reason,
#       cancelled_at_time,
#       closed_at_time,
#       subtotal_price,
#       total_discounts,
#       total_line_items_price,
#       total_price,
#       total_tax,
#       total_weight,
#       taxes_included,
#       source_name,
#       browser_ip,
#       buyer_accepts_marketing,
#       token,
#       shipping_address_name,
#       shipping_address_first_name,
#       shipping_address_last_name,
#       shipping_address_company,
#       shipping_address_phone,
#       shipping_address_address_1,
#       shipping_address_address_2,
#       shipping_address_city,
#       shipping_address_country,
#       shipping_address_country_code,
#       shipping_address_province,
#       shipping_address_province_code,
#       shipping_address_zip,
#       shipping_address_latitude,
#       shipping_address_longitude,
#       _fivetran_synced_time,
#       note_attribute_require_signature_on_delivery,
#       note_attribute_hubspotutk,
#       note_attribute_hubspot_utk_,
#       note_attribute_hubspotutk_,
#       billing_address_city,
#       billing_address_company,
#       billing_address_province_code,
#       billing_address_address_2,
#       billing_address_country_code,
#       billing_address_first_name,
#       billing_address_address_1,
#       billing_address_longitude,
#       billing_address_zip,
#       billing_address_phone,
#       billing_address_latitude,
#       billing_address_province,
#       billing_address_name,
#       billing_address_country,
#       billing_address_last_name,
#       checkout_token,
#       cart_token,
#       note,
#       landing_site_base_url
#     ]
#   }
}
