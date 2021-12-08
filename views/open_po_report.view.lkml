# The name of this view in Looker is "Open Po Report"
view: open_po_report {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "SHIPPING"."OPEN_PO_REPORT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Account Values" in Explore.

  dimension: account_values {
    type: string
    sql: ${TABLE}."ACCOUNT_VALUES" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: arrival_notice_received {
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
    sql: ${TABLE}."ARRIVAL_NOTICE_RECEIVED" ;;
  }

  dimension_group: cargo_ready {
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
    sql: ${TABLE}."CARGO_READY" ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: container_number {
    type: string
    sql: ${TABLE}."CONTAINER_NUMBER" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}."DESTINATION" ;;
  }

  dimension_group: discharged {
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
    sql: ${TABLE}."DISCHARGED" ;;
  }

  dimension: diversion_request {
    type: string
    sql: ${TABLE}."DIVERSION_REQUEST" ;;
  }

  dimension_group: eta {
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
    sql: ${TABLE}."ETA" ;;
  }

  dimension_group: etd {
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
    sql: ${TABLE}."ETD" ;;
  }

  dimension: final_destination {
    type: string
    sql: ${TABLE}."FINAL_DESTINATION" ;;
  }

  dimension: freight_terms {
    type: string
    sql: ${TABLE}."FREIGHT_TERMS" ;;
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

  dimension: is_fulfilled {
    type: string
    sql: ${TABLE}."IS_FULFILLED" ;;
  }

  dimension: item_number {
    type: string
    sql: ${TABLE}."ITEM_NUMBER" ;;
  }

  dimension_group: lfd {
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
    sql: ${TABLE}."LFD" ;;
  }

  dimension: mbol_mawb_hbol_hawb {
    type: string
    sql: ${TABLE}."MBOL_MAWB_HBOL_HAWB" ;;
  }

  dimension: mode {
    type: string
    sql: ${TABLE}."MODE" ;;
  }

  dimension_group: netsuite_eta {
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
    sql: ${TABLE}."NETSUITE_ETA" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."NOTES" ;;
  }

  dimension: ordered_quantity {
    type: string
    sql: ${TABLE}."ORDERED_QUANTITY" ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}."ORIGIN" ;;
  }

  dimension: pick_up_number {
    type: string
    sql: ${TABLE}."PICK_UP_NUMBER" ;;
  }

  dimension: po_number {
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension_group: purple_in_hand {
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
    sql: ${TABLE}."PURPLE_IN_HAND" ;;
  }

  dimension: shipment_cbms {
    type: string
    sql: ${TABLE}."SHIPMENT_CBMS" ;;
  }

  dimension: shipping_week {
    type: string
    sql: ${TABLE}."SHIPPING_WEEK" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: supplier {
    type: string
    sql: ${TABLE}."SUPPLIER" ;;
  }

  dimension: to_number {
    type: string
    sql: ${TABLE}."TO_NUMBER" ;;
  }

  dimension_group: upload {
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
    sql: ${TABLE}."UPLOAD_DATE" ;;
  }

  dimension: vendor_mid {
    type: string
    sql: ${TABLE}."VENDOR_MID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
