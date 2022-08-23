view: gtms {
  sql_table_name: "SHIPPING"."GTMS";;
  view_label: "GTMS"

  ########################################################################################
  ## PRIMARY KEY
  ########################################################################################

  dimension: lading_id {
    type: number
    primary_key: yes
    link: {
        label: "Bill of Lading"
        url: "https://tms.gtms.us/CrReports/Viewers/RptBolCustom.aspx?LadingID={{value}}&BolTemplate=77&ClientID=1152"
    }
    sql: ${TABLE}."LADING_ID" ;;
  }

  ########################################################################################
  ## ID's
  ########################################################################################

  ########################################################################################
  ## DIMENSIONS
  ########################################################################################

  dimension: created_by {
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: client_lading_no {
    type: string
    label: "Bill of Lading #"
    sql: ${TABLE}."CLIENT_LADING_NO" ;;
  }

  dimension: consignee_notes {
    type: string
    sql: ${TABLE}."CONSIGNEE_NOTES" ;;
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

  dimension: mode {
    type: string
    sql: ${TABLE}."MODE" ;;
  }

  dimension: modified_by {
    type: string
    sql: ${TABLE}."MODIFIED_BY" ;;
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

  dimension: truck_no {
    type: string
    sql: ${TABLE}."TRUCK_NO" ;;
  }

  dimension: pickup_to_delivery {
    type: number
    hidden: yes
    sql: datediff(day,${pickup_date},${delivery_date}) ;;
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

  dimension: sales_order {
    type: string
    sql: ${TABLE}."SALES_ORDER" ;;
  }

  dimension: seal_no {
    type: string
    sql: ${TABLE}."SEAL_NO" ;;
  }

  dimension: pro_number {
    type: string
    sql: ${TABLE}."PRO_NUMBER" ;;
  }

  dimension: purchase_order {
    type: string
    sql: ${TABLE}."PURCHASE_ORDER" ;;
  }

  dimension: quote_number {
    type: string
    sql: ${TABLE}."QUOTE_NUMBER" ;;
  }

  #########################################
  ## BILL TO
  #########################################
  dimension: bill_to_adr1 {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_ADR1" ;;
  }

  dimension: bill_to_adr2 {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_ADR2" ;;
  }

  dimension: bill_to_city {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_CITY" ;;
  }

  dimension: bill_to_name {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_NAME" ;;
  }

  dimension: bill_to_state {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_STATE" ;;
  }

  dimension: bill_to_zip {
    view_label: "Bill To"
    type: string
    sql: ${TABLE}."BILL_TO_ZIP" ;;
  }

  #########################################
  ## CARRIER
  #########################################

  dimension: carrier_bol_no {
    view_label: "Carrier"
    type: string
    sql: ${TABLE}."CARRIER_BOL_NO" ;;
  }

  dimension: carrier_code {
    view_label: "Carrier"
    type: string
    sql: ${TABLE}."CARRIER_CODE" ;;
  }

  dimension: carrier_name {
    view_label: "Carrier"
    type: string
    sql: upper(${TABLE}."CARRIER_NAME") ;;
  }

  dimension: carrier_notes {
    view_label: "Carrier"
    type: string
    sql: ${TABLE}."CARRIER_NOTES" ;;
  }

  dimension: carrier_type {
    view_label: "Carrier"
    type: string
    sql: ${TABLE}."CARRIER_TYPE" ;;
  }

  #########################################
  ## DESTINATION
  #########################################

  dimension: dest_adr1 {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_ADR1" ;;
  }

  dimension: dest_adr2 {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_ADR2" ;;
  }

  dimension: dest_city {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_CITY" ;;
  }

  dimension: dest_contact_person {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_CONTACT_PERSON" ;;
  }

  dimension: dest_contact_phone {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_CONTACT_PHONE" ;;
  }

  dimension: dest_country {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_COUNTRY" ;;
  }

  dimension: dest_email {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_EMAIL" ;;
  }

  dimension: dest_name {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_NAME" ;;
  }

  dimension: dest_state {
    view_label: " Destination"
    type: string
    map_layer_name: us_states
    sql: concat(upper(substring(${TABLE}."DEST_STATE",0,1)),lower(substring(${TABLE}."DEST_STATE",2))) ;;
  }

  dimension: dest_terminal_name {
    view_label: " Destination"
    type: string
    sql: ${TABLE}."DEST_TERMINAL_NAME" ;;
  }

  dimension: dest_zip {
    view_label: " Destination"
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}."DEST_ZIP" ;;
  }

  #########################################
  ## ORGIN
  #########################################

  dimension: org_adr1 {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_ADR1" ;;
  }

  dimension: org_adr2 {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_ADR2" ;;
  }

  dimension: org_city {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_CITY" ;;
  }

  dimension: org_country {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_COUNTRY" ;;
  }

  dimension: org_name {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_NAME" ;;
  }

  dimension: org_state {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_STATE" ;;
  }

  dimension: org_zip {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORG_ZIP" ;;
  }

  dimension: origin_contact_person {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORIGIN_CONTACT_PERSON" ;;
  }

  dimension: origin_contact_phone {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORIGIN_CONTACT_PHONE" ;;
  }

  dimension: origin_email {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORIGIN_EMAIL" ;;
  }

  dimension: origin_terminal_name {
    view_label: "Origin"
    type: string
    sql: ${TABLE}."ORIGIN_TERMINAL_NAME" ;;
  }

  #########################################
  ## SHIPMENT DIMENSIONS
  #########################################

  dimension: total_height {
    view_label: "Shipment Dimensions"
    type: number
    sql: ${TABLE}."TOTAL_HEIGHT" ;;
  }

  dimension: total_length {
    view_label: "Shipment Dimensions"
    type: number
    sql: ${TABLE}."TOTAL_LENGTH" ;;
  }

  dimension: total_width {
    view_label: "Shipment Dimensions"
    type: number
    sql: ${TABLE}."TOTAL_WIDTH" ;;
  }

  dimension: requested_delivery_from {
    view_label: " Requested"
    type: string
    sql: ${TABLE}."REQUESTED_DELIVERY_FROM" ;;
  }

  #########################################
  ## REQUESTED
  #########################################

  dimension: requested_delivery_to {
    view_label: " Requested"
    type: string
    sql: ${TABLE}."REQUESTED_DELIVERY_TO" ;;
  }

  dimension: requested_pickup_from {
    view_label: " Requested"
    type: string
    sql: ${TABLE}."REQUESTED_PICKUP_FROM" ;;
  }

  dimension: requested_pickup_to {
    view_label: " Requested"
    type: string
    sql: ${TABLE}."REQUESTED_PICKUP_TO" ;;
  }

  ########################################################################################
  ## HIDDEN DIMENSIONS
  ########################################################################################

  ########################################################################################
  ## MEASURES
  ########################################################################################

  measure: quoted_accs_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_accs_cost;;
  }

  measure: distinct_BOLs {
    type:  count_distinct
    sql: ${client_lading_no} ;;
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

  measure: avg_transit_days{
    type: average
    value_format: "##.0"
    sql: ${transit_days} ;;
  }

  measure: weight {
    type: sum
    sql: ${TABLE}."WEIGHT" ;;
  }

  measure: avg_pickup_to_delivery {
    type: average
    value_format: "##.0"
    sql: ${pickup_to_delivery} ;;
  }

  measure: quoted_ship_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.quoted_ship_cost ;;
  }

  ########################################################################################
  ## HIDDEN MEASURES
  ########################################################################################

  ########################################################################################
  ## DATES
  ########################################################################################


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
