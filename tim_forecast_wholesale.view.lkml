view: tim_forecast_wholesale {

  derived_table: {
    sql:
      select b.date
          , a.sku_id
          , coalesce(a.total_units/c.days_in_week,0) as total_units
          , coalesce(a.total_amount/c.days_in_week,0) as total_amount
          , coalesce(a.MF_Instore_Units/c.days_in_week,0) as MF_Instore_Units
          , coalesce(a.MF_Online_Units/c.days_in_week,0) as MF_Online_Units
          , coalesce(a.FR_Units/c.days_in_week,0) as FR_Units
          , coalesce(a.Macys_Instore_Units/c.days_in_week,0) as Macys_Instore_Units
          , coalesce(a.Macys_Online_Units/c.days_in_week,0) as Macys_Online_Units
          , coalesce(a.SCC_Units/c.days_in_week,0) as SCC_Units
          , coalesce(a.HOM_Units/c.days_in_week,0) as HOM_Units
          , coalesce(a.BBB_Units/c.days_in_week,0) as BBB_Units
          , coalesce(a.Medical_Units/c.days_in_week,0) as Medical_Units
          , coalesce(a.Trucking_Units/c.days_in_week,0) as Trucking_Units
          , coalesce(a.BD_Units/c.days_in_week,0) as BD_Units
          , coalesce(a.BD_Units/c.days_in_week,0) as Other_Units
          , coalesce(a.MF_Instore_Amount/c.days_in_week,0) as MF_Instore_Amount
          , coalesce(a.MF_Online_Amount/c.days_in_week,0) as MF_Online_Amount
          , coalesce(a.FR_Amount/c.days_in_week,0) as FR_Amount
          , coalesce(a.Macys_Instore_Amount/c.days_in_week,0) as Macys_Instore_Amount
          , coalesce(a.Macys_Online_Amount/c.days_in_week,0) as Macys_Online_Amount
          , coalesce(a.SCC_Amount/c.days_in_week,0) as SCC_Amount
          , coalesce(a.HOM_Amount/c.days_in_week,0) as HOM_Amount
          , coalesce(a.BBB_Amount/c.days_in_week,0) as BBB_Amount
          , coalesce(a.Medical_Amount/c.days_in_week,0) as Medical_Amount
          , coalesce(a.Trucking_Amount/c.days_in_week,0) as Trucking_Amount
          , coalesce(a.BD_Amount/c.days_in_week,0) as BD_Amount
          , coalesce(a.Other_Amount/c.days_in_week,0) as Other_Amount

      from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
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

      dimension: week_bucket{
        group_label: "Forecast Date"
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

          measure: total_units {
            label: "Total Units"
            type:  sum
            sql:round(${TABLE}.total_units,2) ;; }

          measure: total_units_2 {
            label: "Total Units (not rounded)"
            type:  sum
            sql:${TABLE}.total_units ;; }

          measure: total_amount {
            label: "Total Amount"
            type:  sum
            sql:round(${TABLE}.total_amount,2) ;; }


          measure: avg_units {
            label: "Average Units"
            type:  average
            sql:round(${TABLE}.total_units,2) ;; }

          measure: to_date {
            label: "Total Goal to Date"
            description: "This field is for formatting on (week/month/quarter/year) to date reports"
            type: sum
            sql: round(case when ${TABLE}.date < current_date then ${TABLE}.total_amount else 0 end,2);; }

          dimension: primary_key {
            primary_key: yes
            sql: CONCAT(${sku_id}, ${date_date}) ;;
            hidden: yes
          }

        }
