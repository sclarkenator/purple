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
    sql: ${TABLE}."RECEIPT_ID" ||'-'|| ${TABLE}."ITEM_ID" ;;
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

  measure: total_restocked_items {
    group_label: "  Advanced"
    label: "    * Is Restocked"
    description: "in units"
    type: yesno
    sql: ${TABLE}."RESTOCKED_ITEMS is not NULL" ;;
  }
}
