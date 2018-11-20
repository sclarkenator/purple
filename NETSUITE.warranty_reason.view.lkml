view: warranty_reason {
  sql_table_name:  ANALYTICS_STAGE.netsuite.UPDATE_WARRANTY_REASONS ;;

  dimension: list_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.LIST_ID ;; }

  dimension: return_reason {
    label:"Warranty Reason"
    description: "Reason customer gives for submitting warranty claim on that item"
    type:  string
    sql:  upper(${TABLE}.list_item_name) ;; }

}
