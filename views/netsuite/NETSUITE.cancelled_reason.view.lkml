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
    group_label: "Advanced"
    label: " Cancel Reason"
    description: "Given reason for cancelling the order or item.
      Source: netsuite.netsuite_cancelled_reason
      Snowflake: analytics_stage.netsuite.
      shopify_cancel_reason_list"
    sql:
    case when
      ${TABLE}.list_item_name = 'FRAUD RISK' then 'Fraud Risk'
      else ${TABLE}.list_item_name
    end;; }

}
