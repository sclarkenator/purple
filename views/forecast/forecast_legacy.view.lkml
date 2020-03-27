view: forecast_legacy {

  derived_table: {
    sql:
       select b.date
            , a.sku_id
            , (a.standard_sales + a.discounted_sales)/c.days as amount
            , (a.standard_units + a.discounted_units)/c.days as paid_units
            , a.promo_units/days as promo_units
        from analytics.csv_uploads.forecast_dtc a
        left join (
            select distinct a.start_date
                , a.end_date
                , b.date
            from analytics.csv_uploads.forecast_dtc a
            left join analytics.util.warehouse_date b on b.date::date >= a.start_date::date and b.date::date <= a.end_date
        ) b on b.start_date = a.start_date and b.end_date = a.end_date
        left join (
            select z.start_date
                , count (z.date) as days
            from (
              select distinct a.start_date
                  , a.end_date
                  , b.date
              from analytics.csv_uploads.forecast_dtc a
              left join analytics.util.warehouse_date b on b.date::date >= a.start_date::date and b.date::date <= a.end_date
              ) z
              group by z.start_date
          ) c on c.start_date = a.start_date
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

  dimension: week_bucket{
    group_label: "Forecast Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;;
    primary_key:yes
  }

  measure: amount {
    label: "Total Forecast Amount"
    type:  sum
    sql:round(${TABLE}.amount,2) ;; }

  measure: total_units {
    label: "Total Units"
    type:  sum
    sql:round(${TABLE}.paid_units+coalesce(${TABLE}.promo_units,0),2) ;; }

  measure: total_paid_units {
    label: "Total Paid Units"
    type:  sum
    sql:round(${TABLE}.paid_units,2) ;; }

  measure: total_promo_units {
    label: "Total Promo Units"
    type:  sum
    sql:round(${TABLE}.promo_units,2) ;; }

  measure: to_date {
    label: "Total Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    sql: round(case when ${TABLE}.date < current_date then ${TABLE}.total_amount else 0 end,2);; }

}
