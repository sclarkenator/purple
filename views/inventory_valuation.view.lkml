#-------------------------------------------------------------------
# Owner - Tim Schultz
# Netsuite report, exported and saved as a snapshot.
#-------------------------------------------------------------------

view: inventory_valuation {
  sql_table_name: production.inventory_valuation ;;

  dimension: report_date {
    label: "Report Generated"
    type:  date
    sql: ${TABLE}.report_date ;; }

  dimension: item_id {
    label: "Item ID"
    description: "Internal Netsuite ID"
    type:  string
    sql:  ${TABLE}.item_id ;; }

  dimension: location_id {
    hidden:  yes
    type:  number
    sql:  ${TABLE}.location_id ;; }

  dimension: asset_account_name {
    group_label: "Asset Account Name"
    type:  string
    sql: ${TABLE}.asset_account_name ;; }

  measure: inventory_value {
    label: "Total Inventory Value"
    type:  sum
    sql: ${TABLE}.inventory_value ;; }

  measure: percent_of_value {
    label: "Total Percent of Value"
    type:  sum
    sql: ${TABLE}.percent_of_value ;; }

  measure: on_hand {
    label: "Total On Hand"
    type:  sum
    sql: ${TABLE}.on_hand ;; }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${report_date},${item_id},${asset_account_name}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
