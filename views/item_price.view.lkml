view: item_price {
  sql_table_name: ANALYTICS.sales.item_price ;;

  dimension: id {
    type: number
    sql: ${TABLE}.id ;; }

  dimension: item_id {
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: sku {
    type: string
    primary_key: yes
    sql: ${TABLE}.sku ;; }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;; }

  dimension: has_had_price_test {
    type: yesno
    sql: ${TABLE}.price_test ;; }

  dimension: start_date {
    type: date
    sql: ${TABLE}.start_date ;; }

  dimension: end_date {
    type: date
    sql: ${TABLE}.end_date ;; }

}
