view: return_form_entry {
  sql_table_name: CUSTOMER_CARE.RETURN_FORM_ENTRY ;;

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: comments {
    type: string
    sql: ${TABLE}."COMMENTS" ;;
  }

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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: customer {
    type: string
    sql: ${TABLE}."CUSTOMER" ;;
  }

  dimension: delivery_status {
    type: string
    sql: ${TABLE}."DELIVERY_STATUS" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: entry_id {
    type: string
    sql: ${TABLE}."ENTRY_ID" ;;
  }

  dimension: ideal_firmness {
    type: string
    sql: ${TABLE}."IDEAL_FIRMNESS" ;;
  }

  dimension: instructions {
    type: string
    sql: ${TABLE}."INSTRUCTIONS" ;;
  }

  dimension: opened {
    type: string
    sql: ${TABLE}."OPENED" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: policy {
    type: string
    sql: ${TABLE}."POLICY" ;;
  }

  dimension: previous_mattress {
    type: string
    sql: ${TABLE}."PREVIOUS_MATTRESS" ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}."PRODUCT_TYPE" ;;
  }

  dimension: purple_mattress_firmness {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_FIRMNESS" ;;
  }

  dimension: reasons {
    type: string
    sql: ${TABLE}."REASONS" ;;
  }

  dimension: return_option {
    type: string
    sql: ${TABLE}."RETURN_OPTION" ;;
  }

  dimension: rma {
    type: string
    sql: ${TABLE}."RMA" ;;
  }

  dimension: ship_to {
    type: string
    sql: ${TABLE}."SHIP_TO" ;;
  }

  dimension: sleep_preference {
    type: string
    sql: ${TABLE}."SLEEP_PREFERENCE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
