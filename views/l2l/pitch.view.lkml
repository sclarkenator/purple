view: ltol_pitch {
  label: "L2L Pitch Data"
 # sql_table_name: L2L.PITCH ;;

derived_table: {
  sql: select * from ANALYTICS.L2L.Pitch where delete_ts is null;;
  }

## Hidden by Jared to fix nulling max machine data - 09/01/2021
##  select *
##  from (
##    select *
##        , row_number () over(partition by pitch_start, area, line order by id desc) as row_num
##    from ANALYTICS.L2L.Pitch
## ) z
## where z.row_num = 1 and delete_ts is null;;


  dimension: pitch_id {
    primary_key: yes
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    hidden: no
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
  }

  dimension: actual_product {
    hidden: yes
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

  dimension: comment {
    hidden: no
    description: "Source: l2l.pitch"
    type: string
    sql: ${TABLE}."COMMENT" ;;
  }

  dimension_group: created {
    hidden: yes
    description: "Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    hidden: no
    type: string
    sql: ${TABLE}."CREATEDBY" ;;
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
    hidden: yes
    description: "Source: l2l.pitch"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension_group: pitch_end {
    hidden: yes
    description: "Pitch Name (Start of Shift, End of Shift, Break, Lunch, etc); Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."PITCH_END" ;;
  }

  dimension_group: pitch_start {
    description: "Pitch is an Hour increment, a new Pitch starts every Hour; Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day,hour, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."PITCH_START" ;;
  }

  dimension: current_day_numb  {
    view_label: "Pitch"
    group_label: "Pitch Start Date"
    label: "z - Before Current Day"
    description: "Yes/No for if the date is before the current day of the year. Source: Looker Calculation"
    type: yesno
    sql: ${TABLE}.pitch_start::date < current_date ;;
  }

  dimension: current_week_numb {
    view_label: "Pitch"
    group_label: "Pitch Start Date"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is before the current week of the year. Source: Looker Calculation"
    type: yesno
    sql: date_trunc(week, ${TABLE}.pitch_start::date) < date_trunc(week, current_date) ;;
  }

  dimension: planned_product {
    hidden: yes
    description: "Source: l2l.pitch"
    type: number
    sql: ${TABLE}."PLANNED_PRODUCT" ;;
  }

  dimension: shift {
    hidden: yes
    description: "(Shift 1  is 7am-7pm, Shift 2 is 7pm-7am; Source: l2l.pitch"
    type: number
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension_group: shift_start {
    description: "Shift is from 7am - 7pm, Shift Start Date begins at 7am; Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."SHIFT_START_DATE" ;;
  }

  dimension_group: delete_ts {
    hidden: yes
    label: "Deleted"
    description: "Date and Time a Pitch was deleted; Source: l2l.pitch"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}."DELETE_TS" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension: actual_dim {
    hidden: yes
    description: "Total amount of Actual Product Produced; Source: l2l.pitch"
    type: number
    sql: ${TABLE}."ACTUAL" ;;
  }

  dimension: scrap_dim {
  hidden: yes
    description: "Total number of Actual Products Produced that are Scrap; Source: l2l.pitch"
    type: number
    sql: ${TABLE}."SCRAP" ;;
  }

  dimension: planned_production_minutes_dim {
    hidden: yes
    description: "Dimension Version of the Planned Production Minutes; Source l2l.pitch"
    type: number
    sql: ${TABLE}."PLANNED_PRODUCTION_MINUTES"  ;;
  }

  dimension: downtime_minutes_dim {
    hidden: yes
    description: "Dimension Version of the Downtime Minutes; Source l2l.pitch"
    type: number
    sql: ${TABLE}."DOWNTIME_MINUTES"  ;;
  }

  dimension: cycle_time_dim {
    hidden: yes
    description: "Dimension Version of the cylce Time; Source l2l.pitch"
    type:number
    sql: ${TABLE}."CYCLE_TIME" ;;
  }

  measure: theoretical_parts {
    description: "(Planned Production Minutes - Downtime Minutes) * 60 / Cycle Time; Source: Looker Calculation"
    type: sum
    value_format: "0.##"
    sql: ((${planned_production_minutes_dim}-${downtime_minutes_dim})*60/nullif(${cycle_time_dim},0)) ;;
  }

  measure: actual {
    description: "Total amount of Actual Product Produced; Source: l2l.pitch"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."ACTUAL" ;;
  }

  measure: scrap {
    label: "Scrap"
    description: "Total number of Actual products produced that are Scrap; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."SCRAP" ;;
  }

  measure: first_pass_yield{
    label: "FPY"
    description: "Total # of good parts produced divided by total number of shots"
    type: number
    value_format: "0.0%"
    sql: case when ${demand} = 0 then null else div0(${actual},${actual}+${scrap}) end;;
  }

  measure: throughput_percent{
    label: "Throughput %"
    description: "Actual good parts produced divided by pitch demand"
    type: number
    value_format: "0.0%"
    sql: case when ${demand} = 0 then null else div0(${actual},${demand}) end;;
  }

  measure: planned_production_minutes {
    description: "Total amount of Planned Minutes spent Producing; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."PLANNED_PRODUCTION_MINUTES" ;;
  }

  measure: downtime_minutes {
    description: "Total amount of Downtime Mintues; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."DOWNTIME_MINUTES" ;;
  }

  measure: cycle_time {
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."CYCLE_TIME" ;;
  }

  measure: changeover_earned_hours {
    hidden: yes
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."CHANGEOVER_EARNED_HOURS" ;;
  }

  measure: demand {
    description: "Total amount of Demanded Product to be Produced; Source: l2l.pitch"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."DEMAND" ;;
  }

  measure: earned_hours {
    hidden: yes
    description: "Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."EARNED_HOURS" ;;
  }

  measure: nonproduction_minutes {
    description: "Total amount of Non-Production Minutes; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."NONPRODUCTION_MINUTES" ;;
  }

  measure: operational_availability {
    description: "(Planned Production Minutes - Downtime Minutes)/Planned Production Mintues; Source: l2l.pitch"
    type: average
    value_format: "0.0%"
    sql: ${TABLE}."OPERATIONAL_AVAILABILITY"/100 ;;
  }

  measure: overall_equipment_effectiveness_L2L {
    hidden: yes
    description: "Operational Availability% * Quality% * Performance Per Part%; Source: l2l.pitch"
    value_format: "0.0%"
    type: average
    sql: ${TABLE}."OVERALL_EQUIPMENT_EFFECTIVENESS" ;;
  }

  measure: overall_equipment_effectiveness {
    label: "OEE"
    description: "FPY * OA * Throughput %"
    hidden: no
    type: number
    value_format: "0.0%"
    sql: ${first_pass_yield}*${throughput_percent}*${operational_availability} ;;
  }

  measure: total_operator_count {
    hidden: yes
    description: "Total number of Operators; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }

  measure: Avg_operator_count {
    hidden: yes
    description: "Average Operator Count; Source: l2l.pitch"
    type: average
    sql: ${TABLE}."OPERATOR_COUNT" ;;
  }

  measure: Total_planned_operator_count {
    hidden: yes
    description: "Total Planned Operator Count; Source: l2l.pitch"
    type: sum
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }

  measure: Avg_planned_operator_count {
    hidden: yes
    description: "Average Planned Operator Count; Source: l2l.pitch"
    type: average
    sql: ${TABLE}."PLANNED_OPERATOR_COUNT" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [pitch_id, name]
  }

  }
