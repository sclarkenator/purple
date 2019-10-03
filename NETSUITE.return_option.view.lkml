view: return_option {
  sql_table_name: analytics_stage.netsuite.return_option_list ;;

  dimension: list_id {
    type: number
    hidden: yes
    primary_key: yes
    sql:${TABLE}.LIST_ID;; }

  dimension: list_item_name {
    label:" Return Method"
    description: "Channel the customer used show proof and qualify for the refund"
    type:  string

    sql:${TABLE}.list_item_name;; }

}
