view: standard_cost {

  sql_table_name: analytics.sales.v_main_sales_standard_cost ;;

  dimension: item_id {
    type:  string
    hidden:  yes
    sql:${TABLE}.item_id ;; }

  dimension: ac_item_id {
    primary_key: yes
    type:  string
    hidden:  yes
    sql:${TABLE}.ac_item_id ;; }

  dimension: standard_cost {
    hidden: no
    label: "Standard Cost"
    type:  number
    value_format: "$#,##0.00"
    sql:${TABLE}.cost ;; }

}
