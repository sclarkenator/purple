view: gtms {
  sql_table_name: "SHIPPING"."GTMS";;
  view_label: "GTMS"

  dimension: lading_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."LADING_ID" ;;
  }

  measure: quoted_accs_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_accs_cost;;
  }

  dimension: bill_to_adr1 {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_ADR1" ;;
  }

  dimension: bill_to_adr2 {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_ADR2" ;;
  }

  dimension: bill_to_city {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_CITY" ;;
  }

  dimension: bill_to_name {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_NAME" ;;
  }

  dimension: bill_to_state {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_STATE" ;;
  }

  dimension: bill_to_zip {
    type: string
    group_label: " Bill To"
    sql: ${TABLE}."BILL_TO_ZIP" ;;
  }

  dimension: carrier_bol_no {
    type: string
    group_label: " Carrier"
    sql: ${TABLE}."CARRIER_BOL_NO" ;;
  }

  dimension: carrier_code {
    type: string
    group_label: " Carrier"
    sql: ${TABLE}."CARRIER_CODE" ;;
  }

  dimension: carrier_name {
    type: string
    group_label: " Carrier"
    sql: upper(${TABLE}."CARRIER_NAME") ;;
  }

  dimension: carrier_notes {
    type: string
    group_label: " Carrier"
    sql: ${TABLE}."CARRIER_NOTES" ;;
  }

  dimension: carrier_type {
    type: string
    group_label: " Carrier"
    sql: ${TABLE}."CARRIER_TYPE" ;;
  }

  dimension: client_lading_no {
    type: string
    label: "Bill of Lading #"
    sql: ${TABLE}."CLIENT_LADING_NO" ;;
  }

  measure: distinct_BOLs {
    type:  count_distinct
    sql: ${client_lading_no} ;;
  }

  dimension: consignee_notes {
    type: string
    sql: ${TABLE}."CONSIGNEE_NOTES" ;;
  }


  dimension_group: created {
    type: time
    group_label: "  Created"
    view_label: "Dates"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension_group: delivery {
    type: time
    group_label: "  Delivery"
    view_label: "Dates"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERY" ;;
  }

  dimension: dest_adr1 {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_ADR1" ;;
  }

  dimension: dest_adr2 {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_ADR2" ;;
  }

  dimension: dest_city {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_CITY" ;;
  }

  dimension: dest_contact_person {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_CONTACT_PERSON" ;;
  }

  dimension: dest_contact_phone {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_CONTACT_PHONE" ;;
  }

  dimension: dest_country {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_COUNTRY" ;;
  }

  dimension: dest_email {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_EMAIL" ;;
  }

  dimension: dest_name {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_NAME" ;;
  }

  dimension: dest_state {
    type: string
    group_label: " Destination"
    map_layer_name: us_states
    sql: concat(upper(substring(${TABLE}."DEST_STATE",0,1)),lower(substring(${TABLE}."DEST_STATE",2))) ;;
  }

  dimension: dest_terminal_name {
    type: string
    group_label: " Destination"
    sql: ${TABLE}."DEST_TERMINAL_NAME" ;;
  }

  dimension: dest_zip {
    type: string
    group_label: " Destination"
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}."DEST_ZIP" ;;
  }

  dimension: entry_source {
    type: string
    sql: ${TABLE}."ENTRY_SOURCE" ;;
  }

  dimension: equipment {
    type: string
    sql: ${TABLE}."EQUIPMENT" ;;
  }

  dimension: equipment_group {
    type: string
    sql: case
          when ${equipment} = 'LTL' then 'LTL'
          when ${equipment} = 'VOLUME' then 'LTL'
          when ${equipment} = 'Expedite' then 'Service Level'
          when ${equipment} = 'Guaranteed' then 'Service Level'
          when ${equipment} ilike '%intermodal%' then 'Intermodal'
          else 'FTL'
        end;;
  }

  measure: quoted_freight_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_freight_cost ;;
  }

  measure: quoted_fuel_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_fuel_cost ;;
  }

  measure: miles {
    type: sum
    sql: ${TABLE}."MILES" ;;
  }

  measure: avg_miles {
    type: average
    value_format: "#0"
    sql: ${TABLE}."MILES" ;;
  }

  dimension: mode {
    type: string
    sql: ${TABLE}."MODE" ;;
  }

  dimension_group: modified {
    type: time
    group_label: "  Modified"
    view_label: "Dates"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: modified_by {
    type: string
    sql: ${TABLE}."MODIFIED_BY" ;;
  }

  dimension: org_adr1 {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_ADR1" ;;
  }

  dimension: org_adr2 {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_ADR2" ;;
  }

  dimension: org_city {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_CITY" ;;
  }

  dimension: org_country {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_COUNTRY" ;;
  }

  dimension: org_name {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_NAME" ;;
  }

  dimension: org_state {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_STATE" ;;
  }

  dimension: org_zip {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORG_ZIP" ;;
  }

  dimension: origin_contact_person {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORIGIN_CONTACT_PERSON" ;;
  }

  dimension: origin_contact_phone {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORIGIN_CONTACT_PHONE" ;;
  }

  dimension: origin_email {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORIGIN_EMAIL" ;;
  }

  dimension: origin_terminal_name {
    type: string
    group_label: " Origin"
    sql: ${TABLE}."ORIGIN_TERMINAL_NAME" ;;
  }

  measure: paid_amount {
    type: sum
    sql: ${TABLE}."PAID_AMOUNT" ;;
  }

  measure: pallets {
    type: sum
    sql: ${TABLE}."PALLETS" ;;
  }

  dimension: payment_term {
    type: string
    sql: ${TABLE}."PAYMENT_TERM" ;;
  }

  measure: pieces {
    type: sum
    sql: ${TABLE}."PIECES" ;;
  }

  dimension_group: pickup {
    type: time
    group_label: "   Pickup"
    view_label: "Dates"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PICKUP" ;;
  }

  dimension: pickup_api_call_status {
    type: string
    sql: ${TABLE}."PICKUP_API_CALL_STATUS" ;;
  }

  dimension: pickup_number {
    type: string
    sql: ${TABLE}."PICKUP_NUMBER" ;;
  }

  dimension: po_number {
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension_group: pro {
    type: time
    group_label: "  Pro"
    view_label: "Dates"
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
    sql: ${TABLE}."PRO" ;;
  }

  dimension: pro_number {
    type: string
    sql: ${TABLE}."PRO_NUMBER" ;;
  }

  dimension: purchase_order {
    type: string
    sql: ${TABLE}."PURCHASE_ORDER" ;;
  }

  dimension_group: quote {
    type: time
    group_label: "  Quote"
    view_label: "Dates"
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
    sql: ${TABLE}."QUOTE" ;;
  }

  dimension: quote_number {
    type: string
    sql: ${TABLE}."QUOTE_NUMBER" ;;
  }

  dimension_group: requested_delivery {
    type: time
    group_label: "  Requested Delivery"
    view_label: "Dates"
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
    sql: ${TABLE}."REQUESTED_DELIVERY" ;;
  }

  dimension: requested_delivery_from {
    type: string
    group_label: " Requested"
    sql: ${TABLE}."REQUESTED_DELIVERY_FROM" ;;
  }

  dimension: requested_delivery_to {
    type: string
    group_label: " Requested"
    sql: ${TABLE}."REQUESTED_DELIVERY_TO" ;;
  }

  dimension_group: requested_pickup {
    type: time
    group_label: "  Requested Pickup"
    view_label: "Dates"
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
    sql: ${TABLE}."REQUESTED_PICKUP" ;;
  }

  dimension: requested_pickup_from {
    type: string
    group_label: " Requested"
    sql: ${TABLE}."REQUESTED_PICKUP_FROM" ;;
  }

  dimension: requested_pickup_to {
    type: string
    group_label: " Requested"
    sql: ${TABLE}."REQUESTED_PICKUP_TO" ;;
  }

  dimension: sales_order {
    type: string
    sql: ${TABLE}."SALES_ORDER" ;;
  }

  dimension: seal_no {
    type: string
    sql: ${TABLE}."SEAL_NO" ;;
  }

  measure: quoted_ship_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_ship_cost ;;
  }

  dimension: shipment_direction {
    type: string
    sql: ${TABLE}."SHIPMENT_DIRECTION" ;;
  }

  dimension: shipment_error {
    type: string
    sql: ${TABLE}."SHIPMENT_ERROR" ;;
  }

  dimension: shipment_value {
    type: number
    sql: ${TABLE}."SHIPMENT_VALUE" ;;
  }

  dimension: shipper_notes {
    type: string
    sql: ${TABLE}."SHIPPER_NOTES" ;;
  }

  dimension: spl_notes {
    type: string
    sql: ${TABLE}."SPL_NOTES" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: total_height {
    type: number
    group_label: " Dimensions"
    sql: ${TABLE}."TOTAL_HEIGHT" ;;
  }

  dimension: total_length {
    type: number
    group_label: " Dimensions"
    sql: ${TABLE}."TOTAL_LENGTH" ;;
  }

  dimension: total_width {
    type: number
    group_label: " Dimensions"
    sql: ${TABLE}."TOTAL_WIDTH" ;;
  }

  dimension: trailer_no {
    type: string
    sql: ${TABLE}."TRAILER_NO" ;;
  }

  dimension: trans_time {
    type: number
    sql: ${TABLE}."TRANS_TIME" ;;
  }

  dimension: transfer_order {
    type: string
    sql: ${TABLE}."TRANSFER_ORDER" ;;
  }

  dimension: transit_days {
    type: number
    sql: ${TABLE}."TRANSIT_DAYS" ;;
  }

  measure: avg_transit_days{
    type: average
    value_format: "##.0"
    sql: ${transit_days} ;;
  }

  dimension: truck_no {
    type: string
    sql: ${TABLE}."TRUCK_NO" ;;
  }

  measure: weight {
    type: sum
    sql: ${TABLE}."WEIGHT" ;;
  }

  dimension: pickup_to_delivery {
    type: number
    hidden: yes
    sql: datediff(day,${pickup_date},${delivery_date}) ;;
  }

  measure: avg_pickup_to_delivery {
    type: average
    value_format: "##.0"
    sql: ${pickup_to_delivery} ;;
  }

  set: detail {
    fields: [
      carrier_name,
      dest_name,
      org_name,
      origin_terminal_name,
      dest_terminal_name,
      bill_to_name
    ]
  }
}
