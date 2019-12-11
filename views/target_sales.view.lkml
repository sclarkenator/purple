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

  measure: days {
    label: "Days in month"
    description: "This is the number of days in the month by any of the applied fields"
    type: count
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
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
   sql: CONCAT(${date_date}, ${MTD_flg}) ;;
  }

}
