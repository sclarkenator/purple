view: v_shopify_refund_status {
  derived_table: {
    sql: select *
      from analytics.customer_care.v_shopify_refund_status
       ;;
  }

  measure: count {
    type: count
    hidden: yes
    # drill_fields: [detail*]
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: etail_order_id {
    type: string
    sql: ${TABLE}."ETAIL_ORDER_ID" ;;
  }

  measure: amount {
    type: max
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}."MESSAGE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."NOTE" ;;
  }

  set: detail {
    fields: [
      source,
      related_tranid,
      created_time,
      created_at_time,
      etail_order_id,
      amount,
      message,
      status
    ]
  }
}
