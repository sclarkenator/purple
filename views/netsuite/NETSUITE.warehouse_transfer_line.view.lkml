view: warehouse_transfer_line {
  #sql_table_name: PRODUCTION.WAREHOUSE_TRANSFER_LINE ;;
  derived_table: {sql:
  select * from (
    select a.*
        , row_number () over (partition by a.WAREHOUSE_TRANSFER_ID||a.ITEM_ID order by 1) as rownum
    from PRODUCTION.WAREHOUSE_TRANSFER_LINE a
  ) z
  where z.rownum = 1
  ;;}

  dimension: key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."WAREHOUSE_TRANSFER_ID"||"-"||${TABLE}."ITEM_ID"  ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: item_count {
    type: number
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  measure: Total_items {
    type: sum
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}."ITEM_ID" ;;
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

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}."UNIT_OF_MEASURE" ;;
  }

  dimension_group: update_ts {
    hidden:  yes
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

  dimension: warehouse_transfer_id {
    type: string
    hidden: yes
    sql: ${TABLE}."WAREHOUSE_TRANSFER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [warehouse_transfer.warehouse_transfer_id]
  }
}
