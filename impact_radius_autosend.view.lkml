view: impact_radius_autosend {
   derived_table: {
     sql:   select *
    from
      (SELECT so.order_id
        ,so.related_tranid oid
        ,case when related_tranid ilike '#CA%' then 'CAD' else 'USD' end currency
        ,ir.actiondate
        ,ir.revenue*1 IR_AMT
        ,case when (sl.sales*1 - nvl(cancel,0)*1 - nvl(returns,0)*1)<0 then 0 else sl.sales*1 - nvl(cancel,0)*1 - nvl(returns,0)*1 end current_net_amt
        ,sl.sales*1 original_sales_amt
        ,nvl(cancel,0) cancel_amt
        ,nvl(returns,0) return_amt
from ANALYTICS_STAGE.MARKETING_STAGE.IMPACTRADIUS_1 IR
join sales.sales_order so on so.related_tranid = '#'||IR.oid
join (select order_id
                ,system
                ,sum(gross_amt) sales
     from sales.sales_order_line
      group by 1,2) sl
      on so.order_id = sl.order_id and so.system = sl.system
left join (
select order_id
        ,sum(gross_amt) cancel
from sales.cancelled_order
group by 1) c on c.order_id = so.order_id
left join (
select ro.order_id
        ,sum(rl.gross_amt) returns
from sales.return_order ro
join sales.return_order_line rl on ro.return_order_id = rl.return_order_id and ro.system = rl.system
group by 1) r on r.order_id = so.order_id
where so.created > current_date()-100
and revenue > 0)
where cancel_amt +return_amt > 0    ;;
  }

  dimension: oid {
    description: "OrderID or related_tranid"
    label: "OrderID"
    sql: ${TABLE}.oid ;;
    primary_key: yes
    }

  dimension: currency {
    description: "USD or CAD"
    label: "Currency"
    sql: ${TABLE}.currency ;;   }

  dimension_group: actiondate {
    description: "Order date"
    label: "Date"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    #convert_tz: no
    datatype: date
    sql: ${TABLE}.actiondate ;; }

  measure: current_amt {
    description: "Current net order amount (less cancellations and returns)"
    label: "Current order amt"
    type: sum
    sql: ${TABLE}.current_net_amt ;; }

  measure: original_amt {
    description: "Original order amount (before cancellations and returns)"
    label: "Original order amt"
    type: sum
    sql: ${TABLE}.original_sales_amt ;; }

  measure: cancel_amt {
    description: "Current net order amount (less cancellations and returns"
    label: "Cancel amt"
    type: sum
    sql: ${TABLE}.cancel_amt ;; }

  measure: return_amt {
    description: "Current net order amount (less cancellations and returns"
    label: "Return amt"
    type: sum
    sql: ${TABLE}.return_amt ;; }
}
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
