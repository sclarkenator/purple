view: v_stripe_to_netsuite {
  sql_table_name: ACCOUNTING.V_STRIPE_TO_NETSUITE ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: exchange_rate {
    type: number
    sql: ${TABLE}."EXCHANGE_RATE" ;;
  }

  dimension: fee {
    type: number
    sql: ${TABLE}."FEE" ;;
  }

  dimension: net {
    type: number
    sql: ${TABLE}."NET" ;;
  }

  dimension: netsuite_related_tranid {
    type: string
    sql: ${TABLE}."NETSUITE_RELATED_TRANID" ;;
  }

  dimension_group: netsuite_transaction {
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
    sql: ${TABLE}."NETSUITE_TRANSACTION_DATE" ;;
  }

  dimension: netsuite_transaction_id {
    type: number
    sql: ${TABLE}."NETSUITE_TRANSACTION_ID" ;;
  }

  dimension: netsutie_status {
    type: string
    sql: ${TABLE}."NETSUTIE_STATUS" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
