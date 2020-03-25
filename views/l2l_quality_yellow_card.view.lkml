view: l2l_quality_yellow_card {
  sql_table_name: "L2L"."V_QUALITY_YELLOW_CARD"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: bed_size {
    type: string
    sql: ${TABLE}."BED_SIZE" ;;
  }

  dimension: bed_type {
    type: string
    sql: ${TABLE}."BED_TYPE" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}."DATE" ;;
  }

  dimension: defect_location {
    type: string
    sql: ${TABLE}."DEFECT_LOCATION" ;;
  }

  dimension: defect_origin {
    type: string
    sql: ${TABLE}."DEFECT_ORIGIN" ;;
  }

  dimension: defect_type {
    type: string
    sql: ${TABLE}."DEFECT_TYPE" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: details {
    type: string
    sql: ${TABLE}."DETAILS" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: initial_disposition {
    type: string
    sql: ${TABLE}."INITIAL_DISPOSITION" ;;
  }

  dimension: is_bed_rework {
    type: string
    sql: ${TABLE}."IS_BED_REWORK" ;;
  }

  dimension: is_factory_second {
    type: string
    sql: ${TABLE}."IS_FACTORY_SECOND" ;;
  }

  dimension: is_for_mrb {
    type: string
    sql: ${TABLE}."IS_FOR_MRB" ;;
  }

  dimension: is_line_rework {
    type: string
    sql: ${TABLE}."IS_LINE_REWORK" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: prod_approval_name {
    type: string
    sql: ${TABLE}."PROD_APPROVAL_NAME" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: quantity {
    type: string
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: shift {
    type: string
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: vendor_po_lotcode {
    type: string
    sql: ${TABLE}."VENDOR_PO_LOTCODE" ;;
  }

  dimension: workorder_num {
    type: string
    sql: ${TABLE}."WORKORDER_NUM" ;;
  }

  measure: count {
    type: count
    drill_fields: [prod_approval_name, name]
  }
}
