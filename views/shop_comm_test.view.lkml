view: shop_comm_test {
  sql_table_name: "SALES"."SHOP_COMM_TEST"
    ;;

  dimension: etailer {
    label: "Platform"
    type: string
    sql: ${TABLE}."ETAILER" ;;
  }

  dimension: gross_sales_dim {
    label: "Gross Sales (what customer paid)"
    type: tier
    tiers: [0,10,100,500,1000,2000,3000]
    sql: ${TABLE}."GROSS_SALES" ;;
  }

  dimension_group: time {
    label: "Order time"
    type: time
    timeframes: [
      raw,
      hour,
      time,
      date,
      week,
      month,
      quarter,
    ]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: mattress_order {
    type: yesno
    sql: ${TABLE}."MATTRESS_ORDER" ;;
  }

  dimension: order_number {
    hidden: yes
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  measure: orders {
    type: sum
    sql: ${TABLE}."ORDERS" ;;
  }

  measure: gross_sales {
    type: sum
    value_format_name: usd_0
    sql: ${TABLE}.gross_sales ;;
    drill_fields: [order_number]
  }

  measure: aov {
    label: "AOV"
    type: number
    value_format_name: usd_0
    sql: ${gross_sales}/${orders} ;;
  }

  measure: mattress_orders {
    type: sum
    filters: [mattress_order: "1"]
    sql: ${TABLE}."ORDERS" ;;
  }

  measure: non_mattress_orders {
    type: sum
    filters: [mattress_order: "0"]
    sql: ${TABLE}."ORDERS" ;;
  }

  measure: mattress_sales {
    type: sum
    hidden: yes
    filters: [mattress_order: "1"]
    value_format_name: usd_0
    sql: ${TABLE}.gross_sales ;;
  }

  measure: non_mattress_sales {
    type: sum
    filters: [mattress_order: "0"]
    value_format_name: usd_0
    sql: ${TABLE}.gross_sales ;;
  }

  measure: amov {
    label: "AMOV"
    type: number
    value_format_name: usd_0
    sql: ${mattress_sales}/nullif(${mattress_orders},0) ;;
}

  measure: namov {
    label: "NAMOV"
    type: number
    value_format_name: usd_0
    sql: ${non_mattress_sales}/nullif(${non_mattress_orders},0) ;;
  }

  measure: date_refresh_time {
    type: date_time_of_day
    sql: max(${time_raw}) ;;
  }
measure: date_refresh_date {
  type: date
  sql: max(${time_raw}) ;;
}


}
