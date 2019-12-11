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

  dimension: ownership {
    type: number
    sql: ${TABLE}.ownership ;;
  }

  dimension: entry_id {
    type: number
    sql: ${TABLE}."ENTRY_ID" ;;
    primary_key: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: knowledgeable {
    type: number
    sql: ${TABLE}.knowledgeable ;;
  }

  dimension: caring {
    type: number
    sql: ${TABLE}.caring ;;
  }

  dimension: customer_focused{
    type: number
    sql: ${TABLE}.customer_focused ;;
  }

  dimension: adaptability {
    type: number
    sql: ${TABLE}.adaptability ;;
  }

  dimension: COLLABORATION_TEAMWORK  {
    type: number
    sql: ${TABLE}.COLLABORATION_TEAMWORK   ;;
  }

  dimension: ENGAGEMENT {
    type: number
    sql: ${TABLE}.ENGAGEMENT ;;
  }

  dimension: DEPENDABILITY {
    type: number
    sql: ${TABLE}.DEPENDABILITY ;;
  }

  dimension: PRIDE_PASSION_FOR_PRODUCTS {
    type: number
    sql: ${TABLE}.PRIDE_PASSION_FOR_PRODUCTS ;;
  }

  dimension: COMMUNICATION   {
    type: number
    sql: ${TABLE}.COMMUNICATION  ;;
  }

  measure: average_knowledgeable {
    type: average
    sql: ${TABLE}.knowledgeable ;;
  }

  measure: average_caring {
    type: average
    sql: ${TABLE}.caring ;;
  }

  measure: average_customer_focused{
    type: average
    sql: ${TABLE}.customer_focused ;;
  }

  measure: average_adaptability {
    type: average
    sql: ${TABLE}.adaptability ;;
  }

  measure: average_COLLABORATION_TEAMWORK  {
    type: average
    sql: ${TABLE}.COLLABORATION_TEAMWORK   ;;
  }

  measure: average_ENGAGEMENT {
    type: average
    sql: ${TABLE}.ENGAGEMENT ;;
  }

  measure: average_DEPENDABILITY {
    type: average
    sql: ${TABLE}.DEPENDABILITY ;;
  }

  measure: average_PRIDE_PASSION_FOR_PRODUCTS {
    type: average
    sql: ${TABLE}.PRIDE_PASSION_FOR_PRODUCTS ;;
  }

  measure: average_COMMUNICATION   {
    type: average
    sql: ${TABLE}.COMMUNICATION  ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
