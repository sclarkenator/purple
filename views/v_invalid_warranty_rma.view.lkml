view: v_invalid_warranty_rma {
  sql_table_name: analytics.customer_care.v_invalid_warranty_rma
    ;;

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
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: item {
    type: string
    sql: ${TABLE}."ITEM" ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: product_line {
    type: string
    sql: ${TABLE}."PRODUCT_LINE" ;;
  }

  dimension: product_line_id {
    type: number
    sql: ${TABLE}."PRODUCT_LINE_ID" ;;
  }

  dimension: warranty_reason {
    type: string
    sql: ${TABLE}."WARRANTY_REASON" ;;
  }

  dimension: warranty_reason_id {
    type: number
    sql: ${TABLE}."WARRANTY_REASON_ID" ;;
  }

}
