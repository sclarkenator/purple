#-------------------------------------------------------------------
# Owner - Scott Clark
#-------------------------------------------------------------------

view: progressive {
  sql_table_name: FINANCE.progressive_agreement ;;

  dimension: lease_id {
    hidden: yes
    type: number
    primary_key: yes
    sql: ${TABLE}.LEASE_ID ;; }

  dimension: store_id {
    hidden: yes
    type: number
    sql: ${TABLE}.STORE_ID ;; }

  dimension_group: created {
    type: time
    timeframes:[raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.CREATED ;; }

  dimension_group: funded {
    label: "Funded"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.FUNDED ;; }

  dimension: identifier {
    label: "Identifier"
    type: string
    sql: ${TABLE}.IDENTIFIER ;; }

  dimension: status {
    label: "Status"
    type: string
    sql: ${TABLE}.STATUS ;; }

  measure: count {
    type: count }

  measure: approval_limit {
    label:  "Approval Limit ($)"
    description:  "Total amount approved (but not necessarily funded)"
    type: sum
    value_format: "$#,##0"
    sql:  ${TABLE}.approval_limit ;; }

  measure: funded_amt {
    label:  "Funded Amount ($)"
    description:  "Total amount actually funded"
    type: sum
    value_format: "$#,##0"
    sql:  ${TABLE}.funded_amt ;; }

}
