include: "/views/_period_comparison.view.lkml"
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
      column: customer_care_orders {}
      column: insidesales_orders {}
      column: new_customer { field: first_order_flag.new_customer }
      filters: { field: sales_order.channel value: "DTC" }
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
      #filters: { field: item.modified value: "Yes" }
      filters: { field: item.product_description value: "-3X3 SAMPLE-MAILER" }
      filters: { field: item.product_description value: "-PURPLE SQUISHIES-10 PK" }
      filters: { field: item.product_description value: "-SQUISHY MINI-BED" }
      filters: { field: item.product_description value: "-PURPLE SQUISHIES-50 PK" }
      filters: { field: item.product_description value: "-PURPLE SQUISHIES-25 PACK" }
      filters: { field: item.product_description value: "-PURPLE SQUISHIES-2 PK" }
      filters: { field: item.product_description value: "-MINI BED SQUISHY SAMPLE" }
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
  measure: insidesales_orders {type: sum}
  measure: customer_care_orders {type: sum}
  measure: new_customer {type: sum}
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
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
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
      column: mattress_units {}

      filters: { field: sales_order.channel value: "Wholesale"}
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
      #filters: { field: item.modified value: "Yes" }
      #filters: { field: sales_order_line.created_date value: "2 years" }
    }
  }

  dimension: created_date { type: date }
  measure: total_gross_Amt_non_rounded { type: sum}
  measure: total_units {type: sum}
  measure: mattress_units {type: sum}

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${created_date}, ${total_gross_Amt_non_rounded}, ${total_units}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }
}

######################################################
#   Wholesale Fulfilled
######################################################

view: day_aggregations_wholesale_fulfilled {
  derived_table: {
    explore_source: sales_order_line {
      column: fulfilled_orders {}
      column: fulfilled_orders_units {}
      column: fulfilled_date {}
      filters: {field: sales_order.channel value: "Wholesale"}
      filters: {field: sales_order.is_exchange_upgrade_warranty value: ""}
      filters: {field: sales_order_line.fulfilled_date value: "NOT NULL"}
    }
  }
  dimension: fulfilled_orders {type: number }
  dimension: fulfilled_orders_units {type: number }
  dimension: fulfilled_date {type: date}
}

######################################################
#   Canada Sales and Units
######################################################
# If necessary, uncomment the line below to include explore_source.
# include: "sales.explore.lkml"

view: day_aggregations_scc {
  derived_table: {
    explore_source: scc {
      column: created_date {}
      column: net_sales {}
    }
  }
  dimension: created_date {}
  dimension: net_sales {}
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
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes, No" }
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
      column: impressions {}
      column: clicks {}
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
  measure: impressions { type: sum }
  measure: clicks { type: sum }
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
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
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
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
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
      #filters: { field: item.merchandise value: "No" }
      #filters: { field: item.finished_good_flg value: "Yes" }
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
#   wholesale roa calculated amount
######################################################
view: whlsl_roa {
  derived_table: {
    explore_source: v_new_roa {
      column: roa_date {}
      column: roa_amt {}
    }
  }
  dimension: roa_date { type: date }
  measure: roa_amt { type: sum }
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
#   IS Deals
#   https://purple.looker.com/dashboards/4132
######################################################
view: day_agg_is_deals {
  derived_table: {
    explore_source: cc_deals {
      column: created_date {}
      column: count {}
      column: total_orders { field: sales_order.total_orders }
      filters: { field: cc_deals.created_date value: "2 years" }
    }
  }
  dimension: created_date { type: date }
  dimension: count { type: number }
  dimension: total_orders { type: number}
}

######################################################
#   IS Activities
#   https://purple.looker.com/dashboards/4132
######################################################
view: day_agg_is_activities {
  derived_table: {
    explore_source: cc_activities {
      column: activity_date {}
      column: count {}
      column: calls {}
      column: chats {}
      column: emails {}
      filters: { field: cc_activities.activity_date value: "2 years" }
      filters: { field: cc_activities.team value: "sales" }
      filters: { field: cc_activities.missed value: "No" }
    }
  }
  dimension: activity_date { type: date }
  dimension: count {type: number }
  dimension: calls { type: number }
  dimension: chats { type: number }
  dimension: emails { type: number }
}

######################################################
#   Retail Traffic Aura Visison
#   https://purple.looker.com/dashboards/4132
######################################################
view: day_agg_retail_auravision{
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: Store_Entries { field: aura_vision_traffic.Store_Entries }
      column: total_orders { field: sales_order.total_orders }
      filters: {field: sales_order.channel value: "Owned Retail"}
      filters: {field: sales_order.is_exchange_upgrade_warranty value: "No"}
      filters: {field: retail_order_flag.is_draft value: "No"}
      filters: {field: retail_order_flag.is_chat value: "No"}
      filters: {field: sales_order_line.created_date value: "2021/02/10 to yesterday" }
    }
  }
  dimension: created_date {type: date}
  dimension: Store_Entries {type: number}
  dimension: total_orders {type: number}
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
        , dtc.customer_care_orders as cc_orders
        , dtc.insidesales_orders as is_orders
        , dtc.new_customer as new_customers
        , wholesale.total_gross_Amt_non_rounded as wholesale_amount
        , wholesale.total_units as wholesale_units
        , wholesale.mattress_units as wholesale_mattress_units
        , wholesale_fulfilled.fulfilled_orders as wholesale_fulfilled_amount
        , wholesale_fulfilled.fulfilled_orders_units as wholesale_fulfilled_units
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
        , adspend.impressions
        , adspend.clicks
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
--        , (nvl(dtc.total_gross_Amt_non_rounded,0) + nvl(retail.total_gross_Amt_non_rounded,0) + (nvl(wholesale.total_gross_Amt_non_rounded,0) * 0.50)) as roas_sales
        , (nvl(dtc.total_gross_Amt_non_rounded,0) + nvl(retail.total_gross_Amt_non_rounded,0) + nvl(whlsl_roa.roa_amt,0)) as roas_sales
        , nvl(whlsl_roa.roa_amt,0) whlsl_calc
        , is_deals.count as is_deals
        , is_deals.total_orders as is_cohort_orders
        , is_activities.count as is_activities
        , is_activities.calls as is_calls
        , is_activities.chats as is_chats
        , is_activities.emails as is_emails
        , retail_traffic.created_date as retail_traffic_date
        , retail_traffic.store_entries as retail_traffic_showroom_entries
        , retail_traffic.total_orders as retail_traffic_showroom_orders
        , scc.net_sales as scc_sales
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
      left join ${day_agg_is_deals.SQL_TABLE_NAME} is_deals on is_deals.created_date::date = d.date
      left join ${day_agg_is_activities.SQL_TABLE_NAME} is_activities on is_activities.activity_date::date = d.date
      left join ${day_agg_retail_auravision.SQL_TABLE_NAME} retail_traffic on retail_traffic.created_date::date = d.date
      left join ${day_aggregations_scc.SQL_TABLE_NAME} scc on scc.created_date::date = d.date
      left join ${day_aggregations_wholesale_fulfilled.SQL_TABLE_NAME} wholesale_fulfilled on wholesale_fulfilled.fulfilled_date::date = d.date
      left join ${whlsl_roa.SQL_TABLE_NAME} whlsl_roa on whlsl_roa.roa_date::date = d.date
      where date::date >= '2017-01-01' and date::date < '2023-01-01' ;;

    datagroup_trigger: pdt_refresh_6am
    publish_as_db_view: yes
  }
  extends: [_period_comparison]

  #dimension: date {type: date hidden:yes}

  ### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [raw,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${TABLE}.date);;
 }

  dimension_group: date {
  ##Scott Clark, 1/8/21: Deleted week of year.
    label: "Created"
    type: time
    timeframes: [hour_of_day, date, day_of_week, day_of_week_index, day_of_month, month_num, day_of_year, week, month, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${TABLE}.date) ;; }

  # dimension: date_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "Week of Year"
  #   group_label: "Created Date"
  #   description: "2021 adjusted week of year number"
  #   sql: case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 1
  #             when ${date_year::number}=2021 then date_part(weekofyear,${date_date::date}) + 1
  #             else date_part(weekofyear,${date_date::date}) end ;;
  # }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "Created Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 2021 else ${date_year} end   ;;
  }


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

  dimension: week_bucket_old{
    group_label: "Created Date"
    label: "z - Week Bucket"
    hidden:  yes
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -2, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: week_bucket{
    group_label: "Created Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) THEN 'Current Week'
             WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) THEN 'Last Week'
             WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -2 AND ${date_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
             WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
             WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
             WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -2 AND ${date_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END;;
    # sql:  CASE WHEN ${date_week_of_year} = 2  AND ${date_year} = 2022 THEN 'Current Week'
    #           WHEN ${date_week_of_year} = 1  AND ${date_year} = 2022 THEN 'Last Week'
    #           WHEN ${date_date} >= '2021-12-27' AND ${date_date} <= '2022-01-02' THEN 'Two Weeks Ago'
    #           WHEN ${date_week_of_year} = 2  AND ${date_year} = 2021 THEN 'Current Week LY'
    #           WHEN ${date_week_of_year} = 1 AND ${date_year} = 2021 THEN 'Last Week LY'
    #           WHEN ${date_week_of_year} = 52 AND ${date_year} = 2020 THEN 'Two Weeks Ago LY'
    #           ELSE 'Other' END;;
  }

  dimension_group: current {
    label: "Current"
    description:  "Current Time/Date for calculations"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    hidden: yes
    datatype: timestamp
    sql: current_date ;;
  }

  measure: dtc_amount {
    label: "DTC Amount"
    group_label: "Sales - DTC"
    description: "Total DTC sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_amount_k {
    label: "DTC Amount ($.k)"
    group_label: "Sales - DTC"
    description: "Total DTC sales aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_amount_before_today{
    label: "DTC Amount Before T"
    group_label: "Sales - DTC"
    hidden: yes
    description: "Total DTC sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.dtc_amount;; }

  measure: dtc_amount_before_today_null{
    label: "DTC Amount Before Today"
    group_label: "Sales - DTC"
    description: "Total DTC sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${dtc_amount_before_today},0);; }

  measure: dtc_units {
    label: "DTC Units"
    group_label: "Sales - DTC"
    description: "Total DTC units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dtc_units;; }



  #dimension: new_customer {

  measure: new_customers {
    label: "New Customers"
    group_label: "Sales - DTC"
    description: "Total new customers (by email) aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.new_customers;; }

  measure: wholesale_amount {
    label: "Wholesale Amount"
    group_label: "Sales - Wholesale"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_fulfilled_amount {
    label: "Wholesale Fulfilled Amount"
    group_label: "Sales - Wholesale"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_fulfilled_amount;; }

  measure: wholesale_fulfilled_units {
    label: "Wholesale Fulfilled Units"
    group_label: "Sales - Wholesale"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_fulfilled_units;; }

  measure: scc_net_sales {
    label: "Sleep Country Canada Sales"
    group_label: "Sales - Wholesale"
    description: "Total SCC sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.scc_net_sales;; }

  measure: wholesale_amount_k {
    label: "Wholesale Amount ($.k)"
    group_label: "Sales - Wholesale"
    description: "Total wholesale sales aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_amount_before_today{
    label: "Wholesale Amount Before T"
    group_label: "Sales - Wholesale"
    hidden: yes
    description: "Total Wholesale sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.wholesale_amount;; }

  measure: wholesale_amount_before_today_null{
    label: "Wholesale Amount Before Today"
    group_label: "Sales - Wholesale"
    description: "Total Wholesale sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${wholesale_amount_before_today},0);; }

  measure: wholesale_units {
    label: "Wholesale Units"
    group_label: "Sales - Wholesale"
    description: "Total wholesale units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wholesale_units;; }

  measure: wholesale_mattress_units {
    label: "Wholesale Mattress Units"
    group_label: "Sales - Wholesale"
    description: "Total wholesale units aggregated to the day (written orders)."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wholesale_mattress_units;; }

  measure: retail_amount {
    label: "Retail Amount"
    group_label: "Sales - Retail"
    description: "Total Retail sales aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.retail_amount;; }

  measure: retail_amount_before_today{
    label: "Retail Amount Before T"
    group_label: "Sales - Retail"
    hidden: yes
    description: "Total Retail sales aggregated to the day."
    type: sum
    filters: [date_date: "before today"]
    value_format: "$#,##0"
    sql: ${TABLE}.retail_amount;; }

  measure: retail_amount_before_today_null{
    label: "Retail Amount Before Today"
    group_label: "Sales - Retail"
    description: "Total Retail sales aggregated to the day."
    type: number
    value_format: "$#,##0"
    sql: NULLIF(${retail_amount_before_today},0);; }

  measure: retail_units {
    label: "Retail Units"
    group_label: "Sales - Retail"
    description: "Total Retail units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.retail_units;; }

  measure: forecast_total_amount {
    label: "Forecast Amount"
    group_label: "Forecast"
    description: "Total forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_total_amount;; }

  measure: forecast_total_units {
    label: "Forecast Units"
    group_label: "Forecast"
    description: "Total forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_total_units;; }

  measure: forecast_dtc_amount {
    label: "Forecast DTC Amount"
    group_label: "Forecast"
    description: "Total DTC forecast amount aggregated to the day. Excludes Amazon/Ebay"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_dtc_amount;; }

  measure: forecast_dtc_units {
    label: "Forecast DTC Units"
    group_label: "Forecast"
    description: "Total DTC forecast units aggregated to the day. Excludes Amazon/Ebay"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_dtc_units;; }

  measure: forecast_wholesale_amount {
    label: "Forecast Wholesale Amount"
    group_label: "Forecast"
    description: "Total wholesale forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_wholesale_amount;; }

  measure: forecast_wholesale_units {
    label: "Forecast Wholesale Units"
    group_label: "Forecast"
    description: "Total wholesale forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_wholesale_units;; }

  measure: forecast_retail_amount {
    label: "Forecast Retail Amount"
    group_label: "Forecast"
    description: "Total Retail forecast amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.forecast_retail_amount;; }

  measure: forecast_retail_units {
    label: "Forecast Retail Units"
    group_label: "Forecast"
    description: "Total Retail forecast units aggregated to the day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_retail_units;; }

  measure: adspend {
    label: "Adspend"
    group_label: "Adspend"
    description: "Total adspend aggregated to the day."
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.adspend;; }

  measure: impressions {
    label: "Impressions"
    group_label: "Adspend"
    description: "Impressions"
    type: sum
    sql: ${TABLE}.impressions;; }

  measure: clicks {
    label: "Clicks"
    group_label: "Adspend"
    description: "Clicks"
    type: sum
    sql: ${TABLE}.clicks;; }

  measure: adspend_k {
    label: "Adspend ($K)"
    group_label: "Adspend"
    description: "Total adspend aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.adspend;; }

  measure: target_dtc_amount {
    label: "Plan DTC Amount"
    group_label: "Plan"
    description: "Plan DTC target from finance team, amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_dtc_amount;; }

  measure: target_retail_amount {
    label: "Plan Retail Amount"
    group_label: "Plan"
    description: "Total Retail plan from finance team, amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_retail_amount;; }

  measure: target_wholesale_amount {
    label: "Plan Wholesale Amount"
    group_label: "Plan"
    description: "Plan wholesale target from finance amount aggregated to the day."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_wholesale_amount;; }


  measure: target_insidesales_amount {
    label: "Plan Insidesales Amount"
    group_label: "Plan"
    description: "Ramping percentage of DTC plan.  Going from 5% to 15% by Dec 2020."
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.target_insidesales_amount;; }

  measure: total_target_amount {
    label: "Total Plan Amount"
    group_label: "Plan"
    description: "Total plan from finance team amount aggregated to the day. Retail, DTC, & Wholesale"
    type: number
    value_format: "$#,##0,\" K\""
    sql: ${target_retail_amount}+${target_dtc_amount}+${target_wholesale_amount};; }

  measure: total_gross_sales {
    label: " Total Gross Sales"
    description: "Total Gross Sales. Retail, DTC, & Wholesale"
    type: number
    value_format: "$#,##0,\" K\""
    sql: ${retail_amount_before_today}+${dtc_amount_before_today}+${wholesale_amount_before_today};; }

  measure: dtc_nontrial_returns {
    label: "DTC Non-Trial Returns"
    group_label: "Sales - DTC"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_nontrial_returns;; }

  measure: dtc_trial_returns {
    label: "DTC Trial Returns"
    group_label: "Sales - DTC"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_trial_returns;; }

  measure: dtc_refunds {
    label: "DTC Refunds"
    group_label: "Sales - DTC"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.dtc_refunds;; }

  measure: adspend_target {
    label: "Goal Adspend"
    group_label: "Adspend"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.adspend_adspend_target;; }

  measure: cpm {
    label: "CPM"
    group_label: "Adspend"
    description: "Adspend / Total impressions/1000"
    type: number
    value_format: "$#,##0.00"
    sql: ${adspend}/NULLIF((${impressions}/1000),0) ;;  }

  measure: cpc {
    label: "CPC"
    group_label: "Adspend"
    description: "Adspend / Total Clicks"
    type: number
    value_format: "$#,##0.00"
    sql: ${adspend}/NULLIF(${clicks},0) ;;  }

  measure: ctr {
    label: "CTR"
    group_label: "Adspend"
    description: " (Total Clicks / Total Impressions) *100"
    type: number
    value_format: "00.00%"
    sql: (${clicks}/NULLIF(${impressions},0));;  }

  measure: total_unique_orders {
    label: "DTC Orders"
    group_label: "Sales - DTC"
    description: "Count of Distinct Order for DTC"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.total_unique_orders ;; }

 measure: unique_mattress_orders {
   label: "DTC Mattress Orders"
   group_label: "Sales - DTC"
   description: "Total Unique DTC Mattress Orders"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.unique_mattress_orders ;; }

 measure: sessions_count {
   label: "Sessions"
   group_label: "Site Traffic"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.sessions_count ;; }

 measure: non_bounced_sessions {
   label: "Sessions -  Non-Bounced"
   group_label: "Site Traffic"
   type: sum
   value_format: "#,##0"
   sql: ${TABLE}.non_bounced_sessions ;; }

  measure: cvr {
    label: "CVR - All Sessions"
    group_label: "Site Traffic"
    description: "% of all Sessions that resulted in an order. (Total DTC Orders / Sessions) Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.total_unique_orders})/NULLIF(${day_aggregations.sessions_count},0) ;; }

  measure: q_cvr {
    label: "CVR - Qualified Sessions"
    group_label: "Site Traffic"
    description: "% of all Non-bounced Sessions that resulted in an order. (Total DTC Orders / Non-bounced Sessions) Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.total_unique_orders})/NULLIF(${day_aggregations.non_bounced_sessions},0) ;; }

  measure: production_target {
    label: "Goal Mattress Production"
    group_label: "Production"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.production_target ;; }

  measure: production_mattresses {
    label: "Mattress Production"
    group_label: "Production"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.production_mattresses ;; }

  measure: roas_sales {
    label: "ROAs - Total Sales"
    group_label: "Adspend"
    description: "100% of DTC Sales, 100% of Owned Retail, 50% of Wholesales Sales lagged 2 weeks from fulfilled date and smoothed acrossed the week. "
    #type: number
    type:  sum
    value_format: "$#,##0"
    #sql:  ${dtc_amount}+${retail_amount}+(${wholesale_amount}*.5);;
    sql: ${TABLE}.roas_sales;;
    }

  measure: roas_sales_calc {
    label: "ROAs - Total Sales (test)"
    hidden: yes
    group_label: "Adspend"
    description: "Calculations done in lookML not sql"
    type: number
    value_format: "$#,##0"
    sql:  nvl(${dtc_amount},0)+nvl(${retail_amount},0)+(nvl(${wholesale_amount},0)*.5);;
  }

  measure: roas {
    label: "ROAs - Full"
    group_label: "Adspend"
    description: "Retun on Adspend (total roas salse/adspend)"
    type: number
    value_format: "$#,##0.00"
    sql: ${roas_sales}/NULLIF(${adspend},0) ;;
    }

  measure: dtc_roas {
    label: "ROAs - DTC"
    group_label: "Adspend"
    description: "Retun on Adspend (total roas salse/adspend)"
    type: number
    value_format: "$#,##0.00"
    sql: ${dtc_amount}/NULLIF(${adspend},0) ;;
  }

  measure: target_roas_sales {
    label: "Plan ROAs Sales"
    group_label: "Adspend"
    description: "DTC Plan + Retail Plan + 50% of Wholesale Plan"
    type: number
    value_format: "$#,##0.00"
    sql: nvl(${target_dtc_amount},0)+nvl(${target_retail_amount},0)+(nvl(${target_wholesale_amount},0)*0.50) ;;
  }

  measure: target_roas {
    label: "Plan ROAs"
    group_label: "Adspend"
    description: "Plan Target + Plan Target + 50% of Wholesale Plan /Adspend Goal"
    type: number
    value_format: "$#,##0.00"
    sql: ${target_roas_sales}/NULLIF(${adspend_target},0) ;;
  }

  measure: is_sales {
    label: "IS Inside Sales ($)"
    group_label: "Inside Sales"
    description: "Gross Sales from Inside Sales Team (Does not include customer care)"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.is_sales ;;
  }

  measure: cc_sales {
    label: "IS Customer Care Sales ($)"
    group_label: "Inside Sales"
    description: "Gross Sales from Customer Care Team"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.cc_sales ;;
  }

  measure: is_total_sales {
    label: "IS - Total Sales ($)"
    group_label: "Inside Sales"
    description: "Gross Sales from Customer Care Team"
    type: sum
    value_format: "$#,##0.00"
    sql: nvl(${TABLE}.is_sales,0) + nvl(${TABLE}.cc_sales,0) ;;
  }

  measure: is_orders {
    label: "IS Inside Orders (#)"
    group_label: "Inside Sales"
    description: "Gross Sales from Inside Sales Team (Does not include customer care)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_orders ;;
  }

  measure: cc_orders {
    label: "IS Customer Care Orders (#)"
    group_label: "Inside Sales"
    description: "Gross Sales from Customer Care Team"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.cc_orders ;;
  }

  measure: is_total_orders {
    label: "IS - Total Orders (#)"
    group_label: "Inside Sales"
    description: "Total Ordrs from Customer Care and Inside Sales Team"
    type: sum
    value_format: "#,##0"
    sql: nvl(${TABLE}.is_orders,0) + nvl(${TABLE}.cc_orders,0) ;;
  }

  measure: is_deals {
    label: "IS SQOs (#)"
    group_label: "Inside Sales"
    description: "Deals created in zendesk sell"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_deals ;;
  }

  measure: is_cohort_orders {
    label: "IS Cohort Orders (#)"
    group_label: "Inside Sales"
    description: "Netsuite orders converted from deals created in zendesk sell on the zendesk deal date"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_cohort_orders ;;
  }

  measure: is_activities {
    label: "IS Activities (#)"
    group_label: "Inside Sales"
    description: "Total activities from calls, chats and emails"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_activities ;;
  }

  measure: is_calls {
    label: "IS Calls (#)"
    group_label: "Inside Sales"
    description: "Total calls from RPT skills report download in incontact"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_calls ;;
  }

  measure: is_chats {
    label: "IS Chats (#)"
    group_label: "Inside Sales"
    description: "Total chats from zendesk tickets"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_chats ;;
  }

  measure: is_emails {
    label: "IS Emails (#)"
    group_label: "Inside Sales"
    description: "Total emails from zendesk tickets"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.is_emails ;;
  }

  measure: cvr_is {
    label: "IS Conversion Rate"
    group_label: "Inside Sales"
    description: "% of all IS actvities over IS orders. Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.is_orders})/NULLIF(${day_aggregations.is_activities},0) ;; }

  measure: retail_traffic_showroom_entries{
    label: "Retail Showroom Entries"
    group_label: "Sales - Retail"
    description: "Total showroom entry count. Data available starting Feb 2021"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.retail_traffic_showroom_entries ;;
  }

  measure: retail_traffic_showroom_orders{
    label: "Retail Order Count"
    group_label: "Sales - Retail"
    description: "Count of Retail Showroom Orders (excludes chat/draft). Data available starting Feb 2021"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.retail_traffic_showroom_orders ;;
  }

  measure: retail_conversion {
    label: "Retail Conversion Rate"
    group_label: "Sales - Retail"
    description: "% of all showroom entries that resulted in an order (excludes chat/draft orders). Data available starting Feb 2021  Source: looker.calculation"
    type: number
    value_format_name: percent_2
    sql: 1.0*(${day_aggregations.retail_traffic_showroom_orders})/NULLIF(${day_aggregations.retail_traffic_showroom_entries},0) ;; }

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
