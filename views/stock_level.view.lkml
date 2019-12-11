view: stock_level {
  sql_table_name: PRODUCTION.STOCK_LEVEL ;;

  dimension: PK {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."ITEM_ID"||${TABLE}."LOCATION_ID" ;;
  }

  dimension: item_id {
    description: "Netsuite Item Internal Primary Key"
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location_id {
    description: "Netsuite Warehouse Internal Primary Key"
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: target_stocklevel {
    hidden: yes
    type: number
    sql: ${TABLE}."TARGET_STOCKLEVEL" ;;
  }

  measure: count {
    description: "The count of occurences"
    type: count
    drill_fields: []
  }

  measure: Stock_Level_SUM {
    description: "The aggregation of warehouse and item specific stock levels"
    type: sum
    drill_fields: [item_id,location_id]
    sql: ${TABLE}."TARGET_STOCKLEVEL";;
  }
}
