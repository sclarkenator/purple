view: mattress_firm_item {
  sql_table_name: mattress_firm.product ;;

  dimension: item_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.item_id ;;
  }

  dimension: mf_sku {
    hidden: yes
    type:  string
    primary_key: yes
    sql: ${TABLE}.mf_sku ;;
  }
}
