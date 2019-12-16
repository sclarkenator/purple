view: tim_forecast_historical {

  derived_table: {
    sql:
      select d.date as forecasted_date
        , f.forecast_made
        , f.channel
        , f.account
        , f.sku_id
        , coalesce(f.amount/f.days,0) amount
        , coalesce(f.unit/f.days,0) unit
      from analytics.util.warehouse_date d
      left join csv_uploads.HISTORICAL_FORECAST f on f.start_date <= d.date and f.end_date >= d.date
      where d.date >= '2019-01-01'
        and d.date < '2020-01-01'
  ;; }

      dimension_group: forecasted_date {
        label: "Forecast"
        type: time
        timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
        convert_tz: no
        datatype: date
        sql: ${TABLE}.forecasted_date ;; }

      dimension: Before_today{
        group_label: "Forecast Date"
        label: "z - Is Before Today (mtd)"
        #hidden:  yes
        description: "This field is for formatting on (week/month/quarter/year) to date reports"
        type: yesno
        sql: ${TABLE}.forecasted_date < current_date;; }

      dimension: forecast_made {
        type:  string
        sql:${TABLE}.forecast_made ;; }

      dimension: sku_id {
        type:  string
        sql:${TABLE}.sku_id ;; }

    dimension: channel {
      type:  string
      sql:${TABLE}.channel ;; }

    dimension: account {
      type:  string
      sql:${TABLE}.account ;; }

      measure: unit {
        label: "Total Units"
        type:  sum
        value_format: "#,##0"
        sql:${TABLE}.unit ;; }

      measure: amount {
        label: "Total Amount"
        type:  sum
        value_format: "$#,##0.00"
        sql:${TABLE}.amount ;; }

      measure: total_amount_million {
        label: "Total Amount (millions)"
        type:  sum
        value_format: "$#,##0.00,,\" M\""
        sql:${TABLE}.total_amount ;; }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sku_id}, ${forecasted_date_date}) ;;
    hidden: yes
  }
}
