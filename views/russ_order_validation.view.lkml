view: russ_order_validation {
  derived_table: {
    sql:
     WITH s as (
      select
        s.id::varchar as etail_order_id,
        max(trim(s.name)) as etail_order_name,
        MAX(s.subtotal_price) as etail_revenue,
        MAX(convert_timezone('America/Denver',s.created_at)) as etail_event_time
      from analytics_stage.shopify_us_ft."ORDER" s
      where to_date(convert_timezone('America/Denver',s.created_at)) >= '2019-11-01'
        and lower(s.source_name) = 'web'
      group by 1
      UNION
      select
        c.order_id as etail_order_id,
        max(upper(trim(c.order_number))) as order_name,
        max(c.gross_amt) as etail_revenue,
        max(convert_timezone('America/Denver',c.created)) as etail_event_time
      from analytics.commerce_tools_dev.ct_order c
      where upper(trim(c.order_number)) like 'C%' --removes Shopify orders copied into CT
        and not c.is_draft_order --removes orders created by customer care
      group by 1
    ), orders as (
      select related_tranid as ns_order_id, gross_amt as ns_revenue, so.created as ns_timestamp
          , s.etail_order_id, s.etail_revenue, s.etail_event_time
      from analytics.sales.sales_order so
        left join s on so.etail_order_id = s.etail_order_id
      where so.created::date >= '2019-11-01'
          and so.source = 'Shopify - US'
          and so.warranty != 'T'
          and so.exchange != 'T'
    )
    SELECT TO_DATE(NS_TIMESTAMP) as netsuite_date
    ,  COUNT(NS_ORDER_ID) as netsuite_order_count
    ,  COUNT(etail_order_id) as etail_order_count
    ,  SUM(NS_REVENUE) as netsuite_subtotal
    ,  SUM(etail_revenue) as etail_subtotal
    FROM orders
    GROUP BY 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: ns_order_id {
    type: string
    sql: ${TABLE}."NS_ORDER_ID" ;;
  }

  dimension: ns_revenue {
    type: number
    sql: ${TABLE}."NS_REVENUE" ;;
  }

  dimension_group: ns_timestamp {
    type: time
    sql: ${TABLE}."NS_TIMESTAMP" ;;
  }

  dimension: o_order_id {
    type: string
    sql: ${TABLE}."O_ORDER_ID" ;;
  }

  dimension: o_revenue {
    type: number
    sql: ${TABLE}."O_REVENUE" ;;
  }

  dimension_group: o_event_time {
    type: time
    sql: ${TABLE}."O_EVENT_TIME" ;;
  }

  dimension: h_order_id {
    type: string
    sql: ${TABLE}."H_ORDER_ID" ;;
  }

  dimension: h_revenue {
    type: string
    sql: ${TABLE}."H_REVENUE" ;;
  }

  dimension: h_event_time {
    type: date
    sql: ${TABLE}."H_EVENT_TIME" ;;
  }

  dimension: h_total_discounts {
    type: string
    sql: ${TABLE}."H_TOTAL_DISCOUNTS" ;;
  }

  dimension: t_order_id {
    type: string
    sql: ${TABLE}."T_ORDER_ID" ;;
  }

  dimension: t_revenue {
    type: string
    sql: ${TABLE}."T_REVENUE" ;;
  }

  dimension: t_event_time {
    type: date
    sql: ${TABLE}."T_EVENT_TIME" ;;
  }

  dimension: s_order_id {
    type: string
    sql: ${TABLE}."S_ORDER_ID" ;;
  }

  dimension: s_revenue {
    type: number
    sql: ${TABLE}."S_REVENUE" ;;
  }

  dimension_group: s_event_time {
    type: time
    sql: ${TABLE}."S_EVENT_TIME" ;;
  }

  set: detail {
    fields: [
      ns_order_id,
      ns_revenue,
      ns_timestamp_time,
      o_order_id,
      o_revenue,
      o_event_time_time,
      h_order_id,
      h_revenue,
      h_event_time,
      h_total_discounts,
      t_order_id,
      t_revenue,
      t_event_time,
      s_order_id,
      s_revenue,
      s_event_time_time
    ]
  }
}
