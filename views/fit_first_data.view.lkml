#############################
## Hyrum Ward 2020-12-29
#############################
# this is a dynamic query where you select the date range in the Look
view: fit_first_data {
  derived_table: {
    sql:
    with param_dates as(

  SELECT      date
  FROM        analytics.util.warehouse_timestamp
  where       {% condition date_selector %} to_date(date) {% endcondition %}

),

netsuite_refunds_raw as (
  select      regexp_replace(
                  case
                    when coalesce(t.memo,'') ilike '%DSC08%'
                      then regexp_substr(coalesce(t.memo,''),'[Oo]?#?[ ]?N?[ ]?(\\d{4,7})',1,1,'e',1)
                    when t.related_tranid is not null
                      then t.related_tranid
                    when t2.memo ilike '%DSC08%'
                      then regexp_substr(t2.memo,'[Oo]?#?[ ]?N?[ ]?(\\d{4,7})',1,1,'e',1)
                    when t2.related_tranid is not null
                      then t2.related_tranid
                    else null
                  end
              , '[ #NwW-]{1,}','') as related_tranid,
              t.entity_id as netsuite_customer_id,
              t.transaction_id,
              t.transaction_number,
              l.amount

  from        analytics_stage.ns.transactions t

    left join analytics_stage.nstl.transaction_lines l
        on    l.transaction_id = t.transaction_id

    left join analytics_stage.ns.transactions t2
        on    t2.transaction_id = t.sales_order_ref_id

  where       t.transaction_type in ('Cash Refund', 'Customer Refund')
    and       t.transaction_number is not null
    and       t.date_deleted is null
    and       l.account_id = 133
    and       to_date(t.create_date) in (select * from param_dates)

  UNION

  select      regexp_replace(
                  case
                    when t.memo ilike '%DSC08%' then regexp_substr(t.memo,'[Oo]?#?[ ]?N?[ ]?(\\d{4,7})',1,1,'e',1)
                    when t.related_tranid is not null then t.related_tranid
                    else null
                  end,
                '[ #NwW-]{1,}','') as related_tranid,
              t.entity_id as netsuite_customer_id,
              t2.transaction_id,
              t2.transaction_number,
              l.amount

  from        analytics_stage.ns.transactions t

    left join analytics_stage.ns.transactions t2
        on    t.transaction_id = t2.sales_order_ref_id

    left join analytics_stage.nstl.transaction_lines l
        on    t2.transaction_id = l.transaction_id

  where       t.transaction_type in ('Cash Sale', 'Sales Order')
    and       t2.transaction_number is not null
    and       t.date_deleted is null
    and       case
                when coalesce(t.warranty_order,'F') = 'T' then iff(t.upgrade_0 = 'T',1,0)
                else 1
              end = 1
    and       case
                when t2.transaction_type is null then 1
                when t2.transaction_type in ('Cash Refund', 'Customer Refund') then 1
                else 0
              end = 1
    and       l.account_id = 133
    and       to_date(t.create_date) in (select * from param_dates)

),

netsuite_clean as (
  select      distinct related_tranid,
              netsuite_customer_id,
              listagg(distinct transaction_id, ';') within group (order by transaction_id) as transaction_id,
              listagg(distinct transaction_number, ';') within group (order by transaction_number) as transaction_number,
              sum(abs(amount)) as amount,
              count(9) as netsuite_count

  from        netsuite_refunds_raw

  where       related_tranid is not null
  group by    1,2
  order by    count(9) desc
),

first_data_raw as(
  select      f.tag,
              f.amount,
              iff(ctt.interaction_id is null,f.ref_num,f.tag::string) as ref_num,
              f.auth_no,
              iff(ctt.interaction_id is null,o.id::string,ctop.order_id) as id,
              iff(ctt.interaction_id is null,regexp_replace(o.name,'[ #N]{1,}',''),cto.order_number) as order_number,
              f.time as created

  from        analytics.accounting.first_data_transaction f

    left join analytics_stage.shopify_us_ft.transaction s
      on          f.ref_num = s.receipt:reference_no
      and         f.auth_no = s.receipt:authorization_num
      and         f.tag::varchar = s.receipt:transaction_tag

                  left join analytics_stage.shopify_us_ft."ORDER" o
                    on          s.order_id = o.id

    left join
                  analytics.commerce_tools.ct_payment_gateway_link gl             on f.auth_no = gl.gateway_link
                  left join analytics.commerce_tools.ct_transaction ctt           on gl.interaction_id  = ctt.interaction_id
                  left join analytics.commerce_tools.ct_payment ctp               on ctt.payment_id = ctp.payment_id
                  left join analytics.commerce_tools.ct_order_payment ctop        on ctp.payment_id = ctop.payment_id
                  left join analytics.commerce_tools.ct_order cto                 on ctop.order_id = cto.order_id


  where       f.transaction_type = 'Tagged Refund'
    and       f.status = 'Approved'
    and       to_date(f.time) in (select * from param_dates)
    and       not rlike(coalesce(f.ref_num,''),'\\d{14}')
),

first_data_stage_f as (
  select      listagg(distinct f0.tag, ';') within group (order by f0.tag) as tag,
              sum(f0.amount) as amount,
              listagg(distinct f0.ref_num, ';') within group (order by f0.ref_num) as ref_num,
              listagg(distinct f0.auth_no, ';') within group (order by f0.auth_no) as auth_no,
              listagg(distinct f0.id, ';') within group (order by f0.id) as id,
              f0.order_number,
              max(f0.created) as created,
              count(9) as gateway_count

  from        first_data_raw as f0

  group by    6
),

first_data_stage_g as (
select      'First Data' as gateway,
            f.tag::varchar as transaction_id,
            null as secondary_id,
            f.ref_num::varchar as po_id,
            f.created::timestamp_tz as created,
            'Refund' as transaction_type,
            'USD' as currency,
            f.amount::float as transaction_amount,
            n.amount::float as netsuite_amount,
            f.order_number::varchar as order_number,
            f.id::varchar as etail_order_id,
            n.transaction_id::varchar as netsuite_tran_id,
            n.transaction_number::varchar as netsuite_transaction_id,
            n.netsuite_customer_id

from        first_data_stage_f as f

left join   netsuite_clean as n
    on          f.order_number = n.related_tranid

where       f.created >= '2018-01-01'

UNION ALL

select      'First Data' as gateway,
            f.tag::varchar as transaction_id,
            f.auth_no::varchar as secondary_id,
            iff(ctt.interaction_id is null,f.ref_num,f.tag::string) as po_id,
            f.time::timestamp_tz as created,
            'Capture' as transaction_type,
            'USD' as currency,
            f.amount::float as transaction_amount,
            iff(d.gross_amount is null,iff(d2.gross_amount is null,p.amount,d2.gross_amount),d.gross_amount)::float as netsuite_amount,
            iff(ctt.interaction_id is null,regexp_replace(o.name::varchar,'[ #N]{1,}',''),cto.order_number) as order_number,
            iff(ctt.interaction_id is null,o.id::string,cto.order_id) as etail_order_id,
            iff(d.customer_deposit_id is null,
                iff(d2.customer_deposit_id is null,p.payment_id,d2.customer_deposit_id),
                d.customer_deposit_id)::varchar as netsuite_tran_id,
            iff(d.TRANSACTION_NUMBER is null,
                iff(d2.transaction_number is null,p.transaction_number,d2.transaction_number),
                d.transaction_number)::varchar as netsuite_transaction_id,
            t.entity_id as netsuite_customer_id

from        analytics.accounting.first_data_transaction f


  left join     analytics.commerce_tools.ct_payment_gateway_link gl             on f.tag::string = gl.gateway_link
                left join analytics.commerce_tools.ct_transaction ctt           on gl.interaction_id  = ctt.interaction_id
                left join analytics.commerce_tools.ct_payment ctp               on ctt.payment_id = ctp.payment_id
                left join analytics.commerce_tools.ct_order_payment ctop        on ctp.payment_id = ctop.payment_id
                left join analytics.commerce_tools.ct_order cto                 on ctop.order_id = cto.order_id

  left join analytics_stage.shopify_us_ft.transaction s
    on      f.ref_num = s.receipt:reference_no
    and     f.auth_no = s.receipt:authorization_num
    and     f.tag::varchar = s.receipt:transaction_tag

            left join analytics_stage.shopify_us_ft."ORDER" o
              on      s.order_id = o.id

                       left join    analytics_stage.ns.transactions t
                        on          trim(coalesce(o.id::string,ctop.order_id)) = trim(t.etail_order_id)
                        and         t.transaction_type in ('Sales Order','Cash Sale')
                        and         coalesce(t.total_amount_ref,'0') <> '0'

                                    left join   analytics.sales.customer_deposit d
                                      on        t.transaction_id::string = d.sales_order_id::string
                                      and       d.account = 'FIT - First Data'

                                    left join   analytics.sales.customer_deposit d2
                                      on        t.related_tranid::string = d2.related_tranid::string
                                      and       d2.account = 'FIT - First Data'

                                    left join (
                                                select        p.payment_id, p.transaction_extid, p.transaction_number, sum(pl.amount*-1) as amount
                                                from          analytics.finance.payment p
                                                join          analytics.finance.payment_line pl
                                                  on          p.payment_id = pl.payment_id
                                                where         p.transaction_extid is not null
                                                group by      1,2,3
                                              ) p
                                      on                      t.transaction_id::string = p.transaction_extid::string




where   f.status = 'Approved'
  and   f.transaction_type in ('Purchase','Tagged Completion')
  and   not rlike(coalesce(f.ref_num,''),'\\d{14}')
  and   to_date(f.time) in (select * from param_dates)
)

select      gateway,
            transaction_id,
            secondary_id,
            po_id,
            created,
            transaction_type,
            currency,
            transaction_amount,
            netsuite_amount,
            abs(coalesce(transaction_amount,0) - coalesce(netsuite_amount,0)) as amount_difference,
            order_number,
            etail_order_id,
            netsuite_tran_id,
            netsuite_transaction_id,
            netsuite_customer_id

from        first_data_stage_g
      ;;
  }

  filter: date_selector {
    type: date_time
    description: "Use this field to select a date to filter results by."
  }

  dimension: gateway {
    type: string
    sql:${TABLE}.gateway;;
  }

  dimension: transaction_id {
    type: string
    sql:${TABLE}.transaction_id;;
  }

  dimension: secondary_id {
    type: string
    sql:${TABLE}.secondary_id;;
  }

  dimension: po_id {
    type: string
    sql:${TABLE}.po_id;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension: transaction_type {
    type: string
    sql:${TABLE}.transaction_type;;
  }

  dimension: currency {
    type: string
    sql:${TABLE}.currency;;
  }

  dimension: order_number {
    type: string
    sql:${TABLE}.order_number;;
  }

  dimension: etail_order_id {
    type: string
    sql:${TABLE}.etail_order_id;;
  }

  dimension: netsuite_tran_id {
    type: string
    sql:${TABLE}.netsuite_tran_id;;
  }

  dimension: netsuite_transaction_id {
    type: string
    sql:${TABLE}.netsuite_transaction_id;;
  }

  dimension: netsuite_customer_id {
    type: number
    sql:${TABLE}.netsuite_customer_id;;
  }

  dimension: is_match {
    type: yesno
    sql:${TABLE}.transaction_amount = ${TABLE}.netsuite_amount;;
  }

  measure: transaction_amount {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.transaction_amount;;
  }

  measure: netsuite_amount {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.netsuite_amount;;
  }

  measure: amount_difference {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.amount_difference;;
  }

}
