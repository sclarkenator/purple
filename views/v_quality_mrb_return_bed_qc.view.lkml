view: v_quality_mrb_return_bed_qc {
  sql_table_name: "L2L"."V_QUALITY_MRB_RETURN_BED_QC"
    ;;

  dimension: area {
    type: string
    hidden: yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension: bed_size {
    type: string
    sql: ${TABLE}."BED_SIZE" ;;
  }

  dimension: bed_type {
    type: string
    sql: CASE WHEN ${TABLE}."BED_TYPE" = '2in' THEN '2'
              WHEN ${TABLE}."BED_TYPE" = '3in' THEN '3'
              WHEN ${TABLE}."BED_TYPE" = '4in' THEN '4'
              ELSE ${TABLE}."BED_TYPE" END ;;  }

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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: date_on_cover_date_stamp {
    type: string
    sql: ${TABLE}."DATE_ON_COVER_DATE_STAMP" ;;
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

  dimension: disposition {
    type: string
    sql: ${TABLE}."DISPOSITION" ;;
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

  dimension: site {
    type: string
    sql: CASE WHEN ${TABLE}.site = '2' THEN 'Grantsville'
              WHEN ${TABLE}.site = '3' THEN 'Alpine'
              WHEN ${TABLE}.site = '4' THEN 'McDonough'
              ELSE ${TABLE}.site END;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    hidden: yes
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: where_did_this_return_come_from {
    type: string
    label: "Return Source"
    sql: ${TABLE}."WHERE_DID_THIS_RETURN_COME_FROM" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [name]
  }
}
