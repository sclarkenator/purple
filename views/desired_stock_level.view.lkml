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
  , round(coalesce(sum(inv.on_hand ), 0),0) on_hand
  , sum(case when l.location ='200-Purple South' then on_hand else 0 end) psouth_onhand
  , sum(case when l.location ='100-Purple West' then on_hand else 0 end) pwest_onhand
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.category = 'MATTRESS' and (i.sku_id not like '%AC%' or i.sku_id is null) and i.classification_new = 'FG' and l.INACTIVE = 0 and l.location_id in ('4','5','111')
group by 1,2
order by 3 desc

), cc as (

--Scrim Peak by Mattress SKU
select
    i.sku_id
    , i.product_description
    , round(coalesce(sum(inv.on_hand ), 0),0) on_hand
    , sum(case when l.location ='200-Purple South' then on_hand else 0 end) psouth_onhand
    , sum(case when l.location ='100-Purple West' then on_hand else 0 end) pwest_onhand
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.model = 'MATTRESS SCRIM PEAK' and (i.SKU_ID not like '%AC%' or i.sku_id is null) and l.INACTIVE = 0 and l.location_id in ('4','5','111')
group by 1,2
order by 3 desc

), dd as (

--Open Orders by Mattress SKU PWest
with sales_order_line as (select
      sol.*,
      case when so.channel_id = 2 and co.cancelled is not null then true else false end as is_cancelled_wholesale
    from sales.sales_order_line sol
      left join sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
      left join sales.cancelled_order co on sol.order_id = co.order_id and sol.item_id = co.item_id and sol.system = co.system
    )
select
  i.sku_id,
  i.product_description,
  (coalesce(coalesce(cast( ( sum(distinct (cast(floor(coalesce(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.ordered_qty  else null end
,0)*(1000000*1.0)) as decimal(38,0))) + (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0) ) - sum(distinct (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0)) ) as double precision) / cast((1000000*1.0) as double precision), 0), 0))-(coalesce(sum(case when so.transaction_type = 'Cash Sale' or so.source in ('Amazon-FBA-US','Amazon-FBA-CA') then sol.ordered_qty
      when nvl(f.bundle_quantity,0) > 0 then f.bundle_quantity
      else f.quantity end ), 0))  unfulfilled_orders_units
from sales_order_line sol
      left join sales.item i on sol.item_id = i.item_id
      left join sales.fulfillment f on (sol.item_id||'-'||sol.order_id||'-'||sol.system) = (case when f.parent_item_id = 0 or f.parent_item_id is null then f.item_id else f.parent_item_id end)||'-'||f.order_id||'-'||f.system
      left join sales.sales_order so on (sol.order_id||'-'||sol.system) = (so.order_id||'-'||so.system)
      left join analytics_stage.ns.customers c on (c.customer_id::int) = so.customer_id
where ((sol.location in ('100-Purple West', '101-XPO PWest', '101-Home Delivery','P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC','S10 - Speedy Delivery Auburn','S20 - Speedy Delivery UC'))) and ((i.type in ('Assembly/Bill of Materials', 'Inventory Item', 'Kit/Package'))) and (i.category = 'MATTRESS') and
((case when so.channel_id = 1 then 'DTC'
               when so.channel_id = 2 then 'Wholesale'
               when so.channel_id = 3 then 'General'
               when so.channel_id = 4 then 'Employee Store'
               when so.channel_id = 5 then 'Owned Retail'
              else 'Other' end in ('DTC', 'Wholesale', 'Owned Retail', 'General'))) and ((so.status in ('Partially Fulfilled', 'Pending Approval', 'Pending Billing/Partially Fulfilled', 'Pending Fulfillment'))) and (c.shipping_hold = 'F')
group by 1,2
having
  ((coalesce(coalesce(cast( ( sum(distinct (cast(floor(coalesce(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.ordered_qty  else null end
,0)*(1000000*1.0)) as decimal(38,0))) + (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0) ) - sum(distinct (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0)) )  as double precision) / CAST((1000000*1.0) as double precision), 0), 0))-(coalesce(sum(case when so.transaction_type = 'Cash Sale' or so.source in ('Amazon-FBA-US','Amazon-FBA-CA') then sol.ordered_qty
      when nvl(f.bundle_quantity,0) > 0 then f.bundle_quantity
      else f.quantity end ), 0))  > 0)
order by 3 desc

), ee as (

--Open Orders by Mattress SKU PSouth
with sales_order_line as (select
      sol.*,
      case when so.channel_id = 2 and co.cancelled is not null then true else false end as is_cancelled_wholesale
    from sales.sales_order_line sol
      left join sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
      left join sales.cancelled_order co on sol.order_id = co.order_id and sol.item_id = co.item_id and sol.system = co.system
    )
select
  i.sku_id,
  i.product_description,
  (coalesce(coalesce(cast( ( sum(distinct (cast(floor(coalesce(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.ordered_qty  else null end
,0)*(1000000*1.0)) as decimal(38,0))) + (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0) ) - sum(distinct (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0)) ) as double precision) / cast((1000000*1.0) as double precision), 0), 0))-(coalesce(sum(case when so.transaction_type = 'Cash Sale' or so.source in ('Amazon-FBA-US','Amazon-FBA-CA') then sol.ordered_qty
      when nvl(f.bundle_quantity,0) > 0 then f.bundle_quantity
      else f.quantity end ), 0))  unfulfilled_orders_units
from sales_order_line sol
      left join sales.item i on sol.item_id = i.item_id
      left join sales.fulfillment f on (sol.item_id||'-'||sol.order_id||'-'||sol.system) = (case when f.parent_item_id = 0 or f.parent_item_id is null then f.item_id else f.parent_item_id end)||'-'||f.order_id||'-'||f.system
      left join sales.sales_order so on (sol.order_id||'-'||sol.system) = (so.order_id||'-'||so.system)
      left join analytics_stage.ns.customers c on (c.customer_id::int) = so.customer_id
where ((sol.location in ('200-Purple South', 'M20 - Manna Chicago DC', 'M70 - Manna Atlanta DC', 'P30 - PILOT DFW DC','R10 - Ryder Atlanta DC','R20 - Ryder Minneapolis DC','R30 - Ryder Baltimore DC','R40 - Ryder Chicago DC','R50 - Ryder Boston DC'))) and ((i.type in ('Assembly/Bill of Materials', 'Inventory Item', 'Kit/Package'))) and (i.category = 'MATTRESS') and ((case when so.channel_id = 1 then 'DTC'
               when so.channel_id = 2 then 'Wholesale'
               when so.channel_id = 3 then 'General'
               when so.channel_id = 4 then 'Employee Store'
               when so.channel_id = 5 then 'Owned Retail'
              else 'Other' end in ('DTC', 'Wholesale', 'Owned Retail', 'General'))) and ((so.status in ('Partially Fulfilled', 'Pending Approval', 'Pending Billing/Partially Fulfilled', 'Pending Fulfillment'))) and (c.shipping_hold = 'F')
group by 1,2
having
  ((coalesce(coalesce(cast( ( sum(distinct (cast(floor(coalesce(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.ordered_qty  else null end
,0)*(1000000*1.0)) as decimal(38,0))) + (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0) ) - sum(distinct (to_number(MD5(case when (case when sol.is_cancelled_wholesale then 1 else 0 end
) = 0 then sol.item_id||'-'||sol.order_id||'-'||sol.system  else null end
), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::numeric(38, 0)) )  as double precision) / CAST((1000000*1.0) as double precision), 0), 0))-(coalesce(sum(case when so.transaction_type = 'Cash Sale' or so.source in ('Amazon-FBA-US','Amazon-FBA-CA') then sol.ordered_qty
      when nvl(f.bundle_quantity,0) > 0 then f.bundle_quantity
      else f.quantity end ), 0))  > 0)
order by 3 desc

), ff as (

--Forecasted Sales by Mattress SKU
select
  coalesce (i.sku_id, aip.sku_id) sku_id
    , i.product_description
    , round(coalesce(sum(fc.total_units), 0),0) total_units_new
    , round(coalesce(sum(case when fc.channel = 'Wholesale' then fc.total_units else 0 end), 0),0) total_units_new_wholesale
    , round(coalesce(sum(case when fc.channel in ('DTC', 'Owned Retail') then fc.total_units else 0 end), 0),0) total_units_new_dtcor
    , round((total_units_new_wholesale*0.5 + total_units_new_dtcor*0.32),0) total_units_new_pwest
    , round((total_units_new_wholesale*0.5 + total_units_new_dtcor*0.68),0) total_units_new_psouth
    , round(((total_units_new/8)*2),0) "14_DAY_FORECAST"
    , round(((total_units_new_wholesale/8)*2),0) "14_DAY_FORECAST_WHOLESALE"
    , round(((total_units_new_dtcor/8)*2),0) "14_DAY_FORECAST_DTCOR"
    , round(((total_units_new_pwest/8)*2),0) "14_DAY_FORECAST_PWEST"
    , round(((total_units_new_psouth/8)*2),0) "14_DAY_FORECAST_PSOUTH"
    , round(("14_DAY_FORECAST"/14),0) daily_forecast
    , round(("14_DAY_FORECAST_WHOLESALE"/14),0) daily_forecast_wholesale
    , round(("14_DAY_FORECAST_DTCOR"/14),0) daily_forecast_dtcor
    , round(("14_DAY_FORECAST_PWEST"/14),0) daily_forecast_pwest
    , round(("14_DAY_FORECAST_PSOUTH"/14),0) daily_forecast_psouth
    , case
        when fc.version = 'Working'  then 'Working'
        when fc.version = 'Current S&OP'  then 'Current S&OP'
        when fc.version = 'Last Month S&OP'  then 'Last Month S&OP'
        when fc.version = 'Two Month S&OP'  then 'Two Month S&OP'
        when fc.version = 'Running 4 Month'  then 'Running 4 Month'
    end as forecast_version
from sales.v_forecast fc
    left join sales.item i on fc.sku_id = i.sku_id
    left join forecast.v_ai_product aip on fc.sku_id = aip.sku_id
where ((fc.forecast  < (to_date(dateadd('day', 63, date_trunc('week', current_date()))))))
    and ((fc.forecast  >= (to_date(dateadd('day', 7, date_trunc('week', current_date()))))))
    and (i.category = 'MATTRESS')
group by 1,2,18

)

select zz.new_hep_sku
    , zz.sfg_product_description
    , zz.finished_good_sku
    , zz.fg_product_description
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
from (
  select aa.new_hep_sku
      , aa.finished_good_sku
      , aa.count as qty_used
      , bb.on_hand as fg_on_hand
      , bb.pwest_onhand as fg_on_hand_pwest
      , bb.psouth_onhand as fg_on_hand_psouth
      , bb.product_description as fg_product_description
      , cc.on_hand as sfg_on_hand
      , cc.pwest_onhand as sfg_on_hand_pwest
      , cc.psouth_onhand as sfg_on_hand_psouth
      , cc.product_description as sfg_product_description
      , dd.unfulfilled_orders_units as unfulfilled_units_pwest
      , ee.unfulfilled_orders_units as unfulfilled_units_psouth
      , ff.total_units_new as total_units_new
      , ff."14_DAY_FORECAST" as "14_DAY_FORECAST"
      , ff.daily_forecast as daily_forecast
      , ff.total_units_new_pwest as total_units_new_pwest
      , ff."14_DAY_FORECAST_PWEST" as "14_DAY_FORECAST_PWEST"
      , ff.daily_forecast_pwest as daily_forecast_pwest
      , ff.total_units_new_psouth as total_units_new_psouth
      , ff."14_DAY_FORECAST_PSOUTH" as "14_DAY_FORECAST_PSOUTH"
      , ff.daily_forecast_psouth as daily_forecast_psouth
      , ff.forecast_version as forecast_version
  from aa
  left join bb on bb.sku_id = aa.finished_good_sku
  left join cc on cc.sku_id = aa.new_hep_sku
  left join dd on dd.sku_id = aa.finished_good_sku
  left join ee on ee.sku_id = aa.finished_good_sku
  left join ff on ff.sku_id = aa.finished_good_sku
) zz
--where forecast_version ='Working'
group by 1,2,3,4,24,25,26,27, 28;;  }

  dimension: hep_sku {
    label: "SFG SKU"
    description: "SFG SKU number; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."NEW_HEP_SKU" ;;
  }

  dimension: sfg_production_description {
    label: "SFG Product Description"
    description: "SFG Product Descripton; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."SFG_PRODUCT_DESCRIPTION" ;;
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

  dimension: forecast_version {
    label: "Forecast Version"
    type: string
    description: "Working is the current data in Adaptive, Current S&OP is locked at the first Saturday of the current month, Previous is 1 month previos.  Rolling 4 month is looking at the forecast data from 4 months previous to the date being forecasted. "
    case: {
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'Working' ;; label: "Working" }
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'Current S&OP' ;; label: "Current S&OP" }
      when: { sql: ${TABLE}."FORECAST_VERSION" = 'Running 4 Month' ;; label: "Running 4 Month" }
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
    type: max
    sql:  ${TABLE}."SFG_ON_HAND" ;;
  }

  measure: sfg_on_hand_pwest {
    label: "SFG on Hand P-West"
    description: "source; looker calculation"
    type: max
    sql:  ${TABLE}."SFG_ON_HAND_PWEST" ;;
  }

  measure: sfg_on_hand_psouth {
    label: "SFG on Hand P-South"
    description: "source; looker calculation"
    type: max
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

}
