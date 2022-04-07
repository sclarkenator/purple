view: etq_ncr {
  sql_table_name: "PRODUCTION"."ETQ_NCR";;

  dimension: ncr_number {
    label: "NCR Number"
    primary_key: yes
    type: string
    sql: ${TABLE}."NCR_NUMBER" ;;
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
  dimension_group: completed {
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
    sql: ${TABLE}."COMPLETED" ;;
  }

  dimension: current_phase {
    type: string
    sql: ${TABLE}."CURRENT_PHASE" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: ncr_initiating_department {
    label: "NCR Initiating Department"
    type: string
    sql: ${TABLE}."NCR_INITIATING_DEPARTMENT" ;;
  }

  dimension: non_conformance_origin {
    label: "Non-Conformance Origin"
    type: string
    sql: ${TABLE}."NON_CONFORMANCE_ORIGIN" ;;
  }

  dimension: po_number {
    label: "PO Number"
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}."SUPPLIER_NAME" ;;
  }

  dimension: supplier_number {
    type: string
    sql: ${TABLE}."SUPPLIER_NUMBER" ;;
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

  measure: count {
    type: count
    drill_fields: [supplier_name]
  }
}
