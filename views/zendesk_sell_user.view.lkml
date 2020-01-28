view: zendesk_sell_user {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_SELL_USER"
    ;;

  dimension: confirmed {
    type: string
    sql: ${TABLE}."CONFIRMED" ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: identity {
    type: string
    sql: ${TABLE}."IDENTITY" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}."ROLE" ;;
  }

  dimension: team_name {
    type: string
    sql: ${TABLE}."TEAM_NAME" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: zendesk_id {
    type: number
    sql: ${TABLE}."ZENDESK_ID" ;;
  }

  dimension: zendesk_sell_status {
    type: string
    sql: ${TABLE}."ZENDESK_SELL_STATUS" ;;
  }

  measure: count {
    type: count
    drill_fields: [name, team_name]
  }
}
