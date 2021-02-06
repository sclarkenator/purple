######################################################
#   Sales and Fulfillment
######################################################
view: sales_day_sku1 {
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
      filters: { field: sales_order.channel value: "DTC,Wholesale,Owned Retail" }
##      filters: { field: sales_order.is_exchange_upgrade_warranty value: "No" }
      filters: { field: sales_order_line.created_date value: "3 years" }
    }
  }
  dimension: created_date { type: date}
##  dimension: channel2 { }
  dimension: sku_id { }
  dimension: total_gross_Amt_non_rounded { type: number }
  dimension: total_units { type: number }
  dimension: adj_gross_amt { type: number }
  dimension: unfulfilled_orders { type: number }
  dimension: unfulfilled_orders_units { type: number }
}

######################################################
#   Production
######################################################
view: production_day_sku1 {
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
view: forecast_day_sku1 {
  derived_table: {
    explore_source: forecast_combined {
      column: date_date {}
  ##    column: channel {}
      column: sku_id {}
      column: total_amount {}
      column: total_units {}
      filters: { field: forecast_combined.date_date value: "3 years" }
    }
  }
  dimension: date_date { type: date }
##  dimension: channel {}
  dimension: sku_id {}
  dimension: total_amount { type: number }
  dimension: total_units { type: number }
}

######################################################
#   Inventory
######################################################
view: inventory_day_sku1 {
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
view: po_day_sku1 {
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
view: day_sku_no_channel {
  derived_table: {
    sql:
      select aa.date
        , aa.sku_id
--        ,s.total_gross_Amt_non_rounded as total_sales
--        , s.total_units as total_units
--        , s.adj_gross_amt as total_adjusted_sales
--        , s.unfulfilled_orders as unfulfilled_sales
--        , s.unfulfilled_orders_units as unfulfilled_units
        , p.Total_Quantity as produced_units
--        , f.total_amount as forecast_amount
        , sum(f.total_units) over (partition by aa.date, aa.sku_id) as forecast_units
--        , i.on_hand as units_on_hand
        , i.available as units_available
        , po.Total_quantity_received as purchased_units_recieved
      from (
        select d.date
          , i.sku_id
          from analytics.util.warehouse_date d
        cross join analytics.sales.item i
          where date between '2019-01-01' and '2021-12-31'
      ) aa
      left join ${sales_day_sku1.SQL_TABLE_NAME} s on s.created_date::date = aa.date and s.sku_id = aa.sku_id
      left join ${production_day_sku1.SQL_TABLE_NAME} p on p.produced_date::date = aa.date and p.sku_id = aa.sku_id
      left join ${forecast_day_sku1.SQL_TABLE_NAME} f on f.date_date::date = aa.date and f.sku_id = aa.sku_id
      left join ${inventory_day_sku1.SQL_TABLE_NAME} i on i.created_date::date = aa.date and i.sku_id = aa.sku_id
      left join ${po_day_sku1.SQL_TABLE_NAME} po on po.estimated_arrival_date::date = aa.date and po.sku_id = aa.sku_id
      --group by 1,2,3,5,6
    ;;
    datagroup_trigger: pdt_refresh_6am
  }
  dimension: date {type: date hidden:yes}

  dimension: pk {
    hidden: yes
    primary_key: yes
    sql: ${sku_id}||'-'||${date_date} ;;
  }
  dimension_group: date {
    ##Scott Clark, 1/8/21: Deleted week of year.
    label: "Dynamic"
    type: time
    timeframes: [hour_of_day, date, day_of_week, day_of_week_index, day_of_month, month_num, day_of_year, week, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${date}) ;; }

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

  dimension: cur_week{
    group_label: "Dynamic Date"
    label: "z - Current Week"
    hidden: yes
    type: yesno
    sql: date_trunc(week, ${TABLE}.date) = date_trunc(week, current_date) ;;}

  dimension: week_bucket{
    hidden: no
    group_label: "Created Date"
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


      measure: total_sales {
        type: sum
        value_format: "$#,##0"
        sql: ${TABLE}.dtc_amount;; }

      measure: total_units {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.total_units;; }

      measure: total_adjusted_sales {
        type: sum
        value_format: "$#,##0"
        sql: ${TABLE}.total_adjusted_sales;; }

      measure: unfulfilled_sales{
        type: sum
        value_format: "$#,##0"
        sql: ${TABLE}.unfulfilled_sales;; }

      measure: unfulfilled_units {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.unfulfilled_units;; }

      measure: produced_units {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.produced_units;; }

      measure: forecast_amount {
        type: sum
        value_format: "$#,##0"
        sql: ${TABLE}.forecast_amount;; }

      measure: forecast_units {
        type: sum_distinct
        value_format: "#,##0"
        sql: ${TABLE}.forecast_units;; }

      measure: units_on_hand {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.units_on_hand;; }

      measure: units_available {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.units_available;; }

      measure: purchased_units_recieved {
        type: sum
        value_format: "#,##0"
        sql: ${TABLE}.purchased_units_recieved;; }

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
