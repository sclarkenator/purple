view: exchange_order_line {
  sql_table_name: SALES.EXCHANGE_ORDER_LINE ;;

  dimension_group: closed {
    type: time
    hidden:  yes
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
    sql: ${TABLE}."CLOSED" ;;
  }

  dimension_group: created {
    type: time
    hidden:  yes
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

  dimension: exchange_order_id {
    type: number
    hidden:  yes
    sql: ${TABLE}."EXCHANGE_ORDER_ID" ;;
  }

  dimension_group: insert_ts {
    type: time
    hidden:  yes
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

  dimension: item_id {
    type: number
    hidden:  yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: memo {
    type: string
    hidden:  yes
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: order_id {
    type: number
    hidden:  yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: quantity {
    type: number
    hidden:  yes
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: replacement_order_id {
    type: number
    hidden:  yes
    sql: ${TABLE}."REPLACEMENT_ORDER_ID" ;;
  }

  dimension: system {
    type: string
    hidden:  yes
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension_group: system_created {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SYSTEM_CREATED" ;;
  }

  dimension_group: update_ts {
    type: time
    hidden:  yes
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
    label: "Exchanged Units"
    type: count
    #hidden:  yes
    drill_fields: []
  }

  dimension: is_exchanged {
    label: "     * Is Exchanged"
    description: "Exchange order has been created"
    type: yesno
    sql: ${TABLE}.CREATED is not null ;;
  }
}
