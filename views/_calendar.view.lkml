view: _calendar {
  derived_table: {
    sql:
      select
        date_id,
        date,
        day_in_month,
        date = current_date as is_current_date,
        datediff(day,current_date,date) as day_diff,
        datediff(week,current_date,date) as week_diff,
        datediff(month,current_date,date) as month_diff,
        datediff(quarter,current_date,date) as quarter_diff,
        datediff(year,current_date,date) as year_diff,
        week_of_year,
        week_of_month,
        day_of_year,
        day_of_quarter,
        date_part(dayofweekiso,date) as day_of_week,
        us_holiday
      from analytics.util.warehouse_date
      ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.date_id ;;
  }

  dimension_group: created {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: time
    timeframes: [date, day_of_week,week, month,month_name,month_num, quarter, year, week_of_year]
    sql: ${TABLE}.date ;;
  }

  dimension: is_current_date {
    group_label: "Calendar"
    description: "Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.date = current_date ;;
  }

  dimension: day_in_month {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.day_in_month ;;
  }

  dimension: day_diff {
    group_label: "Calendar"
    label: "Day Difference"
    description: "The number of days from today. -1 is yesterday, 0 is today, 1 is tomorrow. Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.day_diff ;;
  }

  dimension: week_diff {
    group_label: "Calendar"
    label: "Week Difference"
    description: "Number of weeks from this week. Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.week_diff ;;
  }

  dimension: month_diff {
    group_label: "Calendar"
    label: "Month Difference"
    description: "Number of months from this month. Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.month_diff ;;
  }

  dimension: quarter_diff {
    group_label: "Calendar"
    label: "Quarter Difference"
    description: "Number of quarters from this quarter. Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.quarter_diff ;;
  }

  dimension: year_diff {
    group_label: "Calendar"
    label: "Year Difference"
    description: "Number of years from this year. Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.year_diff ;;
  }

  dimension: week_of_year {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.week_of_year ;;
  }

  dimension: week_of_month {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.week_of_month ;;
  }

  dimension: day_of_year {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.day_of_year ;;
  }

  dimension: day_of_quarter {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.day_of_quarter ;;
  }

  dimension: day_of_week {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: number
    sql: ${TABLE}.day_of_week ;;
  }

  dimension: us_holiday {
    group_label: "Calendar"
    description: "Source: snowflake.warehouse_date"
    type: string
    sql: ${TABLE}.us_holiday ;;
  }

  measure: min_date {
    type: min
    sql: ${TABLE}.date ;;
  }

}
