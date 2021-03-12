view: shopify_refund {
  derived_table: {
    sql:
      with t as (
        select refund_id, sum(amount) as amount
        from analytics_stage.shopify_us_ft.transaction
        where status = 'success'
          and refund_id is not null
        group by 1
      )
      select r.id, o.name as order_number, r.note as refund_note, to_date(r.created_at) as refunded, t.amount, a.name as refunded_by
      from analytics_stage.shopify_us_ft.refund r
        join analytics_stage.shopify_us_ft."ORDER" o on r.order_id = o.id
        join t on r.id = t.refund_id
        join analytics.customer_care.agent_lkp a on r.user_id = a.shopify_id
      where
        a.inactive is null
    ;;
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

  dimension: refund_note {
    type: string
    sql: ${TABLE}.refund_note ;;
  }

  measure: amount {
    type: sum
    value_format: "$0.00"
    sql: ${TABLE}.amount ;;
  }

}
