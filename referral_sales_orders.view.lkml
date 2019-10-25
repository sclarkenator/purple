view: referral_sales_orders {
  sql_table_name: MARKETING.REFERRAL_SALES_ORDERS ;;

  dimension_group: order {
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
    sql: ${TABLE}."ORDER_DATE" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
