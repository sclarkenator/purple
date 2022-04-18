view: etq_scar {

  sql_table_name: "PRODUCTION"."ETQ_SCAR";;

  dimension: containment_performed {
    type: string
    sql: ${TABLE}."CONTAINMENT_PERFORMED" ;;
  }

  dimension: scar_number {
    primary_key: yes
    type: string
    sql: ${TABLE}."SCAR_NUMBER" ;;
  }

  dimension_group: corrective_action_approval {
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
    sql: ${TABLE}."CORRECTIVE_ACTION_APPROVAL" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: defect_issue {
    type: string
    sql: ${TABLE}."DEFECT_ISSUE" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: lot_number {
    type: string
    sql: ${TABLE}."LOT_NUMBER" ;;
  }

  dimension: ncr_number {
    label: "NCR Number"
    type: string
    sql: ${TABLE}."NCR_NUMBER" ;;
  }

  dimension: po_number {
    label: "PO Number"
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}."PRODUCT_TYPE" ;;
  }

  dimension: restatement_nonconformance {
    label: "Restatement Non-Conformance"
    type: string
    sql: ${TABLE}."RESTATEMENT_NONCONFORMANCE" ;;
  }

  dimension: root_cause_category {
    type: string
    sql: ${TABLE}."ROOT_CAUSE_CATEGORY" ;;
  }

  dimension: root_cause_corrective_action {
    type: string
    sql: ${TABLE}."ROOT_CAUSE_CORRECTIVE_ACTION" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}."SUPPLIER_NAME" ;;
  }

  dimension: phase {
    type: string
    sql: ${TABLE}."PHASE" ;;
  }

  measure: count {
    type: count
    drill_fields: [supplier_name]
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
}
