view: v_dispatch_with_downtime_minutes {
  sql_table_name: "L2L"."V_DISPATCH_WITH_DOWNTIME_MINUTES"
    ;;

dimension: id_date {
  primary_key: yes
  hidden: yes
  type: string
  sql: ${dispatch_id}||'-'||${dispatch_date}  ;;
}

  dimension: assigned_techs {
    hidden: yes
    type: string
    sql: ${TABLE}."ASSIGNED_TECHS" ;;
  }

  dimension_group: completed {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."COMPLETED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    hidden: yes
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: description {
    hidden: yes
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_id {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_ID" ;;
  }

  dimension: dispatch_number {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension: dispatch_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_TYPE_ID" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_updated_by {
    hidden: yes
    type: string
    sql: ${TABLE}."LAST_UPDATED_BY" ;;
  }

  dimension: machine_id {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension_group: reported {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."REPORTED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: technicians {
    hidden: yes
    type: string
    sql: ${TABLE}."TECHNICIANS" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: downtime {
    hidden: yes
    type: number
    sql: ${TABLE}."DOWNTIME" ;;
  }

  dimension: dispatch_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_MINUTES" ;;
  }

  dimension_group: dispatched {
    group_label: "Advanced"
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."DISPATCHED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: dispatch {
    description: "To be used with the Data by Date Measures; Source: l2l.v_dispatch_wtih_downtime_minutes"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."DISPATCH_DATE" ;;
  }

  dimension: reason_code {
    hidden: yes
    description: "Dispatch Reason Code; Source:l2l.v_dispatch_with_downtime_minutes"
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  measure: downtime_minutes {
    type: sum
    description: "Source: l2l.v_dispatch_with_downtime_minutes"
    value_format: "#,##0"
    sql: ${dispatch_minutes} ;;
  }

  measure: downtime_hours {
    type: sum
    description: "Source: Looker Calculation"
    value_format: "#,##0.00"
    sql: ${dispatch_minutes}/60 ;;
  }

  measure: dispatch_occurences {
    type: count_distinct
    description: "Source: Looker Calculation"
    sql: ${dispatch_number} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
