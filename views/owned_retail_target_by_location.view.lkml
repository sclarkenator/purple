view: owned_retail_target_by_location {

  derived_table: {
    sql: select b.date
    , a.store_id
    , a.target/days as target
    from analytics.csv_uploads.RETAIL_STORE_TARGETS a
    left join (
    select distinct a.start_date
    , a.end_date
    , b.date
    from analytics.csv_uploads.RETAIL_STORE_TARGETS a
    left join analytics.util.warehouse_date b on b.date::date >= a.start_date::date and b.date::date <= a.end_date
    ) b on b.start_date = a.start_date and b.end_date = a.end_date
    left join (
    select z.start_date
    , count (z.date) as days
    from (
    select distinct a.start_date
    , a.end_date
    , b.date
    from analytics.csv_uploads.RETAIL_STORE_TARGETS a
    left join analytics.util.warehouse_date b on b.date::date >= a.start_date::date and b.date::date <= a.end_date
    ) z
    group by z.start_date
    ) c on c.start_date = a.start_date ;;}

  dimension_group: date {
    label: "Forecast"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;; }

  dimension: store_id {
    label: "Retail store ID"
    description: "Store ID"
    type: string
    sql: ${TABLE}.store_id ;;
    hidden: no
}


dimension: store_name{
  label: "Store Name"
  description: "Manually grouped from store ID"
  type: string
  sql: case when ${store_id} = 'CA-01' then 'San Diego'
  when ${store_id} = 'CA-02' then 'Santa Clara'
  when ${store_id} = 'CA-03' then 'Santa Monica'
  when ${store_id} = 'WA-01' then 'Seattle'
  when ${store_id} in ('FO-01','FO_01') then 'Salt Lake'
  when ${store_id} = 'UT-01' then 'Showroom'
  else ${store_id} end;;}

  dimension: start_date{
    hidden: no
    type: date
    sql: ${TABLE}.start_date ;;
}

  dimension: end_date {
    hidden: no
    type: date
    sql: ${TABLE}.end_date ;;
}

  measure: target {
    label: " Target ($)"
    description: "Target amount for owned retail"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.target ;;
  }
 }
