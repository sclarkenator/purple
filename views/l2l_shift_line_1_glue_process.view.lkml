view: l2l_shift_line_1_glue_process {
  sql_table_name: "L2L"."SHIFT_LINE_1_GLUE_PROCESS"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: auto_line_1 {
    type: string
    sql: ${TABLE}."AUTO_LINE_1" ;;
  }

  dimension: average_open_time {
    type: string
    sql: ${TABLE}."AVERAGE_OPEN_TIME" ;;
  }

  dimension: coater_height {
    type: string
    sql: ${TABLE}."COATER_HEIGHT" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: d_sec_delay {
    type: string
    sql: ${TABLE}."D_SEC_DELAY" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: dwell_tamp_time_1 {
    type: string
    sql: ${TABLE}."DWELL_TAMP_TIME_1" ;;
  }

  dimension: dwell_tamp_time_2 {
    type: string
    sql: ${TABLE}."DWELL_TAMP_TIME_2" ;;
  }

  dimension: glue_block_test_left {
    type: string
    sql: ${TABLE}."GLUE_BLOCK_TEST_LEFT" ;;
  }

  dimension: glue_block_test_middle {
    type: string
    sql: ${TABLE}."GLUE_BLOCK_TEST_MIDDLE" ;;
  }

  dimension: glue_block_test_right {
    type: string
    sql: ${TABLE}."GLUE_BLOCK_TEST_RIGHT" ;;
  }

  dimension: glue_level {
    type: string
    sql: ${TABLE}."GLUE_LEVEL" ;;
  }

  dimension: glue_pump_air_pressure {
    type: string
    sql: ${TABLE}."GLUE_PUMP_AIR_PRESSURE" ;;
  }

  dimension: glue_trough_depth {
    type: string
    sql: ${TABLE}."GLUE_TROUGH_DEPTH" ;;
  }

  dimension: glue_vendor {
    type: string
    sql: ${TABLE}."GLUE_VENDOR" ;;
  }

  dimension: humidity {
    type: string
    sql: ${TABLE}."HUMIDITY" ;;
  }

  dimension: ir_power {
    type: string
    sql: ${TABLE}."IR_POWER" ;;
  }

  dimension: ir_speed {
    type: string
    sql: ${TABLE}."IR_SPEED" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: mattress_temp_out_of_ir {
    type: string
    sql: ${TABLE}."MATTRESS_TEMP_OUT_OF_IR" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}."PRODUCT_TYPE" ;;
  }

  dimension: roll_coater_idle_speed {
    type: string
    sql: ${TABLE}."ROLL_COATER_IDLE_SPEED" ;;
  }

  dimension: roll_coater_running_speed {
    type: string
    sql: ${TABLE}."ROLL_COATER_RUNNING_SPEED" ;;
  }

  dimension: roller_push_into_foam {
    type: string
    sql: ${TABLE}."ROLLER_PUSH_INTO_FOAM" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tamp_height_crush_1 {
    type: string
    sql: ${TABLE}."TAMP_HEIGHT_CRUSH_1" ;;
  }

  dimension: tamp_height_crush_2 {
    type: string
    sql: ${TABLE}."TAMP_HEIGHT_CRUSH_2" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: temp {
    type: string
    sql: ${TABLE}."TEMP" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }

  measure: average_open_time_measure{
    type: average
    label: "Average Open Time"
    sql: ${TABLE}.AVERAGE_OPEN_TIME;;

  }

  measure: temp_measure{
    type: average
    label: "Temp"
    sql: ${TABLE}.TEMP ;;
    }

  measure: glue_block_test_left_measure {
    type: average
    label: "Glue Block Test Left"
    sql: ${TABLE}.GLUE_BLOCK_TEST_LEFT ;;
  }

  measure: glue_block_test_middle_measure {
    type: average
    label: "Glue Block Test Left"
    sql: ${TABLE}.GLUE_BLOCK_TEST_MIDDLE ;;
  }

  measure: glue_block_test_right_measure{
    type: average
    label: "Glue Block Test Left"
    sql: ${TABLE}.GLUE_BLOCK_TEST_RIGHT ;;
  }

}
