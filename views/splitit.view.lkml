#############################
## Blake Walton 2020-06-02
#############################
# this is a dynamic query where you select the date range in the Look
view: splitit {
  derived_table: {
    sql:
    with s as (
      select
        trim(coalesce(c.first_name,'') || ' ' || coalesce(c.last_name,'')) as customer, so.order_id,
        o.name as shopify_order_number, authorization as plan_number, so.tranid as netsuite_order_number,
        max(case
          when kind = 'sale' then receipt:x_reference::string
          else null
        end) as ref_num,
        sum(case
          when kind = 'sale' then amount
          else 0
        end) as shopify_amount,
        sum(case
          when kind = 'refund' then amount
          else 0
        end) as shopify_refunded
      from analytics_stage.shopify_us_ft.transaction t
        join analytics_stage.shopify_us_ft."ORDER" o on t.order_id = o.id
        join analytics_stage.shopify_us_ft.customer c on o.customer_id = c.id
        left join analytics.sales.sales_order so on o.id::varchar = so.etail_order_id
      where gateway = 'splitit_monthly_payments'
        and t.status = 'success'
        and {% condition date_selector %}  t.created_at {% endcondition %}
        --and t.created_at < '2020-10-01'
      group by 1,2,3,4,5
    ), fd as (
      select
        ref_num,
        sum(case
          when transaction_type = 'Tagged Completion' then amount
          else 0
        end) as fd_paid_amt,
        sum(case
          when transaction_type = 'Tagged Refund' then amount
          else 0
        end) as fd_refund_amt
      from analytics.accounting.first_data_transaction
      where status = 'Approved'
        and transaction_type in ('Tagged Completion','Tagged Refund')
        and {% condition date_selector %}  time {% endcondition %}
        --and time < '2020-10-01'
      group by 1
    ), ns as (
      select s.order_id, min(s.gross_amt) as ns_amt, coalesce(sum(rol.gross_amt),0) as ns_refund_amt
      from analytics.sales.sales_order s
        left join analytics.sales.return_order_line rol on s.order_id = rol.order_id
      where {% condition date_selector %}  rol.closed {% endcondition %}
        --where rol.closed < '2020-10-01'
      group by 1
    )
    select
      s.customer, s.shopify_order_number, s.ref_num, s.plan_number, s.netsuite_order_number,
      s.shopify_amount, s.shopify_refunded, s.shopify_amount - s.shopify_refunded as shopify_bal,
      fd_paid_amt, fd_refund_amt, round(shopify_bal - (fd_paid_amt-fd_refund_amt),2) as amt_due, ns_amt, ns_refund_amt
    from s
      full join fd on s.ref_num = fd.ref_num
      left join ns on s.order_id = ns.order_id
    where amt_due > 0
      ;;
  }

  filter: date_selector {
    type: date_time
    description: "Use this field to select a date to filter results by."
  }

  dimension: customer {
    type: string
    sql:${TABLE}.customer;;
  }

  dimension: shopify_order_number {
    type: string
    sql:${TABLE}.shopify_order_number;;
  }

  dimension: ref_num {
    type: string
    sql:${TABLE}.ref_num;;
  }

  dimension: plan_number {
    type: string
    sql:${TABLE}.plan_number;;
  }

  dimension: netsuite_order_number {
    type: string
    sql:${TABLE}.netsuite_order_number;;
  }

  measure: shopify_amount {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.shopify_amount;;
  }

  measure: shopify_refunded {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.shopify_refunded;;
  }

  measure: shopify_bal {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.shopify_bal;;
  }

  measure: fd_paid_amt {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.fd_paid_amt;;
  }

  measure: fd_refund_amt {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.fd_refund_amt;;
  }

  measure: amt_due {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.amt_due;;
  }

  measure: ns_amt {
    type: sum
    value_format: "$#,##0.00"
    sql:${TABLE}.ns_amt;;
  }

  measure: ns_refund_amt {
    type: sum
    value_format: "$0,0##.##"
    sql:${TABLE}.ns_refund_amt;;
  }

}
