view: bin {
  sql_table_name: "HIGHJUMP"."BIN"
    ;;

  dimension: allow_negative {
    type: yesno
    sql: ${TABLE}."ALLOW_NEGATIVE" ;;
  }

  dimension: auto_break {
    type: number
    sql: ${TABLE}."AUTO_BREAK" ;;
  }

  dimension: bin_label {
    type: string
    sql: ${TABLE}."BIN_LABEL" ;;
  }

  dimension: bin_type {
    type: string
    sql: ${TABLE}."BIN_TYPE" ;;
  }

  dimension: comment_in {
    type: string
    sql: ${TABLE}."COMMENT_IN" ;;
  }

  dimension: con_expiry {
    type: yesno
    sql: ${TABLE}."CON_EXPIRY" ;;
  }

  dimension: con_fifo {
    type: yesno
    sql: ${TABLE}."CON_FIFO" ;;
  }

  dimension: con_recvpo {
    type: yesno
    sql: ${TABLE}."CON_RECVPO" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }


  dimension: is_empty {
    type: yesno
    sql: ${TABLE}."IS_EMPTY" ;;
  }

  dimension: is_random {
    type: yesno
    sql: ${TABLE}."IS_RANDOM" ;;
  }

  dimension: is_sticky {
    type: yesno
    sql: ${TABLE}."IS_STICKY" ;;
  }

  dimension: keep_lp {
    type: yesno
    sql: ${TABLE}."KEEP_LP" ;;
  }

  dimension_group: last_count {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."LAST_COUNT" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: non_rb {
    type: yesno
    sql: ${TABLE}."NON_RB" ;;
  }

  dimension: pack_size {
    type: number
    sql: ${TABLE}."PACK_SIZE" ;;
  }

  dimension: pick_complete {
    type: yesno
    sql: ${TABLE}."PICK_COMPLETE" ;;
  }

  dimension: skip_count {
    type: yesno
    sql: ${TABLE}."SKIP_COUNT" ;;
  }

  dimension: uniform_lp {
    type: yesno
    sql: ${TABLE}."UNIFORM_LP" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: ws_counted {
    type: number
    sql: ${TABLE}."WS_COUNTED" ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}."ZONE" ;;
  }

  measure: count {
    type: count_distinct
    sql: ${bin_label} ;;
  }

}
