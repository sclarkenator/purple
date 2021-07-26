view: agent_current_warning_level {
  sql_table_name: "CUSTOMER_CARE"."AGENT_CURRENT_WARNING_LEVEL"
    ;;

  dimension: ic_id {
    label: "InContact ID"
    primary_key: yes
    type: number
    sql: ${TABLE}."IC_ID" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: warning_level {
    label: "Warning Level"
    description: "Current attendance warning level"
    type: string
    sql: ltrim(rtrim(${TABLE}."WARNING_LEVEL")) ;;
  }
}
