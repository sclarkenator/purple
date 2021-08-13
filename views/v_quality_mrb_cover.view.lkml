view: v_quality_mrb_cover {
  sql_table_name: "L2L"."V_QUALITY_MRB_COVER"
    ;;

  dimension: area {
    type: string
    hidden: yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension: cover_size {
    type: string
    sql: ${TABLE}."COVER_SIZE" ;;
  }

  dimension: cover_type {
    type: string
    sql: ${TABLE}."COVER_TYPE" ;;
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

  measure: quantity {
    type: sum
    sql: ${TABLE}."QTY" ;;
  }

  dimension: source_of_noncon {
    type: string
    sql: ${TABLE}."SOURCE_OF_NONCON" ;;
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

  dimension: us {
    type: yesno
    label: "US"
    sql: ${TABLE}."US" = 'Yes';;
  }

  dimension: vendor {
    type: string
    sql: ${TABLE}."VENDOR" ;;
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
