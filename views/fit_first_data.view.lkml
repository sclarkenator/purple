#############################
## Hyrum Ward 2020-12-29
#############################
# this is a dynamic query where you select the date range in the Look
view: fit_first_data {
  derived_table: {
    sql:
    with z as (
    select
        kind,
        listagg(distinct netsuite_transaction_id, ';') within group (order by netsuite_transaction_id) as netsuite_transaction_id,
        etail_order_id as shopify_order_id,
        array_to_string(array_slice(split(authorization_code, ';'), 0, 1), ',') as authorization_code
    from analytics_stage.ns.celigo_etail_order_transactio
    where gateway = 'firstdata_e4'
    and kind = 'sale'
    group by 1,3,4
), nt as (
  select
    regexp_replace(case
      when t.memo ilike '%DSC08%' then regexp_substr(t.memo,'[Oo]?#?[ ]?N?[ ]?(\\d{4,7})',1,1,'e',1)
      else t.related_tranid
    end, '[ #NwW-]{1,}','') as related_tranid,
    t.entity_id as netsuite_customer_id,
    t.transaction_id,
    t.transaction_number,
    l.amount
  from analytics_stage.ns.transactions t
  left join analytics_stage.nstl.transaction_lines l on t.transaction_id = l.transaction_id
  where t.transaction_type in ('Cash Refund', 'Customer Refund')
    and t.transaction_number is not null
    and t.date_deleted is null
    and l.account_id = 133
    and {% condition date_selector %} to_date(t.create_date) {% endcondition %}
  UNION
  select
      regexp_replace(case
        when t.memo ilike '%DSC08%' then regexp_substr(t.memo,'[Oo]?#?[ ]?N?[ ]?(\\d{4,7})',1,1,'e',1)
        else t.related_tranid
      end, '[ #NwW-]{1,}','') as related_tranid,
      t.entity_id as netsuite_customer_id,
      t2.transaction_id,
      t2.transaction_number,
      l.amount
  from analytics_stage.ns.transactions t
  left join analytics_stage.ns.transactions t2 on t.transaction_id = t2.sales_order_ref_id
  left join analytics_stage.nstl.transaction_lines l on t2.transaction_id = l.transaction_id
  where t.transaction_type in ('Cash Sale', 'Sales Order')
    and t2.transaction_number is not null
    and t.date_deleted is null
    and t.warranty_order = 'F'
    and case
      when t2.transaction_type is null then 1
      when t2.transaction_type in ('Cash Refund', 'Customer Refund') then 1
      else 0
    end = 1
    and l.account_id = 133
    and {% condition date_selector %} to_date(t.create_date) {% endcondition %}
), n as (
  select distinct
    related_tranid,
    netsuite_customer_id,
    listagg(distinct transaction_id, ';') within group (order by transaction_id) as transaction_id,
    listagg(distinct transaction_number, ';') within group (order by transaction_number) as transaction_number,
    sum(abs(amount)) as amount,
    count(9) as netsuite_count
  from nt
  where related_tranid is not null
  group by 1,2
), f as (
    select
      listagg(distinct f.tag, ';') within group (order by f.tag) as tag,
      sum(f.amount) as amount,
      listagg(distinct f.ref_num, ';') within group (order by f.ref_num) as ref_num,
      listagg(distinct f.auth_no, ';') within group (order by f.auth_no) as auth_no,
      listagg(distinct o.id, ';') within group (order by o.id) as id,
      regexp_replace(o.name,'[ #N]{1,}','') as name,
      o.customer_id as shopify_customer_id,
      max(time) as created,
      count(9) as gateway_count
    from analytics.accounting.first_data_transaction f
      left join analytics_stage.shopify_us_ft.transaction s on f.ref_num = s.receipt:reference_no
          and f.auth_no = s.receipt:authorization_num
          and f.tag::varchar = s.receipt:transaction_tag
      left join analytics_stage.shopify_us_ft."ORDER" o on s.order_id = o.id
    where transaction_type = 'Tagged Refund'
      and {% condition date_selector %} to_date(f.time) {% endcondition %}
    group by 6,7
), g as (
  select
      'First Data' as gateway,
      f.tag::varchar as transaction_id,
      null as secondary_id,
      f.ref_num::varchar as po_id,
      f.created::timestamp_tz as created,
      'Refund' as transaction_type,
      'USD' as currency,
      f.amount::float as transaction_amount,
      n.amount::float as netsuite_amount,
      f.name::varchar as shopify_order_number,
      f.shopify_customer_id,
      f.id::varchar as shopify_order_id,
      n.transaction_id::varchar as netsuite_tran_id,
      n.transaction_number::varchar as netsuite_transaction_id,
      n.netsuite_customer_id
  from f
  left join n on f.name = n.related_tranid
  where f.created >= '2018-01-01'
  UNION ALL
  select
      'First Data' as gateway,
      tag::varchar as transaction_id,
      auth_no::varchar as secondary_id,
      ref_num::varchar as po_id,
      time::timestamp_tz as created,
      'Capture' as transaction_type,
      'USD' as currency,
      f.amount::float as transaction_amount,
      l.amount::float as netsuite_amount,
      regexp_replace(o.name::varchar,'[ #N]{1,}','') as shopify_order_number,
      o.customer_id as shopify_customer_id,
      o.id::varchar as shopify_order_id,
      d.customer_deposit_id::varchar as netsuite_tran_id,
      d.TRANSACTION_NUMBER::varchar as netsuite_transaction_id,
      t.entity_id as netsuite_customer_id
  from analytics.accounting.first_data_transaction f
    left join analytics_stage.shopify_us_ft.transaction s on f.ref_num = s.receipt:reference_no
        and f.auth_no = s.receipt:authorization_num
        and f.tag::varchar = s.receipt:transaction_tag
    left join analytics_stage.shopify_us_ft."ORDER" o on s.order_id = o.id
    left join z on o.id = z.shopify_order_id
    left join analytics.sales.customer_deposit d on z.netsuite_transaction_id = d.sales_order_id
    left join analytics_stage.nstl.transaction_lines l on d.customer_deposit_id = l.transaction_id
    left join analytics_stage.ns.transactions t on l.transaction_id = t.transaction_id
  where f.status = 'Approved'
  and f.transaction_type = 'Purchase'
  and case
      when l.account_id is null then 1
      when l.account_id = 133 then 1
      else 0
  end = 1
  and {% condition date_selector %} f.time {% endcondition %}
)
select * from g
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

  dimension: shopify_order_number {
    type: string
    sql:${TABLE}.shopify_order_number;;
  }

  dimension: shopify_customer_id {
    type: number
    sql:${TABLE}.shopify_customer_id;;
  }

  dimension: shopify_order_id {
    type: string
    sql:${TABLE}.shopify_order_id;;
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



}
