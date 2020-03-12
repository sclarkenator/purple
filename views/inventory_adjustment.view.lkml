view: inventory_adjustment {
  sql_table_name: "PRODUCTION"."INVENTORY_ADJUSTMENT"
    ;;
  drill_fields: [inventory_adjustment_id]

  dimension: inventory_adjustment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."INVENTORY_ADJUSTMENT_ID" ;;
  }

  dimension: adjustment_account {
    type: string
    sql: ${TABLE}."ADJUSTMENT_ACCOUNT" ;;
  }

  dimension: adjustment_location {
    type: string
    sql: ${TABLE}."ADJUSTMENT_LOCATION" ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}."CHANNEL_ID" ;;
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

  dimension: created_by_id {
    type: number
    sql: ${TABLE}."CREATED_BY_ID" ;;
  }

  dimension: created_from_id {
    type: number
    sql: ${TABLE}."CREATED_FROM_ID" ;;
  }

  dimension: download_to_warehouse_edge {
    type: yesno
    sql: ${TABLE}."DOWNLOAD_TO_WAREHOUSE_EDGE" ;;
  }

  measure: estimated_total_value {
    type: sum
    sql: ${TABLE}."ESTIMATED_TOTAL_VALUE" ;;
  }

  dimension: memo {
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

  dimension: posting_period {
    type: string
    sql: ${TABLE}."POSTING_PERIOD" ;;
  }

  dimension: reason_code {
    type: string
    sql: ${TABLE}."REASON_CODE" ;;
  }

  dimension_group: sales_effective {
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
    sql: ${TABLE}."SALES_EFFECTIVE" ;;
  }

  dimension_group: trandate {
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

  dimension: transaction_extid {
    type: string
    sql: ${TABLE}."TRANSACTION_EXTID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_source {
    type: string
    sql: ${TABLE}."TRANSACTION_SOURCE" ;;
  }

  dimension: transfer_order {
    type: number
    sql: ${TABLE}."TRANSFER_ORDER" ;;
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
    drill_fields: [inventory_adjustment_id, inventory_adjustment_line.count]
  }
}
