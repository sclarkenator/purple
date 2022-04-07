view: etq_ncr_item {

  sql_table_name: "PRODUCTION"."ETQ_NCR_ITEM";;

  dimension: ncr_number_item_number {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.ncr_number||'-'||${TABLE}.item_number ;;
  }

  dimension_group: actual_returned {
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
    sql: ${TABLE}."ACTUAL_RETURNED" ;;
  }

  dimension: defect_type {
    type: string
    sql: ${TABLE}."DEFECT_TYPE" ;;
  }

  dimension: disposition_type {
    type: string
    sql: ${TABLE}."DISPOSITION_TYPE" ;;
  }

  dimension: item_number {
    type: string
    sql: ${TABLE}."ITEM_NUMBER" ;;
  }

  dimension: lot_date_of_mfg {
    type: string
    sql: ${TABLE}."LOT_DATE_OF_MFG" ;;
  }

  dimension: lot_size {
    type: number
    sql: ${TABLE}."LOT_SIZE" ;;
  }

  measure: total_lot_size {
    type: sum
    sql: ${lot_size} ;;
  }

  measure: average_lot_size {
    type: average
    sql: ${lot_size} ;;
  }

  dimension: ncr_number {
    label: "NCR Number"
    type: string
    sql: ${TABLE}."NCR_NUMBER" ;;
  }

  dimension: nonconformance_description {
    label: "Non-Conformance Description"
    type: string
    sql: ${TABLE}."NONCONFORMANCE_DESCRIPTION" ;;
  }

  dimension: part_name {
    type: string
    sql: ${TABLE}."PART_NAME" ;;
  }

  dimension: part_number {
    type: string
    sql: ${TABLE}."PART_NUMBER" ;;
  }

  dimension: qty_inspected_dim {
    hidden: yes
    type: number
    sql: ${TABLE}."QTY_INSPECTED" ;;
  }

  dimension: qty_rejected_dim {
    hidden: yes
    type: number
    sql: ${TABLE}."QTY_REJECTED" ;;
  }

  dimension: qty_returned_dim {
    hidden: yes
    type: number
    sql: ${TABLE}."QTY_RETURNED" ;;
  }

  measure: qty_inspected {
    type: sum
    sql: ${TABLE}."QTY_INSPECTED" ;;
  }

  measure: qty_rejected {
    type: sum
    sql: ${TABLE}."QTY_REJECTED" ;;
  }

  measure: qty_returned {
    type: sum
    sql: ${TABLE}."QTY_RETURNED" ;;
  }

  measure: scrap_cost {
    type: sum
    value_format: "$#,##0"
    sql: ${qty_rejected_dim} * ${standard_cost.standard_cost} ;;
    filters: [disposition_type: "Scrap"]
  }

  measure: rtv_cost {
    label: "RTV Cost"
    type: sum
    value_format: "$#,##0"
    sql: ${qty_rejected_dim} * ${standard_cost.standard_cost} ;;
    filters: [disposition_type: "Return to Supplier"]
  }

  dimension: reference_number {
    type: string
    sql: ${TABLE}."REFERENCE_NUMBER" ;;
  }

  dimension: supplier_action_required {
    type: string
    sql: ${TABLE}."SUPPLIER_ACTION_REQUIRED" ;;
  }

  dimension: supplier_fault {
    type: yesno
    sql: ${TABLE}."SUPPLIER_FAULT" ;;
  }

  dimension: transfer_order_number {
    label: "TO Number"
    type: string
    sql: ${TABLE}."TRANSFER_ORDER_NUMBER" ;;
  }

  dimension: ncr_accuracy {
    label: "Is Accurate?"
    type: string
    sql: ${TABLE}."NCR_ACCURACY" ;;
  }

  dimension: inaccuracy_reason {
    type: string
    sql: ${TABLE}."INACCURACY_REASON" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: vendor_return_authorization_number {
    type: string
    sql: ${TABLE}."VENDOR_RETURN_AUTHORIZATION_NUMBER" ;;
  }

  measure: count {
    type: count
    drill_fields: [part_name]
  }
}
