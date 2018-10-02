view: stock_level {
  sql_table_name: PRODUCTION.STOCK_LEVEL ;;

  dimension: PK {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."ITEM_ID"||${TABLE}."LOCATION_ID" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: target_stocklevel {
    type: number
    sql: ${TABLE}."TARGET_STOCKLEVEL" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: Stock_Level_SUM {
    type: sum
    drill_fields: [item_id,location_id]
    sql: ${TABLE}."TARGET_STOCKLEVEL";;
  }
}
