view: sales_targets {
  sql_table_name: CSV_UPLOADS.finance_targets ;;

  measure: dtc_target {
    label: "Daily sales target"
    description: "Monthly gross sales target, spread by day"
    type: sum
    sql: ${TABLE}.DTC ;;
  }

  measure: whlsl_target {
    label: "Wholesale sales target"
    description: "Monthly gross sales target, spread by day"
    value_format: "0.0,,\" M\""
    type: sum
    sql: ${TABLE}.WHLSL ;;
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

  dimension: MTD_flg{
    description: "This field is for formatting on MTD reports"
    type: yesno
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) and month(${TABLE}.date) = month(current_date) and year(${TABLE}.date) = year(current_date) ;;
  }

}
