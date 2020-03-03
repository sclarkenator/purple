view: l2l_qpc_mattress_audit {
  sql_table_name: "L2L"."QPC_MATTRESS_AUDIT"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  measure: cover_fit {
    type: sum
    sql: case when ${TABLE}.COVER_FIT ='FAIL' OR ${TABLE}.COVER_FIT= '0' then 0
              when ${TABLE}.COVER_FIT ='PASS' OR ${TABLE}.COVER_FIT= '1' then 1
              else null
              end;;
  }

  measure: cover_rips_tears {
    type: sum
    sql: case when ${TABLE}."COVER_RIPS_TEARS"  ='FAIL' OR ${TABLE}.FIRE_SOCK_HOLES_RIPS_GLUE= '0' then 0
    when ${TABLE}."COVER_RIPS_TEARS"='PASS' OR ${TABLE}."COVER_RIPS_TEARS" = '1' then 1
    else null
    end;;
  }

  measure: cover_stains {
    type: sum
    sql: case when ${TABLE}.COVER_STAINS ='FAIL' OR ${TABLE}.COVER_STAINS= '0' then 0
              when ${TABLE}.COVER_STAINS ='PASS' OR ${TABLE}.COVER_STAINS= '1' then 1
              else null
              end;;
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

  measure: fire_sock_holes_rips_glue {
    type: sum
    sql: case when ${TABLE}.FIRE_SOCK_HOLES_RIPS_GLUE ='FAIL' OR ${TABLE}.FIRE_SOCK_HOLES_RIPS_GLUE= '0' then 0
              when ${TABLE}.FIRE_SOCK_HOLES_RIPS_GLUE ='PASS' OR ${TABLE}.FIRE_SOCK_HOLES_RIPS_GLUE= '1' then 1
              else null
              end;;
  }

  measure: fire_sock_seam {
    type: sum
    sql: case when ${TABLE}.FIRE_SOCK_SEAM ='FAIL' OR ${TABLE}.FIRE_SOCK_SEAM= '0' then 0
              when ${TABLE}.FIRE_SOCK_SEAM ='PASS' OR ${TABLE}.FIRE_SOCK_SEAM= '1' then 1
              else null
              end;;
  }

  measure: foam_puckered {
    type: sum
    sql: case when ${TABLE}.FOAM_PUCKERED ='FAIL' OR ${TABLE}.FOAM_PUCKERED= '0' then 0
              when ${TABLE}.FOAM_PUCKERED ='PASS' OR ${TABLE}.FOAM_PUCKERED= '1' then 1
              else null
              end;;
  }

  measure: foam_recovery {
    type: sum
    sql: case when ${TABLE}.FOAM_RECOVERY ='FAIL' OR ${TABLE}.FOAM_RECOVERY= '0' then 0
              when ${TABLE}.FOAM_RECOVERY ='PASS' OR ${TABLE}.FOAM_RECOVERY= '1' then 1
              else null
              end;;

  }

  measure: foam_tears_holes {
    type: sum
    sql: case when ${TABLE}.foam_tears_holes ='FAIL' OR ${TABLE}.foam_tears_holes= '0' then 0
              when ${TABLE}.foam_tears_holes ='PASS' OR ${TABLE}.foam_tears_holes= '1' then 1
              else null
              end;;
  }

  measure: hep_adhesion {
    type: sum
    sql: case when ${TABLE}.HEP_ADHESION ='FAIL' OR ${TABLE}.HEP_ADHESION= '0' then 0
              when ${TABLE}.HEP_ADHESION ='PASS' OR ${TABLE}.HEP_ADHESION= '1' then 1
              else null
              end;;
  }

  measure: hep_alignment {
    type: sum
    sql: case when ${TABLE}.HEP_ALIGNMENT ='FAIL' OR ${TABLE}.HEP_ALIGNMENT= '0' then 0
              when ${TABLE}.HEP_ALIGNMENT ='PASS' OR ${TABLE}.HEP_ALIGNMENT= '1' then 1
              else null
              end;;
  }

  measure: hep_gaps_to_foam_rails {
    type: sum
    sql: case when ${TABLE}.hep_gaps_to_foam_rails ='FAIL' OR ${TABLE}.hep_gaps_to_foam_rails= '0' then 0
              when ${TABLE}.hep_gaps_to_foam_rails ='PASS' OR ${TABLE}.hep_gaps_to_foam_rails= '1' then 1
              else null
              end;;
  }

  measure: hep_tears_voids {
      type: sum
    sql: case when ${TABLE}.hep_tears_voids ='FAIL' OR ${TABLE}.hep_tears_voids= '0' then 0
              when ${TABLE}.hep_tears_voids ='PASS' OR ${TABLE}.hep_tears_voids= '1' then 1
              else null
              end;;
  }

  measure: law_tag_date {
    type: sum
    sql:case when ${TABLE}.law_tag_date ='FAIL' OR ${TABLE}.law_tag_date= '0' then 0
              when ${TABLE}.law_tag_date ='PASS' OR ${TABLE}.law_tag_date= '1' then 1
              else null
              end;;
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

  measure: would_you_want_customer {
    type: average
    sql: ${TABLE}."WOULD_YOU_WANT_CUSTOMER" ;;
  }

  measure: would_you_want_retail {
    type: average
    sql: ${TABLE}."WOULD_YOU_WANT_RETAIL" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
