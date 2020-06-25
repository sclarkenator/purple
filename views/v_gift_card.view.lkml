view: v_gift_card {
  sql_table_name: "ACCOUNTING"."V_GIFT_CARD"
    ;;

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: card_number {
    type: number
    sql: ${TABLE}."CARD_NUMBER" ;;
  }

  dimension_group: card_used {
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
    sql: CAST(${TABLE}."CARD_USED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: gift_card_last_characters {
    type: string
    sql: ${TABLE}."GIFT_CARD_LAST_CHARACTERS" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
