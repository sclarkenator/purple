view: tim_forecast_wholesale_dim {

  derived_table: {
    sql:
      select b.date
          , a.sku_id
          , a.account
          , coalesce(a.units/c.days_in_week,0) as units
          , coalesce(a.amount/c.days_in_week,0) as amount
      from (
        select a.week
          , a.sku_id
          , 'Mattress Firm Instore' as account
          , a.MF_Instore_Units as units
          , a.MF_Instore_Amount as amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Mattress Firm Online'
          , a.MF_Online_Units
          , a.MF_Online_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Furniture Row'
          , a.FR_Units
          , a.FR_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Macys Instore'
          , a.Macys_Instore_Units
          , a.Macys_Instore_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Macys Online'
          , a.Macys_Online_Units
          , a.Macys_Online_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Sleep Country Canada'
          , a.SCC_Units
          , a.SCC_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Bed, Bath & Beyond'
          , a.BBB_Units
          , a.BBB_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Medical'
          , a.Medical_Units
          , a.Medical_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Trucking'
          , a.Trucking_Units
          , a.Trucking_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        union all
        select a.week
          , a.sku_id
          , 'Other'
          , a.CATCH_ALL_units
          , a.CATCH_ALL_AMOUNT
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
      ) a
      left join (
        select
            year::text || '-' ||case when week_of_year < 10 then concat('0',week_of_year::text) else week_of_year::text end as year_week
            , year
            , week_of_year
            , count (date) as days_in_week
            , min(date) as start_date
            , max(date) as end_date
        from analytics.util.warehouse_date
        where year > 2018
        group by year, week_of_year
        order by 1
      ) c on c.year_week = a.week
      left join analytics.util.warehouse_date b on b.date >= c.start_date and b.date <= c.end_date
      order by 2, 1
  ;; }

      dimension_group: date {
        label: "Forecast"
        type: time
        timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
        convert_tz: no
        datatype: date
        sql: ${TABLE}.date ;; }

      dimension: Before_today{
        group_label: "Forecast Date"
        label: "z - Is Before Today (mtd)"
        #hidden:  yes
        description: "This field is for formatting on (week/month/quarter/year) to date reports"
        type: yesno
        sql: ${TABLE}.date < current_date;; }

      dimension: sku_id {
        type:  string
        sql:${TABLE}.sku_id ;; }

  dimension: account {
    label: "Account Name"
    type:  string
    sql:${TABLE}.account ;; }

      measure: units {
        label: "Total Units"
        type:  sum
        sql:round(${TABLE}.units,2) ;; }

      measure: units_2 {
        label: "Total Units (not rounded)"
        type:  sum
        sql:${TABLE}.units ;; }

      measure: amount {
        label: "Total Amount"
        type:  sum
        sql:round(${TABLE}.amount,2) ;; }


      measure: avg_units {
        label: "Average Units"
        type:  average
        sql:round(${TABLE}.units,2) ;; }

      measure: to_date {
        label: "Total Goal to Date"
        description: "This field is for formatting on (week/month/quarter/year) to date reports"
        type: sum
        sql: round(case when ${TABLE}.date < current_date then ${TABLE}.amount else 0 end,2);; }

    }
