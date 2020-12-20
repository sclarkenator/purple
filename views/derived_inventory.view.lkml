view: derived_inventory {
## View added by Scott Clark 11/25/2020
## Can be deleted. Data Engineering built these metrics in to the actual snowflake tables. 12/20/2020

   derived_table: {
     sql: select location_id
        ,item_id
        ,ON_HAND
        ,OPEN_ORDER
        ,avg(case when on_hand < open_order then on_hand-open_order else 0 end) backorder
        ,avg(case when on_hand-open_order < 0 then 0 else on_hand-open_order end) available
        ,sum(case when channel_id = 1 then channel_open_order else 0 end) DTC_OPEN_ORDER
        ,sum(case when channel_id = 2 then channel_open_order else 0 end) WHOLESALE_OPEN_ORDER
        ,sum(case when channel_id = 5 then channel_open_order else 0 end) RETAIL_OPEN_ORDER
from
(select distinct full_name
        ,l.location_id
        ,item.item_id
        ,on_hand
        ,s.channel_id
        ,sum(ordered_qty) over (partition by item.description, l.location_id) open_order
        ,sum(ordered_qty) over (partition by item.description, l.location_id, s.channel_id) channel_open_order
from production.inventory i join analytics_stage.ns.locations l on i.location_id = l.location_id
join analytics.sales.item on i.item_id = item.item_id
join analytics.sales.sales_order_line sl on sl.item_id = item.item_id and sl.location = l.full_name
join analytics.sales.sales_order s on s.order_id = sl.order_id and s.system = sl.system
left join analytics.sales.cancelled_order co on co.order_id = sl.order_id and co.item_id = sl.item_id
left join analytics.sales.fulfillment f on f.order_id = sl.order_id and f.item_id = sl.item_id
where current_date <= dateadd(d,35,sl.created)
and co.cancelled is null
and f.fulfilled is null
and coalesce(s.ship_by,to_Date(sl.created)) <= dateadd(d,7 ,current_Date)
and s.channel_id in (1,2,5)
)
group by 1,2,3,4
       ;;
   }

  dimension: location_id {
    description: "location_id used by Netsuite"
    hidden: yes
    type: string
    sql: ${TABLE}.location_id ;;
  }

  dimension: item_id {
    description: "item_id used by Netsuite"
    hidden: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  measure: open_order {
    label: "Open orders"
    description: "Open orders includes all orders placed in the last 35 days that have a minimum ship_date less than 1 week out."
    type: sum
    sql: ${TABLE}.open_order ;;
  }

  measure: available {
    label: "Available"
    description: "This is on hand, minus open orders at fulfillment locations. Totals are then aggregated across locations."
    type: sum
    sql: ${TABLE}.available ;;
  }

  measure: backorder {
    label: "Backorder"
    description: "When open orders exceed on hand at a fulfillment location, backorder is calculated as on hand - open orders."
    type: sum
    sql: ${TABLE}.backorder ;;
  }

  measure: dtc_open_order {
    label: "DTC Open orders"
    description: "Open DTC orders includes all orders placed in the last 35 days that have a minimum ship_date less than 1 week out."
    type: sum
    sql: ${TABLE}.dtc_open_order ;;
  }

  measure: wholesale_open_order {
    label: "Open whlsl orders"
    description: "Open wholesale orders includes all orders placed in the last 35 days that have a minimum ship_date less than 1 week out."
    type: sum
    sql: ${TABLE}.wholesale_open_order ;;
  }

  measure: retail_open_order {
    label: "Open retail orders"
    description: "Open retail orders includes all orders placed in the last 35 days that have a minimum ship_date less than 1 week out."
    type: sum
    sql: ${TABLE}.retail_open_order ;;
  }


}
