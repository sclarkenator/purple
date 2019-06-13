view: user {
    sql_table_name:  analytics_stage.zendesk.user  ;;


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension: url {
    type: string
    hidden: yes
    sql: ${TABLE}."URL" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: time_zone {
    type: string
    hidden: yes
    sql: ${TABLE}."TIME_ZONE" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: locale_id {
    type: number
    hidden: yes
    sql: ${TABLE}."LOCALE_ID" ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}."LOCALE" ;;
  }

  dimension: organization_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ORGANIZATION_ID" ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}."ROLE" ;;
  }

  dimension: verified {
    type: string
    sql: ${TABLE}."VERIFIED" ;;
  }

  dimension: authenticity_token {
    type: string
    hidden: yes
    sql: ${TABLE}."AUTHENTICITY_TOKEN" ;;
  }

  dimension: external_id {
    type: string
    hidden: yes
    sql: ${TABLE}."EXTERNAL_ID" ;;
  }

  dimension: alias {
    type: string
    sql: ${TABLE}."ALIAS" ;;
  }

  dimension: active {
    type: string
    sql: ${TABLE}."ACTIVE" ;;
  }

  dimension: shared {
    type: string
    hidden: yes
    sql: ${TABLE}."SHARED" ;;
  }

  dimension: shared_agent {
    type: string
    hidden: yes
    sql: ${TABLE}."SHARED_AGENT" ;;
  }

  dimension_group: last_login_at {
    type: time
    sql: ${TABLE}."LAST_LOGIN_AT" ;;
  }

  dimension: two_factor_auth_enabled {
    type: string
    hidden: yes
    sql: ${TABLE}."TWO_FACTOR_AUTH_ENABLED" ;;
  }

  dimension: signature {
    type: string
    label: "Agent Message Signature"
    sql: ${TABLE}."SIGNATURE" ;;
  }

  dimension: details {
    type: string
    hidden: yes
    sql: ${TABLE}."DETAILS" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."NOTES" ;;
  }

  dimension: custom_role_id {
    type: number
    label: "bring in custom role table and join on this"
    sql: ${TABLE}."CUSTOM_ROLE_ID" ;;
  }

  dimension: moderator {
    type: string
    sql: ${TABLE}."MODERATOR" ;;
  }

  dimension: ticket_restriction {
    type: string
    hidden: yes
    sql: ${TABLE}."TICKET_RESTRICTION" ;;
  }

  dimension: only_private_comments {
    type: string
    hidden: yes
    sql: ${TABLE}."ONLY_PRIVATE_COMMENTS" ;;
  }

  dimension: restricted_agent {
    type: string
    sql: ${TABLE}."RESTRICTED_AGENT" ;;
  }

  dimension: suspended {
    type: string
    sql: ${TABLE}."SUSPENDED" ;;
  }

  dimension: chat_only {
    type: string
    hidden: yes
    sql: ${TABLE}."CHAT_ONLY" ;;
  }

  dimension: remote_photo_url {
    type: string
    sql: ${TABLE}."REMOTE_PHOTO_URL" ;;
  }

  dimension: custom_billing_address_1 {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_ADDRESS_1" ;;
  }

  dimension: custom_billing_address_2 {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_ADDRESS_2" ;;
  }

  dimension: custom_billing_phone {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_PHONE" ;;
  }

  dimension: custom_mobile_phone {
    type: string
    sql: ${TABLE}."CUSTOM_MOBILE_PHONE" ;;
  }

  dimension: custom_shipping_addressee {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ADDRESSEE" ;;
  }

  dimension: custom_billing_attention {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_ATTENTION" ;;
  }

  dimension: custom_shipping_address_ln_2 {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ADDRESS_LN_2" ;;
  }

  dimension: custom_currency_name {
    type: string
    sql: ${TABLE}."CUSTOM_CURRENCY_NAME" ;;
  }

  dimension: custom_credit_hold {
    type: string
    hidden: yes
    sql: ${TABLE}."CUSTOM_CREDIT_HOLD" ;;
  }

  dimension: custom_shipping_state {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_STATE" ;;
  }

  dimension: custom_shipping_country {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_COUNTRY" ;;
  }

  dimension: custom_shipping_address_phone {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ADDRESS_PHONE" ;;
  }

  dimension: custom_alternate_phone_2 {
    type: string
    sql: ${TABLE}."CUSTOM_ALTERNATE_PHONE_2" ;;
  }

  dimension: custom_alternate_phone_3 {
    type: string
    sql: ${TABLE}."CUSTOM_ALTERNATE_PHONE_3" ;;
  }

  dimension: custom_net_suite_sales_order_data {
    type: string
    hidden: yes
    description: "note from Russ: Data Engineering may be able to use this to tie back to the order/Netsuite data"
    sql: ${TABLE}."CUSTOM_NET_SUITE_SALES_ORDER_DATA" ;;
  }

  dimension: custom_created_in_freshdesk {
    type: date
    sql: ${TABLE}."CUSTOM_CREATED_IN_FRESHDESK" ;;
  }

  dimension: custom_billing_zip {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_ZIP" ;;
  }

  dimension: custom_shipping_address_ln_1 {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ADDRESS_LN_1" ;;
  }

  dimension: custom_alternate_phone_1 {
    type: string
    sql: ${TABLE}."CUSTOM_ALTERNATE_PHONE_1" ;;
  }

  dimension: custom_shipping_zip {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ZIP" ;;
  }

  dimension: custom_days_overdue {
    type: number
    sql: ${TABLE}."CUSTOM_DAYS_OVERDUE" ;;
  }

  dimension: custom_shipping_city {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_CITY" ;;
  }

  dimension: custom_fresh_desk_id {
    type: number
    sql: ${TABLE}."CUSTOM_FRESH_DESK_ID" ;;
  }

  dimension: custom_recent_order_numbers {
    type: string
    sql: ${TABLE}."CUSTOM_RECENT_ORDER_NUMBERS" ;;
  }

  dimension: custom_net_suite_id {
    type: number
    sql: ${TABLE}."CUSTOM_NET_SUITE_ID" ;;
  }

  dimension: custom_alt_email {
    type: string
    sql: ${TABLE}."CUSTOM_ALT_EMAIL" ;;
  }

  dimension: custom_billing_city {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_CITY" ;;
  }

  dimension: custom_net_suite_customer_id {
    type: string
    sql: ${TABLE}."CUSTOM_NET_SUITE_CUSTOMER_ID" ;;
  }

  dimension: custom_unbilled_orders {
    type: number
    sql: ${TABLE}."CUSTOM_UNBILLED_ORDERS" ;;
  }

  dimension: custom_shipping_attention {
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_ATTENTION" ;;
  }

  dimension: custom_billing_addressee {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_ADDRESSEE" ;;
  }

  dimension: custom_billing_country {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_COUNTRY" ;;
  }

  dimension: custom_billing_state {
    type: string
    sql: ${TABLE}."CUSTOM_BILLING_STATE" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden:  yes
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  dimension: custom_fax {
    type: string
    hidden: yes
    sql: ${TABLE}."CUSTOM_FAX" ;;
  }

  dimension: custom_credit_limit {
    type: number
    hidden: yes
    sql: ${TABLE}."CUSTOM_CREDIT_LIMIT" ;;
  }

  dimension: custom_agent_in_contact_id {
    type: number
    sql: ${TABLE}."CUSTOM_AGENT_IN_CONTACT_ID" ;;
  }

  dimension: custom_purple_communication_only {
    type: string
    sql: ${TABLE}."CUSTOM_PURPLE_COMMUNICATION_ONLY" ;;
  }

  dimension: custom_title {
    type: string
    hidden: yes
    sql: ${TABLE}."CUSTOM_TITLE" ;;
  }

  set: detail {
    fields: [
      id,
      url,
      name,
      email,
      created_at_time,
      updated_at_time,
      time_zone,
      phone,
      locale_id,
      locale,
      organization_id,
      role,
      verified,
      authenticity_token,
      external_id,
      alias,
      active,
      shared,
      shared_agent,
      last_login_at_time,
      two_factor_auth_enabled,
      signature,
      details,
      notes,
      custom_role_id,
      moderator,
      ticket_restriction,
      only_private_comments,
      restricted_agent,
      suspended,
      chat_only,
      remote_photo_url,
      custom_billing_address_1,
      custom_billing_address_2,
      custom_billing_phone,
      custom_mobile_phone,
      custom_shipping_addressee,
      custom_billing_attention,
      custom_shipping_address_ln_2,
      custom_currency_name,
      custom_credit_hold,
      custom_shipping_state,
      custom_shipping_country,
      custom_shipping_address_phone,
      custom_alternate_phone_2,
      custom_alternate_phone_3,
      custom_net_suite_sales_order_data,
      custom_created_in_freshdesk,
      custom_billing_zip,
      custom_shipping_address_ln_1,
      custom_alternate_phone_1,
      custom_shipping_zip,
      custom_days_overdue,
      custom_shipping_city,
      custom_fresh_desk_id,
      custom_recent_order_numbers,
      custom_net_suite_id,
      custom_alt_email,
      custom_billing_city,
      custom_net_suite_customer_id,
      custom_unbilled_orders,
      custom_shipping_attention,
      custom_billing_addressee,
      custom_billing_country,
      custom_billing_state,
      _fivetran_synced_time,
      custom_fax,
      custom_credit_limit,
      custom_agent_in_contact_id,
      custom_purple_communication_only,
      custom_title
    ]
  }
}
