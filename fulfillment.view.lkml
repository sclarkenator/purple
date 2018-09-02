view: fulfillment {
  sql_table_name: SALES.FULFILLMENT ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."FULFILLMENT_ID"||'-'||${TABLE}.item_id||${TABLE}.parent_item_id ;;
  }

  dimension: carrier {
    label: "Shipping provider"
    description: "What shipping provider was used to fulfill this part of the order?"
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: fulfilled {
    hidden: yes
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FULFILLED" ;;
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

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: parent_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."PARENT_ITEM_ID" ;;
  }

  dimension: quantity {
    hidden: yes
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: shipping {
    hidden: yes
    type: number
    sql: ${TABLE}."SHIPPING" ;;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension: tranid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."TRANID" ;;
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

  measure: count {
    hidden: yes
    type: count
    drill_fields: [PK]
  }

  measure: total_shipping {
    label: "Direct shipping costs"
    description: "Direct shipping costs incurred, not including last-mile or other transfer costs"
    type: sum
    sql: ${TABLE}.shipping ;;
  }
}
