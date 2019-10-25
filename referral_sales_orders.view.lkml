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

  dimension: order_id_referral {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }


  dimension: order_id_flag {
    type:  yesno
    sql: ${order_id_referral} is not NULL  ;;
  }

}
