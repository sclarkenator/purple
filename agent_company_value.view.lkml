view: agent_company_value {
  sql_table_name: CUSTOMER_CARE.AGENT_COMPANY_VALUE ;;

  dimension: accessibility {
    type: number
    sql: ${TABLE}."ACCESSIBILITY" ;;
  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}."AGENT_ID" ;;
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

  dimension: delight {
    type: number
    sql: ${TABLE}."DELIGHT" ;;
  }

  dimension: entry_id {
    type: number
    sql: ${TABLE}."ENTRY_ID" ;;
  }

  dimension: hustle {
    type: number
    sql: ${TABLE}."HUSTLE" ;;
  }

  dimension: innovation {
    type: number
    sql: ${TABLE}."INNOVATION" ;;
  }

  dimension: integrity {
    type: number
    sql: ${TABLE}."INTEGRITY" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: respect {
    type: number
    sql: ${TABLE}."RESPECT" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
