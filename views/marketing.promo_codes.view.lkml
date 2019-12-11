view: marketing_promo_codes {
  sql_table_name: csv_uploads.promo_codes ;;

  dimension: promo {
    hidden: yes
    type: string
    sql: ${TABLE}.promo ;;}

  dimension: keyword {
    hidden: yes
    type: string
    sql: ${TABLE}.keyword ;;}

  dimension: source {
    hidden: yes
    type: string
    sql: Lower(${TABLE}.media_type) ;;}

  dimension: media_type {
    hidden: yes
    type: string
    sql: ${TABLE}.media_type ;;}

  dimension: station {
    hidden: yes
    type: string
    sql: ${TABLE}.station ;;}

  dimension: offer {
    hidden: yes
    type: string
    sql: ${TABLE}.offer ;;}

  dimension: start_date {
    type: date
    hidden: yes
    sql: ${TABLE}.start_date ;;}

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${promo},${source},${start_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
