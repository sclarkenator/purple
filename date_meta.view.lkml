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

  dimension: DAY_OF_QUARTER {
    type: number
    hidden: yes
    sql: ${TABLE}.day_in_quarter ;;
  }

  dimension: most_recent_day_of_quarter {
    label: "Highest Day of Current Quarter"
    type: number
    #hidden: yes
    sql: case when ${date} = current_date() then ${DAY_OF_QUARTER} end ;;
  }

}
