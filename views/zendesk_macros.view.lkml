view: zendesk_macros {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_MACROS"
    ;;

  dimension: action_field {
    type: string
    sql: ${TABLE}."ACTION_FIELD" ;;
  }

  dimension: action_value {
    type: string
    sql: ${TABLE}."ACTION_VALUE" ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
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
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: macro_id {
    type: number
    sql: ${TABLE}."MACRO_ID" ;;
  }

  dimension: position {
    type: number
    sql: ${TABLE}."POSITION" ;;
  }

  dimension: restriction_id {
    type: number
    sql: ${TABLE}."RESTRICTION_ID" ;;
  }

  dimension: restriction_ids {
    type: string
    sql: ${TABLE}."RESTRICTION_IDS" ;;
  }

  dimension: restriction_types {
    type: string
    sql: ${TABLE}."RESTRICTION_TYPES" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."TITLE" ;;
  }

  dimension_group: updated {
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
    sql: CAST(${TABLE}."UPDATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: 1_day {
    type: sum
    sql: ${TABLE}.usage_24H ;;
  }

  measure: 7_day {
    type: sum
    sql: ${TABLE}.usage_7d ;;
  }
}
