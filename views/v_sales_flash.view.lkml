# The name of this view in Looker is "V Sales Flash"
view: v_sales_flash {

  sql_table_name: "SALES"."V_SALES_FLASH"   ;;

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}."CUSTOMER_EMAIL" ;;
  }

  dimension: gross_amt {
    type: number
    sql: ${TABLE}."GROSS_AMT" ;;
  }

  measure: total_gross_amt {
    type: sum
    value_format_name: "usd_0"
    sql: ${gross_amt} ;;
  }

  dimension: order_number {
    primary_key: yes
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      hour,
      hour_of_day,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."ORDER_TIME" ;;
  }

  dimension: shipping_state {
    type: string
    sql: ${TABLE}."SHIPPING_STATE" ;;
  }

   measure: time_max {
    group_label: " Sync"
    hidden: no
    type: date_time_of_day
    sql: max(${order_raw}) ;;
    convert_tz: no
  }

  measure: date_max {
    group_label: " Sync"
    hidden: no
    type: date
    sql: max(${order_raw}) ;;
    convert_tz: no
  }

  measure: count {
    label: "Orders"
    type: count
    drill_fields: []
  }
}
