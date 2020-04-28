view: at_risk_amount {
  derived_table: {
    sql:
      select a.date
    , count(order_id) as total_orders
    , sum(z.total_amount) as total_amount
from util.warehouse_date a
left join (
   select
    sol.order_id
    , sol.item_id
    , case
        when lower(so.system) like ('%shopify%') and lower(so.system) like ('%us%')
          or lower(so.source) like ('%shopify%') and lower(so.source) like ('%us%')
          or lower(so.source) like ('%direct entry%') or (so.source is null)
          then 'SHOPIFY-US'
        when lower(so.system) like ('%shopify-ca%')
          or lower(so.source) like ('%shopify-ca%')
          then 'SHOPIFY-CA'
        when lower(so.system) like ('%amazon-ca%')
          or lower(so.source) like ('%amazon-ca%')
          then 'AMAZON-CA'
        when lower(so.source) like ('%amazon%') or  lower(so.system) like ('%amazon%')
          then 'AMAZON-US'
        else 'OTHER'
        end as channel_source_buckets
    , sum(sol.gross_amt) as total_amount
    , min(sol.created::date) as created
    , min(dateadd('day',14,sol.created::date)) as created14
    , max(coalesce(sol.fulfilled, dateadd('day',1,current_date))) as ff
    --, max(coalesce(f.fulfilled, dateadd('day',1,current_date))) as fulfilled
    , max(coalesce(co.cancelled, dateadd('day',1,current_date))) as cancelled
  from sales.sales_order_line sol left join sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
    --left join sales.fulfillment f on sol.order_id = f.order_id and sol.item_id = f.item_id and sol.system = f.system
    left join sales.cancelled_order co on sol.order_id = co.order_id and sol.item_id = co.item_id and sol.system = co.system
    left join sales.item i on sol.item_id = i.item_id
  where
    --co.cancelled is null
    --and
    sol.created >= '2019-01-01'
    and
    i.item_id != 0
    --and f.fulfilled is null
    and so.channel_id in (1,5)
    and so.gross_amt >10
    and sol.location != '900 - Employee Store'
    and channel_source_buckets = 'SHOPIFY-US'
  group by 1,2,3
) z on z.created14 <= a.date and z.ff > a.date and z.cancelled > a.date
where a.date between '2019-01-01' and current_date
group by 1
order by 1 desc
    ;;
  }

  dimension_group: created {
    hidden: no
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.date ;;
  }

  measure: total_orders {
    type: sum
    sql: ${TABLE}.total_orders ;;
  }

  measure: at_risk_amount {
    type: sum
    value_format: "$#, ##0.00"
    sql: ${TABLE}.total_amount ;;
  }

}
