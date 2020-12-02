view: incoming_inspection_form_rails {
  sql_table_name: "L2L"."V_INCOMING_INSPECTION_FORM_RAILS"
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

  measure: qty_rejected_damaged_in_transit {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_DAMAGED_IN_TRANSIT" ;;
  }

  measure: qty_rejected_dirt_oil {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_DIRT_OIL" ;;
  }

  measure: qty_rejected_other {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_OTHER" ;;
  }

  measure: qty_rejected_tears_holes_chunks {
    type: sum
    sql: ${TABLE}."QTY_REJECTED_TEARS_HOLES_CHUNKS" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
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
