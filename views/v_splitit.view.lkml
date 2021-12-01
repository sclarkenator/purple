view: v_splitit {
  sql_table_name: ANALYTICS.ACCOUNTING.V_SPLITIT
    ;;

  measure: amount {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: card_number {
    type: string
    sql: ${TABLE}."CARD_NUMBER" ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}."CARD_TYPE" ;;
  }

  dimension: cardholder_name {
    type: string
    sql: ${TABLE}."CARDHOLDER_NAME" ;;
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
    sql: CAST(${TABLE}."TIME" AS TIMESTAMP_NTZ) ;;
  }

  dimension: installment_plan {
    type: string
    sql: ${TABLE}."INSTALLMENT_PLAN" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: platform {
    type: string
    sql:  ${TABLE}."PLATFORM" ;;
  }

  dimension: ref_num {
    type: string
    sql: ${TABLE}."REF_NUM" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tag {
    type: string
    sql: ${TABLE}."TAG" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [cardholder_name]
  }
}
