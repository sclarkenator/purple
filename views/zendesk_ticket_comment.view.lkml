view: zendesk_ticket_comment {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_TICKET_COMMENT"
    ;;

  dimension: agent {
    type: yesno
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: agent_response_time {
    type: number
    sql: ${TABLE}."AGENT_RESPONSE_TIME" ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}."COMMENT" ;;
  }

  dimension: comment_order {
    type: number
    sql: ${TABLE}."COMMENT_ORDER" ;;
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: ticket_comment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."TICKET_COMMENT_ID" ;;
  }

  dimension: ticket_id {
    type: number
    sql: ${TABLE}."TICKET_ID" ;;
  }

  dimension: user_role {
    type: string
    sql: ${TABLE}."USER_ROLE" ;;
  }

  dimension: zendesk_user_id {
    type: number
    sql: ${TABLE}."ZENDESK_USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
