view: sales_targets {
  sql_table_name: CSV_UPLOADS.finance_targets ;;

  measure: dtc_target {
    label: "Daily DTC Sales Target"
    description: "Monthly gross sales target, spread by day"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.DTC ;;
  }

  measure: retail_target {
    label: "Retail Sales Target"
    description: "Monthly gross sales target, spread by day"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.RETAIL ;;
  }

  measure: whlsl_target {
    label: "Wholesale Sales Target"
    description: "Monthly gross sales target, spread by day"
    value_format: "$#,##0"
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
      day_of_week_index,
      day_of_year,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
   sql:  ${TABLE}.date ;;
  }

  dimension: dayofquarterindex {   #returns day of quarter index int 1-92
    type: number
    view_label: "Sales Targets"
    description: "Returns a date's number position in its quarter. Ex. Jan 1 = 1; Feb 1 = 32"
    group_label: "Date Date"
    label: "Day of Quarter"
    sql: DATEDIFF('day',date_trunc('quarter',${date_date}::date),${date_date}::date) + 1 ;;
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
