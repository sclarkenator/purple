view: mainfreight_inventory_snapshot {
  sql_table_name: analytics.production.mainfreight_inventory_snapshot
  ;;

  dimension: pk {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${sku_id}||${snapshot_raw};;
  }

  dimension: sku_id {
    hidden: yes
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension_group: snapshot {
    label: "Created"
    description: "Source: analytics. mainfreight_inventory_snapshot"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}."SNAPSHOT") ;;
  }

  measure: available {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."AVAILABLE" ;;
  }

  measure: available_to_order {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."AVAILABLE_TO_ORDER" ;;
  }

  measure: committed {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."COMMITTED" ;;
  }

  measure: damaged {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."DAMAGED" ;;
  }

  measure: entered {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."ENTERED" ;;
  }

  measure: held {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."HELD" ;;
  }

  measure: restricted {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."RESTRICTED" ;;
  }

  measure: stock_on_hand {
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: sum
    sql: ${TABLE}."STOCK_ON_HAND" ;;
  }

}
