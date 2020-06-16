view: return_reason {
  sql_table_name: analytics_stage.ns.UPDATED_RETURN_REASONS ;;

  dimension: list_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.LIST_ID ;; }

  dimension: return_reason {
    ###this is garbage data. I'm working on the real return reasons with Nate C. -Scott
    label:"Return Reason"
    description: "Reason customer gives for returning that item"
    type:  string
    hidden: yes
    sql:  upper(${TABLE}.list_item_name) ;; }

}