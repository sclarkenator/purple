view: marketing_promo_codes {
  sql_table_name: csv_uploads.promo_codes ;;

  dimension: promo {
    type: string
    sql: ${TABLE}.promo ;;}

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;}

  dimension: source {
    hidden: yes
    type: string
    sql: Lower(${TABLE}.media_type) ;;}

  dimension: media_type {
    type: string
    sql: ${TABLE}.media_type ;;}

  dimension: station {
    type: string
    sql: ${TABLE}.station ;;}

  dimension: offer {
    type: string
    sql: ${TABLE}.offer ;;}

  dimension: start_date {
    type: date
    sql: ${TABLE}.start_date ;;}

}
