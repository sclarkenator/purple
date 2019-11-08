view: date_meta {
  derived_table: {
    sql:
      select date
          , row_number () over (partition by date_part('quarter',date), date_part('year',date) order by date) as day_in_quarter
      from util.warehouse_date
      where date between '2017-01-01' and '2020-12-31';;}

  dimension: date {
    type: date
    sql: ${TABLE}.date::date ;;
    primary_key: yes
    hidden: yes
  }

  dimension: DAY_OF_QUARTER {
    type: number
    hidden: yes
    sql: ${TABLE}.day_in_quarter ;;
  }

}
