view: agg_check {
  derived_table: {
    sql:


select CASE
           when (abs(X.NETSUITE_AMOUNT - X.SHOPIFY_AMOUNT)/X.SHOPIFY_AMOUNT) * 100 > 10.00 then 'ERROR'
           else 'NO ERROR'
       END as RAISE_ALERT
from
   (select  date,
           sum(case
               when EXTRACTED_SYSTEM = 'NETSUITE' then amount
               else 0
           end) as NETSUITE_AMOUNT,
           max(s.GROSS_SALES) as SHOPIFY_AMOUNT
   from analytics.agg_check.DAILY_SOURCE_SALES_CHECK n join
        (select  to_date(convert_timezone('America/Denver',s.CREATED_AT)) as CREATED,
                     sum(s.SUBTOTAL_PRICE) + sum(s.TOTAL_TAX)  as GROSS_SALES
             from    ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" s
             where to_date(convert_timezone('America/Denver',s.CREATED_AT)) = dateadd(day,-1,current_date)
             group by 1
        ) s
           on n.date = s.CREATED
   where n.extracted_system = 'NETSUITE' and n.source = 'Shopify - US' and to_date(n.date) = dateadd(day,-1,current_date)
   group by 1) X ;;
    }

  dimension: alert_flg {
    sql: ${TABLE}.raise_alert ;;
  }


}
