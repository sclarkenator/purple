view: ltol_line {
  label: "L2L Line Information"
  sql_table_name: L2L.LINE ;;

  dimension: line_id {
    primary_key: yes
    description: "Source: l2l.line"
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: abbreviation {
    label: "Display Name"
    description: "Source: l2l.line"
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
    description: "Source: l2l.line"
    type: string
    sql: case when ${TABLE}."DESCRIPTION" = 'Scrim Line Red Max 2 and 5' then 'Scrim Red'
      when ${TABLE}."DESCRIPTION" = 'Scrim Line Blue Max 3 and 4' then 'Scrim Blue'
      when ${TABLE}."DESCRIPTION" = 'Regrind Line' then 'Regrind'
      when ${TABLE}."DESCRIPTION" = 'Max One Line' then 'Max 1'
      when ${TABLE}."DESCRIPTION" = 'Max Two Line' then 'Max 2'
      when ${TABLE}."DESCRIPTION" = 'Max Three Line' then 'Max 3'
      when ${TABLE}."DESCRIPTION" = 'Max Four Line' then 'Max 4'
      when ${TABLE}."DESCRIPTION" = 'Max Five Line' then 'Max 5'
      when ${TABLE}."DESCRIPTION" = 'Max Six Line' then 'Max 6'
      when ${TABLE}."DESCRIPTION" = 'Max Seven Line' then 'Max 7'
      when ${TABLE}."DESCRIPTION" = 'Line One Glue' then 'Glue 1'
      when ${TABLE}."DESCRIPTION" = 'Line Two Glue' then 'Glue 2'
      when ${TABLE}."DESCRIPTION" = 'Line Three Glue' then 'Glue 3'
      when ${TABLE}."DESCRIPTION" = 'Line Four Glue' then 'Glue 4'
      when ${TABLE}."DESCRIPTION" = 'Line One Roll Pack' then 'Roll Pack 1'
      when ${TABLE}."DESCRIPTION" = 'Line Two Roll Pack' then 'Roll Pack 2'
      when ${TABLE}."DESCRIPTION" = 'Line Three Roll Pack' then 'Roll Pack 3'
      when ${TABLE}."DESCRIPTION" = 'Line Four Roll Pack' then 'Roll Pack 4'
      else ${TABLE}."DESCRIPTION" end ;;
  }

  dimension: line_name_bucket {
    description: "Source: Looker Calculation"
    type: string
    sql: case
      when ${Line_name} = 'Line One Glue' and  ${Line_name} = 'Line One Roll Pack' then 'Assembly Line 1'
      when ${Line_name} = 'Line Two Glue' and  ${Line_name} = 'Line Two Roll Pack' then 'Assembly Line 2'
      when ${Line_name} = 'Line Three Glue' and  ${Line_name} = 'Line Three Roll Pack' then 'Assembly Line 3'
      when ${Line_name} = 'Line Four Glue' and  ${Line_name} = 'Line Four Roll Pack' then 'Assembly Line 4'
      else ${Line_name} end;;
  }

  dimension: downtime_rate {
    description: "Source: l2l.line"
    type: number
    sql: ${TABLE}."DOWNTIME_RATE" ;;
  }

  dimension: inactive {
    description: "Source: l2l.line"
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
    sql: ${TABLE}."SITE";;
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
