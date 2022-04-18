# The name of this view in Looker is "Envista Invoice"
view: envista {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "SHIPPING"."ENVISTA_INVOICE"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Account Number" in Explore.

  dimension: account_number {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."ACCOUNT_NUMBER" ;;
  }

  dimension: actual_weight {
    group_label: "Weights & Dims"
    type: number
    sql: ${TABLE}."ACTUAL_WEIGHT_INVOICED" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_actual_weight {
    group_label: "Weights & Dims"
    type: sum
    value_format: "#,###.00"
    sql: ${actual_weight} ;;
  }

  measure: avg_actual_weight {
    hidden:  yes
    group_label: "Weights & Dims"
    type: average
    value_format: "#,###.00"
    sql: ${actual_weight} ;;
  }

  dimension: adjustment {
    group_label: "Charges"
    type: number
    value_format: "$#,###.00"
    sql: ${TABLE}."ADJUSTMENT" ;;
  }

  measure: total_adjustments {
    group_label: "Charges"
    type: sum
    value_format: "$#,###.00"
    sql: ${adjustment} ;;
  }

  measure: avg_adjustments {
    hidden:  yes
    group_label: "Charges"
    type: average
    value_format: "$#,###.00"
    sql: ${adjustment} ;;
  }

  dimension: approved_line_charges {
    group_label: "Charges"
    type: number
    value_format: "$#,###.00"
    sql: ${TABLE}."APPROVED_LINE_CHARGES" ;;
  }

  measure: total_approved_charges {
    group_label: "Charges"
    type: sum
    value_format: "$#,###.00"
    sql: ${approved_line_charges} ;;
  }

  measure: avg_approved_charges {
    hidden: yes
    group_label: "Charges"
    type: average
    value_format: "$#,###.00"
    sql: ${approved_line_charges} ;;
  }

  dimension: bill_weight {
    group_label: "Weights & Dims"
    type: number
    sql: ${TABLE}."BILL_WEIGHT_INVOICED" ;;
  }

  measure: total_bill_weight {
    group_label: "Weights & Dims"
    type: sum
    value_format: "#,###.00"
    sql: ${bill_weight} ;;
  }

  measure: avg_bill_weight {
    hidden: yes
    group_label: "Weights & Dims"
    type: average
    value_format: "#,###.00"
    sql: ${bill_weight} ;;
  }

  dimension: carrier {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: charge_description {
    group_label: "Charges"
    type: string
    sql: ${TABLE}."CHARGE_DESCRIPTION_INVOICED" ;;
  }

  dimension: charge_type {
    group_label: "Charges"
    type: string
    sql: ${TABLE}."CHARGE_TYPE" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    group_label: "Dates"
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: delivered {
    group_label: "Dates"
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
    sql: CAST(${TABLE}."DELIVERED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: gl_code_shipment_level {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."GL_CODE_SHIPMENT_LEVEL" ;;
  }

  dimension: internal_key_1 {
    hidden:  yes
    type: number
    sql: ${TABLE}."INTERNAL_KEY_1" ;;
  }

  dimension: internal_key_charge_1 {
    hidden: yes
    type: number
    sql: ${TABLE}."INTERNAL_KEY_CHARGE_1" ;;
  }

  dimension: invoice_number {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."INVOICE_NUMBER" ;;
  }

  dimension_group: invoiced {
    group_label: "Dates"
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
    sql: ${TABLE}."INVOICED" ;;
  }

  dimension: item_height {
    group_label: "Weights & Dims"
    type: number
    sql: ${TABLE}."ITEM_HEIGHT" ;;
  }

  measure: avg_height {
    group_label: "Weights & Dims"
    type: average
    value_format: "#,###.0"
    sql: ${item_height} ;;
  }

  dimension: item_length {
    group_label: "Weights & Dims"
    type: number
    sql: ${TABLE}."ITEM_LENGTH" ;;
  }

  measure: avg_length {
    group_label: "Weights & Dims"
    type: average
    value_format: "#,###.0"
    sql: ${item_length} ;;
  }

  dimension: item_width {
    group_label: "Weights & Dims"
    type: number
    sql: ${TABLE}."ITEM_WIDTH" ;;
  }

  measure: avg_width {
    group_label: "Weights & Dims"
    type: average
    value_format: "#,###.0"
    sql: ${item_width} ;;
  }

  dimension: line_charges {
    group_label: "Charges"
    type: number
    sql: ${TABLE}."LINE_CHARGES" ;;
  }

  measure: total_line_charges {
    group_label: "Charges"
    type:  sum
    value_format: "$#,###.00"
    sql: ${line_charges} ;;
  }

  measure: avg_line_charges {
    hidden:  yes
    group_label: "Charges"
    type: average
    value_format: "$#,###.00"
    sql: ${line_charges} ;;
  }

  dimension: line_item {
    group_label: "Shipment Info"
    type: number
    sql: ${TABLE}."LINE_ITEM" ;;
  }

  dimension: receiver_address_1 {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_ADDRESS_1" ;;
  }

  dimension: receiver_city {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_CITY" ;;
  }

  dimension: receiver_company {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_COMPANY" ;;
  }

  dimension: receiver_country {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_COUNTRY" ;;
  }

  dimension: receiver_name {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_NAME" ;;
  }

  dimension: receiver_postal_code {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_POSTAL_CODE" ;;
  }

  dimension: receiver_state {
    group_label: "Receiver Info"
    type: string
    sql: ${TABLE}."RECEIVER_STATE" ;;
  }

  dimension: reference1 {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."REFERENCE1" ;;
  }

  dimension: reference2 {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."REFERENCE2" ;;
  }

  dimension: service_level_invoiced {
    hidden: yes
    type: string
    sql: ${TABLE}."SERVICE_LEVEL_INVOICED" ;;
  }

  dimension: service_level {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."SERVICE_LEVEL_NORMALIZED" ;;
  }

  dimension: shipment_count_normalized {
    hidden: yes
    type: number
    sql: ${TABLE}."SHIPMENT_COUNT_NORMALIZED" ;;
  }

  measure: shipments {
    hidden: yes
    type: sum
    sql: ${shipment_count_normalized} ;;
  }

  dimension_group: shipped {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SHIPPED" ;;
  }

  dimension: shipper_address_1 {
    group_label: "Shipper Info"
    type: string
    sql: ${TABLE}."SHIPPER_ADDRESS_1" ;;
  }

  dimension: shipper_city_dim {
    hidden:  yes
    type: string
    sql: ${TABLE}."SHIPPER_CITY" ;;
  }

  dimension: shipper_city {
    group_label: "Shipper Info"
    type: string
    sql:  replace(${shipper_city_dim},',');;
  }

  dimension: shipper_company {
    group_label: "Shipper Info"
    type: string
    sql: ${TABLE}."SHIPPER_COMPANY" ;;
  }

  dimension: shipper_country {
    group_label: "Shipper Info"
    type: string
    sql: ${TABLE}."SHIPPER_COUNTRY" ;;
  }

  dimension: shipper_name {
    group_label: "Shipper Info"
    type: string
    sql: ${TABLE}."SHIPPER_NAME" ;;
  }

  dimension: shipper_postal_code {
    group_label: "Shipper Info"
    type: number
    sql: ${TABLE}."SHIPPER_POSTAL_CODE" ;;
  }

  dimension: shipper_state {
    group_label: "Shipper Info"
    type: string
    sql: ${TABLE}."SHIPPER_STATE" ;;
  }

  dimension: tracking_number {
    group_label: "Shipment Info"
    type: string
    sql: ${TABLE}."TRACKING_NUMBER" ;;
  }

  dimension: zone_invoiced {
    hidden:  yes
    type: string
    sql: ${TABLE}."ZONE_INVOICED" ;;
  }

  dimension: zone_normalized {
    hidden: yes
    type: string
    sql: ${TABLE}."ZONE_NORMALIZED";;
  }

  dimension: zone_type {
    group_label: "Shipment Info"
    type: string
    sql: replace(replace(zone_normalized, '.'), '0') ;;
  }

  measure: avg_zone {
    type: average
    value_format: "#,###.00"
    sql: cast(
            case
              when ${zone_type} ='AK/HI'
              or ${zone_type} ='CANADA'
              or ${zone_type} ='INTERNATIONAL'
              or ${zone_type} ='MEXICO'
              or ${zone_type} ='NOT MAPPED'
              then null else ${zone_type}
              end
              as number);;
  }

  measure: tracking_number_count {
    type: count_distinct
    value_format: "#,###"
    sql: ${tracking_number} ;;
  }

  measure: charge_per_tracking_number {
    hidden: yes
    type: number
    value_format: "$#,###.00"
    sql:  div0(${total_line_charges},${tracking_number_count});;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [receiver_name, shipper_name]
  }
}
