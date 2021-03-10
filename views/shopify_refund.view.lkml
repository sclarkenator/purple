view: shopify_refund {
  derived_table: {
    sql:
      select o.name as order_number, to_date(r.created_at) as refunded, t.amount, a.name as refunded_by
      from analytics_stage.shopify_us_ft.refund r
        join analytics_stage.shopify_us_ft."ORDER" o on r.order_id = o.id
        join analytics_stage.shopify_us_ft.transaction t on r.id = t.refund_id
        join analytics.customer_care.agent_lkp a on r.user_id = a.shopify_id
    ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: refunded  {
    type: time
    timeframes: [date,month_num,week_of_year,week,month,quarter,year,raw]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.refunded ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: refunded_by {
    type: string
    sql: ${TABLE}.refunded_by ;;
  }

  measure: amount {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}.amount ;;
  }

}
