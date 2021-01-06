view: transfer_order_line {
  #sql_table_name: PRODUCTION.TRANSFER_ORDER_LINE ;;
  derived_table: { sql:
    select * from (
      select a.*
          , row_number () over (partition by ACCOUNT_ID || TRANSFER_ORDER_ID || ITEM_ID order by 1) as rownum
      from PRODUCTION.transfer_order_line a
    ) z
    where z.rownum = 1
  ;;}


  dimension: pk {
    type: string
    sql: ${TABLE}."ACCOUNT_ID" ||  ${TABLE}."TRANSFER_ORDER_ID" ||  ${TABLE}."ITEM_ID" ;;
    primary_key: yes
    hidden:  yes
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."CREATED" );;
  }

  dimension_group: expected_receipt {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."EXPECTED_RECEIPT") ;;
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
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: line_memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension_group: shipment_received {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."SHIPMENT_RECEIVED") ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."SHIPPED") ;;
  }

  measure: days_in_transit {
    hidden: no
    type: count
    sql: datediff(${shipped_date},${shipment_received_date})  ;;
  }

  measure: sum_days_in_tranist {
    hidden: no
    type: sum
    sql: datediff(${shipped_date},${shipment_received_date}) ;;
  }

  dimension: transfer_order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."TRANSFER_ORDER_ID" ;;
  }

  dimension: transfer_order_item_line {
    type: number
    sql: ${TABLE}."TRANSFER_ORDER_ITEM_LINE" ;;
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}."UNIT_OF_MEASURE" ;;
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
    convert_tz: no
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: line_count {
    type: count
    drill_fields: [transfer_order_item_line]
  }

  measure: total_amount_received {
    type: sum
    sql: ${TABLE}."AMOUNT_RECEIVED" ;;
  }

  measure: total_amount_shipped {
    type: sum
    sql: ${TABLE}."AMOUNT_SHIPPED" ;;
  }

  measure: total_committed_qty {
    type: sum
    sql: ${TABLE}."COMMITTED_QTY" ;;
  }

  measure: total_item_count {
    type: sum
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  measure: total_item_unit_price {
    type: sum
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  measure: total_packed_qty {
    type: sum
    sql: ${TABLE}."PACKED_QTY" ;;
  }

  measure: total_picked_qty {
    type: sum
    sql: ${TABLE}."PICKED_QTY" ;;
  }

  measure: total_received_qty {
    type: sum
    sql: ${TABLE}."RECEIVED_QTY" ;;
  }

  measure: fulfilled_qty {
    type: sum
    sql: ${TABLE}."FULFILLED_QTY" ;;
  }

  dimension: total_received_qty_d {
    hidden: yes
    type: number
    sql: ${TABLE}."RECEIVED_QTY" ;;
  }

  dimension: fulfilled_qty_d {
    hidden: yes
    type: number
    sql: ${TABLE}."FULFILLED_QTY" ;;
  }

  measure: remaining_qty {
    type: sum
    sql: ${fulfilled_qty_d}-${total_received_qty_d} ;;
  }

}
