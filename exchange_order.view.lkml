view: exchange_order {
  sql_table_name: SALES.EXCHANGE_ORDER ;;
  drill_fields: [exchange_order_id]

  dimension: exchange_order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."EXCHANGE_ORDER_ID" ;;
  }

  dimension: channel_id {
    type: number
    hidden: yes
    sql: ${TABLE}."CHANNEL_ID" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: exchange_ref_id {
    type: string
    hidden: yes
    sql: ${TABLE}."EXCHANGE_REF_ID" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: memo {
    type: string
    hidden: yes
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: related_tranid {
    type: string
    hidden: yes
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: replacement_order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."REPLACEMENT_ORDER_ID" ;;
  }

  dimension: status {
    type: string
    hidden: yes
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: system {
    type: string
    hidden: yes
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension: transaction_number {
    type: string
    hidden: yes
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: upgrade {
    type: string
    hidden: yes
    sql: ${TABLE}."UPGRADE" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [exchange_order_id]
  }
}
