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
    description: "Source: mainfreight. mainfreight_inventory_snapshot"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension_group: snapshot {
    description: "Source: analytics. mainfreight_inventory_snapshot"
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
    sql: CAST(${TABLE}."SNAPSHOT_TS" AS TIMESTAMP_NTZ) ;;
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
