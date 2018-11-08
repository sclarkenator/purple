view: inventory_valuation {
  sql_table_name: production.inventory_valuation ;;

  dimension: report_date {
    type:  date
    sql: ${TABLE}.report_date ;; }

  dimension: item_id {
    type:  string
    sql:  ${TABLE}.item_id ;; }

  dimension: location_id {
    type:  number
    sql:  ${TABLE}.location_id ;; }

  dimension: asset_account_name {
    type:  string
    sql: ${TABLE}.asset_account_name ;; }

  measure: inventory_value {
    type:  sum
    sql: ${TABLE}.inventory_value ;; }

  measure: percent_of_value {
    type:  sum
    sql: ${TABLE}.percent_of_value ;; }

  measure: on_hand {
    type:  sum
    sql: ${TABLE}.on_hand ;; }

}
