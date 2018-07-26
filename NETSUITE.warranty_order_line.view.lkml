view: warranty_order_line {
  sql_table_name: sales.warranty_order_line ;;

  dimension_group: closed {
    hidden: yes
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
    sql: ${TABLE}."CLOSED" ;;
  }

  dimension_group: created_ts {
    hidden: yes
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
    sql: ${TABLE}."CREATED_TS" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  measure: quantity {
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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

  dimension: warranty_order_id {
    hidden: yes
    primary_key: yes
    type: number
    # hidden: yes
    sql: ${TABLE}."WARRANTY_ORDER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [warranty_order.warranty_order_id]
  }
}
