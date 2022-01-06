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
          UNION ALL
          select
              o.id,
              SUBTOTAL_PRICE + TOTAL_TAX  as gross_sales,
              to_date(convert_timezone('America/Denver', o.created_at)) as created
          from ANALYTICS_STAGE.SHOPIFY_OUTLET."ORDER" o
          left join analytics_stage.shopify_outlet.transaction t on o.id = t.order_id
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
      ), ct as (
        select
            SUM(o.TOTAL_GROSS) as ct_gross_sales,
            to_date(convert_timezone('America/Denver', o.created)) as created_date
        FROM analytics.commerce_tools.ct_order o
        WHERE to_date(created) = dateadd(day,-1,current_date)
        GROUP BY created_date
      )
      select
          a.date as DATE,
          sum(case when a.EXTRACTED_SYSTEM = 'NETSUITE' then amount  else 0 end) as NETSUITE_AMOUNT,
          sum(case when a.EXTRACTED_SYSTEM = 'ANALYTICS' then amount else 0  end) as ANALYTICS_AMOUNT,
          COALESCE(max(Sg.GROSS_SALES), 0) as SHOPIFY_AMOUNT,
          COALESCE(max(ct.ct_gross_sales), 0) as COMMERCETOOLS_AMOUNT,
          COALESCE(max(Sg.GROSS_SALES), 0) + COALESCE(max(ct.ct_gross_sales), 0) as ETAIL_AMOUNT
      from analytics.agg_check.DAILY_SOURCE_SALES_CHECK A
      left join sg on A.DATE = Sg.CREATED
      left join ct on A.DATE = ct.CREATED_DATE
      where a.source in ('Shopify - US', 'Shopify - Canada', 'Shopify - POS', 'Commerce Tools') and to_date(a.date) = dateadd(day,-1,current_date)
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

  measure:COMMERCETOOLS_AMOUNT   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.COMMERCETOOLS_AMOUNT ;;  }

  measure:ETAIL_AMOUNT   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.ETAIL_AMOUNT ;;  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.NETSUITE_AMOUNT, ${TABLE}.ANALYTICS_AMOUNT,${TABLE}.SHOPIFY_AMOUNT,${TABLE}.COMMERCETOOLS_AMOUNT,${TABLE}.ETAIL_AMOUNT) ;;
  }

}
