view: v_work_order_quality_checklist {
  sql_table_name: "L2L"."V_WORK_ORDER_QUALITY_CHECKLIST"
    ;;

  dimension: air_table_check {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."AIR_TABLE_CHECK" ;;
  }

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: bed_1_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_1_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_2_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_2_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_3_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_3_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_4_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_4_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_5_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_5_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_6_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_6_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_7_open_time_seconds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_7_OPEN_TIME_SECONDS" ;;
  }

  dimension: bed_num_120 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_120" ;;
  }

  dimension: bed_num_150 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_150" ;;
  }

  dimension: bed_num_180 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_180" ;;
  }

  dimension: bed_num_210 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_210" ;;
  }

  dimension: bed_num_30 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_30" ;;
  }

  dimension: bed_num_60 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_60" ;;
  }

  dimension: bed_num_90 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."BED_NUM_90" ;;
  }

  dimension: coater_height {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."COATER_HEIGHT" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: d_sec_delay_value {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."D_SEC_DELAY_VALUE" ;;
  }

  dimension: checklist_description {
    hidden: yes
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: number
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: dwell_tamp_time_1 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."DWELL_TAMP_TIME_1" ;;
  }

  dimension: dwell_tamp_time_2 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."DWELL_TAMP_TIME_2" ;;
  }

  dimension: glue_level {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_LEVEL" ;;
  }

  dimension: glue_test_left {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_TEST_LEFT" ;;
  }

  dimension: glue_test_middle {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_TEST_MIDDLE" ;;
  }

  dimension: glue_test_right {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_TEST_RIGHT" ;;
  }

  dimension: glue_to_roll_pack_bed_num {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_TO_ROLL_PACK_BED_NUM" ;;
  }

  dimension: glue_to_roll_pack_time_minutes {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."GLUE_TO_ROLL_PACK_TIME_MINUTES" ;;
  }

  dimension: glue_vendor {
    group_label: "Checklist Tasks/Questions"
    hidden: yes
    type: string
    sql: ${TABLE}."GLUE_VENDOR" ;;
  }

  dimension: humidity {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."HUMIDITY" ;;
  }

  dimension: inspect_holes_120 {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."INSPECT_HOLES_120" ;;
  }

  dimension: inspect_holes_150 {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."INSPECT_HOLES_150" ;;
  }

  dimension: inspect_holes_30 {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."INSPECT_HOLES_30" ;;
  }

  dimension: inspect_holes_60 {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."INSPECT_HOLES_60" ;;
  }

  dimension: inspect_holes_90 {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."INSPECT_HOLES_90" ;;
  }

  dimension: ir_power {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."IR_POWER" ;;
  }

  dimension: ir_speed {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."IR_SPEED" ;;
  }

  dimension: law_tag_correct {
    group_label: "Checklist Tasks/Questions"
    type: yesno
    sql: ${TABLE}."LAW_TAG_CORRECT" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: number
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: mattress_line {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."MATTRESS_LINE" ;;
  }

  dimension: mattress_temp_out_of_ir {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."MATTRESS_TEMP_OUT_OF_IR" ;;
  }

  dimension_group: modified {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: more_than_4_hours {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."MORE_THAN_4_HOURS" ;;
  }

  dimension: checklist_name {
    hidden: yes
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: non_inventory_items_correct {
    group_label: "Checklist Tasks/Questions"
    type: yesno
    sql: ${TABLE}."NON_INVENTORY_ITEMS_CORRECT" ;;
  }

  dimension: checklist_number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: number_of_beds {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."NUMBER_OF_BEDS" ;;
  }

  dimension: product {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: pull_test_1 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."PULL_TEST_1" ;;
  }

  dimension: pull_test_2 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."PULL_TEST_2" ;;
  }

  dimension: pull_test_3 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."PULL_TEST_3" ;;
  }

  dimension: roll_pack_settings_correct {
    group_label: "Checklist Tasks/Questions"
    type: yesno
    sql: ${TABLE}."ROLL_PACK_SETTINGS_CORRECT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tamp_height_crush_1 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."TAMP_HEIGHT_CRUSH_1" ;;
  }

  dimension: tamp_height_crush_2 {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."TAMP_HEIGHT_CRUSH_2" ;;
  }

  dimension: technology {
    hidden: yes
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: temp {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."TEMP" ;;
  }

  dimension: time_last_glue_test_performed {
    group_label: "Checklist Tasks/Questions"
    type: string
    sql: ${TABLE}."TIME_LAST_GLUE_TEST_PERFORMED" ;;
  }

  dimension: work_order_number {
    group_label: "Checklist Tasks/Questions"
    type: number
    sql: ${TABLE}."WORK_ORDER_NUMBER" ;;
  }

  measure: count {
    type: count
    drill_fields: [checklist_number]
  }
}
