view: affiliate_sales_orders {
  sql_table_name: MARKETING.AFFILIATE_SALES_ORDERS ;;

  dimension: affiliate_name {
    type: string
    sql: ${TABLE}."AFFILIATE_NAME" ;;
  }

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

}
