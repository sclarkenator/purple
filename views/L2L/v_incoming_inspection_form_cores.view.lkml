view: incoming_inspection_form_cores {
  sql_table_name: "L2L"."V_INCOMING_INSPECTION_FORM_CORES"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: bill_of_lading_included {
    type: string
    sql: ${TABLE}."BILL_OF_LADING_INCLUDED" ;;
  }

  dimension: certificate_of_conformity_analysis_included {
    type: string
    sql: ${TABLE}."CERTIFICATE_OF_CONFORMITY_ANALYSIS_INCLUDED" ;;
  }

  dimension: coil_cores_only {
    type: string
    sql: ${TABLE}."COIL_CORES_ONLY" ;;
  }

  dimension_group: created {
    hidden: no
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: inspection {
    hidden: no
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE_OF_INSPECTION" ;;
  }

  dimension_group: manufacture {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE_OF_MANUFACTURE" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: how_long_have_cores_been_rolled {
    type: string
    sql: ${TABLE}."HOW_LONG_HAVE_CORES_BEEN_ROLLED" ;;
  }

  measure: inspection_quantity {
    type: sum
    sql: ${TABLE}."INSPECTION_QUANTITY" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  measure: lot_quantity {
    type: sum
    sql: ${TABLE}."LOT_QUANTITY" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."NOTES" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: pack_slip_included {
    type: string
    sql: ${TABLE}."PACK_SLIP_INCLUDED" ;;
  }

  dimension: part_number {
    type: string
    sql: ${TABLE}."PART_NUMBER" ;;
  }

  dimension: po_numer {
    type: string
    sql: ${TABLE}."PO_NUMER" ;;
  }

  dimension: product_dimensions {
    type: string
    sql: ${TABLE}."PRODUCT_DIMENSIONS" ;;
  }

  dimension: product_weight {
    type: string
    sql: ${TABLE}."PRODUCT_WEIGHT" ;;
  }

  measure: qty_rejected {
    type: sum
    sql: ${TABLE}."QTY_REJECTED" ;;
  }

  measure: qty_rejected_bad_cuts_dimensions {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_BAD_CUTS_DIMENSIONS" ;;
  }

  measure: qty_rejected_bun_skin {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_BUN_SKIN" ;;
  }

  measure: qty_rejected_coil_gap {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_COIL_GAP" ;;
  }

  measure: qty_rejected_damaged_in_transit {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_DAMAGED_IN_TRANSIT" ;;
  }

  measure: qty_rejected_delamination {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_DELAMINATION" ;;
  }

  measure: qty_rejected_dirt_oil {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_DIRT_OIL" ;;
  }

  measure: qty_rejected_excess_glue {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_EXCESS_GLUE" ;;
  }

  measure: qty_rejected_other {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_OTHER" ;;
  }

  measure: qty_rejected_overhang {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_OVERHANG" ;;
  }

  measure: qty_rejected_puckering {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_PUCKERING" ;;
  }

  measure: qty_rejected_resiliency_ball_drop_test {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_RESILIENCY_BALL_DROP_TEST" ;;
  }

  measure: qty_rejected_tears_holes_chuncks {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_TEARS_HOLES_CHUNCKS" ;;
  }

  dimension: reject_reasons_if_any {
    type: string
    sql: ${TABLE}."REJECT_REASONS_IF_ANY" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  measure: total_rejected_after_rollpack {
    type: sum
    sql: ${TABLE}."TOTAL_REJECTED_AFTER_ROLLPACK" ;;
  }

  dimension: truck_number {
    type: string
    sql: ${TABLE}."TRUCK_NUMBER" ;;
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}."VENDOR_NAME" ;;
  }

  measure: count {
    type: count
    drill_fields: [name, vendor_name]
  }
}
