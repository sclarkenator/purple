view: marketing_sms_codes {
  sql_table_name: csv_uploads.sms_codes ;;

  dimension: promo {
    label: "SMS Promo"
    type: string
    hidden: yes
    sql: ${TABLE}.promo ;;
  }

  dimension: sms {
    label: "SMS Code"
    type: string
    #hidden: yes
    sql: ${TABLE}.sms ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sms},${promo}) ;;
    hidden: yes
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
