view: tim_forecast {

  derived_table: {
    sql:
      select b.date
          --, c.days_in_month
          --, a.date as goal_month
          , a.sku_id
          , a.item_id
          , a.amount as monthly_goal
          , a.amount/c.days_in_month as daily_goal
      from analytics.csv_uploads.forecasted_targets a
      left join analytics.util.warehouse_date b on b.month = month(a.date) and b.year = year(a.date)
      left join (
        select year, month, count (date) as days_in_month
        from analytics.util.warehouse_date
        group by year, month
      ) c on c.year = b.year and c.month = b.month ;;
  }

  dimension_group: date {
    label: "Forecast"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;; }


  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;; }

  dimension: item_id {
    hidden:  yes
    type:  string
    sql:${TABLE}.item_id ;; }

  measure: monthly_goal {
    label: "Monthly Goal"
    hidden: yes
    type:  sum
    sql:${TABLE}.monthly_goal ;; }

  measure: daily_goal {
    label: "Total Forecast Amount"
    type:  sum
    sql:round(${TABLE}.daily_goal,2) ;; }

  measure: to_date {
    label: "Total Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    sql: round(case when ${TABLE}.date < current_date then ${TABLE}.daily_goal else 0 end,2);; }

}
