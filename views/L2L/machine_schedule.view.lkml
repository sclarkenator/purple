view: machine_schedule {
  sql_table_name: "L2L"."MACHINE_SCHEDULE"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    label: "Scheduled ID"
    description: "Source: l2l.machine_schedule"
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: schedule_created {
    description: "Source: l2l.machine_schedule"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    hidden: yes
    type: string
    sql: ${TABLE}."CREATEDBY" ;;
  }

  dimension_group: schedule_due {
    description: "Source: l2l.machine_schedule"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."DUE" ;;
  }

  dimension: eventschedule {
    hidden: yes
    type: number
    sql: ${TABLE}."EVENTSCHEDULE" ;;
  }

  dimension_group: lastcompleted {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."LASTCOMPLETED" ;;
  }

  dimension: lastcyclecompleted {
    hidden: yes
    type: number
    sql: ${TABLE}."LASTCYCLECOMPLETED" ;;
  }

  dimension_group: lastlaunched {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."LASTLAUNCHED" ;;
  }

  dimension_group: lastupdated {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."LASTUPDATED" ;;
  }

  dimension: lastupdatedby {
    hidden: yes
    type: string
    sql: ${TABLE}."LASTUPDATEDBY" ;;
  }

  dimension_group: launch {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."LAUNCH" ;;
  }

  dimension: launchprior {
    hidden: yes
    type: number
    sql: ${TABLE}."LAUNCHPRIOR" ;;
  }

  dimension: machine {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: occurrencecount {
    description: "Source: l2l.machine_schedule"
    type: number
    sql: ${TABLE}."OCCURRENCECOUNT" ;;
  }

  dimension: open {
    description: "Source: l2l.machine_schedule"
    type: yesno
    sql: ${TABLE}."OPEN" ;;
  }

  dimension_group: scheduled {
    description: "Source: l2l.machine_schedule"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."SCHEDULED" ;;
  }

  dimension: scheduleprior {
    hidden: yes
    type: number
    sql: ${TABLE}."SCHEDULEPRIOR" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension: suspended {
    hidden: yes
    type: yesno
    sql: ${TABLE}."SUSPENDED" ;;
  }

  dimension: suspendedby {
    hidden: yes
    type: string
    sql: ${TABLE}."SUSPENDEDBY" ;;
  }

  dimension_group: suspendedon {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."SUSPENDEDON" ;;
  }

  dimension: tooling {
    hidden: yes
    type: number
    sql: ${TABLE}."TOOLING" ;;
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
