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
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.category = 'MATTRESS' and i.product_description not like '%SCRIM PEAK-%' and (i.sku_id not like '%AC%' or i.sku_id is null) and i.classification_new = 'FG' and l.location = '100-Purple West' and l.inactive = 0
group by 1,2
order by 3 desc

), cc as (

--Scrim Peak by Mattress SKU
select
    i.sku_id
    , i.product_description
  , round(coalesce(sum(inv.on_hand ), 0),0) on_hand
from production.inventory inv
    left join sales.item i on inv.item_id = i.item_id
    left join sales.location l on inv.location_id = l.location_id
where i.category = 'MATTRESS' and i.product_description LIKE '%SCRIM PEAK-%' and (i.SKU_ID not like '%AC%' or i.sku_id is null) and l.location = '100-Purple West' and l.INACTIVE = 0
group by 1,2
order by 3 desc

), dd as (

--Open Orders by Mattress SKU
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
where ((sol.location in ('100-Purple West', '101-XPO PWest', 'P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC', 'P30 - PILOT DFW DC', 'N10 - NEHDS Cranberry NJ', 'R10 - Ryder Atlanta DC'))) and ((i.type in ('Assembly/Bill of Materials', 'Inventory Item', 'Kit/Package'))) and (i.category = 'MATTRESS') and (i.line <> 'COVER' or i.line is null) and ((case when so.channel_id = 1 then 'DTC'
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

--Forecasted Sales by Mattress SKU
select
  coalesce (i.sku_id, aip.sku_id) sku_id
  , i.product_description
  , round(coalesce(sum(fc.total_units ), 0),0) total_units_new
    , round(((total_units_new/8)*2),0) "14_DAY_SUPPLY"
    , round(("14_DAY_SUPPLY"/14),0) daily_forecast
from sales.v_forecast fc
    left join sales.item i on fc.sku_id = i.sku_id
    left join forecast.v_ai_product aip ON fc.sku_id = (aip.sku_id)
where (((case
    when fc.version = 'Working'  then 'Working'
    when fc.version = 'Current S&OP'  then 'Current S&OP'
    when fc.version = 'Last Month S&OP'  then 'Last Month S&OP'
    when fc.version = 'Two Month S&OP'  then 'Two Month S&OP'
    when fc.version = 'Running 4 Month'  then 'Running 4 Month'
        end) = 'Last Month S&OP'))
    and ((fc.forecast  < (to_date(dateadd('day', 63, date_trunc('week', current_date()))))))
    and ((fc.forecast  >= (to_date(dateadd('day', 7, date_trunc('week', current_date()))))))
    and (i.category = 'MATTRESS')
group by 1,2
order by 3 desc

)

select zz.new_hep_sku
    , zz.sfg_product_description
    , zz.finished_good_sku
    , zz.fg_product_description
    , sum(zz.qty_used) as quantity_used
    , sum(zz.fg_on_hand) as fg_on_hand
    , max(zz.sfg_on_hand) as sfg_stock_level
    , case when sum(zz.unfulfilled_units) is null then 0 else sum(zz.unfulfilled_units) end as quantity_remaining
    , case when sum(zz.total_units_new) is null then 0 else sum(zz.total_units_new) end as total_new_units
    , case when sum(zz."14_DAY_SUPPLY") is null then 0 else sum(zz."14_DAY_SUPPLY") end as fourteen_day_supply
    , case when sum(zz.daily_forecast) is null then 0 else sum(zz.daily_forecast) end as daily_forecast
    , case when round(div0((zz.fg_on_hand-zz.unfulfilled_units),zz.daily_forecast),0) is null then 0
        else round(div0((zz.fg_on_hand-zz.unfulfilled_units),zz.daily_forecast),0)
      end as days_of_inventory
    , case when ((zz."14_DAY_SUPPLY"+zz.unfulfilled_units)-zz.fg_on_hand) < 1 then 0
        when ((zz."14_DAY_SUPPLY"+zz.unfulfilled_units)-zz.fg_on_hand) is null then 0
        else ((zz."14_DAY_SUPPLY"+zz.unfulfilled_units)-zz.fg_on_hand)
      end as beds_needed
from (
  select aa.new_hep_sku
      , aa.finished_good_sku
      , aa.count as qty_used
      , bb.on_hand as fg_on_hand
      , bb.product_description as fg_product_description
      , cc.on_hand as sfg_on_hand
      , cc.product_description as sfg_product_description
      , dd.unfulfilled_orders_units as unfulfilled_units
      , ee.total_units_new as total_units_new
      , ee."14_DAY_SUPPLY" as "14_DAY_SUPPLY"
      , ee.daily_forecast as daily_forecast
  from aa
  left join bb on bb.sku_id = aa.finished_good_sku
  left join cc on cc.sku_id = aa.new_hep_sku
  left join dd on dd.sku_id = aa.finished_good_sku
  left join ee on ee.sku_id = aa.finished_good_sku
) zz
--where new_hep_sku = ''
group by 1,2,3,4,12,13  ;;
  }

  dimension: hep_sku {
    label: "SFG SKU"
    description: "SFG SKU number; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."NEW_HEP_SKU" ;;
  }

  dimension: sfg_production_description {
    label: "Hep Product Description"
    description: "Hep Product Descripton; source:production.fg_to_sfg"
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
    label: "Hep Product Description"
    description: "Hep Product Descripton; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."FG_PRODUCT_DESCRIPTION" ;;
  }

  measure: quantity_used {
    label: "Quantity Used"
    description: "source; looker calculation"
    type: sum
    sql:  ${TABLE}."QUANTITY_USED" ;;
  }

  measure: fg_on_hand {
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."FG_ON_HAND" ;;
  }

  measure: sfg_stock_level{
    description: "source; looker calculation"
    type: sum
    sql:  ${TABLE}."SFG_STOCK_LEVEL" ;;
  }

  measure: quantity_remaining {
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."QUANTITY_REMAINING" ;;
  }

  measure: total_new_units {
    label: "Total Units Forecasted"
    description: "Total Number of Units Forecasted for the next 8 Weeks; source: production.inventory"
    type: sum
    sql:  ${TABLE}."TOTAL_NEW_UNITS" ;;
  }

  measure: fourteen_day_forecast {
    label: "14 Day Supply"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."FOURTEEN_DAY_FORECAST" ;;
  }

  measure: daily_forecast {
    label: "Daily Forecast"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."DAILY_FORECAST" ;;
  }

  measure: days_of_inventory {
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."DAYS_OF_INVENTORY" ;;
  }

  measure: beds_needed {
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."BEDS_NEEDED" ;;
  }
}
