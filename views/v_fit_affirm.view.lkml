view: v_fit_affirm {
  derived_table: {
    sql:
    with af as (
      select
        entry_id,
        min(t.created) as created,
        listagg(t.amount, ';') within group (order by t.amount) as affirm_amounts,
        sum(t.amount) as affirm_total
      from analytics.accounting.affirm_transaction t
        join analytics.accounting.affirm_header h on t.entry_id = h.id
      where t.event_type = 'refund'
        and {% condition date_selector %} to_date(convert_timezone('America/Denver',t.created)) {% endcondition %}
        and h.platform = 'Shopify'
      group by 1
    ), sh as (
      select
        regexp_replace(o.name,'[ #NwW-]{1,}','') as order_number,
        t.authorization as loan_id,
        listagg(t.amount, ';') within group (order by t.amount) as etail_amounts,
        sum(t.amount) as etail_total
      from analytics_stage.shopify_us_ft.transaction t
        join analytics_stage.shopify_us_ft."ORDER" o on t.order_id = o.id
      where t.gateway = 'affirm'
        and t.kind = 'refund'
        and {% condition date_selector %} to_date(convert_timezone('America/Denver',t.created_at)) {% endcondition %}
      group by 1,2
    ), ct as (
      select
        afh.id as loan_id, o.order_number,
        min(afh.created) as created,
        listagg(aft.amount,';') within group (order by aft.amount) as affirm_amounts,
        sum(aft.amount) as affirm_total,
        listagg(t.amt, ';') within group (order by t.amt) as etail_amounts,
        sum(t.amt) as etail_total
      from analytics.commerce_tools.ct_transaction t
        join analytics.commerce_tools.ct_order o on t.order_id = o.order_id
        left join analytics.accounting.affirm_transaction aft on t.interaction_id = aft.event_id
        left join analytics.accounting.affirm_header afh on aft.entry_id = afh.id
      where t.state = 'Success' and t.type = 'Refund' and aft.event_type = 'refund'
        and {% condition date_selector %} to_date(t.transaction_ts) {% endcondition %}
        and afh.merchant_external_reference ilike 'CT%'
      group by 1,2
    ), nst as (
      select
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
          t.transaction_id,
          l.amount*-1 as amount
      from analytics_stage.ns.transactions t
        left join analytics_stage.nstl.transaction_lines l on t.transaction_id = l.transaction_id
        left join analytics_stage.ns.transactions tso on t.sales_order_ref_id = tso.transaction_id
        left join analytics_stage.ns.transactions oso on tso.original_sales_order_id = oso.transaction_id
        left join analytics_stage.ns.transactions oso2 on oso.original_sales_order_id = oso2.transaction_id
      where t.transaction_type in ('Cash Refund', 'Customer Refund')
        and l.account_id = 137
        and abs(l.amount) > 0
        and {% condition date_selector %} to_date(convert_timezone('America/Denver',t.create_date)) {% endcondition %}
    ), ns as (
      select
        order_number,
        listagg(distinct transaction_id,';') within group (order by transaction_id) as transaction_ids,
        listagg(distinct amount,';') within group (order by amount) as netsuite_amounts,
        sum(amount) as netsuite_total
      from nst
      group by 1
    ), final as (
      select
        'Refund' as event_type,
        af.created,
        af.entry_id as affirm_id,
        af.affirm_amounts,
        af.affirm_total,
        sh.order_number,
        sh.etail_amounts,
        sh.etail_total,
        ns.transaction_ids as ns_transaction_ids,
        ns.netsuite_amounts,
        ns.netsuite_total
      from af
        left join sh on af.entry_id = sh.loan_id
        left join ns on sh.order_number = ns.order_number
      UNION ALL
      select
        'Refund' as event_type,
        ct.created,
        ct.loan_id as affirm_id,
        ct.affirm_amounts,
        ct.affirm_total,
        ct.order_number,
        ct.etail_amounts,
        ct.etail_total,
        ns.transaction_ids as ns_transaction_ids,
        ns.netsuite_amounts,
        ns.netsuite_total
      from ct
        left join ns on ct.order_number = ns.order_number
      UNION ALL
      select
        'Charge' as event_type,
        ah.created,
        a.entry_id as affirm_id,
        a.amount::varchar as affirm_amounts,
        a.amount::float as affirm_total,
        o.order_number::string as order_number,
        t.amount::varchar as etail_amounts,
        t.amount::float as etail_total,
        d.transaction_number as ns_transaction_ids,
        d.gross_amount::varchar as netsuite_amounts,
        d.gross_amount::float as netsuite_total
      from analytics.accounting.affirm_transaction a
        join analytics.accounting.affirm_header ah on a.entry_id = ah.id
        left join analytics_stage.shopify_us_ft.transaction t on a.entry_id = t.authorization and a.reference_id = t.receipt:x_reference
        left join analytics_stage.shopify_us_ft."ORDER" o on t.order_id = o.id
        left join analytics.sales.sales_order so on o.id::string = so.etail_order_id
        left join analytics.sales.customer_deposit d on so.order_id = d.sales_order_id
      where a.event_type = 'capture'
        and {% condition date_selector %} a.created {% endcondition %}
        and ah.source = 'Website'
        and ah.platform = 'Shopify'
      UNION ALL
      select
        'Charge' as event_type,
        afh.created,
        afh.id as affirm_id,
        aft.amount::string as affirm_amounts,
        aft.amount as affirm_total,
        o.order_number,
        t.amt::string as etail_amounts,
        t.amt as etail_total,
        d.transaction_number as ns_transaction_ids,
        d.gross_amount::varchar as netsuite_amounts,
        d.gross_amount::float as netsuite_total
      from analytics.commerce_tools.ct_transaction t
        join analytics.commerce_tools.ct_order o on t.order_id = o.order_id
        left join analytics.accounting.affirm_transaction aft on t.interaction_id = aft.event_id
        left join analytics.accounting.affirm_header afh on aft.entry_id = afh.id
        left join analytics.sales.sales_order so on o.order_id = so.etail_order_id
        left join analytics.sales.customer_deposit d on so.order_id = d.sales_order_id
      where t.state = 'Success' and t.type = 'Charge' and aft.event_type = 'capture'
        and {% condition date_selector %} to_date(t.transaction_ts) {% endcondition %}
        and afh.source = 'Website'
        and afh.merchant_external_reference ilike 'CT%'
    )
    select
      event_type, created, affirm_id, affirm_amounts, affirm_total, order_number,
      etail_amounts, etail_total, ns_transaction_ids, netsuite_amounts, netsuite_total,
      abs(coalesce(affirm_total,0) - coalesce(netsuite_total,0)) as amount_difference
    from final
      ;;
  }

  filter: date_selector {
    type: date_time
    description: "Use this field to select a date to filter results by."
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension: event_type {
    type: string
    sql:${TABLE}.event_type;;
  }

  dimension: affirm_id {
    type: string
    sql:${TABLE}.affirm_id;;
  }

  dimension: affirm_amounts {
    type: string
    sql:${TABLE}.affirm_amounts;;
  }

  dimension: order_number {
    type: string
    sql:${TABLE}.order_number;;
  }

  dimension: etail_amounts {
    type: string
    sql:${TABLE}.etail_amounts;;
  }

  dimension: ns_transaction_ids {
    type: string
    sql:${TABLE}.ns_transaction_ids;;
  }

  dimension: netsuite_amounts {
    type: string
    sql:${TABLE}.netsuite_amounts;;
  }

  measure: affirm_total {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.affirm_total;;
  }

  measure: etail_total {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.etail_total;;
  }

  measure: netsuite_total {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.netsuite_total;;
  }

  measure: amount_difference {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.amount_difference;;
  }

}
