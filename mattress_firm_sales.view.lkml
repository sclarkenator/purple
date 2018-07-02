view: mattress_firm_sales {
  sql_table_name: mattress_firm.sales_data ;;

  dimension: mf_sku{
    hidden:  yes
    type:  string
    sql:  ${TABLE}.mf_Sku ;;
  }

  dimension_group: finalized_date{
    type:  time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
    ]
    datatype: date
    sql: ${TABLE}.finalized_date ;;
  }

  dimension: store_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.store_id ;;
  }

  measure: final_units {
    label: "Total units sold"
    description: "Total units finalized to customer"
    type:  sum
    sql:  ${TABLE}.final_units ;;
  }

  measure: avg_units {
    label: "Average units sold"
    description: "Average units finalized to customer"
    type:  average
    sql:  ${TABLE}.final_units ;;
  }


}
