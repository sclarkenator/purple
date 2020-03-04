view: production_goal {
  sql_table_name: "PRODUCTION"."PRODUCTION_GOAL"
    ;;

  dimension: day_name {
    type: string
    sql: ${TABLE}."DAY_NAME" ;;
  }

  dimension: fg_produced {
    type: number
    sql: ${TABLE}."FG_PRODUCED" ;;
  }

  dimension_group: forecast {
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
    sql: ${TABLE}."FORECAST" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}."MONTH" ;;
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}."MONTH_NAME" ;;
  }

  dimension: peak_produced {
    type: number
    sql: ${TABLE}."PEAK_PRODUCED" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: us_holiday {
    type: string
    sql: ${TABLE}."US_HOLIDAY" ;;
  }

  dimension: work_hours {
    type: number
    sql: ${TABLE}."WORK_HOURS" ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}."YEAR" ;;
  }

  measure: count {
    type: count
    drill_fields: [day_name, month_name]
  }
}
