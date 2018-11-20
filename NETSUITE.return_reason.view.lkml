view: return_reason {
  sql_table_name: ANALYTICS_STAGE.netsuite.UPDATED_RETURN_REASONS ;;

  dimension: list_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.LIST_ID ;; }

  dimension: return_reason {
    label:"Return Reason"
    description: "Reason customer gives for returning that item"
    type:  string
    sql:  upper(${TABLE}.list_item_name) ;; }

}
