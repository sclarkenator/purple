view: forecast_snapshot {
sql_table_name: analytics.forecast.monthly_snapshot
  ;;

dimension: primary_key {
  primary_key: yes
  sql: CONCAT(${sku_id}, ${date_date}, ${account}, ${channel}) ;;
  hidden: yes
}

dimension_group: date {
  label: "Forecast"
  type: time
  timeframes: [date, day_of_week, day_of_month, week, month, month_name, quarter, quarter_of_year, year, week_of_year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.forecast ;; }

dimension: snapshot_month {
  type: date
  convert_tz: no
  datatype: date
  sql: ${TABLE}.month ;; }

# dimension: date_week_of_year {
#   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
#   type: number
#   group_label: "Forecast Date"
#   label: "Forecast Week of Year"
#   description: "2021 adjusted week of year number"
#   sql: case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 1
#               when ${date_year::number}=2021 then date_part(weekofyear,${date_date::date}) + 1
#               else date_part(weekofyear,${date_date::date}) end ;;
# }

dimension: Before_today{
  group_label: "Forecast Date"
  label: "z - Is Before Today (mtd)"
  description: "This field is for formatting on (week/month/quarter/year) to date reports"
  type: yesno
  sql: ${TABLE}.forecast < current_date;; }

dimension: current_week_num{
  group_label: "Forecast Date"
  label: "z - Before Current Week"
  type: yesno
  sql: date_trunc(week, ${TABLE}.forecast::date) < date_trunc(week, current_date) ;;}

dimension: week_offset{
  group_label: "Forecast Date"
  label: "z - Week Offset"
  type: number
  sql: date_part('week',current_date) - date_part('week',${TABLE}.forecast) ;; }

dimension: 6_weeks{
  group_label: "Forecast Date"
  label: "z - Before 6 Weeks Later"
  type: yesno
  sql: date_part('week',${TABLE}.forecast) < (date_part('week',current_date)+6);; }

dimension: prev_week{
  group_label: "Forecast Date"
  label: "z - Previous Week"
  type: yesno
  sql:  date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

dimension: cur_week{
  group_label: "Forecast Date"
  label: "z - Current Week"
  type: yesno
  sql: date_trunc(week, ${TABLE}.forecast) = date_trunc(week, current_date) ;;}

  dimension: week_bucket{
    group_label: "Forecast Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    # sql:  CASE WHEN ${date_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${date_year} = date_part (year,current_date) THEN 'Current Week'
    #   WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) THEN 'Last Week'
    #   WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
    #   WHEN ${date_week_of_year} = date_part (weekofyear,current_date) +1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
    #   WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
    #   WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
    # ELSE 'Other' END ;;
    sql:  CASE WHEN ${date_week_of_year} = 1  AND ${date_year} = 2022 THEN 'Current Week'
    WHEN ${date_date} >= '2021-12-27' AND ${date_date} <= '2022-01-02' THEN 'Last Week'
    WHEN ${date_week_of_year} = 51 AND ${date_year} = 2021 THEN 'Two Weeks Ago'
    WHEN ${date_week_of_year} = 1  AND ${date_year} = 2021 THEN 'Current Week LY'
    WHEN ${date_week_of_year} = 52 AND ${date_year} = 2021 THEN 'Last Week LY'
    WHEN ${date_week_of_year} = 51 AND ${date_year} = 2021 THEN 'Two Weeks Ago LY'
    ELSE 'Other' END;;
    }


  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;; }

  dimension: channel {
    type:  string
    sql:${TABLE}.channel ;; }

  dimension: account {
    type:  string
    sql:${TABLE}.account ;; }

  measure: total_units {
    label: "Total Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.total_units ;; }

  measure: total_amount {
    label: "Total Amount"
    type:  sum
    value_format: "$#,##0"
    sql:${TABLE}.total_sales ;; }
  }
