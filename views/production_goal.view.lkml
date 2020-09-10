view: production_goal {
  sql_table_name: "PRODUCTION"."PRODUCTION_GOAL"
    ;;

  dimension: pk {
    label: "Primary key for Production Goal"
    primary_key: yes
    hidden: yes
    type: date
    sql: ${TABLE}."FORECAST" ;;
  }

  dimension: day_name {
    hidden: yes
    type: string
    sql: ${TABLE}."DAY_NAME" ;;
  }

  dimension: fg_produced {
    hidden: yes
    type: number
    sql: ${TABLE}."FG_PRODUCED" ;;
  }

  dimension_group: forecast {
    view_label: "Production Goals"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FORECAST" ;;
  }

  dimension_group: current {
    label: "Current"
    description:  "Current Time/Date for calculations"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

  dimension: month {
    hidden: yes
    type: number
    sql: ${TABLE}."MONTH" ;;
  }

  dimension: month_name {
    hidden: yes
    type: string
    sql: ${TABLE}."MONTH_NAME" ;;
  }

  dimension: peak_produced {
    hidden: yes
    type: number
    sql: ${TABLE}."PEAK_PRODUCED" ;;
  }

  dimension: us_holiday {
    label: "Holdiay Name (USA)"
    view_label: "Production Goals"
    type: string
    sql: ${TABLE}."US_HOLIDAY" ;;
  }

  dimension: work_hours {
    label: "Work Hours"
    view_label: "Production Goals"
    description: "Number of Work Hours per Day"
    type: number
    sql: ${TABLE}."WORK_HOURS" ;;
  }

  measure: work_hours_measure {
    label: "Work Hours"
    view_label: "Production Goals"
    description: "Number of Work Hours per Day"
    type: sum
    sql: ${TABLE}."WORK_HOURS" ;;
  }

  dimension: year {
    hidden: yes
    type: number
    sql: ${TABLE}."YEAR" ;;
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

}
