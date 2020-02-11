view: l2l_qpc_mattress_audit {
  sql_table_name: "L2L"."QPC_MATTRESS_AUDIT"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: cover_fit {
    type: string
    sql: ${TABLE}."COVER_FIT" ;;
  }

  dimension: cover_rips_tears {
    type: string
    sql: ${TABLE}."COVER_RIPS_TEARS" ;;
  }

  dimension: cover_stains {
    type: string
    sql: ${TABLE}."COVER_STAINS" ;;
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

  dimension: date_of_manufacture {
    type: string
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

  dimension: fire_sock_holes_rips_glue {
    type: string
    sql: ${TABLE}."FIRE_SOCK_HOLES_RIPS_GLUE" ;;
  }

  dimension: fire_sock_seam {
    type: string
    sql: ${TABLE}."FIRE_SOCK_SEAM" ;;
  }

  dimension: foam_puckered {
    type: string
    sql: ${TABLE}."FOAM_PUCKERED" ;;
  }

  dimension: foam_recovery {
    type: string
    sql: ${TABLE}."FOAM_RECOVERY" ;;
  }

  dimension: foam_tears_holes {
    type: string
    sql: ${TABLE}."FOAM_TEARS_HOLES" ;;
  }

  dimension: hep_adhesion {
    type: string
    sql: ${TABLE}."HEP_ADHESION" ;;
  }

  dimension: hep_alignment {
    type: string
    sql: ${TABLE}."HEP_ALIGNMENT" ;;
  }

  dimension: hep_gaps_to_foam_rails {
    type: string
    sql: ${TABLE}."HEP_GAPS_TO_FOAM_RAILS" ;;
  }

  dimension: hep_tears_voids {
    type: string
    sql: ${TABLE}."HEP_TEARS_VOIDS" ;;
  }

  dimension: law_tag_date {
    type: string
    sql: ${TABLE}."LAW_TAG_DATE" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: mattress_size {
    type: string
    sql: ${TABLE}."MATTRESS_SIZE" ;;
  }

  dimension: mattress_type {
    type: string
    sql: ${TABLE}."MATTRESS_TYPE" ;;
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

  dimension: shift_of_manufacture {
    type: string
    sql: ${TABLE}."SHIFT_OF_MANUFACTURE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: would_you_want_customer {
    type: string
    sql: ${TABLE}."WOULD_YOU_WANT_CUSTOMER" ;;
  }

  dimension: would_you_want_retail {
    type: string
    sql: ${TABLE}."WOULD_YOU_WANT_RETAIL" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
