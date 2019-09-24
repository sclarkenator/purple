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
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${created_date_date}, ${total_gross_Amt_non_rounded}, ${total_units}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
######################################################
#   Wholesale Sales and Units
######################################################
view: day_aggregations_wholesale_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: fulfilled_date {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      filters: { field: sales_order.channel value: "Wholesale"}
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: sales_order_line.fulfilled_date value: "2 years" }
    }
  }
  dimension: fulfilled_date { type: date }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${fulfilled_date}, ${total_gross_Amt_non_rounded}, ${total_units}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
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
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${date_date}, ${total_amount}, ${dtc_amount}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   Adspend
######################################################
view: day_aggregations_adspend {
  derived_table: {
    explore_source: daily_adspend {
      column: ad_date {}
      column: adspend {}
    }
  }
  dimension: ad_date { type: date }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${ad_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
  measure: adspend { type: sum }
}


######################################################
#   Daily Curve Target
######################################################
view: day_aggregations_targets {
  derived_table: {
    explore_source: sales_targets {
      column: date_date {}
      column: dtc_target {}
      column: whlsl_target {}
    }
  }
  dimension: date_date { type: date }
  measure: dtc_target { type: sum }
  measure: whlsl_target { type: sum }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${date_date}, ${dtc_target}, ${whlsl_target}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   DTC Returns
######################################################

view: day_aggregations_dtc_returns {
  derived_table: {
    explore_source: sales_order_line {
      column: total_trial_returns_completed_dollars { field: return_order_line.total_trial_returns_completed_dollars }
      column: total_non_trial_returns_completed_dollars { field: return_order_line.total_non_trial_returns_completed_dollars }
      column: return_completed_date { field: return_order.return_completed_date }
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: return_order.return_completed_date value: "2 years" }
    }
  }
  dimension: total_trial_returns_completed_dollars { type: number }
  dimension: total_non_trial_returns_completed_dollars { type: number }
  dimension: return_completed_date { type: date }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${total_non_trial_returns_completed_dollars},${total_non_trial_returns_completed_dollars},${return_completed_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   Wholesale Returns
######################################################

view: day_aggregations_wholesale_returns {
  derived_table: {
    explore_source: sales_order_line_dtc {
      column: total_trial_returns_completed_dollars { field: return_order_line.total_trial_returns_completed_dollars }
      column: total_non_trial_returns_completed_dollars { field: return_order_line.total_non_trial_returns_completed_dollars }
      column: return_completed_date { field: return_order.return_completed_date }
      filters: { field: sales_order.channel value: "Wholesale" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: return_order.return_completed_date value: "2 years" }
    }
  }
  dimension: total_trial_returns_completed_dollars { type: number }
  dimension: total_non_trial_returns_completed_dollars { type: number }
  dimension: return_completed_date { type: date }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${total_trial_returns_completed_dollars},${total_non_trial_returns_completed_dollars},${return_completed_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   DTC Cancellations
######################################################

view: day_aggregations_dtc_cancels {
  derived_table: {
    explore_source: sales_order_line {
      column: amt_cancelled_and_refunded { field: cancelled_order.amt_cancelled_and_refunded }
      column: cancelled_date { field: cancelled_order.cancelled_date }
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: cancelled_order.cancelled_date value: "2 years" }
    }
  }
  dimension: amt_cancelled_and_refunded { type: number }
  dimension: cancelled_date { type: date }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${amt_cancelled_and_refunded},${cancelled_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   Adspend Target
######################################################
view: day_aggregations_adspend_target {
  derived_table: {
    explore_source: target_adspend {
      column: date_date {}
      column: amount {}
    }
  }
  dimension: date_date { type: date }
  dimension: amount { type: number }
}

######################################################
#   CREATING FINAL TABLE
######################################################
view: day_aggregations {
  derived_table: {
    sql:
      select d.date
        , week.start_2019 as week_start_2019
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
        , adspend.adspend
        , targets.dtc_target as target_dtc_amount
        , targets.whlsl_target as target_wholesale_amount
        , dtc_returns.total_trial_returns_completed_dollars as dtc_trial_returns
        , dtc_returns.total_non_trial_returns_completed_dollars as dtc_nontrial_returns
        , dtc_cancels.amt_cancelled_and_refunded as dtc_refunds
        , adspend_target.amount as adspend_target
      from analytics.util.warehouse_date d
      left join (
        select date_part('week',d.date) as week_num
            , min (case when year > 2018 then date end) start_2019
            , max (case when year < 2020 then date end) end_2019
            , min (case when year > 2017 then date end) start_2018
            , max (case when year < 2019 then date end) end_2018
            , min (case when year > 2016 then date end) start_2017
            , max (case when year < 2018 then date end) end_2017
        from analytics.util.warehouse_date d
        group by date_part('week',d.date)
      ) week on week.week_num = date_part('week',d.date)
      left join ${day_aggregations_dtc_sales.SQL_TABLE_NAME} dtc on dtc.created_date::date = d.date
      left join ${day_aggregations_wholesale_sales.SQL_TABLE_NAME} wholesale on wholesale.fulfilled_date::date = d.date
      left join ${day_aggregations_forecast.SQL_TABLE_NAME} forecast on forecast.date_date::date = d.date
      left join ${day_aggregations_adspend.SQL_TABLE_NAME} adspend on adspend.ad_date::date = d.date
      left join ${day_aggregations_targets.SQL_TABLE_NAME} targets on targets.date_date::date = d.date
      left join ${day_aggregations_dtc_returns.SQL_TABLE_NAME} dtc_returns on dtc_returns.return_completed_date::date = d.date
      left join ${day_aggregations_dtc_cancels.SQL_TABLE_NAME} dtc_cancels on dtc_cancels.cancelled_date::date = d.date
      left join ${day_aggregations_adspend_target.SQL_TABLE_NAME} adspend_target on adspend_target.date_date::date = d.date
      where date::date >= '2017-01-01' and date::date < '2021-01-01' ;;
  }
  dimension: date {type: date hidden:yes}
  dimension_group: date {
    label: "Created"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${date}) ;; }

  dimension: Before_today{
    group_label: "Created Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.date < current_date;; }

  dimension: start_date {
    group_label: "Created Date"
    label: "z - Start Date"
    description: "This field will show the start date of an interval that is normally a bucket (week 1, august)"
    type: date
    sql: min(${TABLE}.date)::date ;; }

  dimension: last_30{
    group_label: "Created Date"
    label: "z - Last 30 Days"
    type: yesno
    sql: ${TABLE}.date > dateadd(day,-30,current_date);; }

  dimension: current_week_num{
    group_label: "Created Date"
    label: "z - Before Current Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) < date_part('week',current_date) and ${TABLE}.date::date <= current_date::date;; }

  dimension: 6_weeks{
    group_label: "Created Date"
    label: "z - Before 6 Weeks Later"
    type: yesno
    sql: date_part('week',${TABLE}.date) < (date_part('week',current_date)+6);; }

  dimension: prev_week{
    group_label: "Created Date"
    label: "z - Previous Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) = date_part('week',current_date)-1;; }

  dimension: cur_week{
    group_label: "Created Date"
    label: "z - Current Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) = date_part('week',current_date);; }

  dimension: week_2019_start {
    group_label: "Created Date"
    label: "z - Week Start 2019"
    description: "Looking at the week of year for grouping (including all time) but only showing 2019 week start date."
    type: string
    sql: to_char( ${TABLE}.week_start_2019,'MON-DD');; }

  dimension: week_bucket{
    group_label: "Created Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql: case when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) then 'Current Week'
        when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -1 then 'Last Week'
        when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
        when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) then 'Current Week LY'
        when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -1 then 'Last Week LY'
        when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
        else 'Other' end;; }

  measure: dtc_amount {
    label: "DTC Amount"
    description: "Total DTC sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_amount_k {
    label: "DTC Amount ($.k)"
    description: "Total DTC sales aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
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
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_amount_k {
    label: "Wholesale Amount ($.k)"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_units {
    label: "Wholesale Units"
    description: "Total wholesale units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wholesale_units;; }

  measure: forecast_total_amount {
    label: "Forecast Amount"
    description: "Total forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
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
    value_format: "$#,##0,\" K\""
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
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_wholesale_amount;; }

  measure: forecast_wholesale_units {
    label: "Forecast Wholesale Units"
    description: "Total wholesale forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_wholesale_units;; }

  measure: adspend {
    label: "Total Adspend"
    description: "Total adspend aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.adspend;; }

  measure: target_dtc_amount {
    label: "Target DTC Amount"
    description: "Total DTC target from Daily Curve amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_dtc_amount;; }

  measure: target_wholesale_amount {
    label: "Target Wholesale Amount"
    description: "Total wholesale target from Daily Curve amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_wholesale_amount;; }

  measure: dtc_nontrial_returns {
    label: "DTC Non-Trial Returns"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_nontrial_returns;; }

  measure: dtc_trial_returns {
    label: "DTC Trial Returns"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_trial_returns;; }

  measure: dtc_refunds {
    label: "DTC Refunds"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_refunds;; }

  measure: adspend_target {
    label: "Adspend Target"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.adspend_target;; }

}
