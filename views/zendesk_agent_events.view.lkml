view: zendesk_agent_events {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_AGENT_EVENTS" ;;

  ##Zendesk Agent States

  dimension: primary_key {
    label: "Primary Key"
    group_label: "* IDs"
    description: "Primary key field.  [Agent ID - Started]"
    primary_key: yes
    hidden:  no
    type: string
    sql: ${TABLE}."AGENT_ID" || ${TABLE}."STARTED" || ${TABLE}."STATUS";;
  }

  dimension: zendesk_agent_id {
    type: string
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: duration_in_seconds {
    type: number
    sql: ${TABLE}."DURATION_IN_SECONDS" ;;
  }

  ##MEASURES

  measure: total_duration_in_seconds {
    type: sum
    sql: ${duration_in_seconds} ;;
  }

  measure: average_duration_in_seconds {
    type: average
    sql: ${duration_in_seconds} ;;
  }

  dimension: engagement_count {
    type: number
    sql: ${TABLE}."ENGAGEMENT_COUNT" ;;
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
    datatype: timestamp
    sql: ${TABLE}."INSERT_TS";;
  }

  dimension_group: started {
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
    sql: ${TABLE}."STARTED" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
