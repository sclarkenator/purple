view: v_ct_test {
  sql_table_name: "SALES"."CT_TEST"
    ;;

  dimension_group: hour {
    label: "Session/transaction"
    type: time
    timeframes: [
      hour,
      time,
      date,
      week
    ]
    sql: ${TABLE}."HOUR" ;;
  }

  measure: orders {
    label: "Orders placed"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."ORDERS" ;;
  }

  measure: sales {
    label: "Gross sales"
    type: sum
    value_format_name: usd_0
    sql: ${TABLE}."SALES" ;;
  }

  measure: sessions {
    label: "Session count"
    type: sum
    sql: ${TABLE}."SESSIONS" ;;
  }

  measure: aov {
    label: "AOV"
    value_format_name: usd_0
    type: number
    sql: ${sales}/${orders} ;;
  }

  measure: cvr {
    label: "Conversion rate"
    description: "orders / sessions"
    value_format_name: percent_2
    type: number
    sql: ${orders}/nullif(${sessions},0) ;;
  }

  measure: refresh_time {
    label: "Refresh time"
    type: date_time_of_day
    sql: max(${TABLE}.refresh_time) ;;
  }

  measure: refresh_date {
    label: "Refresh date"
    type: date_time
    sql: max(${TABLE}.refresh_time) ;;
  }
  dimension: variant {
    label: "Checkout variant"
    type: string
    sql: ${TABLE}."VARIANT" ;;
  }



}
