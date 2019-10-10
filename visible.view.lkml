view: visible {
  sql_table_name: PRODUCTION.VISIBLE ;;

  dimension_group: delivery {
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
    sql: ${TABLE}."DELIVERY" ;;
  }

  dimension_group: in_hand {
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
    sql: ${TABLE}."IN_HAND" ;;
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

  dimension: item_id {
    type: string
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: load_id {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."LOAD_ID" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: product {
    hidden: yes
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  measure: quantity_on_load{
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: recipient {
    type: string
    sql: ${TABLE}."RECIPIENT" ;;
  }

  dimension: recipient_id {
    type: string
    sql: ${TABLE}."RECIPIENT_ID" ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED" ;;
  }

  dimension: tranid {
    type: string
    group_label: "Advanced"
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
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

  dimension: weight_of_load {
    group_label: "Advanced"
    type: number
    sql: ${TABLE}."WEIGHT" ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${update_ts_date}, ${item_id}, ${order_id}) ;;
    hidden: yes
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
