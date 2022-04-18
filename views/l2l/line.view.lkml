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
    description: "Dispaly Name as shown in L2L (M2L, M3L, M4L, etc); Source: l2l.line"
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

  dimension: Line_name {
    description: "Line Name shown as Description in L2L (Max 1, Max 2, Max 3, etc); Source: l2l.line"
    type: string
    sql: case when ${TABLE}."DESCRIPTION" = 'Scrim Red' then 'Scrim Red'
          when ${TABLE}."DESCRIPTION" = 'Scrim Blue' then 'Scrim Blue'
          when ${TABLE}."DESCRIPTION" = 'Scrim yellow' then 'Scrim Yellow'
          when ${TABLE}."DESCRIPTION" = 'Scrim Line Purple' then 'Scrim Purple'
          when ${TABLE}."DESCRIPTION" = 'Scrim Line Orange' then 'Scrim Orange'
          when ${TABLE}."DESCRIPTION" = 'Scrim Line Brown' then 'Scrim Brown'
          when ${TABLE}."DESCRIPTION" = 'Regrind Line' then 'Regrind'
          when ${TABLE}."DESCRIPTION" = 'Max Line' then 'Max 1'
          when ${TABLE}."DESCRIPTION" = 'Max 2' then 'Max 2'
          when ${TABLE}."DESCRIPTION" = 'Max 3' then 'Max 3'
          when ${TABLE}."DESCRIPTION" = 'Max 4' then 'Max 4'
          when ${TABLE}."DESCRIPTION" = 'Max 5' then 'Max 5'
          when ${TABLE}."DESCRIPTION" = 'Max 6' then 'Max 6'
          when ${TABLE}."DESCRIPTION" = 'Max 7' then 'Max 7'
          when ${TABLE}."DESCRIPTION" = 'Max 8 Line' then 'Max 8'
          when ${TABLE}."DESCRIPTION" = 'Max 9 Line' then 'Max 9'
          when ${TABLE}."DESCRIPTION" = 'Max 10 Line' then 'Max 10'
          when ${TABLE}."DESCRIPTION" = 'Max 11 Line' then 'Max 11'
          when ${TABLE}."DESCRIPTION" = 'Max 12 Line' then 'Max 12'
          when ${TABLE}."DESCRIPTION" = 'Max 13 Line' then 'Max 13'
          when ${TABLE}."DESCRIPTION" = 'Max 14 Line' then 'Max 14'
          when ${TABLE}."DESCRIPTION" = 'Max 15 Line' then 'Max 15'
          when ${TABLE}."DESCRIPTION" = 'H-Max 1 Line' then 'H-Max 1'
          when ${TABLE}."DESCRIPTION" = 'H-Max 2 Line' then 'H-Max 2'
          when ${TABLE}."DESCRIPTION" = 'H-Max 3 Line' then 'H-Max 3'
          when ${TABLE}."DESCRIPTION" = 'H-Max 4 Line' then 'H-Max 4'
          when ${TABLE}."DESCRIPTION" = 'Line One Glue' then 'Glue 1'
          when ${TABLE}."DESCRIPTION" = 'Line Two Glue' then 'Glue 2'
          when ${TABLE}."DESCRIPTION" = 'Line Three Glue' then 'Glue 3'
          when ${TABLE}."DESCRIPTION" = 'Line Four Glue' then 'Glue 4'
          when ${TABLE}."DESCRIPTION" = 'Line Five Glue' then 'Glue 5'
          when ${TABLE}."DESCRIPTION" = 'Line Six Glue' then 'Glue 6'
          when ${TABLE}."DESCRIPTION" = 'Line Seven Glue' then 'Glue 7'
          when ${TABLE}."DESCRIPTION" = 'Rollpack 1' then 'Roll Pack 1'
          when ${TABLE}."DESCRIPTION" = 'Line Two Roll Pack' then 'Roll Pack 2'
          when ${TABLE}."DESCRIPTION" = 'Line Three Roll Pack' then 'Roll Pack 3'
          when ${TABLE}."DESCRIPTION" = 'Line Four Roll Pack' then 'Roll Pack 4'
          when ${TABLE}."DESCRIPTION" = 'Line Five Roll Pack' then 'Roll Pack 5'
          when ${TABLE}."DESCRIPTION" = 'Line Six Roll Pack' then 'Roll Pack 6'
          when ${TABLE}."DESCRIPTION" = 'Line Seven Roll Pack' then 'Roll Pack 7'
          when ${TABLE}."DESCRIPTION" ilike '%Injection Molding Line%' then replace(${TABLE}.DESCRIPTION,'Line')
        else ${TABLE}."DESCRIPTION" end  ;;
  }

  dimension: line_name_bucket {
    description: "Bucketed Line Name (Glue 1 + Roll Pack 1 = Assembly Line 1, etc); Source: Looker Calculation"
    hidden: yes
    type: string
    sql: case
      when ${Line_name} = 'Glue 1' or  ${Line_name} = 'Roll Pack 1' then 'Assembly Line 1'
      when ${Line_name} = 'Glue 2' or  ${Line_name} = 'Roll Pack 2' then 'Assembly Line 2'
      when ${Line_name} = 'Glue 3' or  ${Line_name} = 'Roll Pack 3' then 'Assembly Line 3'
      when ${Line_name} = 'Glue 4' or  ${Line_name} = 'Roll Pack 4' then 'Assembly Line 4'
      else ${Line_name} end;;
  }

  dimension: line_bucket{
    description: "Max Machine, Glue, Roll Pack, Scrim, IMM"
    type: string
    sql: case
            when ${Line_name} ilike '%Glue%' then 'Glue'
            when ${Line_name} ilike '%Max%' then 'Max Machine'
            when ${Line_name} ilike '%Roll%' then 'Roll Pack'
            when ${Line_name} ilike '%Scrim%' then 'Scrim'
            when ${Line_name} ilike 'Assembly Line%' then 'Assembly Line'
            when  ${TABLE}."DESCRIPTION" ilike '%Injection Molding Line%' then 'IMM'
            else ${Line_name} end;;
  }


  dimension: inactive {
    description: "Source: l2l.line"
    type: string
    sql: ${TABLE}."INACTIVE" ;;
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

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
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

  measure: downtime_rate {
    description: "Source: l2l.line"
    type: sum
    sql: ${TABLE}."DOWNTIME_RATE" ;;
  }

  measure: count {
    type: count
    drill_fields: [line_id]
  }
}
