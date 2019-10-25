view: affiliate_sales_orders {
  sql_table_name: MARKETING.AFFILIATE_SALES_ORDERS ;;

  dimension: affiliate_name {
    type: string
    view_label: "Sales Order"
    group_label: " Advanced"
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
    hidden:  yes
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    hidden:  yes
  }

  dimension: order_id_flag {
    view_label: "Sales Order"
    label: "     * Is Affilate Order"
    type: yesno
    sql: ${order_id} is not NULL ;;
  }

}
