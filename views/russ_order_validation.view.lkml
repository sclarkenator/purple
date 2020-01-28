view: russ_order_validation {
  derived_table: {
    sql: with a as (
      select distinct EVENT_FEATURES_SHOPIFY_ORDER_ID, event_metrics_revenue/100 as money, max(convert_timezone('America/Denver', timestamp)) event_time
      from analytics_stage.optimizely.visitor_action va
      where event_name = 'totalRevenue'
          and convert_timezone('America/Denver', timestamp)::date >= '2019-11-01'
      group by 1, 2),
      h as (
      select name, subtotal_price, convert_timezone('America/Denver', time)::date the_day, total_discounts
      from analytics.heap.cart_orders_placed_order
      where convert_timezone('America/Denver', time)::date >= '2019-11-01'
      ),

      t as (
      select distinct "EVENT - UDO - ORDER_ID" order_id, convert_timezone('America/Denver', "EVENT - TIME")::date the_day, "EVENT - UDO - ORDER_SUBTOTAL" subtotal_amt
      from analytics.TEALIUM.EVENTS_VIEW__ALL_EVENTS__ALL_EVENTs
      where "EVENT - UDO - ORDER_ID" is not null
          and convert_timezone('America/Denver', "EVENT - TIME")::date >= '2019-11-01'
      ),

      s as (
      select  trim(s.name) shopify_order_id,
              s.subtotal_price shopify_revenue,
              convert_timezone('America/Denver',s.created_at)  s_event_time
      from analytics_stage.shopify_us_ft."ORDER" s
      where to_date(convert_timezone('America/Denver',s.created_at)) >= '2019-11-01'
           and lower(s.source_name) = 'web'
      )

      select related_tranid ns_order_id, gross_amt ns_revenue, so.created ns_timestamp
          , event_features_shopify_order_id o_order_id, money o_revenue, a.event_time o_event_time
          , h.name h_order_id, h.subtotal_price h_revenue, h.the_day h_event_time, h.total_discounts h_total_discounts
          , t.order_id t_order_id, t.subtotal_amt t_revenue, t.the_day t_event_time
          , s.shopify_order_id s_order_id, s.shopify_revenue s_revenue, s_event_time
      from analytics.sales.sales_order so
      full outer join a on a.event_features_shopify_order_id = so.related_tranid
      full outer join h on h.name = so.related_tranid
      full outer join t on t.order_id = so.related_tranid
      full outer join s on s.shopify_order_id = so.related_tranid
      where created::date >= '2019-11-01'
          and so.source = 'Shopify - US'
          and warranty != 'T'
          and exchange != 'T'
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