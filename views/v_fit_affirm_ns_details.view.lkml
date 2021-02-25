view: v_fit_affirm_ns_details {
  derived_table: {
    sql:
      with p as (
        select p.payment_id, p.transaction_extid, p.transaction_number, sum(pl.amount*-1) as amount
        from analytics.finance.payment p
          join analytics.finance.payment_line pl on p.payment_id = pl.payment_id
        where p.transaction_extid is not null
        group by 1,2,3
      ), ns as (
        select
          'Refund' as event_type,
          t.transaction_id,
          t.transaction_type,
          t.tranid,
          t.transaction_number,
          convert_timezone('America/Denver',t.create_date) as created,
          regexp_replace(
            iff(
              tso.related_tranid is not null,
              tso.related_tranid,
              iff(
                t.related_tranid is not null,
                t.related_tranid,
                iff(
                  t.shopify_order_link is not null,
                  replace(t.shopify_order_link,'http://',''),
                  iff(oso.related_tranid is not null,
                    oso.related_tranid,
                    oso2.related_tranid
                  )
                )
              )
            ),
            '[ #NwW-]{1,}',''
          ) as order_number,
          l.amount*-1 as amount
        from analytics_stage.ns.transactions t
          left join analytics_stage.nstl.transaction_lines l on t.transaction_id = l.transaction_id
          left join analytics_stage.ns.transactions tso on t.sales_order_ref_id = tso.transaction_id
          left join analytics_stage.ns.transactions oso on tso.original_sales_order_id = oso.transaction_id
          left join analytics_stage.ns.transactions oso2 on oso.original_sales_order_id = oso2.transaction_id
        where t.transaction_type in ('Cash Refund', 'Customer Refund')
          and l.account_id = 137
        UNION ALL
        select
          'Charge' as event_type,
          so.order_id as transaction_id,
          so.transaction_type,
          so.tranid,
          iff(d.transaction_number is not null,d.transaction_number,p.transaction_number) as transaction_number,
          so.created,
          regexp_replace(so.related_tranid,'[ #NwW-]{1,}','') as order_number,
          iff(d.gross_amount is not null,d.gross_amount,p.amount)::float as amount
        from analytics.sales.sales_order so
          left join analytics.sales.customer_deposit d on so.order_id = d.sales_order_id
          left join p on so.order_id::string = p.transaction_extid::string
        where so.warranty = 'F'
      )
      select * from ns
      order by created

    ;;
  }
  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }
  dimension: transaction_id {
    primary_key: yes
    type: number
    value_format: "0"
    sql: ${TABLE}.transaction_id ;;
  }
  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }
  dimension: tranid {
    type: string
    sql: ${TABLE}.tranid ;;
  }
  dimension: transaction_number {
    type: string
    sql: ${TABLE}.transaction_number ;;
  }
  dimension: created {
    type: date_time
    sql: ${TABLE}.created ;;
  }
  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }
  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }
  measure: total_amount {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.amount ;;
  }
}
