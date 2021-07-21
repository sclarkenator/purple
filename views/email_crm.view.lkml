
view: email_crm {
  sql_table_name: SALES.customer ;;

  dimension: email {
    group_label: "  Customer details"
    view_label: "Customer"
    hidden:  yes
    label: "Customer Email"
    description: "Customer Email Address on the Netsuite sales order record. Source:netsuite.sales_order used for calculations only to avoid PII"
    type: string
    sql: ${TABLE}.email ;; }


}
