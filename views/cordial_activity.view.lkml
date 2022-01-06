view: cordial_activity {
  sql_table_name: "MARKETING"."CORDIAL_ACTIVITY";;

  dimension: action {
    type: string
    sql: ${TABLE}."ACTION" ;;
  }

  dimension: bm_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."BM_ID" ;;
  }

  dimension: c_id {
    type: string
    hidden: yes
    sql: ${TABLE}."C_ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension_group: time {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."TIME" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
