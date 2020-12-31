######################################################
#   DTC Sales and Units
######################################################
view: day_aggregations_dtc_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      column: insidesales_sales {}
      column: customer_care_sales {}
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      #filters: { field: item.modified value: "Yes" }
      filters: { field: item.product_description value: "-PURPLE SQUISHY MAILER SAMPLE" }
      filters: { field: item.product_description value: "-SQUISHY 2.0" }
    }
  }
  #dimension: created_date { type: date }
  dimension_group: created_date { type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
  measure: insidesales_sales {type: sum}
  measure: customer_care_sales {type: sum}
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${created_date_date}, ${total_gross_Amt_non_rounded}, ${total_units}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}

######################################################
#   DTC Count of Unique Orders and Mattress Orders
######################################################
view: day_aggregation_dtc_orders {
  derived_table: {
    explore_source: sales_order_line {
      column: total_orders { field: sales_order.total_orders }
      column: created_date {}
      column: mattress_orders { field: order_flag.mattress_orders }
      filters: { field: sales_order.channel value: "DTC" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      #filters: { field: item.modified value: "Yes" }
      filters: { field: item.product_description value: "-SQUISHY 2.0,-PURPLE SQUISHY MAILER SAMPLE" }
    }
  }
  dimension: total_orders { type: number }
  dimension: created_date { type: date }
  dimension: mattress_orders { type: number }
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
      filters: { field: sales_order.channel value: "Wholesale"}
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      #filters: { field: item.modified value: "Yes" }
      #filters: { field: sales_order_line.created_date value: "2 years" }
    }
  }
  dimension: created_date { type: date }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${created_date}, ${total_gross_Amt_non_rounded}, ${total_units}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   Retail Sales and Units
######################################################
view: day_aggregations_retail_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      filters: { field: sales_order.channel value: "Owned Retail"}
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes, No" }
      #filters: { field: item.modified value: "Yes" }
      #filters: { field: sales_order_line.created_date value: "2 years" }
    }
  }
  }


######################################################
#   Forecast Amounts and Units
######################################################
view: day_aggregations_forecast {
  derived_table: {
    explore_source: forecast_combined {
      column: date_date {}
      column: total_amount {}
      column: dtc_amount {}
      column: wholesale_amount {}
      column: retail_amount {}
      column: total_units {}
      column: dtc_units {}
      column: wholesale_units {}
      column: retail_units {}
      #filters: { field: forecast_combined.date_date value: "2 years" }
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
      column: amount { field: adspend_target.amount }
    }
  }
  dimension: ad_date { type: date }
  #dimension: primary_key {
  #  primary_key: yes
  #  sql: CONCAT(${ad_date}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  #}
  measure: adspend { type: sum }
  measure: amount {type: sum}
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
      column: retail_target {}
      column: insidesales_target {}
    }
  }
  dimension: date_date { type: date }
  measure: dtc_target { type: sum }
  measure: whlsl_target { type: sum }
  measure: retail_target { type: sum }
  measure: insidesales_target { type: sum }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${date_date}, ${dtc_target}, ${whlsl_target}, ${retail_target}) ;;
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
      #filters: { field: item.modified value: "Yes" }
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
      #filters: { field: item.modified value: "Yes" }
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
      #filters: { field: item.modified value: "Yes" }
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
#   Site Sessions and Non-Bounced Sessions
######################################################

view: day_aggregations_sessions {
  derived_table: {
    explore_source: heap_page_views {
      column: event_time_date {}
      column: count {}
      column: Sum_non_bounced_session {}
    }
  }
  dimension: event_time_date {type: date}
  dimension: count {type: number}
  dimension: Sum_non_bounced_session {type: number}
}

# view: day_aggregations_sessions {
#   derived_table: {
#     explore_source: all_events {
#       column: time_date { field: sessions.time_date }
#       column: count { field: sessions.count }
#       column: Sum_non_bounced_session { field: heap_page_views.Sum_non_bounced_session }
#     }
#   }
#   dimension: time_date { type: date }
#   dimension: count { type: number }
#   dimension: Sum_non_bounced_session { type: number }
# }

######################################################
#   Production Goal
#   https://purple.looker.com/dashboards/3569
######################################################

view: day_agg_prod_goal {
  derived_table: {
    explore_source: production_goal {
      column: units_fg_produced { field: production_goal_by_item.units_fg_produced }
      column: forecast_date {}
      filters: { field: item.category_name value: "MATTRESS" }
      filters: { field: item.product_description_raw value: "-%SCRIM%" }
    }
  }
  dimension: units_fg_produced { type: number }
  dimension: forecast_date { type: date primary_key: yes}
}

#if(${assembly_build.produced_week}<date(2019,04,29),5800,
#  if(${assembly_build.produced_week}<date(2019,08,26),7800,
#      if(${assembly_build.produced_week}<date(2019,12,31),9800,${production_goal_by_item.units_fg_produced})))

######################################################
#   Production Goal
#   https://purple.looker.com/dashboards/3569
######################################################

view: day_agg_prod_mattress {
  derived_table: {
    explore_source: assembly_build {
      column: Total_Quantity {}
      column: produced_date {}
      filters: { field: assembly_build.scrap value: "0" }
      filters: { field: item.merchandise value: "" }
      filters: { field: item.category_name value: "MATTRESS" }
      filters: { field: item.product_description_raw value: "-%SCRIM%" }
    }
  }
  dimension: Total_Quantity { type: number }
  dimension: produced_date { type: date }
}


######################################################
#   CREATING FINAL TABLE
######################################################
view: day_aggregations {
  derived_table: {
    sql:
      select d.date
        , week.start_2020 as week_start_2020
        , dtc.total_gross_Amt_non_rounded as dtc_amount
        , dtc.total_units as dtc_units
        , dtc.insidesales_sales as is_sales
        , dtc.customer_care_sales as cc_sales
        , wholesale.total_gross_Amt_non_rounded as wholesale_amount
        , wholesale.total_units as wholesale_units
        , retail.total_gross_Amt_non_rounded as retail_amount
        , retail.total_units as retail_units
        , forecast.total_amount as forecast_total_amount
        , forecast.total_units as forecast_total_units
        , forecast.dtc_amount as forecast_dtc_amount
        , forecast.dtc_units as forecast_dtc_units
        , forecast.wholesale_amount as forecast_wholesale_amount
        , forecast.wholesale_units as forecast_wholesale_units
        , forecast.retail_amount as forecast_retail_amount
        , forecast.retail_units as forecast_retail_units
        , adspend.adspend
        , adspend.amount as adspend_adspend_target
        , targets.dtc_target as target_dtc_amount
        , targets.whlsl_target as target_wholesale_amount
        , targets.retail_target as target_retail_amount
        , targets.insidesales_target as target_insidesales_amount
        , dtc_returns.total_trial_returns_completed_dollars as dtc_trial_returns
        , dtc_returns.total_non_trial_returns_completed_dollars as dtc_nontrial_returns
        , dtc_cancels.amt_cancelled_and_refunded as dtc_refunds
        , adspend_target.amount as adspend_target
        , dtc_orders.total_orders as total_unique_orders
        , dtc_orders.mattress_orders as unique_mattress_orders
        , sessions.count as sessions_count
        , sessions.Sum_non_bounced_session as non_bounced_sessions
        , case when prod_goal.units_fg_produced is not null then prod_goal.units_fg_produced
          when prod_goal.forecast_date::date < '2019-04-29' then 5800
          when prod_goal.forecast_date::date < '2019-08-26' then 7800
          else 9800 end as production_target
        , prod_mat.Total_Quantity as production_mattresses
        , (nvl(dtc.total_gross_Amt_non_rounded,0) + nvl(retail.total_gross_Amt_non_rounded,0) + (nvl(wholesale.total_gross_Amt_non_rounded,0) * 0.50)) as roas_sales
      from analytics.util.warehouse_date d
      left join (
        select date_part('week',d.date) as week_num
            , min (case when year > 2018 then date end) start_2019
            , max (case when year < 2020 then date end) end_2019
            , min (case when year > 2019 then date end) start_2020
            , max (case when year > 2021 then date end) end_2020
        from analytics.util.warehouse_date d
        group by date_part('week',d.date)
      ) week on week.week_num = date_part('week',d.date)
      left join ${day_aggregations_dtc_sales.SQL_TABLE_NAME} dtc on dtc.created_date::date = d.date
      left join ${day_aggregations_wholesale_sales.SQL_TABLE_NAME} wholesale on wholesale.created_date::date = d.date
      left join ${day_aggregations_retail_sales.SQL_TABLE_NAME} retail on retail.created_date::date = d.date
      left join ${day_aggregations_forecast.SQL_TABLE_NAME} forecast on forecast.date_date::date = d.date
      left join ${day_aggregations_adspend.SQL_TABLE_NAME} adspend on adspend.ad_date::date = d.date
      left join ${day_aggregations_targets.SQL_TABLE_NAME} targets on targets.date_date::date = d.date
      left join ${day_aggregations_dtc_returns.SQL_TABLE_NAME} dtc_returns on dtc_returns.return_completed_date::date = d.date
      left join ${day_aggregations_dtc_cancels.SQL_TABLE_NAME} dtc_cancels on dtc_cancels.cancelled_date::date = d.date
      left join ${day_aggregations_adspend_target.SQL_TABLE_NAME} adspend_target on adspend_target.date_date::date = d.date
      left join ${day_aggregation_dtc_orders.SQL_TABLE_NAME} dtc_orders on dtc_orders.created_date::date = d.date
      left join ${day_aggregations_sessions.SQL_TABLE_NAME} sessions on sessions.event_time_date::date = d.date
      left join ${day_agg_prod_goal.SQL_TABLE_NAME} prod_goal on prod_goal.forecast_date::date = d.date
      left join ${day_agg_prod_mattress.SQL_TABLE_NAME} prod_mat on prod_mat.produced_date::date = d.date
      where date::date >= '2017-01-01' and date::date < '2022-01-01' ;;

    datagroup_trigger: pdt_refresh_6am
  }
  dimension: date {type: date hidden:yes}
  dimension_group: date {
    label: "Created"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, month_num, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${date}) ;; }

  dimension: Before_today{
    group_label: "Created Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: case when ${TABLE}.date < current_date then TRUE else null end;; }

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
    sql: date_trunc(week, ${TABLE}.date::date) < date_trunc(week, current_date) ;;}

  dimension: 6_weeks{
    group_label: "Created Date"
    label: "z - Before 6 Weeks Later"
    type: yesno
    sql: date_part('week',${TABLE}.date) < (date_part('week',current_date)+6);; }

  dimension: prev_week{
    group_label: "Created Date"
    label: "z - Previous Week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: cur_week{
    group_label: "Created Date"
    label: "z - Current Week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.date) = date_trunc(week, current_date) ;;}

  dimension: week_2019_start {
    group_label: "Created Date"
    label: "z - Week Start 2020"
    description: "Looking at the week of year for grouping (including all time) but only showing 2019 week start date."
    type: string
    sql: to_char( ${TABLE}.week_start_2020,'MON-DD');; }

  dimension: week_bucket{
    group_label: "Created Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -2, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension_group: current {
    label: "Current"
    description:  "Current Time/Date for calculations"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

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

  measure: dtc_amount_before_today{
    label: "DTC Amount Before T"
    hidden: yes
    description: "Total DTC sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_amount_before_today_null{
    label: "DTC Amount Before Today"
    description: "Total DTC sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${dtc_amount_before_today},0);; }

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

  measure: wholesale_amount_before_today{
    label: "Wholesale Amount Before T"
    hidden: yes
    description: "Total Wholesale sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_amount_before_today_null{
    label: "Wholesale Amount Before Today"
    description: "Total Wholesale sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${wholesale_amount_before_today},0);; }

  measure: wholesale_units {
    label: "Wholesale Units"
    description: "Total wholesale units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wholesale_units;; }

  measure: retail_amount {
    label: "Retail Amount"
    description: "Total Retail sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.retail_amount;; }

  measure: retail_amount_before_today{
    label: "Retail Amount Before T"
    hidden: yes
    description: "Total Retail sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.retail_amount;; }

  measure: retail_amount_before_today_null{
    label: "Retail Amount Before Today"
    description: "Total Retail sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${retail_amount_before_today},0);; }

  measure: retail_units {
    label: "Retail Units"
    description: "Total Retail units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.retail_units;; }

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

  measure: forecast_retail_amount {
    label: "Forecast Retail Amount"
    description: "Total Retail forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_retail_amount;; }

  measure: forecast_retail_units {
    label: "Forecast Retail Units"
    description: "Total Retail forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_retail_units;; }

  measure: adspend {
    label: "Adspend"
    description: "Total adspend aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.adspend;; }

  measure: adspend_k {
    label: "Adspend ($K)"
    description: "Total adspend aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.adspend;; }

  measure: target_dtc_amount {
    label: "Plan DTC Amount"
    description: "Plan DTC target from finance team, amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_dtc_amount;; }

  measure: target_retail_amount {
    label: "Plan Retail Amount"
    description: "Total Retail plan from finance team, amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_retail_amount;; }

  measure: target_wholesale_amount {
    label: "Plan Wholesale Amount"
    description: "Plan wholesale target from finance amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_wholesale_amount;; }


  measure: target_insidesales_amount {
    label: "Plan Insidesales Amount"
    description: "Ramping percentage of DTC plan.  Going from 5% to 15% by Dec 2020."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_insidesales_amount;; }

  measure: total_target_amount {
    label: "Total Plan Amount"
    description: "Total plan from finance team amount aggregated to the day. Retail, DTC, & Wholesale"
    type: number
    value_format: "$#,##0,\" K\""
    sql: ${target_retail_amount}+${target_dtc_amount}+${target_wholesale_amount};; }

  measure: total_gross_sales {
    label: "Total Gross Sales"
    description: "Total Gross Sales. Retail, DTC, & Wholesale"
    type: number
    value_format: "$#,##0,\" K\""
    sql: ${retail_amount_before_today}+${dtc_amount_before_today}+${wholesale_amount_before_today};; }

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
    label: "Goal Adspend"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.adspend_adspend_target;; }

  measure: total_unique_orders {
    label: "DTC Orders"
    description: "Count of Distinct Order for DTC"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.total_unique_orders ;; }

 measure: unique_mattress_orders {
   label: "DTC Mattress Orders"
  description: "Total Unique DTC Mattress Orders"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.unique_mattress_orders ;; }

 measure: sessions_count {
   label: "Sessions"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.sessions_count ;; }

 measure: non_bounced_sessions {
   label: "Sessions -  Non-Bounced"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.non_bounced_sessions ;; }

  measure: cvr {
    label: "CVR - All Sessions"
    description: "% of all Sessions that resulted in an order. (Total DTC Orders / Sessions) Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.total_unique_orders})/NULLIF(${day_aggregations.sessions_count},0) ;; }

  measure: q_cvr {
    label: "CVR - Qualified Sessions"
    description: "% of all Non-bounced Sessions that resulted in an order. (Total DTC Orders / Non-bounced Sessions) Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.total_unique_orders})/NULLIF(${day_aggregations.non_bounced_sessions},0) ;; }

  measure: production_target {
    label: "Goal Mattress Production"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.production_target ;; }

  measure: production_mattresses {
    label: "Mattress Production"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.production_mattresses ;; }

  measure: roas_sales {
    label: "ROAs - Total Sales"
    description: "100% of DTC Sales, 100% of Owned Retail, 50% of Wholesales Sales"
    #type: number
    type:  sum
    value_format: "$#,##0"
    #sql:  ${dtc_amount}+${retail_amount}+(${wholesale_amount}*.5);;
    sql: ${TABLE}.roas_sales;;
    }

  measure: roas_sales_calc {
    label: "ROAs - Total Sales (test)"
    description: "Calculations done in lookML not sql"
    type: number
    value_format: "$#,##0"
    sql:  nvl(${dtc_amount},0)+nvl(${retail_amount},0)+(nvl(${wholesale_amount},0)*.5);;
  }

  measure: roas {
    label: "ROAs - Full"
    description: "Retun on Adspend (total roas salse/adspend)"
    type: number
    value_format: "$#,##0.00"
    sql: ${roas_sales}/NULLIF(${adspend},0) ;;
    }

  measure: dtc_roas {
    label: "ROAs - DTC"
    description: "Retun on Adspend (total roas salse/adspend)"
    type: number
    value_format: "$#,##0.00"
    sql: ${dtc_amount}/NULLIF(${adspend},0) ;;
  }

  measure: target_roas_sales {
    label: "Plan ROAs Sales"
    description: "DTC Plan + Retail Plan + 50% of Wholesale Plan"
    type: number
    value_format: "$#,##0.00"
    sql: nvl(${target_dtc_amount},0)+nvl(${target_retail_amount},0)+(nvl(${target_wholesale_amount},0)*0.50) ;;
  }

  measure: target_roas {
    label: "Plan ROAs"
    description: "Plan Target + Plan Target + 50% of Wholesale Plan /Adspend Goal"
    type: number
    value_format: "$#,##0.00"
    sql: ${target_roas_sales}/NULLIF(${adspend_target},0) ;;
  }

  measure: is_sales {
    label: "Sales - Inside Sales ($)"
    description: "Gross Sales from Inside Sales Team (Does not include customer care)"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.is_sales ;;
  }

  measure: cc_sales {
    label: "Sales - Customer Care ($)"
    description: "Gross Sales from Customer Care Team"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.cc_sales ;;
  }

  parameter: see_data_by {
    description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
    hidden: yes
    type: unquoted
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
  }

  dimension: see_data {
    label: "See Data By"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${date_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${date_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${date_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${date_quarter}
    {% elsif see_data_by._parameter_value == 'year' %}
      ${date_year}
    {% else %}
      ${date_date}
    {% endif %};;
  }

}
