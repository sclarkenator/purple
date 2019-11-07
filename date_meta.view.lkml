view: date_meta {
  sql_table_name: util.warehouse_date ;;

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
    primary_key: yes
    hidden: yes
  }

  dimension: DAY_OF_QUARTER {
    type: number
    hidden: yes
    sql: ${TABLE}.DAY_OF_QUARTER ;;
  }

}
