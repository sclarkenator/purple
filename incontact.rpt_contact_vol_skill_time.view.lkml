view: rpt_contact_vol_skill_time {
  sql_table_name: CUSTOMER_CARE.RPT_CONTACT_VOL_SKILL_TIME ;;

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: handled {
    type: number
    sql: ${TABLE}."HANDLED" ;;
  }

  dimension: inbound {
    type: number
    sql: ${TABLE}."INBOUND" ;;
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

  dimension: queued {
    type: number
    sql: ${TABLE}."QUEUED" ;;
  }

  dimension_group: report_ts {
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
    sql: ${TABLE}."REPORT_TS" ;;
  }

  dimension: skill {
    type: string
    sql: ${TABLE}."SKILL" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
