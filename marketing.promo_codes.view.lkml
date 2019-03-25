view: marketing_promo_codes {
  sql_table_name: csv_uploads.promo_codes ;;

  dimension: promo {
    type: string
    sql: ${TABLE}.promo ;;}

  dimension: promo_code {
    type: string
    hidden: yes
    sql: ${TABLE}.promo_code ;;  }

  dimension: show_station {
    type: string
    #hidden: yes
    sql: ${TABLE}.show_station ;; }

  dimension: channel {
    type: string
    #hidden: yes
    sql: ${TABLE}.channel ;; }

  dimension: offer {
    type: string
    #hidden: yes
    sql: ${TABLE}.offer ;;
  }

}
