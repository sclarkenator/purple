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
    sql: ${TABLE}.product_id||'-'|| ${TABLE}.store||'-'||${TABLE}.finalized_date;; }


  dimension: mf_sku{
    hidden:  yes
    type:  string
    sql:  ${TABLE}.mf_Sku ;; }

  dimension_group: finalized{
    label: "Order date"
    description: "When order was placed @ Mattress Firm"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.finalized_date ;; }

  dimension: store {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.store ;; }

  dimension: product_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.product_id ;; }

  measure: final_units {
    label: "Units"
    description: "Total units sold (finalized) to customer"
    type:  sum
    sql:  ${TABLE}.final_units ;; }

  #measure: transaction_count {
  #  label: "Transaction Count"
  #  type: count }

}
