view: v_quality_mrb_cores_final_disposition {
  sql_table_name: "L2L"."V_QUALITY_MRB_CORES_FINAL_DISPOSITION"
    ;;

  dimension: area {
    type: string
    hidden: yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension: caused_noncom {
    type: string
    sql: ${TABLE}."CAUSED_NONCOM" ;;
  }

  dimension_group: created {
    type: time
    label: "  Created"
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

  dimension: defect {
    type: string
    sql: ${TABLE}."DEFECT" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    hidden: yes
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: final_disposition {
    type: string
    sql: ${TABLE}."FINAL_DISPOSITION" ;;
  }

  dimension: line {
    type: string
    hidden: yes
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    hidden: yes
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: mfg_date {
    type: string
    sql: ${TABLE}."MFG_DATE" ;;
  }

  dimension_group: modified {
    type: time
    hidden: yes
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

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: product_po_number {
    type: string
    sql: ${TABLE}."PRODUCT_PO_NUMBER" ;;
  }

  dimension: quality_mrb_final_disposition_coil_foam_cores {
    type: string
    hidden: no
    sql: ${TABLE}."QUALITY_MRB_FINAL_DISPOSITION_COIL_FOAM_CORES" ;;
  }

  measure: quantity {
    type: sum
    sql: CASE WHEN ${TABLE}."QUANTITY" IN ('Q','') THEN 0
         ELSE COALESCE (${TABLE}."QUANTITY", 0) END ;;
  }

  dimension: size {
    type: string
    sql: ${TABLE}."SIZE" ;;
  }

  dimension: site {
    type: string
    sql: CASE WHEN ${TABLE}.site = '2' THEN 'Grantsville'
              WHEN ${TABLE}.site = '3' THEN 'Alpine'
              WHEN ${TABLE}.site = '4' THEN 'McDonough'
              ELSE ${TABLE}.site END;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    hidden: no
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: vendor {
    type: string
    sql: ${TABLE}."VENDOR" ;;
  }

  dimension: yellow_card_number {
    type: string
    sql: ${TABLE}."YELLOW_CARD_NUMBER" ;;
  }

  dimension: is_accurate {
    type: string
    sql: CASE WHEN ${TABLE}."IS_ACCURATE" = '' THEN NULL
              ELSE ${TABLE}."IS_ACCURATE" END;;
  }

  measure: count {
    type: count
    hidden: no
    drill_fields: [name]
  }
}
