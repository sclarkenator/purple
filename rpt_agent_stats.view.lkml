view: rpt_agent_stats {
  sql_table_name: CUSTOMER_CARE.RPT_AGENT_STATS ;;

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_acw {
    type: number
    sql: ${TABLE}."AVG_ACW" ;;
  }

  dimension: avg_handle {
    type: number
    sql: ${TABLE}."AVG_HANDLE" ;;
  }

  dimension: avg_hold {
    type: number
    sql: ${TABLE}."AVG_HOLD" ;;
  }

  dimension: avg_talk {
    type: number
    sql: ${TABLE}."AVG_TALK" ;;
  }

  dimension: handled {
    type: number
    sql: ${TABLE}."HANDLED" ;;
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

  dimension_group: reported {
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
    sql: ${TABLE}."REPORTED" ;;
  }

  dimension: transferred {
    type: number
    sql: ${TABLE}."TRANSFERRED" ;;
  }

  dimension: unavailable {
    type: number
    sql: ${TABLE}."UNAVAILABLE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
