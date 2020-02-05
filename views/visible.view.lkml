view: visible {
  sql_table_name: PRODUCTION.VISIBLE ;;

  dimension_group: delivery {
    group_label: "Visible SCM"
    label: "Visible delivery"
    description: "Date Visible delivered load to recipient"
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
    group_label: "Visible SCM"
    label: "Visible in-hand"
    description: "Date Visible takes load"
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
    hidden: yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: load_id {
    group_label: "Visible SCM"
    label: "Visible load_id"
    description: "Visible SCM load_id"
    type: string
    sql: ${TABLE}."LOAD_ID" ;;
  }

  dimension: order_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: product {
    hidden: yes
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  measure: quantity_on_load{
    label: "Load size (qty)"
    description: "Number of items on Visible load"
    type: sum
    hidden: yes
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: recipient {
    type: string
    hidden:  yes
    sql: ${TABLE}."RECIPIENT" ;;
  }

  dimension: recipient_id {
    type: string
    hidden: yes
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
    hidden:  yes
    datatype: date
    sql: ${TABLE}."SHIPPED" ;;
  }

  dimension: tranid {
    type: string
    hidden:  yes
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: type {
    type: string
    hidden: yes
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
    group_label: "Visible SCM"
    type: number
    hidden:  yes
    sql: ${TABLE}."WEIGHT" ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${update_ts_raw}, ${item_id}, ${order_id}, ${load_id}) ;;
    hidden: yes
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
