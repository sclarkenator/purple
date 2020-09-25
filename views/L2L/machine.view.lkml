view: machine {
  sql_table_name: "L2L"."MACHINE"
    ;;
  drill_fields: [machine_id]

  dimension: machine_id {
    primary_key: yes
    description: "Source: l2l.machine"
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension: area_id {
    hidden: yes
    type: number
    sql: ${TABLE}."AREA_ID" ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: critical {
    hidden: yes
    type: number
    sql: ${TABLE}."CRITICAL" ;;
  }

  dimension: description {
    description: "Source: l2l.machine"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: down_count {
    description: "Source: l2l.machine"
    type: number
    sql: ${TABLE}."DOWN_COUNT" ;;
  }

  dimension_group: inactivated {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."INACTIVATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: line_id {
    hidden: yes
    type: number
    sql: ${TABLE}."LINE_ID" ;;
  }

  dimension: machine_code {
    description: "Source: l2l.machine"
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: model_name {
    hidden: yes
    type: string
    sql: ${TABLE}."MODEL_NAME" ;;
  }

  dimension: production {
    hidden: yes
    type: number
    sql: ${TABLE}."PRODUCTION" ;;
  }

  dimension: serial_number {
    hidden: yes
    type: string
    sql: ${TABLE}."SERIAL_NUMBER" ;;
  }

  dimension: short_description {
    description: "Source: l2l.machine"
    label: "Display Name"
    type: string
    sql: ${TABLE}."SHORT_DESCRIPTION" ;;
  }

  dimension: site_id {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE_ID" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [machine_id, model_name]
  }
}
