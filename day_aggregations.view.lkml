######################################################
#   DTC Sales and Units
######################################################
view: day_aggregations_dtc_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: sales_order_line.created_date value: "2 years" }
    }
  }
  #dimension: created_date { type: date }
  dimension_group: created_date { type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
}
######################################################
#   Wholesale Sales and Units
######################################################
view: day_aggregations_wholesale_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      filters: { field: sales_order.channel value: "Wholesale" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: sales_order_line.created_date value: "2 years" }
    }
  }
  dimension: created_date { type: date }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
}

######################################################
#   Forecast Amounts and Units
######################################################
view: day_aggregations_forecast {
  derived_table: {
    explore_source: tim_forecast_combined {
      column: date_date {}
      column: total_amount {}
      column: dtc_amount {}
      column: wholesale_amount {}
      column: total_units {}
      column: dtc_units {}
      column: wholesale_units {}
      filters: { field: tim_forecast_combined.date_date value: "2 years" }
    }
  }
  dimension: date_date { type: date }
  measure: total_amount { type: sum }
  measure: dtc_amount { type: sum }
  measure: wholesale_amount { type: sum }
  measure: total_units { type: sum }
  measure: dtc_units { type: sum }
  measure: wholesale_units { type: sum }
}

######################################################
#   Merging Forecast and Actuals by Day
######################################################
view: day_aggregations {
  #derived_table: {
    #sql: select created_date, total_gross_Amt_non_rounded
    #  from ${day_aggregations_dtc_sales.??} as sales;;
 # }
 # dimension: created_date {type: date}
 # measure: total_gross_Amt_non_rounded {type:sum}
}
