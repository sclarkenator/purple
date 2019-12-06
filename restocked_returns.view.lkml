view: restocked_returns {
  derived_table: {
    sql: SELECT rr.return_order_id, rr.item_id, sum(rr.item_count) restocked_items
        FROM analytics.finance.receipt_restock rr
        where do_restock = 'Yes'
      GROUP BY 1, 2
      ;;
  }

  dimension: pk {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.return_order_id ||'-'|| ${TABLE}."ITEM_ID" ;;
  }

  dimension: return_order_id {
    type: number
    hidden: yes
    sql: ${TABLE}.return_order_id ;;
  }

  dimension: item_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: restocked_items {
    hidden: yes
    type: number
    sql: ${TABLE}."RESTOCKED_ITEMS" ;;
  }

  dimension: total_restocked_items {
    label: "    * Is Restocked"
    description: "in units"
    type: yesno
    sql: ${TABLE}."RESTOCKED_ITEMS" is not NULL ;;
      }

  measure: total_restocked_items_units {
    label: " Total Restocked (units)"
    description: "How many units have been restocked"
    type: sum
    sql: ${TABLE}."RESTOCKED_ITEMS" ;;
  }

}
