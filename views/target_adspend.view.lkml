view: target_adspend {
  sql_table_name: CSV_UPLOADS.ADSPEND_TARGETS ;;

  measure: amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }

  dimension_group: date {
    hidden:  no
    type:  time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql:  ${TABLE}.date ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden:  yes
    sql: ${date_date} ;;
  }

}
