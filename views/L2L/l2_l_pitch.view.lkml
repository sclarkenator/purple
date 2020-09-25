view: ltol_pitch {
  label: "L2L Pitch Data"
 # sql_table_name: L2L.PITCH ;;

derived_table: {
  sql: select * from (
    select *
        , row_number () over(partition by pitch_start, area, line order by id desc) as row_num
    from ANALYTICS.L2L.Pitch
) z
where z.row_num = 1;;
}

  dimension: pitch_id {
    primary_key: yes
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
  }

  measure: actual {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."ACTUAL" ;;
  }

  dimension: actual_product {
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."ACTUAL_PRODUCT" ;;
  }

  dimension: area {
    hidden: yes
    type: number
    sql: ${TABLE}."AREA" ;;
  }

  dimension: build_sequence {
    type: number
    hidden: yes
    sql: ${TABLE}."BUILD_SEQUENCE" ;;
  }

  measure: changeover_earned_hours {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."CHANGEOVER_EARNED_HOURS" ;;
  }

  dimension: comment {
    description: "Source: l2l.pitch"
    type: string
    sql: ${TABLE}."COMMENT" ;;
  }

  dimension_group: created {
    description: "Source: l2l.pitch"
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

  dimension: cycle_time {
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."CYCLE_TIME" ;;
  }

  measure: demand {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."DEMAND" ;;
  }

  measure: downtime_minutes {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."DOWNTIME_MINUTES" ;;
  }

  measure: earned_hours {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."EARNED_HOURS" ;;
  }

  dimension: has_actual_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_ACTUAL_DETAILS" ;;
  }

  dimension: has_operator_count_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_OPERATOR_COUNT_DETAILS" ;;
  }

  dimension: has_scrap_details {
    hidden: yes
    type: yesno
    sql: ${TABLE}."HAS_SCRAP_DETAILS" ;;
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

  dimension: line {
    hidden: yes
    type: number
    sql: ${TABLE}."LINE" ;;
  }

  dimension: name {
    description: "Source: l2l.pitch"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  measure: nonproduction_minutes {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."NONPRODUCTION_MINUTES" ;;
  }

  measure: operational_availability {
    description: "Source: l2l.pitch"
    type: average
    value_format: "0.0\%"
    sql: ${TABLE}."OPERATIONAL_AVAILABILITY" ;;
  }

  measure: total_operator_count {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }
  measure: Avg_operator_count {
    description: "Source: l2l.pitch"
    type: average
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }

  dimension: overall_equipment_effectiveness {
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."OVERALL_EQUIPMENT_EFFECTIVENESS" ;;
  }

  dimension_group: pitch_end {
    description: "Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."PITCH_END" ;;
  }

  dimension_group: pitch_start {
    description: "Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."PITCH_START" ;;
  }

  measure: Total_planned_operator_count {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }

  measure: Avg_planned_operator_count {
    description: "Source: l2l.pitch"
    type: average
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }

  dimension: planned_product {
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."PLANNED_PRODUCT" ;;
  }

  measure: planned_production_minutes {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."PLANNED_PRODUCTION_MINUTES" ;;
  }

  measure: scrap {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."SCRAP" ;;
  }

  dimension: shift {
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension_group: shift_start {
    description: "Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."SHIFT_START_DATE" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [pitch_id, name]
  }
}
