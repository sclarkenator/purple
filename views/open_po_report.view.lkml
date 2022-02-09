# The name of this view in Looker is "Open Po Report"
view: international_open_po_report {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "SHIPPING"."OPEN_PO_REPORT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Account Values" in Explore.

  dimension: account_values_dim {
    hidden: yes
    type: string
    sql: ${TABLE}."ACCOUNT_VALUES" ;;
  }

  measure: accounting_value {
    type: sum
    value_format: "$#,###.00"
    sql:cast(
        case
          when ${account_values_dim} is null or ${account_values_dim}='' then 0
          else replace(replace(replace(replace(replace(${account_values_dim},'$'),','),' - Free Replacement'),'None',0),' None',0)
          end
        as number);;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: arrival_notice_received {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."ARRIVAL_NOTICE_RECEIVED" ;;
  }

  dimension_group: cargo_ready {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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
    hidden: no
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}."DESTINATION" ;;
  }

  dimension_group: discharged {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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

  dimension_group: ETA {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."ETA" ;;
  }

  dimension_group: ETD {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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
    view_label: "Dates"
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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

  dimension_group: LFD {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."LFD" ;;
  }

  dimension: mbol_mawb_hbol_hawb {
    label: "Tracking Info"
    type: string
    sql: ${TABLE}."MBOL_MAWB_HBOL_HAWB" ;;
  }

  dimension: mode {
    type: string
    sql: ${TABLE}."MODE" ;;
  }

  dimension_group: netsuite_ETA {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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

  measure: ordered_quantity {
    type: sum
    value_format: "#,##0.00"
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
    label: "PO Number"
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension_group: purple_in_hand {
    view_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PURPLE_IN_HAND" ;;
  }

  dimension: shipment_cbms {
    label: "Shipment CBMS"
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
    label: "TO Number"
    type: string
    sql: ${TABLE}."TO_NUMBER" ;;
  }

  dimension_group: upload {
    view_label: "Dates"
    hidden: no
    type: time
    timeframes: [
      raw,
      date,
      day_of_year,
      week,
      week_of_year,
      month,
      month_num,
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

  dimension: ETD_to_ETA {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${ETD_raw},${ETA_raw}) ;;
  }

  dimension: ETD_to_Purple_In_Hand {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${ETD_raw},${purple_in_hand_raw}) ;;
  }

  dimension: ETA_to_Purple_In_Hand {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${ETA_raw},${purple_in_hand_raw}) ;;
  }

  dimension: ETA_to_Discharged {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${ETA_raw},${discharged_raw}) ;;
  }

  dimension: Discharged_to_Purple_In_Hand {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${discharged_raw},${purple_in_hand_raw}) ;;
  }

  dimension: Cargo_to_ETD {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${cargo_ready_raw},${ETD_date}) ;;
  }

  dimension: Cargo_to_Purple_In_Hand {
    hidden: yes
    type: number
    group_label: "Days Between"
    sql: DATEDIFF(day,${cargo_ready_raw},${purple_in_hand_raw}) ;;
  }

  measure: Avg_ETD_to_ETA {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${ETD_to_ETA} ;;
  }

  measure: Avg_Cargo_to_ETD {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${Cargo_to_ETD} ;;
  }

  measure: Avg_ETD_to_Purple_In_Hand {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${ETD_to_Purple_In_Hand} ;;
  }

  measure: Avg_ETA_to_Purple_In_Hand {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${ETA_to_Purple_In_Hand} ;;
  }

  measure: Avg_ETA_to_Discharged {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${ETA_to_Discharged} ;;
  }

  measure: Avg_Discharged_to_Purple_In_Hand {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${Discharged_to_Purple_In_Hand} ;;
  }

  measure: Avg_Cargo_to_Purple_In_Hand {
    type: average
    value_format: "#,##0.00"
    group_label: "Days Between"
    sql: ${Cargo_to_Purple_In_Hand} ;;
  }
}
