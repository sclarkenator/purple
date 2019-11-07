view: date_meta {
  sql_table_name: util.warehouse_date ;;

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
    primary_key: yes
    hidden: yes
  }

  dimension: DAY_OF_QUARTER {
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - day of quarter"
    type: number
    hidden: yes
    sql: ${TABLE}.DAY_OF_QUARTER ;;
  }

}
