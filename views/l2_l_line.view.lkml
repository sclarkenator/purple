view: ltol_line {
  label: "L2L Line Information"
  sql_table_name: L2L.LINE ;;

  dimension: line_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: abbreviation {
    label: "Display Name"
    type: string
    sql: ${TABLE}."ABBREVIATION" ;;
  }

  dimension: area {
    type: number
    hidden: yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension: areacode {
    label: "Area Name"
    type: string
    hidden: yes
    sql: ${TABLE}."AREACODE" ;;
  }

  dimension: code {
    type: string
    hidden: yes
    sql: ${TABLE}."CODE" ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    type: string
    hidden: yes
    sql: ${TABLE}."CREATEDBY" ;;
  }

  dimension: Line_name {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: downtime_rate {
    type: number
    sql: ${TABLE}."DOWNTIME_RATE" ;;
  }

  dimension: inactive {
    type: string
    sql: ${TABLE}."INACTIVE" ;;
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

  dimension_group: lastupdated {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."LASTUPDATED" ;;
  }

  dimension: lastupdatedby {
    type: string
    hidden: yes
    sql: ${TABLE}."LASTUPDATEDBY" ;;
  }

  dimension: pitch_schedule_template {
    hidden: yes
    type: number
    sql: ${TABLE}."PITCH_SCHEDULE_TEMPLATE" ;;
  }

  dimension: production_order {
    hidden: yes
    type: number
    sql: ${TABLE}."PRODUCTION_ORDER" ;;
  }

  dimension: site {
    hidden: yes
    type: string
    sql: case when ${TABLE}.SITE = '2' then 'West'
                   when ${TABLE}.SITE = '3' then 'Alpine'
                   else 'Other'
              end;;
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

  measure: count {
    type: count
    drill_fields: [line_id]
  }
}
