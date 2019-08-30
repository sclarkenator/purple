view: v_affirm_to_netsuite {
  sql_table_name: ACCOUNTING.V_AFFIRM_TO_NETSUITE ;;

  dimension: affirm_amount {
    type: string
    sql: ${TABLE}."AFFIRM_AMOUNT" ;;
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

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: entry_id {
    type: string
    sql: ${TABLE}."ENTRY_ID" ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: netsuite_amount {
    type: number
    sql: ${TABLE}."NETSUITE_AMOUNT" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: shopify_amount {
    type: string
    sql: ${TABLE}."SHOPIFY_AMOUNT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: total_price {
    type: number
    sql: ${TABLE}."TOTAL_PRICE" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
    primary_key: yes
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
