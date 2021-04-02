view: sales_targets {
  sql_table_name: CSV_UPLOADS.finance_targets ;;

  measure: dtc_target {
    label: "Daily DTC Sales Target"
    description: "Monthly gross sales target, spread by day"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.DTC ;;
  }

  dimension: dtc_target_dim {
    hidden: yes
    type: number
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

  measure: roas_target {
    label: "ROAS Sales Target"
    description: "100% of DTC and Owned Retail + 50% of Wholesale"
    value_format: "$#,##0"
    type: sum
    sql: (${TABLE}.WHLSL *0.50) + ${TABLE}.RETAIL + ${TABLE}.DTC ;;
  }

    measure: insidesales_target {
    label: "Insidesales Sales Target"
    description: "A ramping % of DTC sales through Dec 2020 capping at 15%"
    value_format: "$#,##0"
    type: sum
    sql: case
        when ${date_date} >= '2020-01-01' and ${date_date} < '2020-02-01' then ${dtc_target_dim} * 0.065
        when ${date_date} >= '2020-02-01' and ${date_date} < '2020-03-01' then ${dtc_target_dim} * 0.064
        when ${date_date} >= '2020-03-01' and ${date_date} < '2020-04-01' then ${dtc_target_dim} * 0.066
        when ${date_date} >= '2020-04-01' and ${date_date} < '2020-05-01' then ${dtc_target_dim} * 0.07
        when ${date_date} >= '2020-05-01' and ${date_date} < '2020-06-01' then ${dtc_target_dim} * 0.071
        when ${date_date} >= '2020-06-01' and ${date_date} < '2020-07-01' then ${dtc_target_dim} * 0.094
        when ${date_date} >= '2020-07-01' and ${date_date} < '2020-08-01' then ${dtc_target_dim} * 0.105
        when ${date_date} >= '2020-08-01' and ${date_date} < '2020-09-01' then ${dtc_target_dim} * 0.115
        when ${date_date} >= '2020-09-01' and ${date_date} < '2020-10-01' then ${dtc_target_dim} * 0.125
        when ${date_date} >= '2020-10-01' and ${date_date} < '2020-11-01' then ${dtc_target_dim} * 0.135
        when ${date_date} >= '2020-11-01' and ${date_date} < '2020-12-01' then ${dtc_target_dim} * 0.14
        when ${date_date} >= '2020-12-01' and ${date_date} < '2021-01-01' then ${dtc_target_dim} * 0.15
        when ${date_date} >= '2021-01-01' and ${date_date} < '2021-02-01' then ${dtc_target_dim} * 0.13845
        when ${date_date} >= '2021-02-01' and ${date_date} < '2021-03-01' then ${dtc_target_dim} * 0.14254
        when ${date_date} >= '2021-03-01' and ${date_date} < '2021-04-01' then ${dtc_target_dim} * 0.16313
        when ${date_date} >= '2021-04-01' and ${date_date} < '2021-05-01' then ${dtc_target_dim} * 0.15821
        when ${date_date} >= '2021-05-01' and ${date_date} < '2021-06-01' then ${dtc_target_dim} * 0.15469
        when ${date_date} >= '2021-06-01' and ${date_date} < '2021-07-01' then ${dtc_target_dim} * 0.15310
        when ${date_date} >= '2021-07-01' and ${date_date} < '2021-08-01' then ${dtc_target_dim} * 0.15717
        when ${date_date} >= '2021-08-01' and ${date_date} < '2021-09-01' then ${dtc_target_dim} * 0.16796
        when ${date_date} >= '2021-09-01' and ${date_date} < '2021-10-01' then ${dtc_target_dim} * 0.15685
        when ${date_date} >= '2021-10-01' and ${date_date} < '2021-11-01' then ${dtc_target_dim} * 0.15755
        when ${date_date} >= '2021-11-01' and ${date_date} < '2021-12-01' then ${dtc_target_dim} * 0.15944
        when ${date_date} >= '2021-12-01' and ${date_date} < '2022-01-01' then ${dtc_target_dim} * 0.15470
        when ${date_date} >= '2022-01-01' then ${dtc_target_dim} * 0.15
        else 0 end
    ;;
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
