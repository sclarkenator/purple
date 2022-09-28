view: desired_stock_level {
  derived_table: {
    sql:
 with aa as (

--FG-SFG by Hep SKU
select
  case
        when fg_sfg.hep_sku = '20-21-22182' then '20-21-22167'
        when fg_sfg.hep_sku = '20-21-22131' then '20-21-22167'
        when fg_sfg.hep_sku = '20-21-22159' then '20-21-22168'
        when fg_sfg.hep_sku = '20-21-22183' then '20-21-22168'
        when fg_sfg.hep_sku = '20-21-22117' then '20-21-22165'
        else fg_sfg.hep_sku
        end new_hep_sku
    , fg_sfg.finished_good_sku
    , count(distinct (fg_sfg.finished_good_sku)) as "COUNT"
from sales.v_forecast fc
    left join sales.item i on fc.sku_id = i.sku_id
    left join production.FG_TO_SFG fg_sfg on fg_sfg.fg_item_id = i.item_id
where i.category = 'MATTRESS' and (i.product_description not like '%SPLIT%' or i.product_description is null) and fg_sfg.hep_sku is not null
group by 1,2
order by 1

), bb as (

--On Hand Units by Mattress SKU
select
  i.sku_id
  , i.product_description
  , i.model
  , i.category
  , round(coalesce(sum(inv.on_hand ), 0),0) on_hand
  , sum(case when l.location ='200-Purple South' then on_hand else 0 end) psouth_onhand
  , sum(case when l.location ='100-Purple West' then on_hand else 0 end) pwest_onhand
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.category = 'MATTRESS' and (i.sku_id not like '%AC%' or i.sku_id is null) and i.classification_new = 'FG' and l.INACTIVE = 0 and l.location_id in ('4','5','111')
group by 1,2,3,4
order by 5 desc

), cc as (

--Scrim Peak by Mattress SKU
select
    i.sku_id
    , i.product_description
    , i.model
    , round(coalesce(sum(inv.on_hand ), 0),0) on_hand
    , sum(case when l.location ='200-Purple South' then on_hand else 0 end) psouth_onhand
    , sum(case when l.location ='100-Purple West' then on_hand else 0 end) pwest_onhand
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.model = 'MATTRESS SCRIM PEAK' and (i.SKU_ID not like '%AC%' or i.sku_id is null) and l.INACTIVE = 0 and l.location_id in ('4','5','111')
group by 1,2,3
order by 4 desc

), dd as (

--Open Orders by Mattress SKU PWest
SELECT
    product."SKU_ID"  AS sku_id,
    product."PRODUCT_DESCRIPTION"  AS "product.product_description",
    COALESCE(SUM(( fulfillment."SOLD_QUANTITY"  ) ), 0) AS unfulfilled_orders_units
FROM "DATAGRID"."PROD"."FULFILLMENT_NEW"
     AS fulfillment
LEFT JOIN "DATAGRID"."PROD"."PRODUCT"
     AS product ON (fulfillment."ITEM_ID") = (product."ITEM_ID")
WHERE ((fulfillment."ORDER_STATUS" ) <> 'Closed' AND (fulfillment."ORDER_STATUS" ) <> 'Cancelled' OR (fulfillment."ORDER_STATUS" ) IS NULL)
AND ((( CAST(fulfillment."ORDER_PLACED" AS TIMESTAMP_NTZ)  ) >= ((DATEADD('month', -5, DATE_TRUNC('month', CURRENT_DATE())))) AND ( CAST(fulfillment."ORDER_PLACED" AS TIMESTAMP_NTZ)  ) < ((DATEADD('month', 6, DATEADD('month', -5, DATE_TRUNC('month', CURRENT_DATE())))))))
AND (((( CAST(fulfillment."ACTUAL_SHIP" AS TIMESTAMP_NTZ)  )) IS NULL)) AND (((( CAST(fulfillment."EXPECTED_SHIP" AS TIMESTAMP_NTZ)  )) IS NOT NULL))
AND (product."CATEGORY" ) = 'MATTRESS'
AND fulfillment."WAREHOUSE_NAME"  in ('100-Purple West', '101-XPO PWest', '101-Home Delivery','P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC','S10 - Speedy Delivery Auburn','S20 - Speedy Delivery UC')
GROUP BY
    1,2

), ee as (

--Open Orders by Mattress SKU PSouth
SELECT
    product."SKU_ID"  AS sku_id,
    product."PRODUCT_DESCRIPTION"  AS "product.product_description",
    COALESCE(SUM(( fulfillment."SOLD_QUANTITY"  ) ), 0) AS unfulfilled_orders_units
FROM "DATAGRID"."PROD"."FULFILLMENT_NEW"
     AS fulfillment
LEFT JOIN "DATAGRID"."PROD"."PRODUCT"
     AS product ON (fulfillment."ITEM_ID") = (product."ITEM_ID")
WHERE ((fulfillment."ORDER_STATUS" ) <> 'Closed' AND (fulfillment."ORDER_STATUS" ) <> 'Cancelled' OR (fulfillment."ORDER_STATUS" ) IS NULL)
AND ((( CAST(fulfillment."ORDER_PLACED" AS TIMESTAMP_NTZ)  ) >= ((DATEADD('month', -5, DATE_TRUNC('month', CURRENT_DATE())))) AND ( CAST(fulfillment."ORDER_PLACED" AS TIMESTAMP_NTZ)  ) < ((DATEADD('month', 6, DATEADD('month', -5, DATE_TRUNC('month', CURRENT_DATE())))))))
AND (((( CAST(fulfillment."ACTUAL_SHIP" AS TIMESTAMP_NTZ)  )) IS NULL)) AND (((( CAST(fulfillment."EXPECTED_SHIP" AS TIMESTAMP_NTZ)  )) IS NOT NULL))
AND (product."CATEGORY" ) = 'MATTRESS'
AND fulfillment."WAREHOUSE_NAME"  in ('200-Purple South', 'M20 - Manna Chicago DC', 'M70 - Manna Atlanta DC', 'P30 - PILOT DFW DC','R10 - Ryder Atlanta DC','R20 - Ryder Minneapolis DC','R30 - Ryder Baltimore DC','R40 - Ryder Chicago DC','R50 - Ryder Boston DC','E10 - Select Express NJ','E30 - Select Express Orlando','C10 - CRST Jessup DC','E20 - Select Express Miami','E40 - Select Express Tampa')
GROUP BY 1,2

), ff as (

--Forecasted Sales by Mattress SKU
select
  coalesce (i.sku_id, aip.sku_id) sku_id
    , i.product_description
    , round(coalesce(sum(fc.subtotal_units), 0),0) total_units_new
    , round(coalesce(sum(case when fc.channel = 'Wholesale' then fc.subtotal_units else 0 end), 0),0) total_units_new_wholesale
    , round(coalesce(sum(case when fc.channel in ('DTC', 'Owned Retail') then fc.subtotal_units else 0 end), 0),0) total_units_new_dtcor
    , round((total_units_new_wholesale*0.65 + total_units_new_dtcor*0.65),0) total_units_new_pwest
    , round((total_units_new_wholesale*0.35 + total_units_new_dtcor*0.35),0) total_units_new_psouth
    , round(((total_units_new/8)*2),0) "14_DAY_FORECAST"
    , round(((total_units_new_wholesale/8)*2),0) "14_DAY_FORECAST_WHOLESALE"
    , round(((total_units_new_dtcor/8)*2),0) "14_DAY_FORECAST_DTCOR"
    , round(((total_units_new_pwest/8)*2),0) "14_DAY_FORECAST_PWEST"
    , round(((total_units_new_psouth/8)*2),0) "14_DAY_FORECAST_PSOUTH"
    , round(((total_units_new_pwest/8)*3),0) "21_DAY_FORECAST_PWEST"
    , round(((total_units_new_psouth/8)*3),0) "21_DAY_FORECAST_PSOUTH"
    , round(("14_DAY_FORECAST"/14),0) daily_forecast
    , round(("14_DAY_FORECAST_WHOLESALE"/14),0) daily_forecast_wholesale
    , round(("14_DAY_FORECAST_DTCOR"/14),0) daily_forecast_dtcor
    , round(("14_DAY_FORECAST_PWEST"/14),0) daily_forecast_pwest
    , round(("14_DAY_FORECAST_PSOUTH"/14),0) daily_forecast_psouth
    , fc.version
from DATAGRID.PROD.MERCHANDISE_PLANNING fc
    left join sales.item i on fc.sku_id = i.sku_id
    left join forecast.v_ai_product aip on fc.sku_id = aip.sku_id
where ((fc.date  < (to_date(dateadd('day', 63, date_trunc('week', current_date()))))))
    and ((fc.date  >= (to_date(dateadd('day', 7, date_trunc('week', current_date()))))))
    and i.category = 'MATTRESS'
group by 1,2,20

), gg as (

--Produced Beds Last 28 Days (20 Workdays)
select
  i.sku_id
  , i.product_description
  , i.model
  , i.category
  , round(coalesce(sum(prod.quantity), 0),0) quantity_produced
  , round((quantity_produced/20),0) avg_daily_produced
  , sum(case when l.location_id = '111' then prod.quantity else 0 end) psouth_quantity
  , round((psouth_quantity/20),0) avg_daily_produced_psouth
  , sum(case when l.location_id = '4' then prod.quantity else 0 end) pwest_quantity
  , round((pwest_quantity/20),0) avg_daily_produced_pwest
from production.v_work_order prod
    left join sales.item i on prod.item_id = i.item_id
    left join sales.location l on prod.location_id = l.location_id
where i.category = 'MATTRESS' and i.classification_new = 'FG' and (i.sku_id not like '%AC%' or i.sku_id is null) and l.INACTIVE = 0 and l.location_id in ('4','111')
    and prod.produced  < current_date()
    and prod.produced >= (to_date(dateadd('day', -28, current_date())))
group by 1,2,3,4
order by 5 desc

), hh as (

--Produced Scrim Last 28 Days (20 Workdays)
select
  i.sku_id
  , i.product_description
  , i.model
  , i.category
  , round(coalesce(sum(prod.quantity), 0),0) quantity_produced
  , round((quantity_produced/20),0) avg_daily_produced
  , sum(case when l.location_id = '111' then prod.quantity else 0 end) psouth_quantity
  , round((psouth_quantity/20),0) avg_daily_produced_psouth
  , sum(case when l.location_id = '4' then prod.quantity else 0 end) pwest_quantity
  , round((pwest_quantity/20),0) avg_daily_produced_pwest
from production.v_work_order prod
    left join sales.item i on prod.item_id = i.item_id
    left join sales.location l on prod.location_id = l.location_id
where i.model = 'MATTRESS SCRIM PEAK' and (i.sku_id not like '%AC%' or i.sku_id is null) and l.INACTIVE = 0 and l.location_id in ('4','111')
    and prod.produced  < current_date()
    and prod.produced >= (to_date(dateadd('day', -28, current_date())))
group by 1,2,3,4
order by 5 desc

)

select zz.new_hep_sku
    , zz.sfg_product_description
    , zz.sfg_model
    , zz.finished_good_sku
    , zz.fg_product_description
    , zz.fg_model
    , zz.fg_category
    , sum(zz.qty_used) as quantity_used
    , sum(zz.fg_on_hand) as fg_on_hand
    , sum(zz.fg_on_hand_pwest) as fg_on_hand_pwest
    , sum(zz.fg_on_hand_psouth) as fg_on_hand_psouth
    , max(zz.sfg_on_hand) as sfg_on_hand
    , max(zz.sfg_on_hand_pwest) as sfg_on_hand_pwest
    , max(zz.sfg_on_hand_psouth) as sfg_on_hand_psouth
    , case when sum(zz.unfulfilled_units_pwest) is null then 0 else sum(zz.unfulfilled_units_pwest) end as fg_unfulfilled_pwest
    , case when sum(zz.unfulfilled_units_psouth) is null then 0 else sum(zz.unfulfilled_units_psouth) end as fg_unfulfilled_psouth
    , (fg_unfulfilled_pwest + fg_unfulfilled_psouth) as fg_unfulfilled
    , case when sum(zz.total_units_new) is null then 0 else sum(zz.total_units_new) end as total_new_units
    , case when sum(zz.total_units_new_pwest) is null then 0 else sum(zz.total_units_new_pwest) end as total_new_units_pwest
    , case when sum(zz.total_units_new_psouth) is null then 0 else sum(zz.total_units_new_psouth) end as total_new_units_psouth
    , case when sum(zz."14_DAY_FORECAST") is null then 0 else sum(zz."14_DAY_FORECAST") end as fourteen_day_forecast
    , case when sum(zz."14_DAY_FORECAST_PWEST") is null then 0 else sum(zz."14_DAY_FORECAST_PWEST") end as fourteen_day_forecast_pwest
    , case when sum(zz."14_DAY_FORECAST_PSOUTH") is null then 0 else sum(zz."14_DAY_FORECAST_PSOUTH") end as fourteen_day_forecast_psouth
    , case when sum(zz."21_DAY_FORECAST_PWEST") is null then 0 else sum(zz."21_DAY_FORECAST_PWEST") end as twentyone_day_forecast_pwest
    , case when sum(zz."21_DAY_FORECAST_PSOUTH") is null then 0 else sum(zz."21_DAY_FORECAST_PSOUTH") end as twentyone_day_forecast_psouth
    , case when sum(zz.daily_forecast) is null then 0 else sum(zz.daily_forecast) end as daily_forecast
    , case when sum(zz.daily_forecast_pwest) is null then 0 else sum(zz.daily_forecast_pwest) end as daily_forecast_pwest
    , case when sum(zz.daily_forecast_psouth) is null then 0 else sum(zz.daily_forecast_psouth) end as daily_forecast_psouth
    , case when round(div0((zz.fg_on_hand_pwest-zz.unfulfilled_units_pwest),zz.daily_forecast_pwest),0) is null then 0
        else round(div0((zz.fg_on_hand_pwest-zz.unfulfilled_units_pwest),zz.daily_forecast_pwest),0)
      end as fg_days_of_inventory_pwest
    , case when round(div0((zz.fg_on_hand_psouth-zz.unfulfilled_units_psouth),zz.daily_forecast_pwest),0) is null then 0
        else round(div0((zz.fg_on_hand_psouth-zz.unfulfilled_units_psouth),zz.daily_forecast_psouth),0)
      end as fg_days_of_inventory_psouth
    , case when ((zz."14_DAY_FORECAST_PWEST"+zz.unfulfilled_units_pwest)-zz.fg_on_hand_pwest) < 1 then 0
       when ((zz."14_DAY_FORECAST_PWEST"+zz.unfulfilled_units_pwest)-zz.fg_on_hand_pwest) is null then 0
       else ((zz."14_DAY_FORECAST_PWEST"+zz.unfulfilled_units_pwest)-zz.fg_on_hand_pwest)
     end as fg_beds_needed_pwest
    , case when ((zz."14_DAY_FORECAST_PSOUTH"+zz.unfulfilled_units_psouth)-zz.fg_on_hand_psouth) < 1 then 0
       when ((zz."14_DAY_FORECAST_PSOUTH"+zz.unfulfilled_units_psouth)-zz.fg_on_hand_psouth) is null then 0
       else ((zz."14_DAY_FORECAST_PSOUTH"+zz.unfulfilled_units_psouth)-zz.fg_on_hand_psouth)
     end as fg_beds_needed_psouth
    , zz.forecast_version
    , (fg_beds_needed_pwest+fg_beds_needed_psouth) as fg_beds_needed
    , sum(zz.daily_beds_produced_pwest) as daily_beds_produced_pwest
    , sum(zz.daily_beds_produced_psouth) as daily_beds_produced_psouth
    , max(zz.daily_peaks_produced_pwest) as daily_peaks_produced_pwest
    , max(zz.daily_peaks_produced_psouth) as daily_peaks_produced_psouth
from (
  select aa.new_hep_sku
      , aa.finished_good_sku
      , aa.count as qty_used
      , bb.on_hand as fg_on_hand
      , bb.pwest_onhand as fg_on_hand_pwest
      , bb.psouth_onhand as fg_on_hand_psouth
      , bb.product_description as fg_product_description
      , bb.model as fg_model
      , bb.category as fg_category
      , cc.on_hand as sfg_on_hand
      , cc.pwest_onhand as sfg_on_hand_pwest
      , cc.psouth_onhand as sfg_on_hand_psouth
      , cc.product_description as sfg_product_description
      , cc.model as sfg_model
      , dd.unfulfilled_orders_units as unfulfilled_units_pwest
      , ee.unfulfilled_orders_units as unfulfilled_units_psouth
      , ff.total_units_new as total_units_new
      , ff."14_DAY_FORECAST" as "14_DAY_FORECAST"
      , ff.daily_forecast as daily_forecast
      , ff.total_units_new_pwest as total_units_new_pwest
      , ff."14_DAY_FORECAST_PWEST" as "14_DAY_FORECAST_PWEST"
      , ff."21_DAY_FORECAST_PWEST" as "21_DAY_FORECAST_PWEST"
      , ff.daily_forecast_pwest as daily_forecast_pwest
      , ff.total_units_new_psouth as total_units_new_psouth
      , ff."14_DAY_FORECAST_PSOUTH" as "14_DAY_FORECAST_PSOUTH"
      , ff."21_DAY_FORECAST_PSOUTH" as "21_DAY_FORECAST_PSOUTH"
      , ff.daily_forecast_psouth as daily_forecast_psouth
      , ff.version as forecast_version
      , gg.avg_daily_produced_pwest as daily_beds_produced_pwest
      , gg.avg_daily_produced_psouth as daily_beds_produced_psouth
      , hh.avg_daily_produced_pwest as daily_peaks_produced_pwest
      , hh.avg_daily_produced_psouth as daily_peaks_produced_psouth

  from aa
  left join bb on bb.sku_id = aa.finished_good_sku
  left join cc on cc.sku_id = aa.new_hep_sku
  left join dd on dd.sku_id = aa.finished_good_sku
  left join ee on ee.sku_id = aa.finished_good_sku
  left join ff on ff.sku_id = aa.finished_good_sku
  left join gg on gg.sku_id = aa.finished_good_sku
  left join hh on hh.sku_id = aa.new_hep_sku
) zz
group by 1,2,3,4,5,6,7,29,30,31,32,33;;  }

  dimension: hep_sku {
    label: "SFG SKU"
    description: "SFG SKU number; source:production.fg_to_sfg"
    type: string
    primary_key: yes
    sql: ${TABLE}."NEW_HEP_SKU" ;;
  }

  dimension: sfg_production_description {
    label: "SFG Product Description"
    description: "SFG Product Descripton; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."SFG_PRODUCT_DESCRIPTION" ;;
  }

  dimension: sfg_model {
    label: "SFG Model"
    type: string
    sql: ${TABLE}."SFG_MODEL" ;;
  }

  dimension: fg_sku {
    label: "FG SKU"
    description: "FG SKU number; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."FINISHED_GOOD_SKU" ;;
  }

  dimension: fg_production_description {
    label: "FG Product Description"
    description: "Hep Product Descripton; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."FG_PRODUCT_DESCRIPTION" ;;
  }

  dimension: fg_model {
    label: "FG Model"
    type: string
    sql: ${TABLE}."FG_MODEL" ;;
  }

  dimension: fg_category {
    label: "FG Category"
    type: string
    sql: ${TABLE}."FG_CATEGORY" ;;
  }

  dimension: forecast_version {
    label: "Forecast Version"
    type: string
    description: "Working is the current data in Adaptive, Current S&OP is locked at the first Saturday of the current month, Previous is 1 month previos.  Rolling 4 month is looking at the forecast data from 4 months previous to the date being forecasted. "
    case: {
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'S&OP' ;; label: "S&OP" }
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'WP' ;; label: "Working Plan" }
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'Modeling' ;; label: "Modeling" }
    }
  }

  measure: quantity_used {
    label: "# FG SKUs Using Part"
    description: "source; looker calculation"
    type: sum
    sql:  ${TABLE}."QUANTITY_USED" ;;
  }

  measure: fg_on_hand {
    label: "FG On Hand"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_ON_HAND" ;;
  }

  measure: fg_on_hand_pwest {
    label: "FG On Hand P-West"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_ON_HAND_PWEST" ;;
  }

  measure: fg_on_hand_psouth {
    label: "FG On Hand P-South"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_ON_HAND_PSOUTH" ;;
  }

  measure: sfg_on_hand {
    label: "SFG on Hand"
    description: "source; looker calculation"
    type: sum_distinct
    sql:  ${TABLE}."SFG_ON_HAND" ;;
  }

  measure: sfg_on_hand_pwest {
    label: "SFG on Hand P-West"
    description: "source; looker calculation"
    type: sum_distinct
    sql:  ${TABLE}."SFG_ON_HAND_PWEST" ;;
  }

  measure: sfg_on_hand_psouth {
    label: "SFG on Hand P-South"
    description: "source; looker calculation"
    type: sum_distinct
    sql:  ${TABLE}."SFG_ON_HAND_PSOUTH" ;;
  }

  measure: quantity_remaining_pwest {
    label: "Unfulfilled P-West"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_UNFULFILLED_PWEST" ;;
  }

  measure: quantity_remaining_psouth {
    label: "Unfulfilled P-South"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_UNFULFILLED_PSOUTH" ;;
  }

  measure: quantity_remaining {
    label: "Unfulfilled"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_UNFULFILLED" ;;
  }

  measure: total_new_units {
    label: "Total Units Forecasted"
    description: "Total Number of Units Forecasted for the next 8 Weeks; source: production.inventory"
    type: sum
    sql:  ${TABLE}."TOTAL_NEW_UNITS" ;;
  }

  measure: total_new_units_pwest {
    label: "Total West Units Forecasted"
    description: "Total Number of P-West Units Forecasted for the next 8 Weeks; source: production.inventory"
    type: sum
    sql:  ${TABLE}.TOTAL_NEW_UNITS_PWEST ;;
  }

  measure: total_new_psouth {
    label: "Total South Units Forecasted"
    description: "Total Number of P-South Units Forecasted for the next 8 Weeks; source: production.inventory"
    type: sum
    sql:  ${TABLE}.TOTAL_NEW_UNITS_PSOUTH ;;
  }

  measure: fourteen_day_forecast {
    label: "14 Day Forecast"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."FOURTEEN_DAY_FORECAST" ;;
  }

  measure: fourteen_day_forecast_pwest {
    label: "14 Day West Forecast"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.FOURTEEN_DAY_FORECAST_PWEST ;;
  }

  measure: fourteen_day_forecast_psouth {
    label: "14 Day South Forecast"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.FOURTEEN_DAY_FORECAST_PSOUTH ;;
  }

  measure: twentyone_day_forecast_pwest {
    label: "21 Day West Forecast"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.TWENTYONE_DAY_FORECAST_PWEST ;;
  }

  measure: twentyone_day_forecast_psouth {
    label: "21 Day South Forecast"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.TWENTYONE_DAY_FORECAST_PSOUTH ;;
  }

  measure: daily_forecast {
    label: "Daily Forecast"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."DAILY_FORECAST" ;;
  }

  measure: daily_forecast_pwest {
    label: "Daily West Forecast"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}.DAILY_FORECAST_PWEST ;;
  }

  measure: daily_forecast_psouth {
    label: "Daily South Forecast"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}.DAILY_FORECAST_PSOUTH ;;
  }

  measure: fg_days_of_inventory {
    label: "FG Days of Inventory"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."FG_DAYS_OF_INVENTORY" ;;
  }

  measure: fg_days_of_inventory_pwest {
    label: "FG Days of West Inventory"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.FG_DAYS_OF_INVENTORY_PWEST ;;
  }

  measure: fg_days_of_inventory_psouth {
    label: "FG Days of South Inventory"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}.FG_DAYS_OF_INVENTORY_PSOUTH ;;
  }

  measure: fg_beds_needed_pwest {
    label: "FG Beds Needed West"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}.FG_BEDS_NEEDED_PWEST ;;
  }

  measure: fg_beds_needed_psouth {
    label: "FG Beds Needed South"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}.FG_BEDS_NEEDED_PSOUTH ;;
  }

  measure: fg_beds_needed {
    label: "FG Beds Needed"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}.FG_BEDS_NEEDED ;;
  }

  measure: daily_beds_produced_pwest {
    label: "P-West Daily Beds Produced"
    description: "Average Beds Produced/Workday. Looks at last 28 complete days, divided by 20 work days"
    type: sum
    sql:  ${TABLE}.daily_beds_produced_pwest ;;
  }

  measure: daily_beds_produced_psouth {
    label: "P-South Daily Beds Produced"
    description: "Average Beds Produced/Workday. Looks at last 28 complete days, divided by 20 work days"
    type: sum
    sql:  ${TABLE}.daily_beds_produced_psouth ;;
  }

  measure: daily_peaks_produced_pwest {
    label: "P-West Daily Peaks Produced"
    description: "Average Beds Produced/Workday. Looks at last 28 complete days, divided by 20 work days"
    type: sum_distinct
    sql:  ${TABLE}.daily_peaks_produced_pwest ;;
  }

  measure: daily_peaks_produced_psouth {
    label: "P-South Daily Peaks Produced"
    description: "Average Beds Produced/Workday. Looks at last 28 complete days, divided by 20 work days"
    type: sum_distinct
    sql:  ${TABLE}.daily_peaks_produced_psouth ;;
  }

}
