view: warehouse_transfer {
  sql_table_name: PRODUCTION.WAREHOUSE_TRANSFER ;;

  dimension: warehouse_transfer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."WAREHOUSE_TRANSFER_ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: employee {
    type: string
    sql: ${TABLE}."EMPLOYEE" ;;
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

  dimension: SHIPPING_LOCATION_ID {
    hidden: yes
    type: string
    sql: ${TABLE}."SHIPPING_LOCATION_ID" ;;
  }

  dimension: RECEIVING_LOCATION_ID {
    hidden:  yes
    type: string
    sql: ${TABLE}."RECEIVING_LOCATION_ID" ;;
  }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension_group: trandate {
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
    sql: ${TABLE}."TRANDATE" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_number {
    hidden:  yes
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
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
    type: count
    drill_fields: [warehouse_transfer_id, warehouse_transfer_line.count]
  }
}
