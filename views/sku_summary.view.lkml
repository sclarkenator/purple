view: sku_summary {
##Added by Scott Clark 11/8/2020 for weekly item-level reporting

   derived_table: {
    persist_for: "24 hours"
    sql: with thirty_inv as
(SELECT item.sku_id
  ,datediff(d,current_date,TO_DATE(inventory_snap.created)) days_ago
  ,COALESCE(SUM(inventory_snap.on_hand ), 0) on_hand
FROM PRODUCTION.INVENTORY_SNAP  AS inventory_snap
LEFT JOIN SALES.ITEM  AS item ON inventory_snap.item_id = item.ITEM_ID
LEFT JOIN analytics.sales.LOCATION  AS warehouse_location ON inventory_snap.location_id = warehouse_location.location_id
WHERE (CAST(EXTRACT(HOUR FROM CAST(inventory_snap.created  AS TIMESTAMP)) AS INT) > 16) AND ((((inventory_snap.created ) >= ((DATEADD('day', -30, CURRENT_DATE()))) AND (inventory_snap.created ) < ((DATEADD('day', 30, DATEADD('day', -30, CURRENT_DATE())))))))
AND ((warehouse_location.location  IN ('100-Purple West', 'M10 - MainFreight Carson', 'P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC', 'P30 - PILOT DFW DC', 'N10 - NEHDS Cranberry NJ', 'MW1 Mattress Firm Warehouse', 'R10 - Ryder Atlanta DC'))) AND (((warehouse_location.INACTIVE = 1) = 'No'))
and item.classification = 'FG'
GROUP BY 1,2)
,
inv_summary as
(select distinct sku_id
        ,regr_slope(on_hand,days_ago) over (partition by sku_id) slope_inv
        ,round(avg(on_hand) over (partition by sku_id),1) average_inv
from thirty_inv)
,
current_inventory as
(SELECT item.SKU_ID
      ,round(COALESCE(SUM(inventory.ON_HAND ), 0),0) current_on_hand
FROM PRODUCTION.INVENTORY  AS inventory
LEFT JOIN SALES.ITEM  AS item ON inventory.ITEM_ID = item.ITEM_ID
LEFT JOIN analytics.sales.LOCATION  AS warehouse_location ON (inventory."LOCATION_ID") = warehouse_location.location_id
WHERE (item.SKU_ID NOT LIKE '%AC-%' OR item.SKU_ID IS NULL)
AND ((warehouse_location.location  IN ('100-Purple West', 'M10 - MainFreight Carson', 'P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC', 'P30 - PILOT DFW DC', 'N10 - NEHDS Cranberry NJ', 'MW1 Mattress Firm Warehouse', 'R10 - Ryder Atlanta DC'))) AND (((warehouse_location.INACTIVE = 1) = 'No'))
and item.classification = 'FG'
GROUP BY 1 )
,
fcst as
(SELECT item.SKU_ID
  ,TO_DATE(forecast_combined.forecast) fcst_date
    ,datediff(d,current_date,fcst_date) days_from
  ,COALESCE(SUM(case when forecast_combined.account = 'Website' then forecast_combined.total_units else 0 end ), 0) dtc_units
  ,COALESCE(SUM(case when forecast_combined.channel = 'Owned Retail' then forecast_combined.total_units else 0 end ), 0) retail_units
  ,COALESCE(SUM(case when forecast_combined.channel = 'Wholesale' then forecast_combined.total_units else 0 end ), 0) AS wholesale_units
FROM sales.forecast  AS forecast_combined
LEFT JOIN SALES.ITEM  AS item ON forecast_combined.sku_id = item.SKU_ID
WHERE ((forecast_combined.forecast  < (TO_DATE(DATEADD('day', 56, CURRENT_DATE()))))) AND ((forecast_combined.forecast  >= (TO_DATE(DATEADD('day', -28, CURRENT_DATE())))))
GROUP BY 1,2,3)
,
tot_fcst as
(select sku_id
        ,days_from
        ,nvl(dtc_units,0)+nvl(retail_units,0)+nvl(wholesale_units,0) tot_units
from fcst)
,
past_4w_dtc_fcst as
(select distinct sku_id
        ,sum(dtc_units) over (partition by sku_id) past_4w_dtc_fcst
        ,round(sum(dtc_units) over (partition by sku_id)/28,1) past_4w_dtc_fcst_avg
        ,regr_slope(dtc_units,days_from) over (partition by sku_id) past_4w_dtc_fcst_slope
from fcst
where days_from < 0)
,
next_4w_dtc_fcst as
(select distinct sku_id
        ,sum(dtc_units) over (partition by sku_id) next_4w_dtc_fcst
        ,round(sum(dtc_units) over (partition by sku_id)/28,1) next_4w_dtc_fcst_avg
        ,regr_slope(dtc_units,days_from) over (partition by sku_id) next_4w_dtc_fcst_slope
from fcst
where days_from > 0
and days_from <= 28)
,
next_8w_dtc_fcst as
(select distinct sku_id
        ,sum(dtc_units) over (partition by sku_id) next_8w_dtc_fcst
        ,round(sum(dtc_units) over (partition by sku_id)/56,1) next_8w_dtc_fcst_avg
        ,regr_slope(dtc_units,days_from) over (partition by sku_id) next_8w_dtc_fcst_slope
from fcst
where days_from > 0)
,
past_4w_retail_fcst as
(select distinct sku_id
        ,sum(retail_units) over (partition by sku_id) past_4w_retail_fcst
        ,round(sum(retail_units) over (partition by sku_id)/28,1) past_4w_retail_fcst_avg
        ,regr_slope(retail_units,days_from) over (partition by sku_id) past_4w_retail_fcst_slope
from fcst
where days_from < 0)
,
next_4w_retail_fcst as
(select distinct sku_id
        ,sum(retail_units) over (partition by sku_id) next_4w_retail_fcst
        ,round(sum(retail_units) over (partition by sku_id)/28,1) next_4w_retail_fcst_avg
        ,regr_slope(retail_units,days_from) over (partition by sku_id) next_4w_retail_fcst_slope
from fcst
where days_from > 0
and days_from <= 28)
,
next_8w_retail_fcst as
(select distinct sku_id
        ,sum(retail_units) over (partition by sku_id) next_8w_retail_fcst
        ,round(sum(retail_units) over (partition by sku_id)/56,1) next_8w_retail_fcst_avg
        ,regr_slope(retail_units,days_from) over (partition by sku_id) next_8w_retail_fcst_slope
from fcst
where days_from > 0)
,
past_4w_wholesale_fcst as
(select distinct sku_id
        ,sum(wholesale_units) over (partition by sku_id) past_4w_wholesale_fcst
        ,round(sum(wholesale_units) over (partition by sku_id)/28,1) past_4w_wholesale_fcst_avg
        ,regr_slope(wholesale_units,days_from) over (partition by sku_id) past_4w_wholesale_fcst_slope
from fcst
where days_from < 0)
,
next_4w_wholesale_fcst as
(select distinct sku_id
        ,sum(wholesale_units) over (partition by sku_id) next_4w_wholesale_fcst
        ,round(sum(wholesale_units) over (partition by sku_id)/28,1) next_4w_wholesale_avg
        ,regr_slope(wholesale_units,days_from) over (partition by sku_id) next_4w_wholesale_fcst_slope
from fcst
where days_from > 0
and days_from <= 28)
,
next_8w_wholesale_fcst as
(select distinct sku_id
        ,sum(wholesale_units) over (partition by sku_id) next_8w_wholesale_fcst
        ,round(sum(wholesale_units) over (partition by sku_id)/56,1) next_8w_wholesale_fcst_avg
        ,regr_slope(wholesale_units,days_from) over (partition by sku_id) next_8w_wholesale_fcst_slope
from fcst
where days_from > 0)
,
past_4w_tot_fcst as
(select distinct sku_id
        ,sum(tot_units) over (partition by sku_id) past_4w_tot_fcst
        ,round(sum(tot_units) over (partition by sku_id)/28,1) past_4w_tot_fcst_avg
        ,regr_slope(tot_units,days_from) over (partition by sku_id) past_4w_tot_fcst_slope
from tot_fcst
where days_from < 0)
,
next_4w_tot_fcst as
(select distinct sku_id
        ,sum(tot_units) over (partition by sku_id) next_4w_tot_fcst
        ,round(sum(tot_units) over (partition by sku_id)/28,1) next_4w_tot_fcst_avg
        ,regr_slope(tot_units,days_from) over (partition by sku_id) next_4w_tot_fcst_slope
from tot_fcst
where days_from > 0
and days_from <= 28)
,
next_8w_tot_fcst as
(select distinct sku_id
        ,sum(tot_units) over (partition by sku_id) next_8w_tot_fcst
        ,round(sum(tot_units) over (partition by sku_id)/28,1) next_8w_tot_fcst_avg
        ,regr_slope(tot_units,days_from) over (partition by sku_id) next_8w_tot_fcst_slope
from tot_fcst
where days_from > 0)
,
prod as
(SELECT TO_DATE(assembly_build.PRODUCED) prod_date
      ,item.SKU_ID
      ,COALESCE(SUM(assembly_build.QUANTITY ), 0) produced
FROM PRODUCTION.BUILD  AS assembly_build
LEFT JOIN SALES.ITEM  AS item ON assembly_build.item_id = item.ITEM_ID
WHERE ((((to_timestamp_ntz(assembly_build.PRODUCED)) >= ((DATEADD('day', -28, CURRENT_DATE()))) AND (to_timestamp_ntz(assembly_build.PRODUCED)) < ((DATEADD('day', 28, DATEADD('day', -28, CURRENT_DATE()))))))) AND (assembly_build.scrap  = 0) AND (((item.merchandise = 1) = '0'))
group by 1,2)
,
prod7 as
(select distinct sku_id
        ,round(sum(produced) over (partition by sku_id)/7,1) avg_daily_prod7
from prod
where datediff(d,current_date,prod_date) > -8)
,
prod28 as
(select distinct sku_id
        ,round(sum(produced) over (partition by sku_id)/28,1) avg_daily_prod28
from prod)
,
sales as
(SELECT to_date(sales_order_line.Created) sales_date
        ,datediff(d,current_date,sales_date) days_from
      ,item.SKU_ID
        ,case when sales_order.CHANNEL_id = 1 then 'DTC'
               when sales_order.CHANNEL_id = 2 then 'Wholesale'
               when sales_order.CHANNEL_id = 5 then 'Retail'
                 else 'Other' end  channel
      ,COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(sales_order_line.ordered_qty ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) units
FROM SALES.SALES_ORDER_LINE  AS sales_order_line
LEFT JOIN SALES.ITEM  AS item ON sales_order_line.ITEM_ID = item.ITEM_ID
LEFT JOIN SALES.FULFILLMENT  AS fulfillment ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (case when fulfillment.parent_item_id = 0 or fulfillment.parent_item_id is null then fulfillment.item_id else fulfillment.parent_item_id end)||'-'||fulfillment.order_id||'-'||fulfillment.system
LEFT JOIN SALES.SALES_ORDER  AS sales_order ON (sales_order_line.order_id||'-'||sales_order_line.system) = (sales_order.order_id||'-'||sales_order.system)

WHERE ((((to_timestamp_ntz(sales_order_line.Created) ) >= ((DATEADD('day', -28, CURRENT_DATE()))) AND (to_timestamp_ntz(sales_order_line.Created) ) < ((DATEADD('day', 28, DATEADD('day', -28, CURRENT_DATE())))))))
AND sales_order.channel_id in (1,2,5)
GROUP BY 1,2,3,4)
,
tot_sales as
(select sku_id
        ,days_from
        ,sum(units) tot_units_sold
from sales
group by 1,2)
,
tot_sales_trend as
(select distinct sku_id
        ,sum(tot_units_Sold) over (partition by sku_id) total_28d_units
        ,regr_slope(tot_units_sold,days_from) over (partition by sku_id) slope_tot_units_sold
from tot_sales)
,
tot_sales7 as
(select distinct sku_id
        ,sum(tot_units_sold) over (partition by sku_id) tot_units_7day
from tot_sales
where days_from > -8)

,
dtc_sales_7 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/7,1) avg_dtc_units_7day
from sales
where channel = 'DTC'
and days_from > -8)
,
dtc_sales_28 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/28,1) avg_dtc_units_28day
        ,regr_slope(units,days_from) over (partition by sku_id) slope_dtc_sales
from sales
where channel = 'DTC')
,
wholesale_sales_7 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/7,1) avg_wholesale_units_7day
from sales
where channel = 'Wholesale'
and days_from > -8)
,
wholesale_sales_28 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/28,1) avg_wholesale_units_28day
        ,regr_slope(units,days_from) over (partition by sku_id) slope_wholesale_sales
from sales
where channel = 'Wholesale')
,
retail_sales_7 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/7,1) avg_retail_units_7day
from sales
where channel = 'Retail'
and days_from > -8)
,
retail_sales_28 as
(select distinct sku_id
        ,round(sum(units) over (partition by sku_id)/28,1) avg_retail_units_28day
        ,regr_slope(units,days_from) over (partition by sku_id) slope_retail_sales
from sales
where channel = 'Retail')

,
OOSLA as
(SELECT case when sales_order.CHANNEL_id = 1 then 'DTC'
               when sales_order.CHANNEL_id = 2 then 'Wholesale'
               when sales_order.CHANNEL_id = 3 then 'General'
               when sales_order.CHANNEL_id = 4 then 'Employee Store'
               when sales_order.CHANNEL_id = 5 then 'Retail'
              else 'Other' end  channel
      ,item.SKU_ID
      ,COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(sales_order_line.ordered_qty ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5(sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) units
FROM SALES.SALES_ORDER_LINE  AS sales_order_line
LEFT JOIN SALES.ITEM  AS item ON sales_order_line.ITEM_ID = item.ITEM_ID
LEFT JOIN SALES.FULFILLMENT  AS fulfillment ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (case when fulfillment.parent_item_id = 0 or fulfillment.parent_item_id is null then fulfillment.item_id else fulfillment.parent_item_id end)||'-'||fulfillment.order_id||'-'||fulfillment.system
LEFT JOIN SALES.SALES_ORDER  AS sales_order ON (sales_order_line.order_id||'-'||sales_order_line.system) = (sales_order.order_id||'-'||sales_order.system)
LEFT JOIN SALES.CANCELLED_ORDER  AS cancelled_order ON (sales_order_line.item_id||'-'||sales_order_line.order_id||'-'||sales_order_line.system) = (cancelled_order.item_id||'-'||cancelled_order.order_id||'-'||cancelled_order.system)

WHERE ((((to_timestamp_ntz(sales_order_line.Created) ) >= ((DATEADD('month', -2, DATE_TRUNC('month', CURRENT_DATE())))) AND (to_timestamp_ntz(sales_order_line.Created) ) < ((DATEADD('month', 3, DATEADD('month', -2, DATE_TRUNC('month', CURRENT_DATE())))))))) AND ((to_timestamp_ntz((TO_CHAR(TO_DATE(case
          -- wholesale is ship by date (from sales order)
          WHEN sales_order.CHANNEL_id = 2 and (TO_CHAR(TO_DATE(sales_order.SHIP_BY ), 'YYYY-MM-DD')) is not null
            THEN (TO_CHAR(TO_DATE(sales_order.SHIP_BY ), 'YYYY-MM-DD'))
          -- fedex is min ship date
          WHEN sales_order.CHANNEL_id <> 2 and upper((case
          when sales_order_line.LOCATION ilike '%mainfreight%' then 'MainFreight'
          when sales_order_line.LOCATION ilike '%xpo%' then 'XPO'
          when sales_order_line.LOCATION ilike '%pilot%' then 'Pilot'
          when sales_order_line.LOCATION is null then 'FBA'
          when sales_order_line.LOCATION ilike '%100-%' then 'Purple'
          when sales_order_line.LOCATION ilike '%le store%' or sales_order_line.LOCATION ilike '%howroom%' then 'Store take-with'
          else 'Other' end)) not in ('XPO','MANNA','PILOT') and (TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order.minimum_ship) ), 'YYYY-MM-DD')) > (TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order_line.Created) ), 'YYYY-MM-DD'))
            THEN (TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order.minimum_ship) ), 'YYYY-MM-DD'))
          -- fedex without min ship date is created + 3
          WHEN sales_order.CHANNEL_id <> 2 and upper((case
          when sales_order_line.LOCATION ilike '%mainfreight%' then 'MainFreight'
          when sales_order_line.LOCATION ilike '%xpo%' then 'XPO'
          when sales_order_line.LOCATION ilike '%pilot%' then 'Pilot'
          when sales_order_line.LOCATION is null then 'FBA'
          when sales_order_line.LOCATION ilike '%100-%' then 'Purple'
          when sales_order_line.LOCATION ilike '%le store%' or sales_order_line.LOCATION ilike '%howroom%' then 'Store take-with'
          else 'Other' end)) not in ('XPO','MANNA','PILOT')
            THEN dateadd(d,3,(TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order_line.Created) ), 'YYYY-MM-DD')))
          --whiteglove is created + 14
          WHEN sales_order.CHANNEL_id <> 2 and upper((case
          when sales_order_line.LOCATION ilike '%mainfreight%' then 'MainFreight'
          when sales_order_line.LOCATION ilike '%xpo%' then 'XPO'
          when sales_order_line.LOCATION ilike '%pilot%' then 'Pilot'
          when sales_order_line.LOCATION is null then 'FBA'
          when sales_order_line.LOCATION ilike '%100-%' then 'Purple'
          when sales_order_line.LOCATION ilike '%le store%' or sales_order_line.LOCATION ilike '%howroom%' then 'Store take-with'
          else 'Other' end)) in ('XPO','MANNA','PILOT')
            THEN dateadd(d,14,(TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order_line.Created) ), 'YYYY-MM-DD')))
          --catch all is creatd +3
          Else dateadd(d,3,(TO_CHAR(TO_DATE(to_timestamp_ntz(sales_order_line.Created) ), 'YYYY-MM-DD'))) END ), 'YYYY-MM-DD')))  < (DATEADD('day', 1, CURRENT_DATE()))) )
      AND ((CASE WHEN (TO_CHAR(TO_DATE(case when sales_order.TRANSACTION_TYPE = 'Cash Sale' or sales_order.SOURCE = 'Amazon-FBA-US'  then (TO_CHAR(DATE_TRUNC('second', sales_order.CREATED ), 'YYYY-MM-DD HH24:MI:SS')) else (to_timestamp_ntz(fulfillment.fulfilled)) end ), 'YYYY-MM-DD')) is not null THEN 1 ELSE 0 END ) = 0)
      AND ((CASE WHEN (TO_CHAR(TO_DATE(to_timestamp_ntz(cancelled_order.CANCELLED) ), 'YYYY-MM-DD')) is not NULL  THEN 1 ELSE 0 END ) = 0)
GROUP BY 1,2)
,
DTC_OOS as
(select sku_id
        ,units
from oosla
where channel = 'DTC')
,
WHolesale_OOS as
(select sku_id
        ,units
from oosla
where channel = 'Wholesale')
,
retail_oos as
(select sku_id
        ,units
from oosla
where channel = 'Retail')
,sub as
(select i.sku_id
        ,item.category
        ,item.line
        ,item.model
        ,item.description
        ,round(slope_inv,0) inv_slope
        ,average_inv
        ,current_on_hand
        ,avg_daily_prod7
        ,avg_daily_prod28
--        ,past_4w_dtc_fcst
--        ,past_4w_dtc_fcst_avg
--        ,past_4w_dtc_fcst_slope
--        ,next_4w_dtc_fcst
--       ,next_4w_dtc_fcst_avg
--        ,next_4w_dtc_fcst_slope
--        ,next_8w_dtc_fcst
--        ,next_8w_dtc_fcst_avg
--        ,next_8w_dtc_fcst_slope
--        ,past_4w_retail_fcst
--        ,past_4w_retail_fcst_avg
--       ,past_4w_retail_fcst_slope
--        ,next_4w_retail_fcst
--        ,next_4w_retail_fcst_avg
--        ,next_4w_retail_fcst_slope
--        ,next_8w_retail_fcst
--        ,next_8w_retail_fcst_avg
--        ,next_8w_retail_fcst_slope
--        ,past_4w_wholesale_fcst
--        ,past_4w_wholesale_fcst_avg
--        ,past_4w_wholesale_fcst_slope
--        ,next_4w_wholesale_fcst
--        ,next_4w_wholesale_avg
--        ,next_4w_wholesale_fcst_slope
--        ,next_8w_wholesale_fcst
--        ,next_8w_wholesale_fcst_avg
--        ,next_8w_wholesale_fcst_slope
--        ,past_4w_tot_fcst
--        ,past_4w_tot_fcst_avg
--        ,past_4w_tot_fcst_slope
        ,round(next_4w_tot_fcst,0) next_4w_tot_fcst
        ,next_4w_tot_fcst_avg
--        ,next_4w_tot_fcst_slope
        ,round(next_8w_tot_fcst,0) next_8w_tot_fcst
        ,next_8w_tot_fcst_avg
--        ,next_8w_tot_fcst_slope
        ,round(slope_tot_units_sold,0) sales_slope
        ,tot_units_7day
        ,total_28d_units
--        ,avg_dtc_units_7day
--        ,avg_dtc_units_28day
--        ,slope_dtc_sales
--        ,avg_wholesale_units_7day
--        ,avg_wholesale_units_28day
--        ,slope_wholesale_sales
--        ,avg_retail_units_7day
--        ,avg_retail_units_28day
--        ,slope_retail_sales
        ,nvl(d1.units,0) dtc_oosla
        ,nvl(w1.units,0) wholesale_oosla
        ,nvl(r1.units,0) retail_oosla
from current_inventory ci join inv_summary i on ci.sku_id = i.sku_id
join sales.item on item.sku_id = ci.sku_id
left join prod7 on prod7.sku_id = ci.sku_id
left join prod28 p28 on p28.sku_id = ci.sku_id
left join dtc_sales_7 d7 on d7.sku_id = ci.sku_id
left join dtc_sales_28 d28 on d28.sku_id = ci.sku_id
left join wholesale_sales_7 w7 on w7.sku_id = ci.sku_id
left join wholesale_sales_28 w28 on w28.sku_id = ci.sku_id
left join retail_sales_7 r7 on r7.sku_id = ci.sku_id
left join retail_sales_28 r28 on r28.sku_id = ci.sku_id
left join dtc_oos d1 on d1.sku_id = ci.sku_id
left join wholesale_oos w1 on w1.sku_id = ci.sku_id
left join retail_oos r1 on r1.sku_id = ci.sku_id
left join past_4w_dtc_fcst p1 on p1.sku_id = ci.sku_id
left join next_4w_dtc_fcst p2 on p2.sku_id = ci.sku_id
left join next_8w_dtc_fcst p3 on p3.sku_id = ci.sku_id
left join past_4w_retail_fcst p4 on p4.sku_id = ci.sku_id
left join next_4w_retail_fcst p5 on p5.sku_id = ci.sku_id
left join next_8w_retail_fcst p6 on p6.sku_id = ci.sku_id
left join past_4w_wholesale_fcst p7 on p7.sku_id = ci.sku_id
left join next_4w_wholesale_fcst p8 on p8.sku_id = ci.sku_id
left join next_8w_wholesale_fcst p9 on p9.sku_id = ci.sku_id
left join past_4w_tot_fcst pt7 on pt7.sku_id = ci.sku_id
left join next_4w_tot_fcst pt8 on pt8.sku_id = ci.sku_id
left join next_8w_tot_fcst pt9 on pt9.sku_id = ci.sku_id
left join tot_sales_trend tst on tst.sku_id = ci.sku_id
left join tot_sales7 ts7 on ts7.sku_id = ci.sku_id
where item.classification = 'FG'
and item.lifecycle_status = 'CURRENT'
and description not ilike '%FLR%'
and description not ilike '%FS%'
and description not ilike '%REFURb%')
select category, line, model, description, sku_id
        ,current_on_hand
        ,greatest(avg_daily_prod7,avg_daily_prod28) avg_production
        ,avg_daily_prod7
        ,sales_slope
        ,coalesce(round(current_on_hand/nullif(next_4w_tot_fcst/4,0),1),999) weeks_OH
        ,nvl(total_28d_units,0) past_4w_total
        ,nvl(next_4w_tot_fcst,0) next_4w_fcst
        ,nvl(next_8w_tot_fcst,0) next_8w_fcst
        ,current_on_hand+nvl(avg_production,0)*7-nvl(next_4w_tot_fcst_avg*7,0) current_inv_est
        ,current_on_hand+nvl(avg_production,0)*28-nvl(next_4w_tot_fcst,0) four_week_inv_est
        ,current_on_hand+nvl(avg_production,0)*56-nvl(next_8w_tot_fcst,0) eight_week_inv_est
        ,case when sales_slope/nullif(next_4w_tot_fcst_avg,0) > .15 then 1 else 0 end trend_up_flg
        ,case when sales_slope/nullif(next_4w_tot_fcst_avg,0) < -0.1 then 1 else 0 end trend_down_flg
        ,case when weeks_oh = 999 then 'NO SALES FORECAST'
                when weeks_oh > 20 then '20+ WEEKS OH'
                when current_inv_est < 0 then 'CURRENT INV. CRUNCH'
                when four_week_inv_est < 0 then '4-WEEK INV. CRUNCH'
                when eight_week_inv_est < 0 then '8-WEEK INV. CRUNCH'
                when trend_up_flg = 1 then 'TRENDING UP'
                when trend_down_flg = 1 then 'TRENDING DOWN'
                else '' end exception_class



from sub ;;
 }

  dimension: sku_id {
    description: "5 - SKU_ID"
    group_label: "Hierarchy"
    primary_key: yes
    type: string
    link: {
      label: "Show SKU dashboard"
      url: "https://purple.looker.com/dashboards-next/3895?SKU+ID={{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com" }
    sql: ${TABLE}.sku_id ;;
   }

  dimension: category {
    description: "Product hierarchy category"
    label: "1 - Category"
    type: string
    group_label: "Hierarchy"
        sql: ${TABLE}.category ;;
  }

  dimension: line {
    description: "Product hierarchy line"
    label: "2 - Line"
    group_label: "Hierarchy"
    type: string
    sql: ${TABLE}.line ;;
  }

  dimension: model {
    description: "Product hierarchy model"
    label: "3 - Model"
    group_label: "Hierarchy"
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: description {
    description: "Product hierarchy description"
    label: "4 - Name"
    group_label: "Hierarchy"
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: exception_class {
    description: "Most urgent exception currently"
    label: "Exception type"
    type: string
    sql: ${TABLE}.exception_class ;;
  }

  measure: 7day_prod {
    description: "Avergae finished good quantity produced over the last 7 days"
    label: "Avg. produced"
    type: sum
     sql: ${TABLE}.avg_daily_prod7 ;;
   }

  measure: current_oh {
    description: "Current inventory on hand in fulfillment warehouses"
    label: "Current OH"
    type: sum
    sql: ${TABLE}.current_on_hand ;;
  }

  measure: past_4w_total {
    description: "Total units sold over past 4 weeks in all channels"
    label: "Units sold (4w)"
    type: sum
    sql: ${TABLE}.past_4w_total ;;
  }

  measure: next_4w_fcst {
    description: "Total units forecasted over next 4 weeks all channels"
    label: "Units fcst (4w)"
    type: sum
    sql: ${TABLE}.next_4w_fcst ;;
  }

  measure: next_8w_fcst {
    description: "Total units forecasted over next 8 weeks all channels"
    label: "Units fcst (8w)"
    type: sum
    sql: ${TABLE}.next_8w_fcst ;;
  }

  measure: count {
    description: "Count of items meeting specified criteria"
    label: "SKU count"
    type: count
  }
  }
