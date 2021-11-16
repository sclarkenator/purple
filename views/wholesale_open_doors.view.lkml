view: wholesale_open_doors {
  sql_table_name: "ANALYTICS"."WHOLESALE"."V_WHOLESALE_OPEN_DOORS"
    ;;

  dimension: pk {
    type: string
    primary_key: yes
    sql: ${TABLE}.date || ${TABLE}.wholesale_store_parent_name ;;
  }

  dimension_group: week {
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
    sql: ${TABLE}."DATE" ;;
  }

  measure: wholesale_store_account_count {
    type: sum
    sql: ${TABLE}."WHOLESALE_STORE_ACCOUNT_COUNT" ;;
  }

  measure: wholesale_store_account_cumulative {
    type: max
    sql: ${TABLE}."WHOLESALE_STORE_ACCOUNT_CUMULATIVE" ;;
  }

  dimension: wholesale_store_parent_name {
    type: string
    sql: ${TABLE}."WHOLESALE_STORE_PARENT_NAME" ;;
  }
}
