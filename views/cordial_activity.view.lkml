view: cordial_activity {
  sql_table_name: "MARKETING"."CORDIAL_ACTIVITY"
    ;;

  dimension: action {
    type: string
    sql: ${TABLE}."ACTION" ;;
  }

  dimension: bm_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."BM_ID" ;;
  }

  dimension: c_id {
    type: string
    sql: ${TABLE}."C_ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: insert_ts {
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

  dimension_group: time {
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
    sql: ${TABLE}."TIME" ;;
  }

  dimension_group: update_ts {
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
    drill_fields: []
  }
}
