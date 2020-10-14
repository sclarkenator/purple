view: sfg_stock_level {
  derived_table: {
    sql:
    with aa as (
  -- hep skus
  select
      hep_sku
      , i2.product_description hep_description
      , finished_good_sku
      , i.product_description finished_description
  from production.fg_to_sfg
      left join sales.item i on i.sku_id = finished_good_sku
      left join sales.item i2 on i2.sku_id = hep_sku
  where i.classification_new = 'FG' and i.category = 'MATTRESS' and i.product_description not like '%SPLIT KIN%' and i.product_description not like '%W/OG COVER%' and hep_sku not in ('20-21-22131','20-21-22159','20-21-22117')
      --and hep_sku = '20-21-22166'
  order by 2 desc
), bb as (
  --sales last 60 days
  select i.sku_id
      , ceil(sum(sol.ordered_qty)/60,0) as qty
      , ceil(sum(case when s.channel_id IN (1,2) then ordered_qty end)/60,0) as dtc_wholesale_qty
  from sales.sales_order_line sol
  left join sales.sales_order s on s.order_id = sol.order_id
  left join sales.item i on i.item_id = sol.item_id
  where sol.created::date > dateadd('day',-61,current_date)
      and sol.created::date < current_date::date
      --and channel_id in(1,2,5)
  group by 1
), cc as (
  --inventory
  select
      i.sku_id
      , sum(s.on_hand) as on_hand
  from production.inventory s
  left join sales.item i on s.item_id = i.item_id
  left join sales.location  l on s.location_id = l.location_id
  where l.location in ('100-Purple West', '150-Alpine', 'P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC', 'P30 - PILOT DFW DC')
  group by 1
), dd as (
   --Open orders
  select i.sku_id
      , i.product_description
      , sum(sol.ordered_qty) as open_qty
  from sales.sales_order_line  sol
  left join sales.item  i ON sol.item_id = i.item_id
  left join sales.fulfillment f ON (sol.item_id||'-'||sol.order_id||'-'||sol.system) =
      (case when f.parent_item_id = 0 or f.parent_item_id is null then f.item_id else f.parent_item_id end)||'-'||f.order_id||'-'||f.system
  left join sales.sales_order  s ON (sol.order_id||'-'||sol.system) = (s.order_id||'-'||s.system)
  left join sales.cancelled_order c ON (sol.item_id||'-'||sol.order_id||'-'||sol.system) = (c.item_id||'-'||c.order_id||'-'||c.system)
  where s.created::date > dateadd('day',-70,current_date::date) --and s.created::date < current_date::date
  and s.transaction_type <> 'Cash Sale'
  and s.source <> 'Amazon-FBA-US'
  and f.fulfilled is null
  and i.classification_new = 'FG'
  and (i.category = 'MATTRESS')
  and s.channel_id in (1,2)
  and c.cancelled is null
  and sol.location in ('100-Purple West', 'P10 - Pilot Columbus DC', 'P20 - Pilot Salt Lake DC', 'P30 - PILOT DFW DC', '101-XPO PWest')
  group by 1,2
  order by 3 desc
)
select zz.hep_sku
    , zz.hep_description
    , count (case when avg_sales is not null then finished_good_sku end) as qty_used
    , sum (avg_sales) daily_avg
    --, sum (avg_sales) *7 as sfg_stock_level
    , round(max(sfg_stock),0) current_inventory
    , round(sum (fg_stock),0) fg_on_hand
    , round(sum (open_qty),0) open_orders
from (
  select aa.*
      , bb.qty as avg_sales
      , bb.dtc_wholesale_qty as avg_sales2
      , cc.on_hand as sfg_stock
      , ccc.on_hand as fg_stock
      , dd.open_qty
  from aa
  left join bb on bb.sku_id = finished_good_sku
  left join cc on cc.sku_id = aa.hep_sku
  left join cc ccc on ccc.sku_id = finished_good_sku
  left join dd on dd.sku_id = aa.finished_good_sku
) zz
group by 1,2  ;;
  }

  dimension: hep_sku {
    label: "Hep SKU"
    description: "Hep SKU number; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."HEP_SKU" ;;
  }

  dimension: hep_description {
    label: "Hep Product Description"
    description: "Hep Product Descripton; source:production.fg_to_sfg"
    type: string
    sql: ${TABLE}."HEP_DESCRIPTION" ;;
  }

  measure: qty_used {
    label: "Quantity Used"
    description: "source; looker calculation"
    type: sum
    sql:  ${TABLE}."QTY_USED" ;;
  }

  measure: daily_avg {
    label: "Daily Average"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."DAILY_AVG" ;;
  }

  measure: current_inventory {
    label: "Current Inventory"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."CURRENT_INVENTORY" ;;
  }

  measure: fg_on_hand {
    label: "FG on Hand"
    description: "source; production.inventory"
    type: sum
    sql:  ${TABLE}."FG_ON_HAND" ;;
  }

  measure: open_orders {
    label: "Open Orders"
    description: "source; sales.sales_order_line"
    type: sum
    sql:  ${TABLE}."OPEN_ORDERS" ;;
  }
}
