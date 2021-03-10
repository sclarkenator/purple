view: store_four_wall {
  derived_table: {
    sql: WITH standard_cost AS
(select
        coalesce(b.item_id, a.item_id) as ac_item_id
        , a.item_id
        , max(standard_cost) as cost
      from sales.item_standard_cost a
      left join
          (
        select
          right(a.sku_id,11) as clean_sku_id
          , max(case when a.sku_id like 'AC-%' then a.item_id else null end) as ac_item_id
          , min(case when length(a.sku_id) = 11 then a.item_id else null end) as item_id
        from sales.item a
        group by 1
      ) b on b.ac_item_id = a.item_id
      where a.end_date = '2099-01-01'
      group by 1,2 )
,

contribution as
(
SELECT
  case when sales_order.showroom_name = 'CA-01' then 'San Diego'
  when sales_order.showroom_name = 'CA-02' then 'Santa Clara'
  when sales_order.showroom_name = 'CA-03' then 'Santa Monica'
  when sales_order.showroom_name = 'WA-01' then 'Seattle'
  when sales_order.showroom_name in ('FO-01','FO_01') then 'Salt Lake'
  when sales_order.showroom_name = 'UT-01' then 'Lehi'
  when sales_order.showroom_name = 'TX-01' then 'Austin'
  when sales_order.showroom_name = 'VA-01' then 'Tysons'
  when sales_order.showroom_name = 'WA-02' then  'Lynnwood'
  when sales_order.showroom_name = 'OH-01' then  'Columbus'
  else sales_order.showroom_name end store,
  to_date(DATE_TRUNC('month', to_timestamp_ntz(sales_order_line.Created) )) month,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(sales_order_line.PRE_DISCOUNT_AMT ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) full_IMU,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(nvl(sales_order_line.order_discount_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) order_discount,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(nvl(sales_order_line.adjusted_discount_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) promo_discount,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(nvl(sales_order_line.cc_discount,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) cc_discount,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(nvl(sales_order_line.adjusted_gross_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) gross_sales,
  (COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(sales_order_line.ordered_qty * standard_cost.cost ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0))  cogs,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(item_return_rate.adj_return_amt ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(item_return_rate.order_id||'-'||item_return_rate.channel||'-'||item_return_rate.sku_id||'-'||item_return_rate.pk_row), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(item_return_rate.order_id||'-'||item_return_rate.channel||'-'||item_return_rate.sku_id||'-'||item_return_rate.pk_row), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) return_amt,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(item_return_rate.adj_ret_clawback ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(item_return_rate.order_id||'-'||item_return_rate.channel||'-'||item_return_rate.sku_id||'-'||item_return_rate.pk_row), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(item_return_rate.order_id||'-'||item_return_rate.channel||'-'||item_return_rate.sku_id||'-'||item_return_rate.pk_row), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) adj_return_amt,
  nvl((COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when (shipping."MAINFREIGHT") > 0 then 5.24 else 0 end  + nvl(shipping."SHIPPING_TOTAL",0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5((shipping."ORDER_ID")||'-'||(shipping."ITEM_ID") ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5((shipping."ORDER_ID")||'-'||(shipping."ITEM_ID") ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0)),0) + nvl((COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when customer_table.companyname ilike '%Raymour & Flanigan Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%d. noblin%' then 0.04*  sales_order_line.gross_amt
              when customer_table.companyname ilike '%Macy%' then 0.095*  sales_order_line.gross_amt
              when customer_table.companyname ilike '%Mattress Firm%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Mathis Brothers Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Big Sandy%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%City Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Living Spaces%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%HOM Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Levin Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Miskelly%s Furnitur%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Ivan Smith%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Nebraska Furniture Ma%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Cardi%s Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Gardner White%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Morris Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Darvin Furniture%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Furniture Ro%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%STEINHAFELS%' then 0.03* sales_order_line.gross_amt
              when customer_table.companyname ilike '%North Dakota Mattress Venture%' then 0.040* sales_order_line.gross_amt
              when customer_table.companyname ilike '%OK Mattress Ventures%' then 0.040* sales_order_line.gross_amt
              when customer_table.companyname ilike '%South Dakota Mattress Ventures%' then 0.040* sales_order_line.gross_amt
              when customer_table.companyname ilike '%Rooms To Go%' then 0.030* sales_order_line.gross_amt else 0 end  ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0)),0) shipping,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when sales_order.CHANNEL_id = 2 then 0
              when sales_order.SOURCE in ('Amazon-FBM-US','Amazon-FBA','Amazon FBA - US') then 0.15
              when sales_order.PAYMENT_METHOD ilike 'AFFIRM' then 0.0497
              when sales_order.PAYMENT_METHOD ilike 'SPLITIT' then 0.04
              else 0.0255 end * nvl(sales_order_line.adjusted_gross_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) merchant_fees,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when ((nvl(affiliate_sales_order."TOTAL_COMMISSION",0))/(case when affiliate_sales_order."SALES" < 1 then 1 else affiliate_sales_order.sales end)) < 0 then 0 else nvl(((nvl(affiliate_sales_order."TOTAL_COMMISSION",0))/(case when affiliate_sales_order."SALES" < 1 then 1 else affiliate_sales_order.sales end)),0)*nvl(sales_order_line.adjusted_gross_amt,0) end ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) affiliate_fees,
  COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(case when customer_table.companyname ilike '%mathis bro%' then 0.02
              when customer_table.companyname ilike '%rooms to go%' then 0.085
              when sales_order.CHANNEL_id = 2 then 0
              else 0.01 end *nvl(sales_order_line.adjusted_gross_amt,0) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) warranty
FROM sales_order_line
LEFT JOIN SALES.ITEM  AS item ON sales_order_line.ITEM_ID = item.ITEM_ID
LEFT JOIN SALES.FULFILLMENT  AS fulfillment ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (case when fulfillment.parent_item_id = 0 or fulfillment.parent_item_id is null then fulfillment.item_id else fulfillment.parent_item_id end)||'-'||fulfillment.order_id||'-'||fulfillment.system
LEFT JOIN SALES.SALES_ORDER  AS sales_order ON (sales_order_line.order_id||'-'||sales_order_line.system) = (sales_order.order_id||'-'||sales_order.system)
LEFT JOIN analytics_stage.ns.CUSTOMERS  AS customer_table ON (customer_table.customer_id::int) = sales_order.CUSTOMER_ID
LEFT JOIN standard_cost ON standard_cost.item_id = item.ITEM_ID or standard_cost.ac_item_id = item.ITEM_ID
LEFT JOIN "MARKETING"."RAKUTEN_AFFILIATE_ORDER"    AS affiliate_sales_order ON sales_order.related_tranid=('#'||affiliate_sales_order."ORDER_ID"
)
FULL OUTER JOIN customer_care.v_zendesk_sell  AS zendesk_sell ON zendesk_sell.order_id=sales_order.order_id and sales_order.SYSTEM='NETSUITE'
LEFT JOIN analytics.sales.item_return_rate AS item_return_rate ON item.SKU_ID = item_return_rate.sku_id and item_return_rate.channel = (case when zendesk_sell.order_id is not null then 'Inside sales'
        when sales_order.CHANNEL_id = 1 then 'Web'
        when sales_order.CHANNEL_id = 5 then 'Retail'
        else 'Other'
      end) and item_return_rate.order_id = sales_order.order_id
LEFT JOIN "SALES"."SHIPPING"
     AS shipping ON sales_order_line.ITEM_ID = (shipping."ITEM_ID") and sales_order_line.ORDER_ID = (shipping."ORDER_ID")
WHERE sales_order.CHANNEL_id = 5
GROUP BY 1,2
)
,
PNL as
(select case when retail_location = 'CA-01' then 'San Diego'
  when retail_location = 'CA-02' then 'Santa Clara'
  when retail_location = 'CA-03' then 'Santa Monica'
  when retail_location = 'WA-01' then 'Seattle'
  when retail_location in ('FO-01','FO_01') then 'Salt Lake'
  when retail_location = 'UT-01' then 'Lehi'
  when retail_location = 'TX-01' then 'Austin'
  when retail_location = 'VA-01' then 'Tysons'
  when retail_location = 'WA-02' then  'Lynnwood'
  when retail_location = 'OH-01' then  'Columbus'
  else retail_location end  store
        ,to_Date(date_trunc(month,(ending))) month
        ,upper(case when category = 'Wholesale & Retail Compensation' then 'compensation'
               when category = 'Professional Services' then 'PROFESSIONAL SERVICES'
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
            when contribution.store = 'WA-02' then 'Lynnwood'
            when contribution.store = 'VA-01' then 'Tysons'
            when contribution.store = 'OH-01' then 'Columbus'
            else contribution.store end STORE
        ,contribution.month
        ,contribution.full_imu
        ,contribution.order_discount
        ,contribution.promo_discount
        ,contribution.gross_Sales
        ,contribution.cogs
        ,nvl(contribution.return_amt,0)+nvl(contribution.adj_return_amt,0) returns
        ,contribution.shipping
        ,contribution.merchant_fees
        ,contribution.affiliate_fees
        ,contribution.warranty
        ,nvl(p1.gross_amount,0) RENT
        ,nvl(p2.gross_amount,0) COMPENSATION
        ,nvl(p3.gross_amount,0) PROFESSIONALSERVICES
        ,nvl(p4.gross_amount,0) UTILITIES
        ,nvl(p5.gross_amount,0) OTHER
from contribution
left join pnl p1 on p1.store = contribution.store and p1.month = contribution.month and p1.expense_type = 'RENT'
left join pnl p2 on p2.store = contribution.store and p2.month = contribution.month and p2.expense_type = 'COMPENSATION'
left join pnl p3 on p3.store = contribution.store and p3.month = contribution.month and p3.expense_type = 'PROFESSIONAL SERVICES'
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
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.month ;;
  }

  measure: full_imu {
    type: sum
    label: "Full markup"
    value_format_name: usd_0
    description: "Total value of sales at full markup"
    sql: ${TABLE}."FULL_IMU" ;;
  }

  measure: order_discount {
    type: sum
    label: "Order discounts"
    value_format_name: usd_0
    description: "Order-level discounts, typically through using agent discount or promo code"
    sql: ${TABLE}."ORDER_DISCOUNT" ;;
  }

  measure: promo_discount {
    type: sum
    label: "Promo discounts"
    value_format_name: usd_0
    description: "Promotion discounts applied, typically free gift with purchase, bundle discounts, etc."
    sql: ${TABLE}."PROMO_DISCOUNT" ;;
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
    sql: ${TABLE}.warranty ;;
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

  measure: professionalservices {
    value_format_name: usd_0
    type: sum
    label: "Professional Services"
    sql: ${TABLE}.professionalservices ;;
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
