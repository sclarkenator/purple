view: shopify_refund {
  sql_table_name: "CUSTOMER_CARE"."V_ETAIL_MANUAL_REFUND"
  ;;

  dimension_group: refunded  {
    type: time
    timeframes: [date,month_num,week_of_year,week,month,quarter,year,raw]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.refunded ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: refunded_by {
    type: string
    sql: ${TABLE}.refunded_by ;;
  }

  dimension: refund_note {
    type: string
    sql: ${TABLE}.refund_note ;;
  }

  measure: amount {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}.amount ;;
  }

}
