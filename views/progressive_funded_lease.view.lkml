#-------------------------------------------------------------------
# Owner - Scott Clark
#-------------------------------------------------------------------

view: progressive_funded_lease {
  sql_table_name: FINANCE.progressive_funded_lease ;;

  dimension: lease_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.LEASE_ID ;; }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;; }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;; }


  dimension: invoice_number {
    label: "Invoice Number"
    type: string
    sql: ${TABLE}.invoice_number ;; }

  dimension: term_dim {
    label: "Term"
    type: string
    sql: ${TABLE}.term ;; }

  dimension: paid {
    label: "Paid"
    type: date
    sql: ${TABLE}.paid ;; }

  dimension: delivery {
    label: "Delivery"
    type: date
    sql: ${TABLE}.delivery ;; }


  measure: count {
    type: count }

  measure: invoice_amount {
    label:  "Total Invoice Amount"
    type: sum
    sql:  ${TABLE}.invoice_amount ;; }

  measure: initial_payment {
    label:  "Total Intial Payment"
    type: sum
    sql:  ${TABLE}.initial_payment ;; }

  measure: initial_payment_tax {
    label:  "Total Initial Payment Tax"
    type: sum
    sql:  ${TABLE}.initial_payment_tax ;; }

  measure: discount {
    label:  "Total Discount"
    type: sum
    sql:  ${TABLE}.discount ;; }

  measure: net_funded {
    label:  "Total Net Funded"
    type: sum
    sql:  ${TABLE}.net_funded ;; }

  measure: term {
    label:  "Total Term"
    type: sum
    sql:  ${TABLE}.term ;; }

}
