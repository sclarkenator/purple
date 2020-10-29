view: store_four_wall {
  derived_table: {
    sql: WITH standard_cost AS
(select
    coalesce(b.item_id, a.item_id) as ac_item_id,
    a.item_id,
    max(standard_cost) as cost
from sales.item_standard_cost a
left join
    (select
    right(a.sku_id,11) as clean_sku_id,
    max(case when a.sku_id like 'AC-%' then a.item_id else null end) as ac_item_id,
    min(case when length(a.sku_id) = 11 then a.item_id else null end) as item_id
from sales.item a
group by 1) b on b.ac_item_id = a.item_id
group by 1,2 )
,
item_return_rate AS
(select trim(i.sku_id,'AC-') sku_id
              ,nvl(sum(returns),0)/sum(sales) return_rate
      from
      (
      select sol.item_id
              ,sum(returns) returns
              ,sum(sol.gross_amt) sales
      from sales.sales_order_line sol
      left join sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
      left join
            (select rl.order_id
                    ,rl.item_id
                    ,rl.system
                    ,sum(rl.gross_amt) returns
             from sales.return_order_line rl
             join sales.return_order ro on ro.return_order_id = rl.return_order_id
             where ro.status = 'Refunded'
             and rl.closed > '2019-10-01'
             group by 1,2,3
             order by 4 desc) r
          on r.order_id = sol.order_id and r.item_id = sol.item_id and r.system = sol.system
      where datediff(d,sol.fulfilled,current_date)>130 and datediff(d,sol.fulfilled,current_date)<=220
      and so.channel_id = 1
      group by 1
      having sum(sol.gross_amt)>0) s
      join sales.item i on i.item_id = s.item_id
      group by 1)
,
contribution as
(SELECT sales_order.showroom_name STORE,
        date_trunc(month,sales_order.trandate) month,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(nvl(sales_order_line.adjusted_gross_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) gross_sales,
  (COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(sales_order_line.ordered_qty * standard_cost.cost ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0))  COGS,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when ((TO_CHAR(TO_DATE(case when sales_order.TRANSACTION_TYPE = 'Cash Sale' or sales_order.SOURCE = 'Amazon-FBA-US'  then (TO_CHAR(DATE_TRUNC('second', sales_order.CREATED ), 'YYYY-MM-DD HH24:MI:SS')) else (to_timestamp_ntz(fulfillment.fulfilled)) end ), 'YYYY-MM-DD')) is null
                or datediff(d,(TO_CHAR(TO_DATE(case when sales_order.TRANSACTION_TYPE = 'Cash Sale' or sales_order.SOURCE = 'Amazon-FBA-US'  then (TO_CHAR(DATE_TRUNC('second', sales_order.CREATED ), 'YYYY-MM-DD HH24:MI:SS')) else (to_timestamp_ntz(fulfillment.fulfilled)) end ), 'YYYY-MM-DD')),current_date)<130) then item_return_rate.return_rate*sales_order_line.gross_amt
                else nvl((case when return_order.STATUS = 'Refunded' then return_order_line.gross_amt else 0 end),0) end ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5((NVL(fulfillment.FULFILLMENT_ID,'0') || NVL(fulfillment.system,'0') || NVL(fulfillment.item_id,'0') || NVL(fulfillment.parent_item_id,'0'))||'-'||(NVL(return_order.return_order_id,0)||NVL(return_order.order_id,0))||'-'||(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5((NVL(fulfillment.FULFILLMENT_ID,'0') || NVL(fulfillment.system,'0') || NVL(fulfillment.item_id,'0') || NVL(fulfillment.parent_item_id,'0'))||'-'||(NVL(return_order.return_order_id,0)||NVL(return_order.order_id,0))||'-'||(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) RETURNS,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when (shipping."MAINFREIGHT") > 0 then 5.24 else 0 end  + shipping."SHIPPING_TOTAL" ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5((shipping."ORDER_ID")||'-'||(shipping."ITEM_ID") ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5((shipping."ORDER_ID")||'-'||(shipping."ITEM_ID") ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) SHIPPING,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when sales_order.SOURCE in ('Amazon-FBM-US','Amazon-FBA','Amazon FBA - US') then 0.15*sales_order_line.gross_amt
              when sales_order.PAYMENT_METHOD ilike 'AFFIRM' then 0.0497*sales_order_line.gross_amt
              when sales_order.PAYMENT_METHOD ilike 'SPLITIT' then .04*sales_order_line.gross_amt
              else 0.0255*sales_order_line.gross_amt end ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) MERCHANT_FEES,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when ((nvl(affiliate_sales_order."TOTAL_COMMISSION",0))/(case when affiliate_sales_order."SALES" < 1 then 1 else affiliate_sales_order.sales end)) < 0 then 0 else nvl(((nvl(affiliate_sales_order."TOTAL_COMMISSION",0))/(case when affiliate_sales_order."SALES" < 1 then 1 else affiliate_sales_order.sales end)),0)*sales_order_line.gross_amt end ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) AFFILIATE_FEES,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(0.01*sales_order_line.gross_amt ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) WARRANTY_ACCRUAL
FROM SALES.SALES_ORDER_LINE  AS sales_order_line
LEFT JOIN SALES.ITEM  AS item ON sales_order_line.ITEM_ID = item.ITEM_ID
LEFT JOIN SALES.FULFILLMENT  AS fulfillment ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (case when fulfillment.parent_item_id = 0 or fulfillment.parent_item_id is null then fulfillment.item_id else fulfillment.parent_item_id end)||'-'||fulfillment.order_id||'-'||fulfillment.system
LEFT JOIN SALES.SALES_ORDER  AS sales_order ON (sales_order_line.order_id||'-'||sales_order_line.system) = (sales_order.order_id||'-'||sales_order.system)
FULL OUTER JOIN (SELECT * FROM SALES.RETURN_ORDER_LINE WHERE system != 'SHOPIFY-US')  AS return_order_line ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (return_order_line.item_id||'-'||return_order_line.order_id||'-'||return_order_line.system)
FULL OUTER JOIN SALES.RETURN_ORDER  AS return_order ON return_order_line.RETURN_ORDER_ID = return_order.RETURN_ORDER_ID
LEFT JOIN standard_cost ON standard_cost.item_id = item.ITEM_ID or standard_cost.ac_item_id = item.ITEM_ID
LEFT JOIN "MARKETING"."RAKUTEN_AFFILIATE_ORDER"    AS affiliate_sales_order ON sales_order.related_tranid=('#'||affiliate_sales_order."ORDER_ID"
)
LEFT JOIN item_return_rate ON item.SKU_ID = item_return_rate.sku_id
LEFT JOIN "SALES"."SHIPPING"
     AS shipping ON sales_order_line.ITEM_ID = (shipping."ITEM_ID") and sales_order_line.ORDER_ID = (shipping."ORDER_ID")

WHERE sales_order.CHANNEL_id = 5
GROUP BY 1,2)
,
PNL as
(select retail_location store
        ,to_Date(date_trunc(month,(ending))) month
        ,upper(case when category = 'Wholesale & Retail Compensation' then 'compensation'
               when name ilike 'lease%' then 'rent'
               when name ilike 'rent%' then 'RENT'
               when name ilike 'water%' then 'UTILITIES'
               when name ilike 'interne%' then 'UTILITIES'
               else 'other' end) expense_Type
        ,sum(gross_amount) gross_amount
from analytics.sales.v_pnl
where retail_location is not null
and name not ilike 'Depreciat%'
group by 1,2,3)
select case when contribution.store = 'CA-01' then 'San Diego'
            when contribution.store = 'CA-02' then 'Santa Clara'
            when contribution.store = 'CA-03' then 'Santa Monica'
            when contribution.store = 'WA-01' then 'Seattle'
            when contribution.store in ('FO-01','FO_01') then 'Salt Lake'
            when contribution.store = 'UT-01' then 'Lehi'
            when contribution.store = 'TX-01' then 'Austin'
            else contribution.store end STORE
        ,contribution.month
        ,contribution.gross_Sales
        ,contribution.cogs
        ,contribution.returns
        ,contribution.shipping
        ,contribution.merchant_fees
        ,contribution.affiliate_fees
        ,contribution.warranty_accrual
        ,nvl(p1.gross_amount,0) RENT
        ,nvl(p2.gross_amount,0) COMPENSATION
        ,nvl(p4.gross_amount,0) UTILITIES
        ,nvl(p5.gross_amount,0) OTHER
from contribution
left join pnl p1 on p1.store = contribution.store and p1.month = contribution.month and p1.expense_type = 'RENT'
left join pnl p2 on p2.store = contribution.store and p2.month = contribution.month and p2.expense_type = 'COMPENSATION'
left join pnl p4 on p4.store = contribution.store and p4.month = contribution.month and p4.expense_type = 'UTILITIES'
left join pnl p5 on p5.store = contribution.store and p5.month = contribution.month and p5.expense_type = 'OTHER'
 ;;}

##Added by Scott Clark 10/29/2020

  dimension: store {
    label: "Location"
    description: "Retail location (based on showroom name field, ie. UT-01)"
    type: string
    sql: ${TABLE}.store ;;
  }

  dimension_group: month {
    type: time
    label: "Expense Date"
    description: "This is the month sales and expenses were incurred"
    timeframes: [
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.month ;;
  }

  measure: gross_sales {
    type: sum
    label: "Gross Sales"
    value_format_name: usd_0
    description: "Total gross sales"
    sql: ${TABLE}."GROSS_SALES" ;;
  }

  measure: cogs{
    type: sum
    value_format_name: usd_0
    label: "COGS"
    description: "Total COGS for items sold (based on standard cost from accounting)"
    sql: ${TABLE}.cogs ;;
  }

  measure: returns{
    type: sum
    value_format_name: usd_0
    label: "Returns"
    description: "Modeled return rate for any items fulfilled less than 130 days ago, actuals used beyond that"
    sql: ${TABLE}.returns ;;
  }

  measure: shipping{
    type: sum
    value_format_name: usd_0
    label: "Shipping"
    description: "Direct shipping costs incurred as reported in Netsuite AND through Pilot"
    sql: ${TABLE}.shipping ;;
  }

  measure: merchant_fees{
    type: sum
    value_format_name: usd_0
    label: "Merchant fees"
    description: "Payment processing fees incurred based on mix of payment methods used."
    sql: ${TABLE}.merchant_fees ;;
  }

  measure: affiliate_fees{
    type: sum
    value_format_name: usd_0
    hidden: yes
    label: "Affiliate fees"
    description: "Affiliate fees related to transactions within that store"
    sql: ${TABLE}.affiliate_fees ;;
  }

  measure: warranty_accrual{
    type: sum
    value_format_name: usd_0
    label: "Warranty accrual"
    description: "Warranty accrual based on items sold at a store during a period"
    sql: ${TABLE}.warranty_accrual ;;
  }

  measure: rent {
    value_format_name: usd_0
    type: sum
    label: "Rent"
    description: "Lease expense for retail store, does not include depreciation expenses"
    sql: ${TABLE}.rent ;;
  }

  measure: compensation {
    value_format_name: usd_0
    type: sum
    label: "Compensation"
    description: "Total compensation for direct labor at store"
    sql: ${TABLE}.compensation ;;
  }

  measure: utilities {
    value_format_name: usd_0
    type: sum
    label: "Utilities"
    description: "Utility expenses incurred during the month, including internet, water, gas, etc."
    sql: ${TABLE}.utilities ;;
  }

  measure: other {
    value_format_name: usd_0
    type: sum
    label: "Other expenses"
    description: "These are other expenses showing up at the store level, including office supplies, maintenance, employee morale, etc."
    sql: ${TABLE}.other ;;
  }


}
