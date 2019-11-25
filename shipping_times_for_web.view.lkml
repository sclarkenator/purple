view: shipping_times_for_web {

  derived_table: {
    sql:
with day_values as (select a.item_id, a.product_description_lkr, a.shipper, a.days, a.fulfilled_quantity, b.unfulfilled_quantity
            , (coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0))) weighted_quantity
            , sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper order by a.days) running_sum
            , sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper) item_sum
            , (sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper order by a.days)) / NULLIF((sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper)),0) cumulative_percent
            , abs(0.95 - ((sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper order by a.days)) / NULLIF((sum((coalesce(a.fulfilled_quantity, 0) + (2 * coalesce(unfulfilled_quantity, 0)))) over (partition by a.item_id, a.shipper)),0)  )) distance_from_95
        from (
            select item_id, product_description_lkr, days_to_fulfill days, shipper, sum(ordered_quantity) fulfilled_quantity
            from (
                select sol.order_id
                    , sol.system
                    , sol.item_id
                    , i.product_description_lkr
                    , sol.location
                    , case when sol.location = ('100-Purple West') then 'West'
                        when sol.location like ('%Pilot%') or sol.location like ('%Manna%') then 'Pilot'
                        when sol.location like ('%XPO%') then 'XPO' else 'Other' end as shipper
                    , datediff('day', sol.created, ful.created) days_to_fulfill
                    , sol.ordered_qty::int ordered_quantity
                from sales_order_line sol
                    LEFT JOIN sales.fulfillment ful ON sol.order_id = ful.order_id AND sol.item_id = ful.item_id AND sol.system = ful.system
                    join sales_order so on so.order_id = sol.order_id and so.system = sol.system
                    left join item i on i.item_id = sol.item_id
                    left join cancelled_order c on c.order_id = sol.order_id and c.system = sol.system
                where sol.created >= dateadd('day', -30, current_date())
                    and sol.created < dateadd('day', -5, current_date())
                    and ful.created is not null
                    and (c.refunded != 'Yes' or c.refunded is null)
                    and so.channel_id = 1
                    and sol.system not like ('AMAZON%')
            )
            group by item_id, product_description_lkr, days_to_fulfill, shipper ) a

        full outer join (
        select item_id, product_description_lkr, days_since_order days, shipper, sum(ordered_quantity) unfulfilled_quantity
        from (
            select sol.order_id
                , sol.system
                , sol.item_id
                , i.product_description_lkr
                , case when sol.location = ('100-Purple West') then 'West'
                        when sol.location like ('%Pilot%') or sol.location like ('%Manna%') then 'Pilot'
                        when sol.location like ('%XPO%') then 'XPO' else 'Other' end as shipper
                , datediff('day', sol.created, current_date()) days_since_order
                , sol.ordered_qty::int ordered_quantity
            from sales_order_line sol
                LEFT JOIN sales.fulfillment ful ON sol.order_id = ful.order_id AND sol.item_id = ful.item_id AND sol.system = ful.system
                join sales_order so on so.order_id = sol.order_id and so.system = sol.system
                left join item i on i.item_id = sol.item_id
                left join cancelled_order c on c.order_id = sol.order_id and c.system = sol.system
            where sol.created >= dateadd('day', -30, current_date())
                and sol.created < dateadd('day', -5, current_date())
                and ful.created is null
                and (c.refunded != 'Yes' or c.refunded is null)
                and so.channel_id = 1
                and sol.system not like ('AMAZON%')
        )
        group by item_id, product_description_lkr, days_since_order, shipper

        ) b on b.item_id = a.item_id and b.product_description_lkr = a.product_description_lkr and b.days = a.days and b.shipper = a.shipper
        order by item_id, shipper, days )

select item_id, product_description_lkr, shipper fulfillment_location, Max(days) days_to_fulfill
from (
    select dv.*
    from day_values dv
    join (select item_id, shipper, min(distance_from_95) the_smallest
          from day_values
          group by item_id, shipper) dv2 on dv.item_id = dv2.item_id and dv.distance_from_95 = dv2.the_smallest and dv.shipper = dv2.shipper
) group by item_id, product_description_lkr, fulfillment_location
order by item_id, fulfillment_location
  ;; }


      dimension: item_id {
        hidden: yes
        type: number
        sql: ${TABLE}.item_id;; }

      dimension: fulfillment_source {
        type:  string
        sql: ${TABLE}.fulfillment_location ;; }


      measure: estimated_fulfillment_days {
        type:  max
        label: "Estimated Days to Fulfill"
        description: "Estimatest the number of days it will take new orders to fulfill"
        sql: ${TABLE}.days_to_fulfill ;; }


  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.item_id,${TABLE}.fulfillment_location) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

    }
