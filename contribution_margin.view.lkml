view: contribution_margin {

   derived_table: {
     sql:
    select sl.item_id
            ,so.order_id
            ,so.system
            ,sl.gross_amt
            ,sl.ordered_qty
            ,sl.ordered_qty-nvl(co.qty,0) net_units
            ,nvl(co.cancelled,0) cancelled_amt
            ,nvl(r.returned,0) return_amt
            ,nvl(rd.rdiscounts,0) retro_discount_amt
            ,(sl.ordered_qty-nvl(co.qty,0))*ic.cogs COGS
            ,(sl.ordered_qty-nvl(co.qty,0))*ic.labor LABOR
            ,(sl.ordered_qty-nvl(co.qty,0))*ic.cogs*.089 FREIGHT_IN
            ,(sl.ordered_qty-nvl(co.qty,0))*ic.cogs*.031 WARRANTY
            ,round(case when so.source ilike '%amaz%' then .15*(sl.gross_amt-nvl(co.cancelled,0))
                    when so.payment_method ilike '%affirm%' then .06*(sl.gross_amt-nvl(co.cancelled,0))
                    when so.channel_id <> 1 then 0
                    else .03*(sl.gross_amt-nvl(co.cancelled,0)) end,2) merchant_fees
            ,nvl(f.shipping,0) +
                 nvl(case when so.customer_id = 2662 then nvl(ic.MF_tran,0)*(sl.ordered_qty-nvl(co.qty,0))
                     when so.system ilike '%amazo%' then nvl(ic.amz_tot,0)*(sl.ordered_qty-nvl(co.qty,0))
                     else nvl(lm.lm_delivery,0) end,0) freight
            ,nvl(ao.rate,0)*(sl.gross_amt-nvl(co.cancelled,0)) affiliate_fees
    from sales.sales_order_line sl
    join sales.sales_order so on so.order_id = sl.order_id and so.system = sl.system
    left join sales.item_cost ic on ic.item_id = sl.item_id
    left join (select order_id,item_id,system,sum(amount) rdiscounts from sales.retroactive_discount group by 1,2,3) rd on rd.item_id = sl.item_id and rd.system = sl.system and rd.order_id = sl.order_id
    left join (select order_id,item_id,system,sum(gross_amt) cancelled,sum(cancelled_qty) qty from sales.cancelled_order group by 1,2,3) co on co.item_id = sl.item_id and co.system = sl.system and co.order_id = sl.order_id
    left join (select order_id,item_id,system,sum(gross_amt) returned from sales.return_order_line group by 1,2,3) r on r.item_id = sl.item_id and r.system = sl.system and r.order_id = sl.order_id
    left join shipping.fedex_ca fc on fc.related_tranid = so.related_tranid
    left join marketing.affiliate_orders ao on ao.related_tranid = so.related_tranid
    left join sales.fulfillment f on f.order_id = sl.order_id and f.system = sl.system and f.item_id = sl.item_id
    left join
        (select s1.order_id,s1.item_id,s1.ordered_qty*fcalc.per_unit_cost lm_delivery from
            (select sl.order_id,case when ordered_qty = 0 then items else ordered_qty end units,(nvl(mlm.amt,0)+nvl(xlm.amt,0))/case when ordered_qty = 0 then items else ordered_qty end per_unit_cost
            from
            (select order_id,carrier,system,created,sum(ordered_qty) ordered_qty,count(distinct item_id) items from sales_order_line where item_id in (2084,2085,2972,2973,2974,2975,2977,2978,2980,2981,2982,2984,2985,2986,2988,2989,2990,3177) group by 1,2,3,4) sl
            join sales_order so on sl.system = so.system and sl.order_id = so.order_id
            left join (select tranid,sum(amt) amt from shipping.manna_last_mile group by 1) mlm on mlm.tranid = so.tranid and mlm.amt > 0
            left join (select tranid,sum(amt) amt from shipping.xpo_last_mile group by 1) xlm on xlm.tranid = so.tranid and xlm.amt > 0
            where nvl(xlm.amt,0)+nvl(mlm.amt,0)>0) fcalc
            join sales.sales_order_line s1 on fcalc.order_id = s1.order_id
            where s1.item_id in (2084,2085,2972,2973,2974,2975,2977,2978,2980,2981,2982,2984,2985,2986,2988,2989,2990,3177)) lm
        on lm.item_id = sl.item_id and lm.order_id = sl.order_id
    ;;
   }

  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  measure: total_lifetime_orders {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${lifetime_orders} ;;
 }
}
