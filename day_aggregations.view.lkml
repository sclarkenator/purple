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
  derived_table: {
    sql:
      select d.date
        , dtc.total_gross_Amt_non_rounded as dtc_amount
        , dtc.total_units as dtc_units
        , wholesale.total_gross_Amt_non_rounded as wholesale_amount
        , wholesale.total_units as wholesale_units
        , forecast.total_amount as forecast_total_amount
        , forecast.total_units as forecast_total_units
        , forecast.dtc_amount as forecast_dtc_amount
        , forecast.dtc_units as forecast_dtc_units
        , forecast.wholesale_amount as forecast_wholesale_amount
        , forecast.wholesale_units as forecast_wholesale_units
      from analytics.util.warehouse_date d
      left join ${day_aggregations_dtc_sales.SQL_TABLE_NAME} dtc on dtc.created_date::date = d.date
      left join ${day_aggregations_wholesale_sales.SQL_TABLE_NAME} wholesale on wholesale.created_date::date = d.date
      left join ${day_aggregations_forecast.SQL_TABLE_NAME} forecast on forecast.date_date::date = d.date
      where date >= '2018-01-01' and date < current_date


      ;;
  }
  dimension: date {type: date hidden:yes}
  dimension_group: date {
    label: "Created"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${date}) ;; }

  dimension: MTD_flg{
    group_label: "Created Date"
    label: "z - Is Before Today (mtd)"
    type: yesno
    sql: ${TABLE}.Created < current_date ;; }


  measure: dtc_amount {
    label: "DTC Amount"
    description: "Total DTC sales aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_units {
    label: "DTC Units"
    description: "Total DTC units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dtc_units;; }

  measure: wholesale_amount {
    label: "Wholesale Amount"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_units {
    label: "Wholesale Units"
    description: "Total wholesale units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wholesale_units;; }

  measure: total_amount {
    label: "Total Amount"
    description: "Total sales aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.dtc_amount + ${TABLE}.wholesale_amount;; }

  measure: total_units {
    label: "Total Units"
    description: "Total DTC units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dtc_units + ${TABLE}.wholesale_units;; }

  measure: forecast_total_amount {
    label: "Forecast Amount"
    description: "Total forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.forecast_total_amount;; }

  measure: forecast_total_units {
    label: "Forecast Units"
    description: "Total forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_total_units;; }

  measure: forecast_dtc_amount {
    label: "Forecast DTC Amount"
    description: "Total DTC forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.forecast_dtc_amount;; }

  measure: forecast_dtc_units {
    label: "Forecast DTC Units"
    description: "Total DTC forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_dtc_units;; }

  measure: forecast_wholesale_amount {
    label: "Forecast Wholesale Amount"
    description: "Total wholesale forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.forecast_wholesale_amount;; }

  measure: forecast_wholesale_units {
    label: "Forecast Wholesale Units"
    description: "Total wholesale forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_wholesale_units;; }
}
