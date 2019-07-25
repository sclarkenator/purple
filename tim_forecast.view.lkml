view: tim_forecast {

  derived_table: {
    sql:
      select b.date
          , a.sku_id
          , a.amount/c.days_in_month as amount
          , a.units/c.days_in_month as paid_units
          , a.promo_units/c.days_in_month as promo_units
      from analytics.csv_uploads.forecasted_targets a
      left join analytics.util.warehouse_date b on b.month = month(a.date::date) and b.year = year(a.date::date)
      left join (
        select year, month, count (date) as days_in_month
        from analytics.util.warehouse_date
        group by year, month
      ) c on c.year = b.year and c.month = b.month
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
