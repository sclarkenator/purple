view: forecast_retail {

  derived_table: {
    sql:
      select b.date
          , a.sku_id
          , coalesce(a.units/c.days_in_dates,0) as total_units
          , coalesce(a.sales/c.days_in_dates,0) as total_amount
      from analytics.csv_uploads.FORECAST_or a
      left join analytics.util.warehouse_date b on b.date >= a.start_date and b.date <= a.end_date
      left join (
        select z.start_date
          , count (distinct (y.date)) as days_in_dates
        from  analytics.csv_uploads.FORECAST_or z
        left join analytics.util.warehouse_date y on y.date >= z.start_date and y.date <= z.end_date
        group by z.start_date
      ) c on c.start_date = a.start_date
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
#     sql:  CASE WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, current_date) THEN 'Current Week'
#             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
#             WHEN date_trunc(week, ${TABLE}.date::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
#             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(year, -1, current_date)) THEN 'Current Week LY'
#             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Last Week LY'
#             WHEN date_trunc(week, ${TABLE}.date::date) = date_trunc(week, dateadd(week, -2, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
#             ELSE 'Other' END ;; }
  sql: case
  when ${TABLE}.date::date >= '2020-01-06' and ${TABLE}.date::date <= '2020-01-12' then 'Current Week'
  when ${TABLE}.date::date >= '2019-12-30' and ${TABLE}.date::date <= '2020-01-05' then 'Last Week'
  when ${TABLE}.date::date >= '2019-12-23' and ${TABLE}.date::date <= '2019-12-29' then 'Two Weeks Ago'
  when ${TABLE}.date::date >= '2019-01-07' and ${TABLE}.date::date <= '2019-01-13' then 'Current Week LY'
  when ${TABLE}.date::date >= '2018-12-31' and ${TABLE}.date::date <= '2019-01-06' then 'Last Week LY'
  when ${TABLE}.date::date >= '2018-12-24' and ${TABLE}.date::date <= '2018-12-30' then 'Two Weeks Ago LY'
  else 'Other' end ;; }

#   case when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) then 'Current Week'
#               when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -1 then 'Last Week'
#               when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
#               when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) then 'Current Week LY'
#               when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -1 then 'Last Week LY'
#               when date_part('year', ${TABLE}.date::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.date::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
#               else 'Other' end;; }


  measure: total_units {
    label: "Total Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.total_units ;; }

  measure: total_amount {
    label: "Total Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.total_amount ;; }

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
