view: NETSUITE_cancelled_reason {
  sql_table_name: ANALYTICS_STAGE.netsuite.SHOPIFY_CANCEL_REASON_LIST ;;

  dimension: list_id {
    type: number
    label: "Cancel Code"
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.list_id  ;; }

  dimension: list_name {
    type: string
    label: " Cancel Reason"
    description: "Given reason for cancelling the order or item"
    sql: ${TABLE}.list_item_name  ;; }

}
