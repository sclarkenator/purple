view: agg_check {
  derived_table: {
    sql: select  a.date as DATE,
      sum (case when a.EXTRACTED_SYSTEM = 'NETSUITE' then amount  else 0 end) as NETSUITE_AMOUNT
      , sum (case when a.EXTRACTED_SYSTEM = 'ANALYTICS' then amount else 0  end) as ANALYTICS_AMOUNT
      , max (S.GROSS_SALES) as SHOPIFY_AMOUNT
    from analytics.agg_check.DAILY_SOURCE_SALES_CHECK A
    join  (
      select   to_date(convert_timezone('America/Denver',s.CREATED_AT)) as CREATED
        , sum ( s.SUBTOTAL_PRICE) + sum(s.TOTAL_TAX)  as GROSS_SALES
      from  ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" s
      where to_date(convert_timezone('America/Denver',s.CREATED_AT)) = dateadd(day,-1,current_date)
      group by 1
    ) S on A.DATE = S.CREATED
    where a.source = 'Shopify - US' and to_date(a.date) = dateadd(day,-1,current_date)
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
