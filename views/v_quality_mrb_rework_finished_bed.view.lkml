view: v_quality_mrb_rework_finished_bed {
  sql_table_name: "L2L"."V_QUALITY_MRB_REWORK_FINISHED_BED"
    ;;

  dimension: area {
    type: string
    hidden: yes
    sql: ${TABLE}."AREA" ;;
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

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: size {
    type: string
    sql: CASE WHEN ${TABLE}."SIZE" = 'Full' THEN 'F' ELSE ${TABLE}."SIZE" END ;;
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

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: yellow_card_num {
    type: string
    sql: ${TABLE}."YELLOW_CARD_NUM" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [name]
  }
}
