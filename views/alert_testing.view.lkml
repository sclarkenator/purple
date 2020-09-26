view: alert_testing {

 derived_table: {
     persist_for: "24 hours"
    sql:
with sessions as
(select to_date(time) date
        ,count(*) sessions
from analytics.heap.sessions
group by 1)
,
dtc_sales as
(select trandate date
        ,sum(case when zero$order_flag=0 and Mattress_Flg = 1 then 1 else 0 end) matt_ord
        ,sum(case when zero$order_flag=0 and Mattress_Flg = 1 then gross_amt else 0 end) matt_ord_vol
        ,sum(case when zero$order_flag=0 and Mattress_Flg = 1 then items_ordered else 0 end) matt_ord_units
        ,round(matt_ord_vol/matt_ord,0) AMOV
        ,round(matt_ord_units/matt_ord,2) M_UPT
        ,sum(case when zero$order_flag=0 and mattress_flg = 0 then 1 else 0 end) non_matt_ord
        ,sum(case when zero$order_flag=0 and mattress_flg = 0 then gross_amt else 0 end) non_matt_ord_vol
        ,sum(case when zero$order_flag=0 and Mattress_Flg = 0 then items_ordered else 0 end) non_matt_ord_units
        ,round(non_matt_ord_vol/non_matt_ord,0) NAMOV
        ,round(non_matt_ord_units/non_matt_ord,2) ACC_UPT
        ,sum(case when zero$order_flag=1 then 1 else 0 end) zero$_order
from
    (select so.trandate
                ,so.order_id
                ,so.gross_amt
                ,sum(case when sl.gross_amt = 0 then 0 else sl.ordered_qty end) items_ordered
                ,sum(case when i.category = 'MATTRESS' and i.classification = 'FG' then 1 else 0 end) mattress_flg
                ,sum(case when so.gross_amt = 0 then 1 else 0 end) zero$order_flag
    from sales_order_line sl join sales_order so on so.order_id = sl.order_id and so.system = sl.system
    join item i on i.item_id = sl.item_id
    where so.channel_id = 1
    and trandate > current_date - 121
    and trandate < current_date
    group by 1,2,3)
group by 1)
,
sub as
(select distinct to_Date(response_received) date
            ,'CUSTOMER_CARE' bus_unit
            ,'SCORE' as metric
            ,'CC_CSAT' category
            ,'M' tier
            ,avg(star_Rating) over (partition by to_date(response_received)) amount
    from ANALYTICS.CUSTOMER_CARE.customer_satisfaction_survey
    where to_Date(response_received) > current_date-121
    and to_date(response_received) <= current_date
UNION
--This pulls the count of calls based on disposition
select distinct to_date(contacted) date
            ,'CUSTOMER_CARE' bus_unit
            ,skill metric
            ,'CALLS' category
            ,'H' tier
            ,count(*) over (partition by to_date(contacted), skill) amount
    from ANALYTICS.CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT
    where skill in ('Abandon Carts','Customer Service General','Customer Service OB','Inbound Sales','Order Follow Up','Returns - Mattress','Returns - Other','Sales Team OB','Sales Xfer%','Service Recovery','Support Xfer%','Warranty')
    and to_date(contacted) > current_date-121
    and to_date(contacted) < current_date
UNION
select distinct to_Date(created) date
        ,'CUSTOMER_CARE' bus_unit
        ,case when department_name is null then 'UNASSIGNED' else department_name end metric
        ,'MISSED_CHATS' category
        ,'H' tier
        ,sum(case when missed=true then 1 else 0 end) over (partition by to_date(created),department_name) amount
from ANALYTICS.CUSTOMER_CARE.ZENDESK_CHATS
where to_date(created) > current_date-121
and to_date(created) < current_date
UNION
--this pulls the top 20 UTM_SOURCE by sessions from Heap.
select distinct to_date(time) date
        ,'WEB' bus_unit
        ,s.UTM_SOURCE metric
        ,'SESSIONS BY SOURCE' category
        ,'M' tier
        ,count(*) over (partition by to_date(time), s.UTM_SOURCE) amount
from analytics.heap.sessions s
join
  (select UTM_SOURCE
      ,count(*) sessions
  from analytics.heap.sessions
  where to_Date(time) < current_date
  and to_Date(time) > current_date-8
  group by 1
  qualify rank() over (order by sessions desc)<=20) s1 on s1.UTM_SOURCE = s.UTM_SOURCE
where to_date(time) > current_date-121
and to_date(time) < current_date
UNION
---this query pulls sessions by state, limited to the top 50 regions in HEAP
select distinct to_date(time) date
        ,'WEB' bus_unit
        ,s.region metric
        ,'SESSIONS BY STATE' category
        ,'L' tier
        ,count(*) over (partition by to_date(time), s.REGION) amount
from analytics.heap.sessions s
join
  (select REGION
      ,count(*) sessions
  from analytics.heap.sessions
  where to_Date(time) < current_date
  and to_Date(time) > current_date-8
  group by 1
  qualify rank() over (order by sessions desc)<=50) s1 on s1.REGION = s.REGION
where to_date(time) > current_date-121
and to_date(time) < current_date
UNION
---this query pulls the top 20 promo codes (determined from the past 7 days)
select distinct trandate date
    ,'DTC' bus_unit
        ,split_part(shopify_discount_code,'-',0) metric
    ,'ORDERS W/ PROMO CODE' category
    ,'H' tier
        ,count(*) over (partition by trandate, metric) amount
from sales_order so
join
    (select split_part(shopify_discount_code,'-',0) promo
            ,count(*) orders
    from sales_order
    where trandate < current_date
    and trandate > current_date-8
    group by 1
    qualify rank() over (order by orders desc)<=20) s1 on s1.promo = split_part(so.shopify_discount_code,'-',0)
where channel_id = 1
and trandate < current_date
and trandate > current_Date - 121
UNION
select distinct(to_Date(sl.created)) date
        ,'DTC' bus_unit
        ,i.line||'|'||i.model  metric
        ,'MATTRESS_ATTACH_RATE' category
        ,'H' tier
        ,round(count(distinct sl.order_id) over (partition by date, i.line||'|'||i.model)/count(distinct sl.order_id) over (partition by date),4) amount
from sales_order_line sl join item i on sl.item_id = i.item_id
join
    (select distinct so.order_id
    from sales_order so join sales_order_line sl on so.order_id = sl.order_id and so.system = sl.system
    join item i on sl.item_id = i.item_id
    where category = 'MATTRESS'
    and classification = 'FG'
    and so.trandate > current_Date - 121
    and so.trandate < current_date
    and so.gross_amt > 0
    and so.channel_id = 1) sub on sub.order_id = sl.order_id
UNION
select date
        ,'DTC' bus_unit
        ,'MATTRESS_ORDERS' metric
        ,'ORDERS' category
        ,'H' tier
        ,matt_ord amount
from dtc_sales
UNION
select date
        ,'DTC' bus_unit
        ,'AMOV' metric
        ,'ORDERS' category
        ,'H' tier
        ,AMOV amount
from dtc_sales
UNION
select date
        ,'DTC' bus_unit
        ,'MATTRESS UPT' metric
        ,'ORDERS' category
        ,'H' tier
        ,m_UPT amount
from dtc_sales
UNION
select date
        ,'DTC' bus_unit
        ,'ACCESSORY_ORDERS' metric
        ,'ORDERS' category
        ,'H' tier
        ,non_matt_ord amount
from dtc_sales
UNION
select date
        ,'DTC' bus_unit
        ,'NAMOV' metric
        ,'ORDERS' category
        ,'H' tier
        ,NAMOV amount
from dtc_sales
UNION
select date
        ,'DTC' bus_unit
        ,'ACCESSORY UPT' metric
        ,'ORDERS' category
        ,'H' tier
        ,acc_UPT amount
from dtc_sales

)
,
MEDIANS as
(select distinct date
            ,bus_unit
            ,category
            ,metric
            ,tier
            ,amount
            ,abs(amount - median(amount) over (partition by category||metric)) diff_median
            ,median(amount) over (partition by category||metric) median
from SUB)

--******// MAIN QUERY //*****
select date
        ,bus_unit
        ,category
        ,metric
        ,tier
        ,amount
        ,median
        ,median-1.5*(median(diff_median) over (partition by category||metric)) neg_one_SD
        ,median-3*(median(diff_median) over (partition by category||metric)) neg_two_SD
        ,median+1.5*(median(diff_median) over (partition by category||metric)) plus_one_SD
        ,median+3*(median(diff_median) over (partition by category||metric)) plus_two_SD
        ,case
            when amount > plus_two_SD then '2 SD above median'
            when amount < neg_two_SD then '2 SD below median'
            when amount > plus_one_SD
                AND (lead(amount,1,0) over (order by date desc)) > plus_one_SD
                AND (lead(amount,2,0) over (order by date desc)) > plus_one_SD then 'Trending above SD'
            when amount < neg_one_SD
                AND (lead(amount,1,0) over (order by date desc)) < neg_one_SD
                AND (lead(amount,2,0) over (order by date desc)) < neg_one_SD then 'Trending below SD'
            else null
        end alert
from medians
       ;;
   }
   dimension: date {
     description: "Date"
     type: date
     sql: ${TABLE}.date ;;
   }

  dimension: bus_unit {
    description: "Business unit responsible for metric"
    type: string
    sql: ${TABLE}.bus_unit ;;
  }
  dimension: category {
    description: "Grouping within metrics"
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: metric {
    description: "What is being measured"
    type: string
    sql: ${TABLE}.metric ;;
  }
  dimension: tier {
    description: "Level of metric in question"
    type: string
    sql: ${TABLE}.tier ;;
  }
  dimension: alert {
    description: "Is metric outside statistical norms?"
    type: string
    sql: ${TABLE}.alert ;;
  }

   measure: amount {
     description: "Value for selected metric"
     type: sum
    value_format: "[<1]0.0%;[>=1]#,##0"
     sql: ${TABLE}.amount ;;
   }
  measure: median {
    description: "120-day median value for selected metric"
    value_format: "[<1]0.0%;[>=1]#,##0"
    type: sum
    sql: ${TABLE}.median ;;
  }
  measure: neg_one_SD {
    description: "1 SD equivalent below median (for control charts)"
    value_format: "[<1]0.0%;[>=1]#,##0"
    type: sum
    sql: ${TABLE}.neg_one_SD ;;
  }
  measure: neg_two_SD {
    description: "2 SD equivalent below median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[>=1]#,##0"
    sql: ${TABLE}.neg_two_SD ;;
  }
  measure: plus_one_SD {
    description: "1 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[>=1]#,##0"
    sql: ${TABLE}.plus_one_SD ;;
  }
  measure: plus_two_SD {
    description: "2 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[>=1]#,##0"
    sql: ${TABLE}.plus_two_SD ;;
  }




}
