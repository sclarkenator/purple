view: fit_problem {
  sql_table_name: ACCOUNTING.FIT_PROBLEM ;;

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: corrected {
    type: yesno
    sql: ${TABLE}."CORRECTED" ;;
  }

  dimension: correction_note {
    type: string
    sql: ${TABLE}."CORRECTION_NOTE" ;;
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

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: problem_category {
    type: string
    sql: ${TABLE}."PROBLEM_CATEGORY" ;;
  }

  dimension: source_system {
    type: string
    sql: ${TABLE}."SOURCE_SYSTEM" ;;
  }

  dimension: transaction_id_1 {
    type: string
    sql: ${TABLE}."TRANSACTION_ID_1" ;;
  }

  dimension: transaction_id_2 {
    type: string
    sql: ${TABLE}."TRANSACTION_ID_2" ;;
  }

  dimension: transaction_id_3 {
    type: string
    sql: ${TABLE}."TRANSACTION_ID_3" ;;
  }

  dimension: transaction_id_4 {
    type: string
    sql: ${TABLE}."TRANSACTION_ID_4" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
