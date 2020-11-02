view: mainfreight_inventory {
  sql_table_name: analytics.production.mainfreight_inventory
    ;;


  dimension: sku_id {
    primary_key: yes
    description: "Source: mainfreight. mainfreight_inventory"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension_group: updated_ts {
    hidden: yes
    description: "Last time this data was received from Mainfreight. Source: analytics. mainfreight_inventory_snapshot"
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
    sql: CAST(${TABLE}."UPDATED_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: available {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."AVAILABLE" ;;
  }

  measure: available_to_order {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."AVAILABLE_TO_ORDER" ;;
  }

  measure: committed {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."COMMITTED" ;;
  }

  measure: damaged {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."DAMAGED" ;;
  }

  measure: entered {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."ENTERED" ;;
  }

  measure: held {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."HELD" ;;
  }

  measure: restricted {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."RESTRICTED" ;;
  }

  measure: stock_on_hand {
    description: "Source: mainfreight. mainfreight_inventory"
    type: sum
    sql: ${TABLE}."STOCK_ON_HAND" ;;
  }

}
