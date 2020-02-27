view: day_pending {
  derived_table: {
    sql:
      select c.date
          , count(c.order_id) as orders
      from (
        select a.date
            , b.order_id
        from (
          --selecting each date with 8 am
          select date
              , dateadd('hour',8,date)::datetime date8am
          from util.warehouse_date
          where date between '2019-01-01' and current_date
        ) a
        left join (
          --setting the start and end date of pending approvals by order_id
          select aa.order_id
              , min(aa.pending_approval_start) as startdate
              , max(coalesce(aa.pending_approval_end,dateadd('day',1,current_date))) as enddate
          from shipping.v_transmission_dates aa
          where aa.pending_approval_start is not null
          group by aa.order_id
        ) b on b.startdate < a.date8am and b.enddate > a.date8am
      ) c
      group by 1
    ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}date ;;
  }

  measure: orders {
    type: average
    sql: orders ;;
  }

}
