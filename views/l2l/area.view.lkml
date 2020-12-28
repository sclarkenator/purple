view: area {
  sql_table_name: "L2L"."AREA"
    ;;
  drill_fields: [area_id]

  dimension: area_id {
    primary_key: yes
    label: "Area ID"
    description: "Source: l2l.area"
    type: number
    sql: ${TABLE}."AREA_ID" ;;
  }

  dimension: description {
    label: "Description"
    description: "Full name of Area (Upstream, Downstream, etc); Source: l2l.area"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: name {
    label: "Display Name"
    description: "Display Name as shown in L2L (US, DS, etc); Source: l2l.area"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: site_id {
    label: "Site ID"
    description: "Manufacturing Site ID (2 = PWest, 3 = Alpine); Source: l2l.area"
    type: number
    sql: ${TABLE}."SITE_ID" ;;
  }

  dimension_group: created {
    hidden: yes
    description: "Source: l2l.area"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
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
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [area_id, name]
  }
}
