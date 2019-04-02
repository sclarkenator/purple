view: problem_order {
  sql_table_name: CUSTOMER_CARE.PROBLEM_ORDER ;;

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
    html: <a href = "https://onpurple.myshopify.com/admin/orders/{{value}}" target="_blank"> {{value}} </a> ;;
  }

  dimension: order_name {
    type: string
    sql: ${TABLE}."ORDER_NAME" ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}."REASON" ;;
  }

}
