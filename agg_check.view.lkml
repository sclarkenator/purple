#-------------------------------------------------------------------
# Owner - Aditya Kannan
# Use pulling the sales amounts from netsuite and shopify and comparing
#   to our sales dataset
#-------------------------------------------------------------------
view: agg_check {
  derived_table: {
    sql: with s as (
   select
        o.id,
        SUBTOTAL_PRICE + TOTAL_TAX  as gross_sales,
        to_date(convert_timezone('America/Denver', o.created_at)) as created
    from ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" o
    left join analytics_stage.shopify_us_ft.transaction t on o.id = t.order_id
    where to_date(convert_timezone('America/Denver',o.CREATED_AT)) = dateadd(day,-1,current_date)
    and case
        when t.id is null then 1
        when t.kind in ('capture', 'sale') and t.status = 'success' then 1
        else 0
    end = 1
    UNION ALL
    select
        o.id,
        SUBTOTAL_PRICE + TOTAL_TAX  as gross_sales,
        to_date(convert_timezone('America/Denver', o.created_at)) as created
    from ANALYTICS_STAGE.SHOPIFY_ca_FT."ORDER" o
    left join analytics_stage.shopify_ca_ft.transaction t on o.id = t.order_id
    where to_date(convert_timezone('America/Denver',o.CREATED_AT)) = dateadd(day,-1,current_date)
    and case
        when t.id is null then 1
        when t.kind in ('capture', 'sale') and t.status = 'success' then 1
        else 0
    end = 1
), sg as (
  select
      s.created,
      sum(gross_sales) as gross_sales
  from s
  group by 1
)
select
    a.date as DATE,
    sum(case when a.EXTRACTED_SYSTEM = 'NETSUITE' then amount  else 0 end) as NETSUITE_AMOUNT,
    sum(case when a.EXTRACTED_SYSTEM = 'ANALYTICS' then amount else 0  end) as ANALYTICS_AMOUNT,
    max(Sg.GROSS_SALES) as SHOPIFY_AMOUNT
from analytics.agg_check.DAILY_SOURCE_SALES_CHECK A
join sg on A.DATE = Sg.CREATED
where a.source in ('Shopify - US', 'Shopify - Canada') and to_date(a.date) = dateadd(day,-1,current_date)
group by 1;;  }

  measure:NETSUITE_AMOUNT   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.NETSUITE_AMOUNT ;;  }

  measure:ANALYTICS_AMOUNT   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.ANALYTICS_AMOUNT ;;  }

  measure:SHOPIFY_AMOUNT   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.SHOPIFY_AMOUNT ;;  }

}
