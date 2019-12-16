view: affirm_daily_lto_funnel {
  sql_table_name: ACCOUNTING.AFFIRM_DAILY_LTO_FUNNEL ;;

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

  dimension: merchant_name {
    type: string
    sql: ${TABLE}."MERCHANT_NAME" ;;
  }

  dimension: lto_applications {
    type: number
    sql: ${TABLE}."LTO_APPLICATIONS" ;;
  }

  dimension: lto_approvals {
    type: number
    sql: ${TABLE}."LTO_APPROVALS" ;;
  }

  dimension: lto_authed_volume {
    type: number
    sql: ${TABLE}."LTO_AUTHED_VOLUME" ;;
  }

  dimension: lto_auths {
    type: number
    sql: ${TABLE}."LTO_AUTHS" ;;
  }

  dimension: lto_eligible_declines {
    type: number
    sql: ${TABLE}."LTO_ELIGIBLE_DECLINES" ;;
  }

  dimension: lto_takeups {
    type: number
    sql: ${TABLE}."LTO_TAKEUPS" ;;
  }

  measure: total_lto_applications {
    type: sum
    sql: ${TABLE}."LTO_APPLICATIONS" ;;
  }

  measure: total_lto_approvals {
    type: sum
    sql: ${TABLE}."LTO_APPROVALS" ;;
  }

  measure: total_lto_authed_volume {
    type: sum
    sql: ${TABLE}."LTO_AUTHED_VOLUME" ;;
  }

  measure: total_lto_auths {
    type: sum
    sql: ${TABLE}."LTO_AUTHS" ;;
  }

  measure: total_lto_eligible_declines {
    type: sum
    sql: ${TABLE}."LTO_ELIGIBLE_DECLINES" ;;
  }

  measure: total_lto_takeups {
    type: sum
    sql: ${TABLE}."LTO_TAKEUPS" ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant_name]
  }
}
