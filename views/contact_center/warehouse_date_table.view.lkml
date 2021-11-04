view: warehouse_date_table {
  sql_table_name: "UTIL"."WAREHOUSE_DATE"
    ;;

  set: default_fields {
    fields: [
      date_date,
      date_month,
      date_week,
      date_quarter,
      date_year
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: day_in_month {
    type: number
    sql: ${TABLE}."DAY_IN_MONTH" ;;
  }

  dimension: day_in_week_of_month {
    type: number
    sql: ${TABLE}."DAY_IN_WEEK_OF_MONTH" ;;
  }

  dimension: day_name {
    type: string
    sql: ${TABLE}."DAY_NAME" ;;
  }

  dimension: day_of_quarter {
    type: number
    sql: ${TABLE}."DAY_OF_QUARTER" ;;
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}."DAY_OF_WEEK" ;;
  }

  dimension: day_of_year {
    type: number
    sql: ${TABLE}."DAY_OF_YEAR" ;;
  }

  dimension: is_us_holiday {
    type: number
    sql: ${TABLE}."IS_US_HOLIDAY" ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}."MONTH" ;;
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}."MONTH_NAME" ;;
  }

  dimension: quarter {
    type: number
    sql: ${TABLE}."QUARTER" ;;
  }

  dimension: us_holiday {
    type: string
    sql: ${TABLE}."US_HOLIDAY" ;;
  }

  dimension: week_of_month {
    type: number
    sql: ${TABLE}."WEEK_OF_MONTH" ;;
  }

  dimension: week_of_quarter {
    type: number
    sql: ${TABLE}."WEEK_OF_QUARTER" ;;
  }

  dimension: week_of_year {
    type: number
    sql: ${TABLE}."WEEK_OF_YEAR" ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}."YEAR" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE" ;;
  }

  dimension_group: first_day_of_month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FIRST_DAY_OF_MONTH" ;;
  }

  dimension_group: last_day_of_month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."LAST_DAY_OF_MONTH" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: date_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."DATE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [month_name, day_name]
  }
}
