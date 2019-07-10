view: starship_fulfillment {
  sql_table_name: STARSHIP.STARSHIP_FULFILLMENT ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: addressaddressee {
    label: "Customer Name"
    description: "The customer name listed in Starship"
    type: string
    sql: ${TABLE}."ADDRESSADDRESSEE" ;;
  }

  dimension: addressattention {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESSATTENTION" ;;
  }

  dimension: addresscity {
    label: "City"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSCITY" ;;
  }

  dimension: addresscountry {
    label: "Country"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSCOUNTRY" ;;
  }

  dimension: addressemail {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESSEMAIL" ;;
  }

  dimension: addressline1 {
    label: "Address"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSLINE1" ;;
  }

  dimension: addressline2 {
    label: "Address Line 2"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSLINE2" ;;
  }

  dimension: addressline3 {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESSLINE3" ;;
  }

  dimension: addressphone {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESSPHONE" ;;
  }

  dimension: addresspostal_code {
    label: "Zip Code"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSPOSTAL_CODE" ;;
  }

  dimension: addressresidential {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ADDRESSRESIDENTIAL" ;;
  }

  dimension: addressstate {
    label: "State"
    group_label: "Shipping Address"
    type: string
    sql: ${TABLE}."ADDRESSSTATE" ;;
  }

  dimension: batchid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."BATCHID" ;;
  }

  dimension: billing_account {
    hidden: yes
    type: string
    sql: ${TABLE}."BILLING_ACCOUNT" ;;
  }

  dimension: binid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."BINID" ;;
  }

  dimension_group: created {
    label: "Created"
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: createdbyid {
    label: "Record Created by"
    description: "The primary key for the user table of who created the record"
    hidden: yes
    type: string
    value_format_name: id
    sql: ${TABLE}."CREATEDBYID" ;;
  }

  dimension: currency {
    hidden: yes
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: deleted {
    hidden: yes
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."DELETED_AT" ;;
  }

  dimension: deletedbyid {
    hidden: yes
    label: "Record deleted by"
    description: "The primary key for the user table of who deleted the record"
    type: number
    value_format_name: id
    sql: ${TABLE}."DELETEDBYID" ;;
  }

  dimension_group: estimated_delivery {
    hidden: yes
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
    sql: ${TABLE}."ESTIMATED_DELIVERY_DATE" ;;
  }

  dimension: hubid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."HUBID" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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

  dimension: netsuite_id {
    label: "Sales Order ID"
    description: "Netsuite Internal ID for the Sales order"
    type: string
    sql: ${TABLE}."NETSUITE_ID" ;;
  }

  dimension: processed {
    hidden: yes
    type: yesno
    sql: ${TABLE}."PROCESSED" ;;
  }

  dimension_group: processed {
    description: "What time was the fulfilment processed"
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
    sql: ${TABLE}."PROCESSED_AT" ;;
  }

  dimension: processedbyid {
    hidden: yes
    label: "Record Processed by"
    description: "The primary key for the user table of who processed the record"
    type: string
    value_format_name: id
    sql: ${TABLE}."PROCESSEDBYID" ;;
  }

  dimension: require_signature {
    hidden: yes
    type: number
    sql: ${TABLE}."REQUIRE_SIGNATURE" ;;
  }

  dimension: salesorderid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."SALESORDERID" ;;
  }

  dimension: shipped {
    hidden: yes
    type: yesno
    sql: ${TABLE}."SHIPPED" ;;
  }

  dimension_group: shipped {
    description: "When was the order shipped in Starship"
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: shippedbyid {
    label: "Shipped by"
    description: "The primary key for the user table of who marked the record shipped"
    type: string
    value_format_name: id
    sql: ${TABLE}."SHIPPEDBYID" ;;
  }

  dimension: shipping_instructions {
    hidden: yes
    type: string
    sql: ${TABLE}."SHIPPING_INSTRUCTIONS" ;;
  }

  dimension: shippinglineid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."SHIPPINGLINEID" ;;
  }

  dimension: shippingmethodid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."SHIPPINGMETHODID" ;;
  }

  measure: total {
    label: "Carrier Charges Total"
    type: sum
    sql: ${TABLE}."TOTAL" ;;
  }

  dimension: tracking_numbers {
    label: "Tracking number on the shipment"
    type: string
    sql: ${TABLE}."TRACKING_NUMBERS" ;;
  }

  dimension: tracking_url {
    label: "Tracking URL on the shipment"
    type: string
    sql: ${TABLE}."TRACKING_URL" ;;
  }

  dimension: transaction_id {
    hidden: yes
    type: string
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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

  dimension_group: updated {
    hidden: yes
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
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: warehouseid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."WAREHOUSEID" ;;
  }

  measure: count_of_orders {
    type: count
    drill_fields: [id]
  }
}
