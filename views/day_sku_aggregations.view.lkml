include: "/views/_period_comparison.view.lkml"
######################################################
#   Sales and Fulfillment
######################################################
view: sales_day_sku {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: channel2 { field: sales_order.channel2 }
      column: sku_id { field: item.sku_id }
      column: total_gross_Amt_non_rounded {}
      column: total_units {}
      column: adj_gross_amt {}
      column: unfulfilled_orders {}
      column: unfulfilled_orders_units {}
      column: gross_margin {}
      filters: { field: sales_order.channel value: "DTC,Wholesale,Owned Retail" }
##      filters: { field: sales_order.is_exchange_upgrade_warranty value: "No" }
      filters: { field: sales_order_line.created_date value: "3 years" }
    }
  }
  dimension: created_date { type: date}
  dimension: channel2 { }
  dimension: sku_id { }
  dimension: total_gross_Amt_non_rounded { type: number }
  dimension: total_units { type: number }
  dimension: adj_gross_amt { type: number }
  dimension: unfulfilled_orders { type: number }
  dimension: unfulfilled_orders_units { type: number }
  dimension: gross_margin { type: number }
}

######################################################
#   Fulfilled
######################################################

view: fulfilled_day_sku {
  derived_table: {
    explore_source: sales_order_line {
      column: channel2 { field: sales_order.channel2 }
      column: sku_id { field: item.sku_id }
      column: fulfilled_date {}
      column: fulfilled_orders {}
      column: fulfilled_orders_units {}
      filters: { field: sales_order.channel value: "DTC,Wholesale,Owned Retail" }
      filters: {field: sales_order_line.fulfilled_date value: "3 years"}
    }
  }

  dimension: channel2 { }
  dimension: sku_id { }
  dimension: fulfilled_date {type: date}
  dimension: fulfilled_orders {type: number}
  dimension: fulfilled_orders_units {type: number}
}

######################################################
#   Production
######################################################
view: production_day_sku {
  derived_table: {
    explore_source: assembly_build {
      column: Total_Quantity {}
      column: produced_date {}
      column: sku_id { field: item.sku_id }
      filters: { field: assembly_build.scrap value: "0" }
      filters: { field: item.merchandise value: "0" }
      filters: { field: assembly_build.produced_date value: "3 years"}
    }
  }
  dimension: Total_Quantity { type: number }
  dimension: produced_date { type: date }
  dimension: sku_id { }
}

######################################################
#   Forecast
######################################################
view: forecast_day_sku {
  derived_table: {
    explore_source: forecast_combined {
      column: date_date {}
      column: channel {}
      column: sku_id {}
      column: total_amount {}
      column: total_units {}
      filters: { field: forecast_combined.date_date value: "3 years" }
    }
  }
  dimension: date_date { type: date }
  dimension: channel {}
  dimension: sku_id {}
  dimension: total_amount { type: number }
  dimension: total_units { type: number }
}

######################################################
#   AOP
######################################################

view: aop_day_sku {
  derived_table: {
    explore_source: aop_combined {
      column: forecast_date {}
      column: channel {}
      column: sku_id {}
      column: total_sales {}
      column: total_units {}
      filters: {field: aop_combined.forecast_date value: "3 years"}
    }
  }
  dimension: forecast_date {type: date}
  dimension: channel {}
  dimension: sku_id {}
  dimension: total_sales {type: number}
  dimension: total_units {type: number}
}

######################################################
#   LRP
######################################################

view: lrp_day_sku {
  derived_table: {
    explore_source: lrp_combined {
      column: forecast_date {}
      column: channel {}
      column: sku_id {}
      column: total_sales {}
      column: total_units {}
    }
  }
  dimension: forecast_date {type: date}
  dimension: channel {}
  dimension: sku_id {}
  dimension: total_sales {type: number}
  dimension: total_units {type: number}
}


######################################################
#   Inventory
######################################################
view: inventory_day_sku {
  derived_table: {
    explore_source: inventory_snap {
      column: created_date {}
      column: on_hand {}
      column: available {}
      column: sku_id { field: item.sku_id }
      filters: { field: warehouse_location.location_Active value: "No" }
      filters: { field: warehouse_location.warehouse_bucket value: "Purple,White Glove" }
      filters: { field: inventory_snap.created_date value: "3 years" }
      filters: { field: inventory_snap.on_hand value: ">0" }
      filters: { field: inventory_snap.created_hour_of_day value: "23" }
    }
  }
  dimension: created_date { type: date }
  dimension: on_hand { type: number }
  dimension: available { type: number }
  dimension: sku_id { }
}

######################################################
#   Purchase Order
######################################################
view: po_day_sku {
  derived_table: {
    explore_source: purcahse_and_transfer_ids {
      column: estimated_arrival_date { field: purchase_order_line.estimated_arrival_date }
      column: sku_id { field: item.sku_id }
      column: Total_quantity_received { field: purchase_order_line.Total_quantity_received }
      filters: { field: purchase_order_line.estimated_arrival_date value: "3 years" }
      filters: { field: purchase_order_line.Total_quantity_received value: ">0" }
    }
  }
  dimension: estimated_arrival_date { type: date }
  dimension: sku_id {  }
  dimension: Total_quantity_received { type: number }
}

######################################################
#   CREATING FINAL TABLE
######################################################
view: day_sku_aggregations {
  derived_table: {
    sql:
      select aa.date
        , aa.sku_id
        , aa.channel
        , s.total_gross_Amt_non_rounded as total_sales
        , s.total_units as total_units
        , s.adj_gross_amt as total_adjusted_sales
        , s.gross_margin as total_gross_margin
        , s.unfulfilled_orders as unfulfilled_sales
        , s.unfulfilled_orders_units as unfulfilled_units
        , ff.fulfilled_orders as fulfilled_sales
        , ff.fulfilled_orders_units as fulfilled_units
        , p.Total_Quantity as produced_units
        , f.total_amount as forecast_amount
        , f.total_units as forecast_units
        , aop.total_sales as plan_amount
        , aop.total_units as plan_units
        , lrp.total_sales as lrp_amount
        , lrp.total_units as lrp_units
        , i.on_hand as units_on_hand
        , i.available as units_available
        , po.Total_quantity_received as purchased_units_recieved
      from (
        select d.date
          , i.sku_id
          , s.channel
        from analytics.util.warehouse_date d
        cross join (
              select distinct coalesce (i.sku_id,ai.sku_id) sku_id
              from sales.item i
              full outer join "FORECAST"."V_AI_PRODUCT" ai on i.sku_id=ai.sku_id
        ) i
        cross join (
          select distinct
              case when channel_id = 1 then 'DTC'
              when channel_id = 2 then 'Wholesale'
              when channel_id = 5 then 'Owned Retail'
              else 'NA' end as channel
          from analytics.sales.sales_order
        ) s
        where date between '2019-01-01' and '2023-12-31'
      ) aa
      left join ${sales_day_sku.SQL_TABLE_NAME} s on s.created_date::date = aa.date and s.sku_id = aa.sku_id and s.channel2 = aa.channel
      left join ${fulfilled_day_sku.SQL_TABLE_NAME} ff on ff.fulfilled_date::date = aa.date and ff.sku_id = aa.sku_id and ff.channel2 = aa.channel
      left join ${production_day_sku.SQL_TABLE_NAME} p on p.produced_date::date = aa.date and p.sku_id = aa.sku_id and aa.channel = 'NA'
      left join ${forecast_day_sku.SQL_TABLE_NAME} f on f.date_date::date = aa.date and f.sku_id = aa.sku_id and f.channel = aa.channel
      left join ${inventory_day_sku.SQL_TABLE_NAME} i on i.created_date::date = aa.date and i.sku_id = aa.sku_id and aa.channel = 'NA'
      left join ${po_day_sku.SQL_TABLE_NAME} po on po.estimated_arrival_date::date = aa.date and po.sku_id = aa.sku_id and aa.channel = 'NA'
      left join ${aop_day_sku.SQL_TABLE_NAME} aop on aop.forecast_date::date = aa.date and aop.sku_id = aa.sku_id and aop.channel = aa.channel
      left join ${lrp_day_sku.SQL_TABLE_NAME} lrp on lrp.forecast_date::date = aa.date and lrp.sku_id = aa.sku_id and lrp.channel = aa.channel
    ;;
    datagroup_trigger: pdt_refresh_6am
  }
  extends: [_period_comparison]
  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,week,
      month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }


  #dimension: date {type: date hidden:yes}

  dimension: pk {
    hidden: yes
    primary_key: yes
    sql: ${sku_id}||'-'||${date_date}||'-'||${channel} ;;
  }
  dimension_group: date {
    ##Scott Clark, 1/8/21: Deleted week of year.
    label: "Dynamic"
    type: time
    timeframes: [hour_of_day, date, day_of_week, day_of_week_index, day_of_month, month_num, day_of_year, week, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${TABLE}.date) ;; }

  dimension: QTD {
    label: "z - QTD"
    group_label: "Dynamic Date"
    description: "Identifies current quarter-to-date for filtering"
    type: yesno
    sql: case when ${date_quarter_of_year}=${current_quarter_of_year} AND ${date_day_of_year}<${current_day_of_year} then TRUE else null end ;;
    }

  dimension: YTD {
    label: "z - YTD"
    group_label: "Dynamic Date"
    description: "Identifies year-to-date for filtering"
    type: yesno
    sql: case when ${date_day_of_year}<${current_day_of_year} then TRUE else null end ;;
  }



  dimension: date_week_of_year {
    ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
    type: number
    label: "Week of Year"
    group_label: "Dynamic Date"
    description: "2021 adjusted week of year number"
    sql: case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 1
            when ${date_year::number}=2021 then date_part(weekofyear,${date_date::date}) + 1
            else date_part(weekofyear,${date_date::date}) end ;;
  }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "Dynamic Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 2021 else ${date_year} end   ;;
  }


  dimension: Before_today{
    group_label: "Dynamic Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: case when ${TABLE}.date < current_date then TRUE else null end;; }

  dimension: start_date {
    group_label: "Dynamic Date"
    label: "z - Start Date"
    description: "This field will show the start date of an interval that is normally a bucket (week 1, august)"
    type: date
    sql: min(${TABLE}.date)::date ;; }

  dimension: last_30{
    group_label: "Dynamic Date"
    label: "z - Last 30 Days"
    type: yesno
    sql: ${TABLE}.date > dateadd(day,-30,current_date);; }

  dimension: current_week_num{
    group_label: "Dynamic Date"
    label: "z - Before Current Week"
    hidden: no
    type: yesno
    sql: date_trunc(week, ${TABLE}.date::date) < date_trunc(week, current_date) ;;}

  dimension: 6_weeks{
    group_label: "Dynamic Date"
    label: "z - Before 6 Weeks Later"
    hidden: yes
    type: yesno
    sql: date_part('week',${TABLE}.date) < (date_part('week',current_date)+6);; }

  dimension: prev_week{
    group_label: "Dynamic Date"
    label: "z - Previous Week"
    hidden: no
    type: yesno
    sql:  date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: month_buckets{
    group_label: "Dynamic Date"
    label: "z - Month Buckets"
    hidden: no
    type: string
    sql: CASE WHEN ${date_month_num} = date_part (month,current_date) - 1 AND ${date_year} = date_part (year,current_date) THEN 'Last Month'
              WHEN ${date_month_num} = date_part (month,current_date) - 1 AND ${date_year} = date_part (year,current_date)-1 THEN 'Last Month LY'
              WHEN ${date_month_num} = date_part (month,current_date) AND ${date_year} = date_part (year,current_date) THEN 'Current Month'
              WHEN ${date_month_num} = date_part (month,current_date) AND ${date_year} = date_part (year,current_date)-1 THEN 'Current Month LY'
              ELSE 'Other' END;; }

  dimension: ytd_complete_months {
    group_label: "Dynamic Date"
    label: "z - YTD Complete Months"
    hidden: no
    type: yesno
    sql: ${date_month_num} < date_part (month,current_date);; }

  dimension: cur_week{
    group_label: "Dynamic Date"
    label: "z - Current Week"
    hidden: no
    type: yesno
    sql: date_trunc(week, ${TABLE}.date) = date_trunc(week, current_date) ;;}

  dimension: week_bucket{
    hidden: no
    group_label: "Dynamic Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql:  CASE WHEN ${date_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${date_year} = date_part (year,current_date) THEN 'Current Week'
      WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) THEN 'Last Week'
      WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
      WHEN ${date_week_of_year} = date_part (weekofyear,current_date) +1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
      WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
      WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
     ELSE 'Other' END;; }

  dimension_group: current {
    label: "Current"
    hidden: yes
    description:  "Current Time/Date for calculations"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

  dimension: sku_id {
    hidden: yes
    type: string
    sql: ${TABLE}.sku_id ;;
  }

  dimension: channel {
    type: string
    description: "DTC, Wholesale, or Owned Retail. (DTC includes Amazon/Ebay)"
    sql: ${TABLE}.channel ;;
  }

  measure: total_sales {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.total_sales;; }

  measure: total_units {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.total_units;; }

  measure: total_adjusted_sales {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.total_adjusted_sales;; }

  measure: total_gross_margin {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.total_gross_margin;; }

  measure: unfulfilled_sales{
    type: sum
    group_label: "Fulfilled"
    value_format: "$#,##0"
    sql: ${TABLE}.unfulfilled_sales;; }

  measure: unfulfilled_units {
    type: sum
    group_label: "Fulfilled"
    value_format: "#,##0"
    sql: ${TABLE}.unfulfilled_units;; }

  measure: fulfilled_sales{
    type: sum
    group_label: "Fulfilled"
    value_format: "$#,##0"
    sql: ${TABLE}.fulfilled_sales;; }

  measure: fulfilled_units {
    type: sum
    group_label: "Fulfilled"
    value_format: "#,##0"
    sql: ${TABLE}.fulfilled_units;; }

  measure: produced_units {
    type: sum
    group_label: "Produced"
    value_format: "#,##0"
    sql: ${TABLE}.produced_units;; }

  measure: forecast_amount {
    type: sum
    group_label: "Forecast"
    value_format: "$#,##0"
    sql: ${TABLE}.forecast_amount;; }

  measure: forecast_units {
    type: sum
    group_label: "Forecast"
    value_format: "#,##0"
    sql: ${TABLE}.forecast_units;; }

  measure: plan_amount {
    type: sum
    group_label: "Plan"
    value_format: "$#,##0"
    sql: ${TABLE}.plan_amount;; }

  measure: plan_units {
    type: sum
    group_label: "Plan"
    value_format: "#,##0"
    sql: ${TABLE}.plan_units;; }

  measure: lrp_amount {
    type: sum
    label: "LRP Amount $"
    group_label: "Plan"
    value_format: "$#,##0"
    sql: ${TABLE}.lrp_amount;; }

  measure: lrp_units {
    type: sum
    label: "LRP Units"
    group_label: "Plan"
    value_format: "#,##0"
    sql: ${TABLE}.lrp_units;; }

  measure: units_on_hand {
    type: sum
    group_label: "Inventory"
    value_format: "#,##0"
    sql: ${TABLE}.units_on_hand;; }

  measure: units_available {
    type: sum
    group_label: "Inventory"
    value_format: "#,##0"
    sql: ${TABLE}.units_available;; }

  measure: purchased_units_recieved {
    type: sum
    group_label: "Inventory"
    value_format: "#,##0"
    sql: ${TABLE}.purchased_units_recieved;; }

  measure: to_plan_dollars {
    label: "To Plan ($)"
    type: number
    group_label: "Plan"
    value_format: "0.0%"
    sql: case when ${plan_amount} > 0 then (${total_sales}/${plan_amount})-1 else 0 end;;
  }
  measure: to_plan_units {
    label: "To Plan (units)"
    type: number
    group_label: "Plan"
    value_format: "0.0%"
    sql: (${total_units}/${plan_units})-1 ;;
  }
  measure: to_forecast_dollars {
    label: "To Forecast ($)"
    type: number
    group_label: "Forecast"
    value_format: "0.0%"
    sql: case when ${forecast_amount} > 0 then (${total_sales}/${forecast_amount})-1 else 0 end;;
  }
  measure: to_forecast_units {
    label: "To Forecast (units)"
    type: number
    group_label: "Forecast"
    value_format: "0.0%"
    sql: case when ${forecast_units} > 0 then (${total_units}/${forecast_units})-1 else 0 end ;;
  }

  dimension: liquid_date {
    group_label: "Dynamic Date"
    label: "z - liquid date"
    description: "If > 365 days in the look, than month, if > 30 than week, else day"
    sql:
    CASE
      WHEN
        datediff(
                'day',
                cast({% date_start date_date %} as date),
                cast({% date_end date_date  %} as date)
                ) >365
      THEN cast(${date_month} as varchar)
      WHEN
        datediff(
                'day',
                cast({% date_start date_date %} as date),
                cast({% date_end date_date  %} as date)
                ) >30
      THEN cast(${date_week} as varchar)
      else ${date_date}
      END
    ;;
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
