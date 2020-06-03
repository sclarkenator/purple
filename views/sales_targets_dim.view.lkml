view: sales_targets_dim {
  derived_table: {
    sql: select date, dtc as target, 'DTC' as channel
      from CSV_UPLOADS.finance_targets
      union all
      select date, whlsl, 'Wholesale' as channel
      from CSV_UPLOADS.finance_targets
      union all
      select date, retail, 'Owned Retail' as channel
      from CSV_UPLOADS.finance_targets ;;
  }

  dimension_group: date {
    label: "Target"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.date ;;
  }

  dimension_group: current {
    label: "Current"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

  dimension: channel {
    label: "Channel"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: before_today {
    type: yesno
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) ;;
  }

  measure: target {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.target ;;
  }
}
