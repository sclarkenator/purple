view: v_ns_deleted_lines {
  derived_table: {
    sql: select *
      from analytics.customer_care.v_ns_deleted_lines
       ;;
  }

 # measure: count {
 #   type: count
 #   hidden: yes
  #  drill_fields: [detail*]
#  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: transaction_line_id {
    type: string
    sql: ${TABLE}."TRANSACTION_LINE_ID" ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  measure: amount {
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_count {
    type: string
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  dimension_group: date_created {
    type: time
    sql: ${TABLE}."DATE_CREATED" ;;
  }

  dimension_group: date_last_modified {
    type: time
    sql: ${TABLE}."DATE_LAST_MODIFIED" ;;
  }

  dimension_group: deleted_ts {
    type: time
    sql: ${TABLE}."DELETED_TS" ;;
  }

 # set: detail {
#    fields: [
#      order_id,
#      tranid,
#      related_tranid,
#      transaction_line_id,
#      account_id,
#      amount,
#      item_id,
#      item_count,
#      date_created_time,
#      date_last_modified_time,
#      deleted_ts_time
#    ]
#  }
}
