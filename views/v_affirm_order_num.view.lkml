view: v_affirm_order_num {
  sql_table_name: ACCOUNTING.V_AFFIRM_ORDER_NUM ;;

  dimension: charge_ari {
    type: string
    sql: ${TABLE}."CHARGE_ARI" ;;
  }

  dimension: deposit_id {
    type: string
    sql: ${TABLE}."DEPOSIT_ID" ;;
    primary_key: yes
  }

  dimension_group: deposited {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DEPOSITED" ;;
  }

  dimension: event_ari {
    type: string
    sql: ${TABLE}."EVENT_ARI" ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: fees {
    type: number
    sql: ${TABLE}."FEES" ;;
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

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: refunds {
    type: number
    sql: ${TABLE}."REFUNDS" ;;
  }

  dimension: sales {
    type: number
    sql: ${TABLE}."SALES" ;;
  }

  dimension: total_settled {
    type: number
    sql: ${TABLE}."TOTAL_SETTLED" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
