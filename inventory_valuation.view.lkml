view: inventory_valuation {
  sql_table_name: production.inventory_valuatoin ;;

  dimension: report_date {
    type:  date
    sql: ${TABLE}.report_date ;;
  }

  dimension: item_id {
    type:  string
    sql:  ${TABLE}.item_id ;;
  }

  dimension: locatoin_id {
    type:  string
    sql:  ${TABLE}.item_id ;;
  }

  dimension: asset_account_name {
    type:  number
    sql: ${TABLE}.asset_account_name ;;
  }

  measure: inventory_value {
    type:  sum
    sql: ${TABLE}.inventory_value ;;
  }

  measure: percent_of_value {
    type:  sum
    sql: ${TABLE}.percent_of_value ;;
  }

  measure: on_hand {
    type:  sum
    sql: ${TABLE}.on_hand ;;
  }

}
