view: tim_forecast {

  derived_table: {
    sql:
      with aa as(
        select z.date
          , z.sku_id
          , z.item_id
          , z.monthly_goal
          , case when z.sku_id in ('10-21-12618','10-21-12620','10-21-12625','10-21-12632',
            '10-21-12960','10-21-60005','10-21-60006','10-21-60007','10-21-60008','10-21-60009',
            '10-21-60010','10-21-60011','10-21-60012','10-21-60013','10-21-60014','10-21-60015',
            '10-21-60016','10-21-60018','10-21-60019','10-21-60020') then 1 else 0 end as is_mattress
          , z.daily_goal+coalesce(a.amount,0) as total_amount
          , z.total_units+coalesce(a.units,0) as total_units
        from (
          select b.date
              --, c.days_in_month
              --, a.date as goal_month
              , a.sku_id
              , a.item_id
              , a.amount as monthly_goal
              , a.amount/c.days_in_month as daily_goal
              , a.units/c.days_in_month as total_units
          from analytics.csv_uploads.forecasted_targets a
          left join analytics.util.warehouse_date b on b.month = month(a.date) and b.year = year(a.date)
          left join (
            select year, month, count (date) as days_in_month
            from analytics.util.warehouse_date
            group by year, month
          ) c on c.year = b.year and c.month = b.month
        ) z
        left join analytics.csv_uploads.forecasted_holidays a on a.date = z.date and z.sku_id = a.sku_id and z.item_id = a.item_id
      )
      select aa.date
        , aa.sku_id
        , aa.item_id
        --, aa.is_mattress
        , aa.total_amount
        , aa.total_units
        , c.promo
        , y.mattresses * s.percent as promo_units
        --, y.mattresses * (s.percent*.9) as promo_units
      from aa
      left join analytics.csv_uploads.promo_calendar c on c.start_date <= aa.date and c.end_date >= aa.date
      left join analytics.csv_uploads.promo_skus s on s.promo = c.promo and s.sku = aa.sku_id
      left join (
        select aa.date, sum(aa.total_units) as mattresses
        from aa
        where is_mattress = 1
        group by aa.date
      ) y on y.date = aa.date
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

  dimension: item_id {
    hidden:  yes
    type:  string
    sql:${TABLE}.item_id ;; }

  measure: total_amount {
    label: "Total Forecast Amount"
    type:  sum
    sql:round(${TABLE}.total_amount,2) ;; }

  measure: total_units {
    label: "Total Units"
    type:  sum
    sql:round(${TABLE}.total_units+coalesce(${TABLE}.promo_units,0),2) ;; }

  measure: total_paid_units {
    label: "Total Paid Units"
    type:  sum
    sql:round(${TABLE}.total_units,2) ;; }


  measure: total_promo_units {
    label: "Total Promo Units"
    type:  sum
    sql:round(${TABLE}.promo_units,2) ;; }

  measure: avg_units {
    label: "Average Units"
    type:  average
    sql:round(${TABLE}.total_units,2) ;; }

  measure: to_date {
    label: "Total Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    sql: round(case when ${TABLE}.date < current_date then ${TABLE}.total_amount else 0 end,2);; }

}
