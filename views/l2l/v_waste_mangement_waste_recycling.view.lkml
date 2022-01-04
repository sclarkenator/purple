view: v_waste_management_waste_recycling {
  sql_table_name: "L2L"."V_WASTE_MANAGEMENT_WASTE_RECYCLING" ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: covers {
    type: string
    sql: ${TABLE}."COVERS" ;;
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

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
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

  dimension: rownum {
    type: number
    sql: ${TABLE}."ROWNUM" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  measure: total_rownum {
    type: sum
    sql: ${rownum} ;;
  }

  measure: average_rownum {
    type: average
    sql: ${rownum} ;;
  }

  measure: oily_water {
    type: sum
    sql: ${TABLE}."OILY_WATER" ;;
  }

  measure: paper {
    type: sum
    sql: ${TABLE}."PAPER" ;;
  }

  measure: plastic {
    type: sum
    sql: ${TABLE}."PLASTIC" ;;
  }

  measure: metal {
    type: sum
    sql: ${TABLE}."METAL" ;;
  }

  measure: foam {
    type: sum
    sql: ${TABLE}."FOAM" ;;
  }

  measure: glue {
    type: sum
    sql: ${TABLE}."GLUE" ;;
  }

  measure: hep {
    type: sum
    sql: ${TABLE}."HEP" ;;
  }

  measure: cardboard {
    type: sum
    sql: ${TABLE}."CARDBOARD" ;;
  }

  measure: alluminum {
    type: sum
    sql: ${TABLE}."ALLUMINUM" ;;
  }

  measure: textiles {
    type: sum
    sql: ${TABLE}."TEXTILES" ;;
  }

  measure: trash {
    type: sum
    sql: ${TABLE}."TRASH" ;;
  }

  measure: used_oil {
    type: sum
    sql: ${TABLE}."USED_OIL" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
