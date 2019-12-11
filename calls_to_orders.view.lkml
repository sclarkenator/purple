view: calls_to_orders {
derived_table: {
  sql:
    -------Only 1 row per call and 1 row per order
    select first_name || ' ' || last_name agent_name
        , contact_info_to
        , captured
        , contact_id
        , contact_info_from
        --, call_end
        --, unique_calls
        , case when unique_orders = 1 then id end as order_id
    from (
      select *
          --, row_number () over (partition by id order by captured, created_at, unique_calls desc) as order_rows
          , case when row_number () over (partition by id order by captured, created_at, unique_calls desc) = 1 then 1 else 0 end as unique_orders
      from (
        --calls with orders
        select contact_id
            , contact_info_to
            , contact_info_from
            , agent_id
            --, disposition
            , captured
            , handle_time
            , dateadd('seconds',handle_time, captured) as call_end
            --, row_number () over (partition by contact_id, captured order by captured) as call_number
            , case when row_number () over (partition by contact_id, captured order by captured) = 1 then 1 else 0 end as unique_calls
            , s.id
            , s.created_at
        from customer_care.rpt_skill_with_disposition_count c
        left join analytics_stage.shopify_us_ft."ORDER" s on s.created_at < dateadd('seconds',handle_time, captured) and s.created_at > captured and s.source_name = 'shopify_draft_order'
        where disposition in ('Place Order','Place Draft Order')
            --and contact_id = '121244004132'
            and agent_id <> 0
        order by captured desc
      ) z
      order by 1, 6 ,10
    ) z
    left join customer_care.agent a on a.agent_id = z.agent_id
    where unique_orders = 1 --or unique_calls = 1
    ;;
}

dimension: agent_name {
  type:  string
  hidden: yes
  sql:${TABLE}.agent_name ;; }

dimension: contact_info_to {
  type:  string
  hidden: yes
  sql:${TABLE}.contact_info_to ;; }

dimension: captured {
  type:  date
  hidden: yes
  sql:${TABLE}.captured ;; }

dimension: order_id {
  primary_key: yes
  hidden: yes
  sql: ${TABLE}.order_id ;; }

  dimension: contact_id {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_id ;; }

  dimension: contact_info_from {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_info_from ;; }

}
