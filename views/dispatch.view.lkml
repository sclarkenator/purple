view: dispatch {
  sql_table_name: "L2L"."DISPATCH"
    ;;
  drill_fields: [dispatch_id]

  dimension: dispatch_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."DISPATCH_ID" ;;
  }

  dimension: assigned_techs {
    type: string
    sql: ${TABLE}."ASSIGNED_TECHS" ;;
  }

  dimension_group: dispatch_completed {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."COMPLETED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: dispatch_created {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: description {
    label: "Dispatch Description"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_number {
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension: dispatch_type_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."DISPATCH_TYPE_ID" ;;
  }

  dimension_group: dispatched {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."DISPATCHED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: downtime {
    type: number
    sql: ${TABLE}."DOWNTIME" ;;
  }

  dimension: last_updated_by {
    type: string
    sql: ${TABLE}."LAST_UPDATED_BY" ;;
  }

  dimension: machine_id {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension_group: dispatch_reported {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."REPORTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: technicians {
    type: string
    sql: ${TABLE}."TECHNICIANS" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [dispatch_id, dispatch_type.dispatch_type_id]
  }
}
