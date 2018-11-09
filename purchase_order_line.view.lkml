view: purchase_order_line {
  sql_table_name: PRODUCTION.PURCHASE_ORDER_LINE ;;

dimension: Primary_key{
  primary_key: yes
  hidden: yes
  type: string
  sql: ${TABLE}."PURCHASE_ORDER_ID"||'L'||${TABLE}."PURCHASE_ORDER_LINE_ID" ;;
}

  dimension: purchase_order_line_id {
    type: number
    sql: ${TABLE}."PURCHASE_ORDER_LINE_ID" ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: closed {
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

  dimension: company_id {
    type: number
    sql: ${TABLE}."COMPANY_ID" ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}."DEPARTMENT_ID" ;;
  }

  dimension_group: due {
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
    sql: ${TABLE}."DUE" ;;
  }

  dimension_group: estimated_arrival {
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
    sql: ${TABLE}."ESTIMATED_ARRIVAL" ;;
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

  dimension: item_count {
    type: number
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_unit_price {
    type: number
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  dimension: line_memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: number_billed {
    type: number
    sql: ${TABLE}."NUMBER_BILLED" ;;
  }

  dimension: part_number_print {
    type: string
    sql: ${TABLE}."PART_NUMBER_PRINT" ;;
  }

  dimension: product_line {
    type: string
    sql: ${TABLE}."PRODUCT_LINE" ;;
  }

  dimension: project {
    type: string
    sql: ${TABLE}."PROJECT" ;;
  }

  dimension: purchase_order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PURCHASE_ORDER_ID" ;;
  }

  dimension: quantity_received {
    type: number
    sql: ${TABLE}."QUANTITY_RECEIVED_IN_SHIPMENT" ;;
  }

  dimension: required_ship_by {
    type: string
    sql: ${TABLE}."REQUIRED_SHIP_BY" ;;
  }

  dimension_group: shipment_received {
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
    sql: ${TABLE}."SHIPMENT_RECEIVED" ;;
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

  dimension: unit_of_measurement {
    type: string
    sql: ${TABLE}."UNIT_OF_MEASUREMENT" ;;
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

  measure: line_count {
    type: count
    drill_fields: [purchase_order_line_id, purchase_order.purchase_order_id]
  }

  measure: total_amount {
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  measure: Total_quantity_received {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."QUANTITY_RECEIVED_IN_SHIPMENT" ;;
  }
  measure: Total_billed {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."NUMBER_BILLED" ;;
  }
  measure: Average_item_unit_price {
    type: average
    value_format: "$0.00"
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }
  measure: Total_item_count {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  measure: Total_open_quantity {
    type: sum
    description: "Of the total item count, how many have not been received"
    value_format: "#,##0"
    sql: ${TABLE}."ITEM_COUNT" - ${TABLE}."QUANTITY_RECEIVED_IN_SHIPMENT" ;;
  }
}
