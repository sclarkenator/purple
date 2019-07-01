view: target_adspend {
  sql_table_name: CSV_UPLOADS.adspend_target ;;

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

}
