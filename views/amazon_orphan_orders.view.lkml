view: amazon_orphan_orders {
  sql_table_name: CUSTOMER_CARE.AMAZON_ORPHAN_ORDERS ;;

  dimension: amazon_order_id {
    type: string
    primary_key: yes
    sql: ${TABLE}."AMAZON_ORDER_ID" ;;
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

  measure: total_price {
    type: sum
    sql: ${TABLE}."TOTAL_PRICE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  hidden:yes
  }
}
