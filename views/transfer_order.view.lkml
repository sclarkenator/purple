view: transfer_order {
  sql_table_name: PRODUCTION.TRANSFER_ORDER ;;

  dimension: transfer_order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."TRANSFER_ORDER_ID" ;;
  }

  dimension: amazon_reference_id {
    type: string
    sql: ${TABLE}."AMAZON_REFERENCE_ID" ;;
  }

  dimension: amazon_shipment_id {
    type: string
    sql: ${TABLE}."AMAZON_SHIPMENT_ID" ;;
  }

  dimension: Container_count{
    type: string
    sql: ${TABLE}."CONTAINER_COUNT" ;;
    hidden: yes
  }

  measure: total_container_count{
    type: sum
    sql: ${TABLE}."CONTAINER_COUNT" ;;
  }

  dimension: amount_unbilled {
    type: number
    hidden: yes
    sql: ${TABLE}."AMOUNT_UNBILLED" ;;
  }

  dimension_group: carrier_eta {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."CARRIER_ETA" );;
  }

  dimension_group: closed {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."CLOSED") ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."CREATED" );;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}."DEPARTMENT_ID" ;;
  }

  dimension_group: estimated_ship {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."ESTIMATED_SHIP" );;
  }

  dimension: incoterm {
    type: string
    sql: ${TABLE}."INCOTERM" ;;
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
    convert_tz: no
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: Order_memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension_group: modified {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."MODIFIED" );;
  }

  dimension_group: received {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."RECEIVED" );;
  }

  dimension: receiving_location_id {
    type: number
    sql: ${TABLE}."RECEIVING_LOCATION_ID" ;;
  }

  dimension_group: sales_effective {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."SALES_EFFECTIVE" );;
  }

  dimension: ship_address {
    type: string
    sql: ${TABLE}."SHIPADDRESS" ;;
  }

  dimension: shipping_item_id {
    type: number
    sql: ${TABLE}."SHIPPING_ITEM_ID" ;;
  }

  dimension: shipping_location_id {
    type: number
    sql: ${TABLE}."SHIPPING_LOCATION_ID" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension_group: trandate {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."TRANDATE" );;
  }

  dimension: Document_Number {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
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

  measure: Order_count {
    type: count
    drill_fields: [transfer_order_id, transfer_order_line.count]
  }
}
