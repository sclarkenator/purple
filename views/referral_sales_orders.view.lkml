view: referral_sales_orders {
  sql_table_name: MARKETING.REFERRAL_SALES_ORDERS ;;

  dimension: order_id_referral {
    primary_key: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    hidden: yes
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
    hidden:  yes
  }

  dimension: order_id_flag {
    view_label: "Sales Order"
    label: "     * Is Referral Order"
    description: "Source: c3.referral_sales_orders"
    type:  yesno
    sql: ${order_id_referral} is not NULL  ;;
  }

}
