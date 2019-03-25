view: marketing_sms_codes {
  sql_table_name: csv_uploads.sms_codes ;;

  dimension: promo {
    type: string
    hidden: yes
    sql: ${TABLE}.promo ;;
  }

  dimension: sms {
    type: string
    hidden: yes
    sql: ${TABLE}.sms ;;
  }

}
