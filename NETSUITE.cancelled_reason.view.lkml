view: NETSUITE_cancelled_reason {
  sql_table_name: ANALYTICS_STAGE.NETSUITE_STG.SHOPIFY_CANCEL_REASON_LIST ;;


  dimension: list_id {
    type: number
    label: "Cancel code"
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.list_id  ;;
  }

  dimension: list_name {
    type: string
    label: "Cancel reason"
    description: "Given reason for cancelling the order or item"
    sql: ${TABLE}.list_item_name  ;;
  }
  }
