view: date_meta {
  derived_table: {
    sql:
      select date
          , row_number () over (partition by date_part('quarter',date), date_part('year',date) order by date) as day_in_quarter
      from util.warehouse_date
      where date between '2015-01-01' and '2022-12-31';;}

  dimension: date {
    type: date
    sql: ${TABLE}.date::date ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: date_group {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    sql: ${TABLE}.date ;;
    hidden: no
  }

  dimension: DAY_OF_QUARTER {
    type: number
    hidden: yes
    sql: ${TABLE}.day_in_quarter ;;
  }

}
