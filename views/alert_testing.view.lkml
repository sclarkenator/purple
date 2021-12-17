view: alert_testing {

 derived_table: {
     persist_for: "24 hours"
    sql:
WITH session_details AS
--this SELECT gets all the session-level metrics aggregated by date WITH all the separate categories to PARTITION BY later
(SELECT
 s.session_id
 ,to_date(s.date_time) date
 ,s.source
 ,s.medium
 ,s.landing_page
 ,s.platform
 ,s.device_Type
 ,s.browser
 ,s.region
 ,s.country
 ,CASE WHEN referrer ilike '%purple.com%' THEN  'purple.com' WHEN referrer ilike '%purple.narvar.com%' THEN  'purple.narvar.com' WHEN referrer ilike '%pinterest.com%' THEN  'pinterest.com' ELSE SPLIT_PART(ltrim(ltrim(SPLIT_PART(rtrim(referrer,'/'),'//',2),'www.'),'l.'),'/',1) END referrer
 ,CASE WHEN utm_medium = 'sr' OR utm_medium = 'search' OR utm_medium = 'cpc' THEN  'search' WHEN utm_medium = 'so' OR utm_medium ilike '%social%' OR referrer ilike '%fb%' OR referrer ilike '%facebo%' OR referrer ilike '%insta%' OR referrer ilike '%l%nk%din%' OR referrer ilike '%pinteres%' OR referrer ilike '%snapch%' THEN  'social' WHEN utm_medium ilike 'vi' OR utm_medium ilike 'video' OR referrer ilike '%y%tube%' THEN  'video' WHEN utm_medium ilike 'nt' OR utm_medium ilike 'native' THEN  'native' WHEN utm_medium ilike 'ds' OR utm_medium ilike 'display' OR referrer ilike '%outbrain%' OR referrer ilike '%doubleclick%' OR referrer ilike '%googlesyndica%' THEN  'display' WHEN utm_medium ilike 'sh' OR utm_medium ilike 'shopping' THEN  'shopping' WHEN utm_medium ilike 'af' OR utm_medium ilike 'ir' OR utm_medium ilike '%affiliate%' THEN  'affiliate'   WHEN utm_medium ilike 'em' OR utm_medium ilike 'email' OR referrer ilike '%mail.%' OR referrer ilike '%outlook.live%' THEN  'email' WHEN utm_medium is null AND (referrer ilike '%google%' OR referrer ilike '%bing%' OR referrer ilike '%yahoo%' OR referrer ilike '%ASk%' OR referrer ilike '%aol%' OR referrer ilike '%msn%' OR referrer ilike '%endex%' OR referrer ilike '%duckduck%') THEN  'organic' WHEN utm_medium ilike 'rf' OR utm_medium ilike 'referral' OR utm_medium ilike '%partner platfo%' OR lower(referrer) not like '%purple%' THEN  'referral' WHEN (referrer ilike '%purple%' AND utm_medium is null) OR referrer is null THEN  'direct' ELSE 'undefined' END channel
 ,pv.pages
 ,1 session_flag
 ,SUM(session_flag) OVER (PARTITION BY date_time) total_sessions
 ,CASE WHEN pv.pages < 2 THEN  1 ELSE 0 END bounce_flag
 ,sn.session_num
 ,CASE WHEN sn.session_num > 1 THEN  1 ELSE 0 END ret_visit_flag
 ,NVL(p.order_amt, 0) order_amt
 ,CASE WHEN p.order_amt is null THEN  0 ELSE 1 END conv_flag
 ,conversions
 FROM datagrid.prod.web_session s
 LEFT JOIN
    (SELECT
     session_id
     ,SUM (shopify_amt) order_amt
     ,COUNT(*) conversions
     FROM analytics.marketing.ecommerce
     WHERE to_date(session_time) > CURRENT_DATE -121
     AND to_date(session_time) < CURRENT_DATE
     AND diff <6000
     GROUP BY 1
    )p ON s.session_id = p.session_id
 LEFT JOIN
    (SELECT
     DISTINCT session_id
     ,total_page_views AS pages
     FROM datagrid.prod.web_session
     WHERE to_date(date_time) > CURRENT_DATE -121
     AND to_date(date_time) < CURRENT_DATE
    )pv ON pv.session_id = s.session_id
 LEFT JOIN
    (SELECT
     DISTINCT session_id
     ,session_sequence AS session_num
     FROM datagrid.prod.web_session
     WHERE to_date(date_time) > CURRENT_DATE -121
     AND to_date(date_time) < CURRENT_DATE
    )sn ON sn.session_id = s.session_id
 WHERE to_date(s.date_time) > CURRENT_DATE -121
 AND to_date(s.date_time) < CURRENT_DATE
)

,tot_sessions AS
(
  SELECT
  DISTINCT date
  ,total_sessions
  FROM session_details
)

,pageviews AS
--this SELECT captures the pageviews
(
  SELECT
  DISTINCT to_date(session_time) date
  ,session_id
  ,CASE WHEN path ilike '%/10304151/checkouts%' THEN  '/checkout' ELSE rtrim(path,'/') END page
  ,rank() OVER (PARTITION BY session_id ORDER BY  time) page_sequence
  ,COUNT(*) OVER (PARTITION BY session_id) session_pages
  ,CASE WHEN MAX(time) OVER (PARTITION BY session_id) = time THEN  1 ELSE 0 END exit_flag
  ,page_sequence||' of '||session_pages page_of_session
  FROM heap_data.purple.pageviews
  WHERE to_date(time) > CURRENT_DATE -121
  AND to_date(time) < CURRENT_DATE
)

,top_pages AS
(
  SELECT page,
  views
  FROM
    (SELECT page
        ,COUNT(*) views
    FROM pageviews
    WHERE date > CURRENT_DATE -8
    GROUP BY 1)
  QUALIFY RANK() OVER (ORDER BY views DESC) <51
)

,top_referrers AS
(
  SELECT referrer
  FROM
    (SELECT referrer
        ,COUNT(*) sessions
    FROM session_details
    WHERE date > CURRENT_DATE -8
    GROUP BY 1)
QUALIFY RANK() OVER (ORDER BY  sessions DESC) <31
)

,top_landing AS
(
  SELECT landing_page
  FROM
    (SELECT landing_page
        ,COUNT(*) sessions
    FROM session_details
    WHERE date > CURRENT_DATE -8
    GROUP BY 1)
  QUALIFY RANK() OVER (ORDER BY  sessions DESC) <31
)

,top_source AS
(
  SELECT source
  FROM
    (SELECT source
        ,COUNT(*) sessions
    FROM session_details
    WHERE date > CURRENT_DATE -8
   GROUP BY 1)
  QUALIFY RANK() OVER (ORDER BY  sessions DESC) <21
)

,top_medium AS
(
  SELECT medium
  FROM
    (SELECT medium
        ,COUNT(*) sessions
    FROM session_details
    WHERE date > CURRENT_DATE -8
    GROUP BY 1)
  QUALIFY RANK() OVER (ORDER BY  sessions desc) <16
)

,top_browser AS
(
  SELECT browser
  FROM
    (SELECT SPLIT_PART(browser,'.',0) browser
        ,COUNT(*) sessions
    FROM session_details
    WHERE date > CURRENT_DATE -8
    GROUP BY 1)
  QUALIFY RANK() OVER (ORDER BY  sessions DESC) <21
)

--this CTE gets all the pageview level information FROM the prio CTE's
,pv_details AS (
SELECT
  DISTINCT p.date
  ,p.page
  ,COUNT(*) OVER (PARTITION BY p.date, p.page) pageviews
  ,SUM (exit_flag) OVER (PARTITION BY p.date, p.page) exits
  ,SUM (conv_flag) OVER (PARTITION BY p.date, p.page) conversions
  ,SUM (NVL(s.order_amt, 0)) OVER (PARTITION BY p.date, p.page) revenue
  ,ROUND(exits/pageviews, 3) exit_rate
  ,ROUND(conversions/pageviews, 3) conversion_rate
  ,ROUND(pageviews/ts.total_sessions, 3) pct_sessions_pageview
  ,ROUND(revenue/pageviews, 2) rev_per_pv
FROM pageviews p JOIN session_details s ON p.session_id = s.session_id
JOIN top_pages tp ON p.page = tp.page
JOIN tot_sessions ts ON p.date = ts.date
ORDER BY 2, 1
)

--this CTE gets all the order level information for DTC Webiste
,dtc_sales AS
(
  SELECT
  order_date date
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  1 ELSE 0 END) matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  gross_amt ELSE 0 END) matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  items_ordered ELSE 0 END) matt_ord_units
  ,ROUND (matt_ord_vol/matt_ord, 0) AMOV
  ,ROUND (matt_ord_units/matt_ord, 2) M_UPT
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  1 ELSE 0 END) non_matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  gross_amt ELSE 0 END) non_matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 0 THEN  items_ordered ELSE 0 END) non_matt_ord_units
  ,ROUND (non_matt_ord_vol/non_matt_ord, 0) NAMOV
  ,ROUND (non_matt_ord_units/non_matt_ord, 2) ACC_UPT
  ,SUM (CASE WHEN zero$order_flag = 1 THEN  1 ELSE 0 END) zero$_ORder
  FROM
    (SELECT
     so.order_date
     ,so.order_id
     ,so.order_value as gross_amt
     ,SUM (CASE WHEN so.order_value = 0 THEN 0 ELSE so.quantity END) items_ordered
     ,SUM (CASE WHEN p.category = 'MATTRESS' AND p.classification_group = 'Finished Good' THEN  1 ELSE 0 END) mattress_flg
     ,SUM (CASE WHEN so.order_value = 0 THEN  1 ELSE 0 END) zero$order_flag
     FROM datagrid.prod.sales_order so
     JOIN datagrid.prod.product p ON so.item_id = p.item_id
     WHERE order_date > CURRENT_DATE -121
      AND order_date < CURRENT_DATE
      AND so.channel = 'DTC' AND so.sub_channel = 'Website'
    GROUP BY 1, 2, 3)
  GROUP BY 1
)

--this CTE gets all the order level information for Contact center
,contact_center_sales AS
(
  SELECT
  order_date date
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  1 ELSE 0 END) matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  gross_amt ELSE 0 END) matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  items_ordered ELSE 0 END) matt_ord_units
  ,ROUND (matt_ord_vol/matt_ord, 0) AMOV
  ,ROUND (matt_ord_units/matt_ord, 2) M_UPT
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  1 ELSE 0 END) non_matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  gross_amt ELSE 0 END) non_matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 0 THEN  items_ordered ELSE 0 END) non_matt_ord_units
  ,ROUND (non_matt_ord_vol/non_matt_ord, 0) NAMOV
  ,ROUND (non_matt_ord_units/non_matt_ord, 2) ACC_UPT
  ,SUM (CASE WHEN zero$order_flag = 1 THEN  1 ELSE 0 END) zero$_ORder
  FROM
    (SELECT
     so.order_date
     ,so.order_id
     ,so.order_value as gross_amt
     ,SUM (CASE WHEN so.order_value = 0 THEN 0 ELSE so.quantity END) items_ordered
     ,SUM (CASE WHEN p.category = 'MATTRESS' AND p.classification_group = 'Finished Good' THEN  1 ELSE 0 END) mattress_flg
     ,SUM (CASE WHEN so.order_value = 0 THEN  1 ELSE 0 END) zero$order_flag
     FROM datagrid.prod.sales_order so
     JOIN datagrid.prod.product p ON so.item_id = p.item_id
     WHERE order_date > CURRENT_DATE -121
     AND order_date < CURRENT_DATE
     AND so.channel = 'DTC' AND so.sub_channel = 'Contact Center'
     GROUP BY 1, 2, 3)
  GROUP BY 1
)

--this CTE gets all the order level information for Amazon Merchant
,amazon_sales AS
(
  SELECT
  order_date date
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  1 ELSE 0 END) matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  gross_amt ELSE 0 END) matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 1 THEN  items_ordered ELSE 0 END) matt_ord_units
  ,ROUND (matt_ord_vol/matt_ord, 0) AMOV
  ,ROUND (matt_ord_units/matt_ord, 2) M_UPT
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  1 ELSE 0 END) non_matt_ord
  ,SUM (CASE WHEN zero$order_flag = 0 AND mattress_flg = 0 THEN  gross_amt ELSE 0 END) non_matt_ord_vol
  ,SUM (CASE WHEN zero$order_flag = 0 AND Mattress_Flg = 0 THEN  items_ordered ELSE 0 END) non_matt_ord_units
  ,ROUND (non_matt_ord_vol/non_matt_ord, 0) NAMOV
  ,ROUND (non_matt_ord_units/non_matt_ord, 2) ACC_UPT
  ,SUM (CASE WHEN zero$order_flag = 1 THEN  1 ELSE 0 END) zero$_ORder
  FROM
    (SELECT so.order_date
     ,so.order_id
     ,so.order_value as gross_amt
     ,SUM (CASE WHEN so.order_value = 0 THEN 0 ELSE so.quantity END) items_ordered
     ,SUM (CASE WHEN p.category = 'MATTRESS' AND p.classification_group = 'Finished Good' THEN  1 ELSE 0 END) mattress_flg
     ,SUM (CASE WHEN so.order_value = 0 THEN  1 ELSE 0 END) zero$order_flag
     FROM datagrid.prod.sales_order so
     JOIN datagrid.prod.product p ON so.item_id = p.item_id
     WHERE order_date > CURRENT_DATE -121
     AND order_date < CURRENT_DATE
     AND so.channel = 'DTC' AND so.sub_channel = 'Merchant'
     GROUP BY 1, 2, 3)
  GROUP BY 1
)

,add_to_cart AS
(
  SELECT
  user_id,
  session_id,
  time
  FROM heap_data.purple.all_events e
  WHERE event_table_name IN ('cart_add_to_cart')
  AND to_date(time) > CURRENT_DATE -121
  AND to_date(time) < CURRENT_DATE
 )

--this is the main select that combines all the single-metric fact queries FROM the previous CTEs or raw tables. simply union another select on to add another category of metrics
--schema is date-> bus_unit -> dimensions --> metric (this is the partition by in most queries) -> category (description of metric) -> tier(detail level) (H/M/L for reporting suppression) -> amount

,
main_query AS
(
//--this pulls sesisons COUNT for the top 20 UTM_SOURCE by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.source DIMENSIONS
  ,'SESSIONS BY SOURCE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY s.date, s.source) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.source) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_source ts ON s.source = ts.source
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls bounce rate for the top 20 UTM_SOURCE by sessions FROM Heap
SELECT
   DISTINCT s.date
  ,'WEB' bus_unit
  ,s.source DIMENSIONS
  ,'BOUNCE BY SOURCE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,-1 POLARITY
  ,ROUND(SUM(bounce_flag) OVER (PARTITION BY date,DIMENSIONS)/SUM(session_flag) OVER (PARTITION BY date,DIMENSIONS), 3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.source) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_source ts ON s.source = ts.source
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls QCVR for the top 20 UTM_SOURCE by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.source DIMENSIONS
  ,'QCVR BY SOURCE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date, DIMENSIONS)/ NULLIF((SUM(session_flag) OVER (PARTITION BY date,DIMENSIONS)- SUM(bounce_flag) OVER (PARTITION BY date,DIMENSIONS)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.source) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_source ts on s.source = ts.source
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls RPV for the top 20 UTM_SOURCE by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.source DIMENSIONS
  ,'RPV BY SOURCE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(order_amt) OVER (PARTITION BY date, DIMENSIONS) / NULLIF(SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.source) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_source ts ON s.source = ts.source
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls sesisons COUNT for the top 20 CHANNEL by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.channel DIMENSIONS
  ,'SESSIONS BY CHANNEL' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY s.date, s.channel) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.channel) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls bounce rate for the top 20 CHANNEL by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.channel DIMENSIONS
  ,'BOUNCE BY CHANNEL' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,-1 POLARITY
  ,ROUND(SUM(bounce_flag) OVER (PARTITION BY date, DIMENSIONS) / SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.channel) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM session_details s
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls QCVR for the top 20 CHANNEL by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.channel DIMENSIONS
  ,'QCVR BY CHANNEL' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date,DIMENSIONS) / NULLIF((SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) - SUM(bounce_flag) OVER (PARTITION BY date,DIMENSIONS)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.channel) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM session_details s
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this pulls RPV for the top 20 CHANNEL by sessions FROM Heap
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.channel DIMENSIONS
  ,'RPV BY CHANNEL' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(order_amt) OVER (PARTITION BY date, DIMENSIONS) / NULLIF(SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.channel) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM session_details s
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
---top 30 landing pages||channels
SELECT
  DISTINCT s.date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page||'||'||s.channel DIMENSIONS
  ,'SESSIONS BY LANDING PAGE||CHANNEL' METRIC
  ,'TIER 4' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page, s.channel) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,500 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page, s.channel) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--pulls bounce rate of top 'N' landing page||channel
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page||'||'||s.channel DIMENSIONS
  ,'LANDING PAGE||CHANNEL BOUNCE' METRIC
  ,'TIER 4' DETAIL_LEVEL
  ,-1 POLARITY
  ,ROUND(SUM(bounce_flag) OVER (PARTITION BY date, s.landing_page, s.channel)/ SUM(session_flag) OVER (PARTITION BY date, s.landing_page, s.channel), 3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,500 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page, s.channel) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this query returns the qualified conversion rate for the top landing page||channel
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page||'||'||s.channel DIMENSIONS
  ,'LANDING PAGE||CHANNEL QCVR' METRIC
  ,'TIER 4' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date, s.landing_page, s.channel) / NULLIF((SUM(session_flag) OVER (PARTITION BY date, s.landing_page, s.channel) - SUM(bounce_flag) OVER (PARTITION BY date, s.landing_page, s.channel)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,500 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date,s.landing_page,s.channel) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
--this query pulls the RPV based on landing page||channel
SELECT DISTINCT date
  ,'ACQUISITIONS' bus_unit
    ,s.landing_page||'||'||s.channel DIMENSIONS
  ,'LANDING PAGE||CHANNEL RPV' METRIC
  ,'TIER 4' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(order_amt) OVER (PARTITION BY date,s.landing_page,s.channel) / NULLIF(SUM(session_flag) OVER (PARTITION BY date,s.landing_page,s.channel),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,500 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date,s.landing_page,s.channel) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
  --this query pulls sessions by state, limited to the top 50 regions in HEAP
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,s.region DIMENSIONS
  ,'SESSIONS BY STATE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY s.date, s.region) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY s.date, s.region) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN
    (SELECT region
    FROM
      (SELECT REGION
        ,COUNT(*) sessions
      FROM session_details
      WHERE date < CURRENT_DATE
      AND date > CURRENT_DATE -8
      AND COUNTry ilike '%united states%'
      GROUP BY 1)
      QUALIFY RANK() OVER (ORDER BY sessions DESC) <=50
    )s1 ON s1.region = s.region
WHERE date > CURRENT_DATE -121
AND date < CURRENT_DATE

UNION
---this query pulls the top 20 promo codes (determined FROM the past 7 days)
SELECT
  DISTINCT order_date date
  ,'DTC' bus_unit
  ,SPLIT_PART(promo_bucket,'-',0) DIMENSIONS
  ,'ORDERS W/ PROMO CODE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,-1 POLARITY
  ,COUNT(*) OVER (PARTITION BY order_date, DIMENSIONS) amount
  ,'MINIMUM ORDERS' HURDLE_DESCRIPTION
  ,10 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY order_date, DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM datagrid.prod.sales_order so
JOIN
  (SELECT promo
  FROM
    (SELECT
     SPLIT_PART(promo_bucket,'-',0) promo
     ,COUNT(*) orders
    FROM datagrid.prod.sales_order
    WHERE order_date < CURRENT_DATE
    AND order_date > CURRENT_DATE -8
    GROUP BY 1)
    QUALIFY RANK() OVER (ORDER BY orders DESC) <=20
  )s1 ON s1.promo = SPLIT_PART(so.promo_bucket,'-',0)
WHERE channel = 'DTC' AND sub_channel = 'Website'
AND order_date > CURRENT_DATE - 121
AND order_date < CURRENT_DATE

UNION
--this select calculates mattress attach rates for non-0 mattress orders
SELECT
  DISTINCT(TO_DATE(so.order_date)) date
  ,'DTC' bus_unit
  ,p.line||'|'||p.model_name  DIMENSIONS
  ,'MATTRESS_ATTACH_RATE' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) amount
  ,'MINIMUM MATTRESS ATTACH RATE' HURDLE_DESCRIPTION
  ,0.03 SIG_HURDLE
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM datagrid.prod.sales_order so
JOIN datagrid.prod.product p on so.item_id = p.item_id
JOIN
  (
    SELECT
    DISTINCT so.order_id
    FROM datagrid.prod.sales_order so
    JOIN datagrid.prod.product p on so.item_id = p.item_id
    WHERE p.category = 'MATTRESS'
      AND p.classification_group = 'Finished Good'
      AND so.order_date > CURRENT_DATE - 121
      AND so.order_date < CURRENT_DATE
      AND so.order_value > 0
      AND so.channel = 'DTC' AND sub_channel = 'Website'
  )sub ON sub.order_id = so.order_id


UNION
--this select calculates mattress attach rates for non-0 mattress orders for Contact center sales
SELECT
  DISTINCT(TO_DATE(so.order_date)) date
  ,'CONTACT CENTER' bus_unit
  ,p.line||'|'||p.model_name  DIMENSIONS
  ,'MATTRESS_ATTACH_RATE' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) amount
  ,'MINIMUM MATTRESS ATTACH RATE' HURDLE_DESCRIPTION
  ,0.03 SIG_HURDLE
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM datagrid.prod.sales_order so
JOIN datagrid.prod.product p on so.item_id = p.item_id
JOIN
  (
    SELECT
    DISTINCT so.order_id
    FROM datagrid.prod.sales_order so
    JOIN datagrid.prod.product p on so.item_id = p.item_id
    WHERE p.category = 'MATTRESS'
    AND p.classification_group = 'Finished Good'
    AND so.order_date > CURRENT_DATE - 121
    AND so.order_date < CURRENT_DATE
    AND so.order_value > 0
    AND so.channel = 'DTC' AND sub_channel = 'Contact Center'
  )sub ON sub.order_id = so.order_id


UNION
--this select calculates mattress attach rates for non-0 mattress orders for Amazon sales
SELECT
  DISTINCT(TO_DATE(so.order_date)) date
  ,'MERCHANT' bus_unit
  ,p.line||'|'||p.model_name  DIMENSIONS
  ,'MATTRESS_ATTACH_RATE' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) amount
  ,'MINIMUM MATTRESS ATTACH RATE' HURDLE_DESCRIPTION
  ,0.03 SIG_HURDLE
  ,ROUND(COUNT(DISTINCT so.order_id) OVER (PARTITION BY date, p.line||'|'||p.model_name) / COUNT(DISTINCT so.order_id) OVER (PARTITION BY date),4) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM datagrid.prod.sales_order so
JOIN datagrid.prod.product p on so.item_id = p.item_id
JOIN
  (
    SELECT
    DISTINCT so.order_id
    FROM datagrid.prod.sales_order so
    JOIN datagrid.prod.product p on so.item_id = p.item_id
    WHERE p.category = 'MATTRESS'
    AND p.classification_group = 'Finished Good'
    AND so.order_date > CURRENT_DATE - 121
    AND so.order_date < CURRENT_DATE
    AND so.order_value > 0
    AND so.channel = 'DTC' AND sub_channel = 'Merchant'
  )sub ON sub.order_id = so.order_id

--DTC Webiste related Order Metrics
UNION
SELECT
  date
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS ORDERS' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

UNION
SELECT
  date
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'AMOV' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,AMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

UNION
SELECT
  DATE
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,m_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

UNION
SELECT
  DATE
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY_ORDERS' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,non_matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

UNION
SELECT
  DATE
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'NAMOV' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,NAMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,5 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

UNION
SELECT
  DATE
  ,'DTC' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,acc_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,6 METRIC_WITHIN_DIMENSIONS
FROM dtc_sales

--DTC Contact Center related Order Metrics
UNION
SELECT
  date
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS ORDERS' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

UNION
SELECT
  date
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'AMOV' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,AMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

UNION
SELECT
  DATE
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,m_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

UNION
SELECT
  DATE
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY_ORDERS' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,non_matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

UNION
SELECT
  DATE
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'NAMOV' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,NAMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,5 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

UNION
SELECT
  DATE
  ,'CONTACT CENTER' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,acc_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,6 METRIC_WITHIN_DIMENSIONS
FROM contact_center_sales

--DTC Merchant related Order Metrics
UNION
SELECT
  date
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS ORDERS' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
SELECT
  date
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'AMOV' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,AMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
SELECT
  DATE
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'MATTRESS UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,m_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
SELECT
  DATE
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY_ORDERS' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,non_matt_ord amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
SELECT
  DATE
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'NAMOV' metric
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,NAMOV amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,5 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
SELECT
  DATE
  ,'MERCHANT' bus_unit
  ,'ORDER' DIMENSIONS
  ,'ACCESSORY UPT' metric
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,acc_UPT amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE
  ,0 HURDLE_VALUE
  ,6 METRIC_WITHIN_DIMENSIONS
FROM amazon_sales

UNION
--transactions by payment method
SELECT
  DISTINCT order_date date
  ,'WEB' bus_unit
  ,payment_method DIMENSIONS
  ,'ORDERS BY PAYMENT METHOD' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY date, payment_method) amount
  ,'MINIMUM ORDER COUNT' HURDLE_DESCRIPTION
  ,50 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date, payment_method) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM datagrid.prod.sales_order
WHERE channel = 'DTC'
AND date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
---top 20 browsers
SELECT
  DISTINCT s.date
  ,'WEB' bus_unit
  ,SPLIT_PART(s.browser,'.',0) DIMENSIONS
  ,'SESSIONS BY BROWSER' METRIC
  ,'TIER 4' tier
  ,1 POLARITY
  ,COUNT(*) OVER (PARTITION BY date,DIMENSIONS) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE --sessions within that browser
  ,COUNT(*) OVER (PARTITION BY date,DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_browser tb ON SPLIT_PART(s.browser,'.',0) = tb.browser
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
---top 30 landing pages
SELECT
  DISTINCT s.date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'SESSIONS BY LANDING PAGE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY --negative number good or bad, to be able to conditional format to red or green under alerts
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--pulls bounce rate of top 'N' landing pages
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE BOUNCE' METRIC
  ,'TIER 3' tier
  ,-1 POLARITY
  ,ROUND(SUM(bounce_flag) OVER (PARTITION BY date,s.landing_page) / SUM(session_flag) OVER (PARTITION BY date, s.landing_page),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date, s.landing_page) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--this query returns the qualified conversion rate for the top landing pages
SELECT DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE QCVR' METRIC
  ,'TIER 3' tier
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date,s.landing_page) / NULLIF((SUM(session_flag) OVER (PARTITION BY date, s.landing_page) - SUM(bounce_flag) OVER (PARTITION BY date,s.landing_page)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date,s.landing_page) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--this query pulls the RPV based on landing page
SELECT DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.landing_page DIMENSIONS
  ,'LANDING PAGE RPV' METRIC
  ,'TIER 3' tier
  ,1 POLARITY
  ,ROUND(SUM(order_amt) OVER (PARTITION BY date,s.landing_page) / NULLIF(SUM(session_flag) OVER (PARTITION BY date,s.landing_page),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(*) OVER (PARTITION BY date,s.landing_page) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_landing t ON s.landing_page = t.landing_page
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--query pulls % sessions hitting that particular page
SELECT
 DISTINCT p.date
 ,'WEB' bus_unit
 ,p.page DIMENSIONS
 ,'pct_traffic_visting' METRIC
 ,'TIER 3' DETAIL_LEVEL
 ,1 POLARITY
 ,pct_sessions_pageview amount
 ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
 ,1000 SIG_HURDLE
 ,p.pageviews HURDLE_VALUE
 ,1 METRIC_WITHIN_DIMENSIONS
FROM pv_details p
JOIN top_pages tp ON tp.page = p.page
WHERE p.date > CURRENT_DATE - 121
AND p.date < CURRENT_DATE

UNION
--query pulls exit rate by top pages
SELECT
  DISTINCT p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'EXIT RATE BY PAGE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,-1 POLARITY
  ,exit_rate amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM pv_details p
JOIN top_pages tp ON tp.page = p.page
WHERE p.date > CURRENT_DATE - 121
AND p.date < CURRENT_DATE

UNION
--query pulls conversion rate by top pages (will exceed site-wide conversion at 3 pageviews can all reflect the same conversion)
SELECT
  DISTINCT p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'QCVR RATE BY PAGE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,conversion_rate amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM pv_details p
JOIN top_pages tp ON tp.page = p.page
WHERE p.date > CURRENT_DATE - 121
AND p.date < CURRENT_DATE

UNION
--query pulls revenue per page visit (will exceed total as it is attributing conversions across every page the converter touches
select
  p.date
  ,'WEB' bus_unit
  ,p.page DIMENSIONS
  ,'RPV BY PAGE' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,rev_per_pv amount
  ,'MINIMUM PAGEVIEW COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,p.pageviews HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM pv_details p
JOIN top_pages tp ON tp.page = p.page
WHERE p.date > CURRENT_DATE - 121
AND p.date < CURRENT_DATE

UNION
--query pulls sessions by device type
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,device_type DIMENSIONS
  ,'SESSIONS BY DEVICE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,SUM(session_flag) OVER (PARTITION BY date, device_type) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,SUM(session_flag) OVER (PARTITION BY date, device_type) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--new vs repeat site visitors
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,CASE WHEN ret_visit_flag = 1 THEN 'RETURN VISIT' ELSE 'FIRST VISIT' END AS DIMENSIONS
  ,'SESSION COUNT BY NEW/REPEAT' METRIC
  ,'TIER 1' DETAIL_LEVEL
  ,1 POLARITY
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) amount
  ,'NONE' HURDLE_DESCRIPTION
  ,0 SIG_HURDLE -- we want to see if we see 0 visits
  ,0 HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--sessions by referrer
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'SESSIONS BY REFERRER' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_referrers t ON s.referrer = t.referrer
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--bounce by referrer
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'BOUNCE BY REFERRER' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,-1 POLARITY
  ,ROUND(SUM(bounce_flag) OVER (PARTITION BY date,s.referrer) / SUM(session_flag) OVER (PARTITION BY date, s.referrer),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) HURDLE_VALUE
  ,2 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_referrers t ON s.referrer = t.referrer
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--this query returns the qualified conversion rate for the top referrer
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'REFERRER QCVR' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date, s.referrer) / NULLIF((SUM(session_flag) OVER (PARTITION BY date, s.referrer) - SUM(bounce_flag) OVER (PARTITION BY date, s.referrer)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) HURDLE_VALUE
  ,3 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_referrers t ON s.referrer = t.referrer
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--this query pulls the RPV based on referrer
SELECT
  DISTINCT date
  ,'ACQUISITIONS' bus_unit
  ,s.referrer DIMENSIONS
  ,'REFERRER RPV' METRIC
  ,'TIER 3' DETAIL_LEVEL
  ,1 POLARITY
  ,ROUND(SUM(conv_flag) OVER (PARTITION BY date, s.referrer) / NULLIF((SUM(session_flag) OVER (PARTITION BY date,s.referrer) - SUM(bounce_flag) OVER (PARTITION BY date,s.referrer)),0),3) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,SUM(session_flag) OVER (PARTITION BY date, DIMENSIONS) HURDLE_VALUE
  ,4 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN top_referrers t ON s.referrer = t.referrer
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--query pulls add to cart by browser
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,browser DIMENSIONS
  ,'ADD TO CARTS BY BROWSER' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.browser) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.browser) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN add_to_cart ac ON s.session_id = ac.session_id
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--query pulls add to cart by device_type
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,device_type DIMENSIONS
  ,'ADD TO CARTS BY DEVICE TYPE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.device_type) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.device_type) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN add_to_cart ac ON s.session_id = ac.session_id
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--query pulls add to cart by referrers
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,referrer DIMENSIONS
  ,'ADD TO CARTS BY REFERRER' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.referrer) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.referrer) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN add_to_cart ac ON s.session_id = ac.session_id
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

UNION
--query pulls add to cart by landing pages
SELECT
  DISTINCT date
  ,'WEB' bus_unit
  ,landing_page DIMENSIONS
  ,'ADD TO CARTS BY LANDING PAGE' METRIC
  ,'TIER 2' DETAIL_LEVEL
  ,1 POLARITY
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.landing_page) amount
  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
  ,1000 SIG_HURDLE
  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.landing_page) HURDLE_VALUE
  ,1 METRIC_WITHIN_DIMENSIONS
FROM session_details s
JOIN add_to_cart ac ON s.session_id = ac.session_id
WHERE date > CURRENT_DATE - 121
AND date < CURRENT_DATE

//UNION
//--query pulls abandoned cart by device type
//SELECT
//  DISTINCT date
//  ,'WEB' bus_unit
//  ,device_type DIMENSIONS
//  ,'ABANDONED CARTS BY DEVICE TYPE' METRIC
//  ,'TIER 2' DETAIL_LEVEL
//  ,1 POLARITY
//  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.device_type) amount
//  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
//  ,1000 SIG_HURDLE
//  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.device_type) HURDLE_VALUE
//  ,1 METRIC_WITHIN_DIMENSIONS
//FROM session_details s
//JOIN abandoned_cart ac ON s.session_id = ac.session_id
//WHERE date > CURRENT_DATE - 121
//AND date < CURRENT_DATE

//UNION
//--query pulls add to cart by browser
//SELECT
//  DISTINCT date
//  ,'WEB' bus_unit
//  ,browser DIMENSIONS
//  ,'ADD TO CARTS BY BROWSER' METRIC
//  ,'TIER 2' DETAIL_LEVEL
//  ,1 POLARITY
//  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.browser) - COUNT(s.conversion) OVER (PARTITION BY s.date, s.browser) amount
//  ,'MINIMUM SESSION COUNT' HURDLE_DESCRIPTION
//  ,1000 SIG_HURDLE
//  ,COUNT(ac.session_id) OVER (PARTITION BY s.date, s.browser) HURDLE_VALUE
//  ,1 METRIC_WITHIN_DIMENSIONS
//FROM session_details s
//JOIN add_to_cart ac ON s.session_id = ac.session_id
//WHERE date > CURRENT_DATE - 121
//AND date < CURRENT_DATE

) --closing bracket for main query CTE

,
MEDIANS as
(select distinct date
            ,bus_unit
            ,DIMENSIONS
            ,METRIC
           ,DETAIL_LEVEL
            ,AMOUNT
            ,abs(amount - median(amount) over (partition by DIMENSIONS||metric||bus_unit)) diff_median
            ,median(amount) over (partition by DIMENSIONS||metric||bus_unit) median
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
        ,median-1.5*(median(diff_median) over (partition by dimensions||metric||bus_unit)) neg_one_SD
        ,median-3*(median(diff_median) over (partition by dimensions||metric||bus_unit)) neg_two_SD
        ,median+1.5*(median(diff_median) over (partition by dimensions||metric||bus_unit)) plus_one_SD
        ,median+3*(median(diff_median) over (partition by dimensions||metric||bus_unit)) plus_two_SD
        ,lead(amount,1,0) over (partition by dimensions||metric||bus_unit order by date desc) one_day_ago
        ,lead(amount,2,0) over (partition by dimensions||metric||bus_unit order by date desc) two_days_ago
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
    ,case when greatest(hurdle_value,median) >= sig_hurdle then 1 else 0 end sig_flag
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
    link: {
      label: "Show dimension dashboard"
      url: "https://purple.looker.com/dashboards/3836?Dimensions={{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com" }
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
    html: {% if pos_neg_flag._value == 'GOOD' %}
          <p style="color: black; background-color: #98FF98; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% else %}
          <p style="color: black; background-color: #F75D59; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% endif %}
    ;;
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
    html: {% if value == 'GOOD' %}
            <p style="color: black; background-color: green; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% else %}
            <p style="color: black; background-color: red; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% endif %}
          ;;

  }

  measure: amount {
    description: "Value for selected metric"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.amount ;;
   }

  measure: median {
    description: "120-day median value for selected metric"
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    type: sum
    sql: ${TABLE}.median ;;
  }
  measure: neg_one_SD {
    description: "1 SD equivalent below median (for control charts)"
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    type: sum
    sql: ${TABLE}.neg_one_SD ;;
  }
  measure: neg_two_SD {
    description: "2 SD equivalent below median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.neg_two_SD ;;
  }
  measure: plus_one_SD {
    description: "1 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.plus_one_SD ;;
  }
  measure: plus_two_SD {
    description: "2 SD equivalent above median (for control charts)"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.plus_two_SD ;;
  }
  measure: one_day_ago {
    hidden: yes
    description: "Yesterday's value for selected metric"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.one_day_ago ;;
  }
  measure: two_days_ago {
    hidden: yes
    description: "2 days ago value for selected metric"
    type: sum
    value_format: "[<1]0.0%;[<5]0.00;#,##0"
    sql: ${TABLE}.two_days_ago ;;
  }



}
