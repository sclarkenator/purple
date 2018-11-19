#-------------------------------------------------------------------
# Owner - Scott Clark
# Mattress firm sales
#-------------------------------------------------------------------

view: mattress_firm_sales {
  sql_table_name: mattress_firm.sales_data ;;

  dimension: key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.mf_sku || || ${TABLE}.store_id || ||  ${TABLE}.created_utc;; }


  dimension: mf_sku{
    hidden:  yes
    type:  string
    sql:  ${TABLE}.mf_Sku ;; }

  dimension_group: finalized_date{
    label: "Finalized"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.finalized_date ;; }

  dimension: store_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.store_id ;; }

  measure: final_units {
    label: "Total Sold (units)"
    description: "Total units finalized to customer"
    type:  sum
    sql:  ${TABLE}.final_units ;; }

  measure: avg_units {
    label: "Average Sold (units)"
    description: "Average units finalized to customer"
    type:  average
    sql:  ${TABLE}.final_units ;; }

  measure: transaction_count {
    label: "Transaction Count"
    type: count }

}
