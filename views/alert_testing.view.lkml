view: alert_testing {

 derived_table: {
     persist_for: "24 hours"
    sql:
with session_details as
--this select gets all the session-level metrics aggregated by date with all the separate categories to partition by later
(select s.session_id
        ,to_date(s.time) date
        ,s.UTM_SOURCE
        ,s.UTM_medium
        ,s.landing_page
        ,s.platform
        ,s.device_Type
        ,s.browser
        ,s.region
        ,s.country
        ,case when referrer ilike '%purple.com%' then 'purple.com' when referrer ilike '%purple.narvar.com%' then 'purple.narvar.com' when referrer ilike '%pinterest.com%' then 'pinterest.com' else split_part(ltrim(ltrim(split_part(rtrim(referrer,'/'),'//',2),'www.'),'l.'),'/',1) end referrer
        ,case when utm_medium = 'sr' or utm_medium = 'search' or utm_medium = 'cpc' /*or qsp.search = 1*/ then 'search' when utm_medium = 'so' or utm_medium ilike '%social%' or referrer ilike '%fb%' or referrer ilike '%facebo%' or referrer ilike '%insta%' or referrer ilike '%l%nk%din%' or referrer ilike '%pinteres%' or referrer ilike '%snapch%' then 'social' when utm_medium ilike 'vi' or utm_medium ilike 'video' or referrer ilike '%y%tube%' then 'video' when utm_medium ilike 'nt' or utm_medium ilike 'native' then 'native' when utm_medium ilike 'ds' or utm_medium ilike 'display' or referrer ilike '%outbrain%' or referrer ilike '%doubleclick%' or referrer ilike '%googlesyndica%' then 'display' when utm_medium ilike 'sh' or utm_medium ilike 'shopping' then 'shopping' when utm_medium ilike 'af' or utm_medium ilike 'ir' or utm_medium ilike '%affiliate%' then 'affiliate'   when utm_medium ilike 'em' or utm_medium ilike 'email' or referrer ilike '%mail.%' or referrer ilike '%outlook.live%' then 'email' when utm_medium is null and (referrer ilike '%google%' or referrer ilike '%bing%' or referrer ilike '%yahoo%' or referrer ilike '%ask%' or referrer ilike '%aol%' or referrer ilike '%msn%' or referrer ilike '%yendex%' or referrer ilike '%duckduck%') then 'organic' when utm_medium ilike 'rf' or utm_medium ilike 'referral' or utm_medium ilike '%partner platfo%' or lower(referrer) not like '%purple%' then 'referral' when (referrer ilike '%purple%' and utm_medium is null) or referrer is null then 'direct' else 'undefined' end channel
        ,pv.pages
        ,1 session_flag
        ,sum(session_flag) over (partition by date) total_sessions
        ,case when pv.pages < 2 then 1 else 0 end bounce_flag
        ,sn.session_num
        ,case when sn.session_num > 1 then 1 else 0 end ret_visit_flag
        ,nvl(p.order_amt,0) order_amt
        ,case when p.order_amt is null then 0 else 1 end conv_flag
from analytics.heap.sessions s
left join
    (select session_id
            ,sum(shopify_amt) order_amt
            ,count(*) conversions
     from ANALYTICS.MARKETING.ECOMMERCE
     where to_date(session_time) > current_date-121
     and to_date(session_time) < current_date
     and diff <6000
     group by 1) p on s.session_id = p.session_id
left join
    (select distinct session_id
            ,count(event_id) over (partition by session_id) pages
    from analytics.heap.pageviews
    where to_date(session_time) > current_date-121
    and to_date(session_time) < current_date) pv on pv.session_id = s.session_id
left join
    (select distinct session_id
            ,row_number() over (partition by user_id order by time) session_num
    from analytics.heap.sessions
    where to_date(time) > current_date -121
    and to_date(time) < current_date) sn on sn.session_id = s.session_id
where to_date(s.time) > current_date -121
and to_date(s.time) < current_date)
,
tot_sessions as
(select distinct date
        ,total_sessions
from session_details)
,
pageviews as
--this select captures the
(select distinct to_date(session_time) date
        ,session_id
        ,case when path ilike '%/10304151/checkouts%' then '/checkout' else rtrim(path,'/') end page
        ,rank() over (partition by session_id order by time) page_sequence
        ,count(*) over (partition by session_id) session_pages
        ,case when max(time) over (partition by session_id) = time then 1 else 0 end exit_flag
        ,page_sequence||' of '||session_pages page_of_session
from analytics.heap.pageviews
where to_date(time) > current_date -121
and to_date(time) < current_date)
,
top_pages as
(select page
from
  (select page
      ,count(*) views
  from pageviews
  where date > current_date-8
  group by 1)
qualify rank() over (order by views desc)<51)
,
top_referrers as
(select referrer
from
  (select referrer
      ,count(*) sessions
  from session_details
  where date > current_date-8
  group by 1)
qualify rank() over (order by sessions desc)<31)
,
top_landing as
(select landing_page
from
  (select landing_page
      ,count(*) sessions
  from session_details
  where date > current_date-8
  group by 1)
qualify rank() over (order by sessions desc)<31)
,
top_source as
(select UTM_SOURCE
from
  (select UTM_SOURCE
      ,count(*) sessions
  from session_details
  where date > current_date-8
  group by 1)
qualify rank() over (order by sessions desc)<21)
,
top_medium as
(select UTM_MEDIUM
from
  (select UTM_MEDIUM
      ,count(*) sessions
  from session_details
  where date > current_date-8
  group by 1)
qualify rank() over (order by sessions desc)<16)
,
top_browser as
(select browser
from
  (select split_part(browser,'.',0) browser
      ,count(*) sessions
  from session_details
  where date > current_date-8
  group by 1)
qualify rank() over (order by sessions desc)<21)
,
pv_details as (
select distinct p.date
        ,p.page
        ,count(*) over (partition by p.date, p.page) pageviews
        ,sum(exit_flag) over (partition by p.date, p.page) exits
        ,sum(conv_flag) over (partition by p.date, p.page) conversions
        ,sum(nvl(s.ordeR_amt,0)) over (partition by p.date, p.page) revenue
        ,round(exits/pageviews,3) exit_rate
        ,round(conversions/pageviews,3) conversion_rate
        ,round(pageviews/ts.total_sessions,3) pct_sessions_pageview
        ,round(revenue/pageviews,2) rev_per_pv
from pageviews p join session_details s on p.session_id = s.session_id
join top_pages tp on p.page = tp.page
join tot_sessions ts on p.date = ts.date
order by 2,1)
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
main_query as
--this is the main select that combines all the single-metric fact queries from the previous CTEs or raw tables. simply union another select on to add another category of metrics
--schema is date-> bus_unit -> metric (this is the partition by in most queries) -> category (description of metric) -> tier (H/M/L for reporting suppression) -> amount
(
--this pulls the CSAT for the call center for a given days
select distinct to_Date(response_received) date
    ,'CUSTOMER_CARE' bus_unit
    ,'RATING' as DIMENSIONS
    ,'AVERAGE CSAT' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,avg(star_Rating) over (partition by to_date(response_received)) amount
  ,'NONE' as HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from ANALYTICS.CUSTOMER_CARE.customer_satisfaction_survey
where to_Date(response_received) > current_date-121
and to_date(response_received) <= current_date
UNION
--this pulls count of 1-star CSAT for the call center for a given day
select distinct to_Date(response_received) date
    ,'CUSTOMER_CARE' bus_unit
    ,'RATING' as DIMENSIONS
    ,'1-STAR SCORES' METRIC
    ,'FINE' DETAIL_LEVEL
  ,-1 POLARITY
    ,sum(star_Rating) over (partition by to_date(response_received)) amount
  ,'NONE' as HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from ANALYTICS.CUSTOMER_CARE.customer_satisfaction_survey
where to_Date(response_received) > current_date-121
and to_date(response_received) <= current_date
and star_rating = 1
UNION
--this pulls count of 5-star CSAT for the call center for a given day
select distinct to_Date(response_received) date
    ,'CUSTOMER_CARE' bus_unit
    ,'RATING' as DIMENSIONS
    ,'5-STAR SCORES' METRIC
    ,'FINE' DETAIL_LEVEL
  ,-1 POLARITY
    ,sum(star_Rating) over (partition by to_date(response_received)) amount
  ,'NONE' as HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from ANALYTICS.CUSTOMER_CARE.customer_satisfaction_survey
where to_Date(response_received) > current_date-121
and to_date(response_received) <= current_date
and star_rating = 5
UNION
--This pulls the count of calls based on disposition
select distinct to_date(contacted) date
    ,'CUSTOMER_CARE' bus_unit
    ,skill DIMENSIONS
    ,'CALLS' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by to_date(contacted), skill) amount
  ,'MINIMUM # CALLS' HURDLE_DESCRIPTION
  ,20 SIG_HURDLE
    ,count(*) over (partition by to_date(contacted), skill) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from ANALYTICS.CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT
where skill in ('Abandon Carts','Customer Service General','Customer Service OB','Inbound Sales','Order Follow Up','Returns - Mattress','Returns - Other','Sales Team OB','Sales Xfer%','Service Recovery','Support Xfer%','Warranty')
and to_date(contacted) > current_date-121
and to_date(contacted) < current_date
UNION
--this pulls the count of missed chats by department_name
select distinct to_Date(created) date
    ,'CUSTOMER_CARE' bus_unit
    ,case when department_name is null then 'UNASSIGNED' else department_name end DIMENSIONS
    ,'MISSED_CHATS' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,-1 POLARITY
    ,sum(case when missed=true then 1 else 0 end) over (partition by to_date(created),department_name) amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from ANALYTICS.CUSTOMER_CARE.ZENDESK_CHATS
where to_date(created) > current_date-121
and to_date(created) < current_date
UNION
--this pulls sesisons count for the top 20 UTM_SOURCE by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.UTM_SOURCE DIMENSIONS
    ,'SESSIONS BY SOURCE' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by s.date, s.UTM_SOURCE) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.UTM_SOURCE) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s join top_source ts on s.utm_source = ts.utm_source
where date > current_date-121
and date < current_date
UNION
--this pulls bounce rate for the top 20 UTM_SOURCE by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.UTM_SOURCE DIMENSIONS
    ,'BOUNCE BY SOURCE' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(bounce_flag) over (partition by date,DIMENSIONS)/sum(session_flag) over (partition by date,DIMENSIONS),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.UTM_SOURCE) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from session_details s join top_source ts on s.utm_source = ts.utm_source
where date > current_date-121
and date < current_date
UNION
--this pulls QCVR for the top 20 UTM_SOURCE by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.UTM_SOURCE DIMENSIONS
    ,'QCVR BY SOURCE' METRIC
    ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(conv_flag) over (partition by date,DIMENSIONS)/nullif((sum(session_flag) over (partition by date,DIMENSIONS)-sum(bounce_flag) over (partition by date,DIMENSIONS)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.UTM_SOURCE) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from session_details s join top_source ts on s.utm_source = ts.utm_source
where date > current_date-121
and date < current_date
UNION
--this pulls RPV for the top 20 UTM_SOURCE by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.UTM_SOURCE DIMENSIONS
    ,'RPV BY SOURCE' METRIC
    ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(order_amt) over (partition by date,DIMENSIONS)/nullif(sum(session_flag) over (partition by date,DIMENSIONS),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.UTM_SOURCE) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from session_details s join top_source ts on s.utm_source = ts.utm_source
where date > current_date-121
and date < current_date
UNION
--this pulls sesisons count for the top 20 CHANNEL by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.CHANNEL DIMENSIONS
    ,'SESSIONS BY SOURCE' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by s.date, s.CHANNEL) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.CHANNEL) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s
where date > current_date-121
and date < current_date
UNION
--this pulls bounce rate for the top 20 CHANNEL by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.CHANNEL DIMENSIONS
    ,'BOUNCE BY SOURCE' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(bounce_flag) over (partition by date,DIMENSIONS)/sum(session_flag) over (partition by date,DIMENSIONS),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.CHANNEL) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from session_details s
where date > current_date-121
and date < current_date
UNION
--this pulls QCVR for the top 20 CHANNEL by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.CHANNEL DIMENSIONS
    ,'QCVR BY SOURCE' METRIC
    ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(conv_flag) over (partition by date,DIMENSIONS)/nullif((sum(session_flag) over (partition by date,DIMENSIONS)-sum(bounce_flag) over (partition by date,DIMENSIONS)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.CHANNEL) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from session_details s
where date > current_date-121
and date < current_date
UNION
--this pulls RPV for the top 20 CHANNEL by sessions from Heap
select distinct s.date
    ,'WEB' bus_unit
    ,s.CHANNEL DIMENSIONS
    ,'RPV BY SOURCE' METRIC
    ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
    ,round(sum(order_amt) over (partition by date,DIMENSIONS)/nullif(sum(session_flag) over (partition by date,DIMENSIONS),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.CHANNEL) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from session_details s
where date > current_date-121
and date < current_date
UNION
--this query pulls sessions by state, limited to the top 50 regions in HEAP
select distinct s.date
    ,'WEB' bus_unit
    ,s.region DIMENSIONS
    ,'SESSIONS BY STATE' METRIC
    ,'VERY DETAILED' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by s.date, s.REGION) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by s.date, s.REGION) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s
join
    (select region
    from
    (select REGION
      ,count(*) sessions
    from session_details
    where date < current_date
    and date > current_date-8
    and country ilike '%united states%'
    group by 1)
    qualify rank() over (order by sessions desc)<=50) s1 on s1.REGION = s.REGION
where date > current_date-121
and date < current_date
UNION
---this query pulls the top 20 promo codes (determined from the past 7 days)
select distinct trandate date
  ,'DTC' bus_unit
  ,split_part(shopify_discount_code,'-',0) DIMENSIONS
  ,'ORDERS W/ PROMO CODE' METRIC
  ,'VERY DETAILED' DETAIL_LEVEL
  ,-1 POLARITY
  ,count(*) over (partition by trandate, DIMENSIONS) amount
  ,'MINIMUM ORDERS' HURDLE_DESCRIPTION
  ,10 SIG_HURDLE
  ,count(*) over (partition by trandate, DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from sales_order so
join
  (select promo
  from
    (select split_part(shopify_discount_code,'-',0) promo
        ,count(*) orders
    from sales_order
    where trandate < current_date
    and trandate > current_date-8
    group by 1)
  qualify rank() over (order by orders desc)<=20) s1 on s1.promo = split_part(so.shopify_discount_code,'-',0)
where channel_id = 1
and trandate < current_date
and trandate > current_Date - 121
UNION
--this select calculates mattress attach rates for non-0 mattress orders
select distinct(to_Date(sl.created)) date
    ,'DTC' bus_unit
    ,i.line||'|'||i.model  DIMENSIONS
    ,'MATTRESS_ATTACH_RATE' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,round(count(distinct sl.order_id) over (partition by date, i.line||'|'||i.model)/count(distinct sl.order_id) over (partition by date),4) amount
  ,'MINIMUM MATTRESS ATTACH RATE' HURDLE_DESCRIPTION
  ,0.03 SIG_HURDLE
  ,round(count(distinct sl.order_id) over (partition by date, i.line||'|'||i.model)/count(distinct sl.order_id) over (partition by date),4) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
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
    ,'ORDER' DIMENSIONS
    ,'MATTRESS ORDERS' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
select date
    ,'DTC' bus_unit
    ,'ORDER' DIMENSIONS
    ,'AMOV' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,AMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
select date
    ,'DTC' bus_unit
    ,'ORDER' DIMENSIONS
    ,'MATTRESS UPT' metric
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,m_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
select date
    ,'DTC' bus_unit
    ,'ORDER' DIMENSIONS
    ,'ACCESSORY_ORDERS' metric
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,non_matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
select date
    ,'DTC' bus_unit
    ,'ORDER' DIMENSIONS
    ,'NAMOV' metric
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,NAMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,5 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
select date
    ,'DTC' bus_unit
    ,'ORDER' DIMENSIONS
    ,'ACCESSORY UPT' metric
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,acc_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,6 METRIC_WITHIN_DIMENSIONS
from dtc_sales
UNION
--transactions by payment method
select distinct trandate date
    ,'WEB' bus_unit
    ,payment_method DIMENSIONS
    ,'ORDERS BY PAYMENT METHOD' METRIC
    ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by date,payment_method) amount
  ,'MINIMUM ORDER COUNT' HURDLE_DESCRIPTION
  ,50 SIG_HURDLE
  ,count(*) over (partition by date,payment_method) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from sales_order
where channel_id = 1
and trandate < current_date
and trandate > current_Date - 121
UNION
---top 20 browsers
select distinct s.date
    ,'WEB' bus_unit
    ,split_part(s.browser,'.',0) DIMENSIONS
    ,'SESSIONS BY BROWSER' METRIC
    ,'VERY DETAILED' tier
  ,1 POLARITY
    ,count(*) over (partition by date,DIMENSIONS) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by date,DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s join top_browser tb on split_part(s.browser,'.',0) = tb.browser
where date < current_date
and date > current_date - 121
UNION
---top 30 landing pages
select distinct s.date
    ,'ACQUISITIONS' bus_unit
    ,s.landing_page DIMENSIONS
    ,'SESSIONS BY LANDING PAGE' METRIC
    ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
    ,count(*) over (partition by date,s.landing_page) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by date,s.landing_page) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s join top_landing t on s.landing_page = t.landing_page
where date < current_date
and date > current_date - 121
UNION
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE BOUNCE' METRIC
  ,'MEDIUM' tier
  ,-1 POLARITY
  ,round(sum(bounce_flag) over (partition by date,s.landing_page)/sum(session_flag) over (partition by date,s.landing_page),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by date,s.landing_page) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from session_details s join top_landing t on s.landing_page = t.landing_page
where date < current_date
and date > current_date - 121
UNION
--this query returns the qualified conversion rate for the top landing pages
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE QCVR' METRIC
  ,'MEDIUM' tier
  ,1 POLARITY
  ,round(sum(conv_flag) over (partition by date,s.landing_page)/nullif((sum(session_flag) over (partition by date,s.landing_page)-sum(bounce_flag) over (partition by date,s.landing_page)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by date,s.landing_page) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from session_details s join top_landing t on s.landing_page = t.landing_page
where date < current_date
and date > current_date - 121
UNION
--this query pulls the RPV based on landing page
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE RPV' METRIC
  ,'MEDIUM' tier
  ,1 POLARITY
  ,round(sum(order_amt) over (partition by date,s.landing_page)/nullif(sum(session_flag) over (partition by date,s.landing_page),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,count(*) over (partition by date,s.landing_page) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from session_details s join top_landing t on s.landing_page = t.landing_page
where date < current_date
and date > current_date - 121
UNION
--query pulls % sessions hitting that particular page
select distinct p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'pct_traffic_visting' METRIC
  ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
  ,pct_sessions_pageview amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from pv_details p join top_pages tp on tp.page = p.page
where p.date > current_date - 121
and p.date < current_date
UNION
--query pulls exit rate by top pages
select distinct p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'EXIT RATE BY PAGE' METRIC
  ,'FINE' DETAIL_LEVEL
  ,-1 POLARITY
  ,exit_rate amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from pv_details p join top_pages tp on tp.page = p.page
where p.date > current_date - 121
and p.date < current_date
UNION
--query pulls conversion rate by top pages (will exceed site-wide conversion at 3 pageviews can all reflect the same conversion)
select distinct p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'QCVR RATE BY PAGE' METRIC
  ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
  ,conversion_rate amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from pv_details p join top_pages tp on tp.page = p.page
where p.date > current_date - 121
and p.date < current_date
UNION
--query pulls revenue per page visit (will exceed total as it is attributing conversions across every page the converter touches
select p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'RPV BY PAGE' METRIC
  ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
  ,rev_per_pv amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from pv_details p join top_pages tp on tp.page = p.page
where p.date > current_date - 121
and p.date < current_date
UNION
--query pulls sessions by device type
select distinct date
  ,'WEB' bus_unit
  ,device_type DIMENSIONS
  ,'SESSIONS BY DEVICE' METRIC
  ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
  ,sum(session_flag) over (partition by date, device_type) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,sum(session_flag) over (partition by date, device_type) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details
where date < current_date
and date > current_date - 121
UNION
--new vs repeat site visitors
select distinct date
  ,'WEB' bus_unit
  ,case when ret_visit_flag = 1 then 'RETURN VISIT' else 'FIRST VISIT' end DIMENSIONS
  ,'SESSION COUNT BY NEW/REPEAT' METRIC
  ,'HIGH LEVEL' DETAIL_LEVEL
  ,1 POLARITY
  ,sum(session_flag) over (partition by date, DIMENSIONS) amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details
where date < current_date
and date > current_date - 121
UNION
--sessions by referrer
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'SESSIONS BY REFERRER' METRIC
  ,'MEDIUM' DETAIL_LEVEL
  ,1 POLARITY
  ,sum(session_flag) over (partition by date, DIMENSIONS) Amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,sum(session_flag) over (partition by date, DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
from session_details s join top_referrers t on s.referrer = t.referrer
where date < current_date
and date > current_date - 121
UNION
--bounce by referrer
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'BOUNCE BY REFERRER' METRIC
  ,'MEDIUM' DETAIL_LEVEL
  ,-1 POLARITY
  ,round(sum(bounce_flag) over (partition by date,s.referrer)/sum(session_flag) over (partition by date,s.referrer),3) amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
from session_details s join top_referrers t on s.referrer = t.referrer
where date < current_date
and date > current_date - 121
UNION
--this query returns the qualified conversion rate for the top referrer
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'REFERRER QCVR' METRIC
  ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
  ,round(sum(conv_flag) over (partition by date,s.referrer)/nullif((sum(session_flag) over (partition by date,s.referrer)-sum(bounce_flag) over (partition by date,s.referrer)),0),3) amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
from session_details s join top_referrers t on s.referrer = t.referrer
where date < current_date
and date > current_date - 121
UNION
--this query pulls the RPV based on referrer
select distinct date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'REFERRER RPV' METRIC
  ,'FINE' DETAIL_LEVEL
  ,1 POLARITY
  ,round(sum(conv_flag) over (partition by date,s.referrer)/nullif((sum(session_flag) over (partition by date,s.referrer)-sum(bounce_flag) over (partition by date,s.referrer)),0),3) amount
  ,'MINIMUM RPV' HURDLE_DESCRIPTION
  ,1 SIG_HURDLE
  ,round(sum(conv_flag) over (partition by date,s.referrer)/nullif((sum(session_flag) over (partition by date,s.referrer)-sum(bounce_flag) over (partition by date,s.referrer)),0),3) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
from session_details s join top_referrers t on s.referrer = t.referrer
where date < current_date
and date > current_date - 121)

,
MEDIANS as
(select distinct date
            ,bus_unit
            ,DIMENSIONS
            ,METRIC
            ,DETAIL_LEVEL
            ,AMOUNT
            ,abs(amount - median(amount) over (partition by DIMENSIONS||metric)) diff_median
            ,median(amount) over (partition by DIMENSIONS||metric) median
      ,POLARITY
      ,HURDLE_DESCRIPTION
      ,SIG_HURDLE
      ,HURDLE_VALUE
      ,METRIC_WITHIN_DIMENSIONS
from MAIN_QUERY)

--******// THE MAGIC //*****
select date
        ,bus_unit
        ,DIMENSIONS
        ,METRIC
        ,DETAIL_LEVEL
        ,amount
        ,median
        ,median-1.5*(median(diff_median) over (partition by dimensions||metric)) neg_one_SD
        ,median-3*(median(diff_median) over (partition by dimensions||metric)) neg_two_SD
        ,median+1.5*(median(diff_median) over (partition by dimensions||metric)) plus_one_SD
        ,median+3*(median(diff_median) over (partition by dimensions||metric)) plus_two_SD
        ,lead(amount,1,0) over (partition by dimensions||metric order by date desc) one_day_ago
        ,lead(amount,2,0) over (partition by dimensions||metric order by date desc) two_days_ago
        ,case
            when amount > plus_two_SD then '2 SD above median'
            when amount < neg_two_SD then '2 SD below median'
            when amount > plus_one_SD AND one_day_ago > plus_one_SD AND two_days_ago > plus_one_SD then 'Trending above SD'
            when amount < neg_one_SD  AND one_day_ago < neg_one_SD  AND two_days_ago < neg_one_SD  then 'Trending below SD'
            else null
        end alert
    ,HURDLE_DESCRIPTION
    ,sig_hurdle
    ,METRIC_WITHIN_DIMENSIONS
    ,case when hurdle_value > sig_hurdle then 1 else 0 end sig_flag
    ,case when (amount-median)*polarity > 0 then 'GOOD' else 'BAD' end pos_neg_flag
from medians
       ;;
   }
  dimension: metric_within_dimensions {
    description: "This field counts up unique metrics by dimension and is used to create the dynamic dashboards"
    label: "Metric count"
    type: string
    sql: ${TABLE}.metric_within_dimensions ;;
  }

  dimension: hurdle_description {
    description: "This is what is being measured to determine if the result is practically significant"
    label: "Hurdle metric"
    type: string
    sql: ${TABLE}.hurdle_description ;;
  }

  dimension: hurdle_amt {
    description: "This is the minimum threshold for the result to be practically significant"
    label: "Hurdle amount"
    sql: ${TABLE}.sig_hurdle ;;
  }

  dimension: date {
    description: "Date"
    label: "   Date"
    type: date
    sql: ${TABLE}.date ;;
   }

  dimension: bus_unit {
    description: "Business unit responsible for metric"
    label: "  Business Unit"
    type: string
    sql: ${TABLE}.bus_unit ;;
  }
  dimension: dimensions {
    description: "Grouping within metrics"
    label: " Dimensions"
    type: string
    sql: ${TABLE}.dimensions ;;
  }
  dimension: metric {
    description: "What is being measured"
    label: " Metric"
    type: string
    sql: ${TABLE}.metric ;;
  }

  dimension: met_dim {
    description: "Metric||Dimension combined into a single field"
    label: "  Metric||Dimension"
    type: string
    sql: ${metric}||'||'||${dimensions} ;;
    link: {
      label: "Show trend chart"
      url: "https://purple.looker.com/looks/4647?f[alert_testing.met_dim]={{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com" }
  }

  dimension: detail_level {
    description: "  Detail level of metric"
    type: string
    sql: ${TABLE}.detail_level ;;
  }

  dimension: alert {
    description: "  Is metric outside statistical norms?"
    type: string
    sql: ${TABLE}.alert ;;
  }

  dimension: sig_flag {
    description: "Is this practically signficant"
    label: "Practically sig?"
    type: yesno
    sql: ${TABLE}.sig_flag=1 ;;
  }

  dimension: pos_neg_flag {
    description: "Is the change from normal levels in a good or bad direction"
    label: "Good/Bad direction"
    type: string
    sql: ${TABLE}.pos_neg_flag ;;
  }

  measure: amount {
     description: "Value for selected metric"
     type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
     sql: ${TABLE}.amount ;;
   }

  measure: median {
    description: "120-day median value for selected metric"
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    type: sum
    sql: ${TABLE}.median ;;
  }
  measure: neg_one_SD {
    description: "1 SD equivalent below median (for control charts)"
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    type: sum
    sql: ${TABLE}.neg_one_SD ;;
  }
  measure: neg_two_SD {
    description: "2 SD equivalent below median (for control charts)"
    type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    sql: ${TABLE}.neg_two_SD ;;
  }
  measure: plus_one_SD {
    description: "1 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    sql: ${TABLE}.plus_one_SD ;;
  }
  measure: plus_two_SD {
    description: "2 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    sql: ${TABLE}.plus_two_SD ;;
  }
  measure: one_day_ago {
    hidden: yes
    description: "Yesterday's value for selected metric"
    type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    sql: ${TABLE}.one_day_ago ;;
  }
  measure: two_days_ago {
    hidden: yes
    description: "2 days ago value for selected metric"
    type: sum
    value_format: "[<0]0;[<1]0.0%;[<5]0.00;[>=1]#,##0"
    sql: ${TABLE}.two_days_ago ;;
  }



}
