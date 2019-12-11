#-------------------------------------------------------------------
# Owner - Scott Clark
# Bucketing touches from marketing channel through Heap
#-------------------------------------------------------------------

view: attribution {
  derived_table: {
    sql: select purch_date
        ,channel
        ,source
        ,referrer
        ,nvl(channel,'')||'|'||nvl(source,'') ch_so
        ,sum(nvl(first_touch,0)) first_touch
        ,sum(nvl(last_touch,0)) last_touch
        ,sum(nvl(all_touch,0)) all_touch
        from
        (select p.user_id
          ,p.session_id purch_session
          ,to_date(convert_timezone('America/Denver',purch_time)) purch_date
          ,LTV
          ,s.session_id
          ,to_date(convert_timezone('America/Denver',s.time)) session_date
          ,lower(
          case when lower(s.referrer) like '%purple.com%' then 'PURPLE'
          when lower(s.referrer) like '%goog%' then 'GOOGLE'
          when lower(s.referrer) like '%fb%' then 'FACEBOOK'
          when lower(s.referrer) like '%faceb%' then 'FACEBOOK'
          when lower(s.referrer) like '%yaho%' then 'YAHOO'
          when lower(s.referrer) like '%bing%' then 'BING'
          when lower(s.referrer) like '%instag%' then 'INSTAGRAM'
          when lower(s.referrer) like '%youtu%' then 'YOUTUBE'
          when lower(s.referrer) like '%aol%' then 'AOL'
          when lower(s.referrer) like '%sleepop%' then 'SLEEPOPOLIS'
          when lower(s.referrer) like '%pintere%' then 'PINTEREST'
          when lower(s.referrer) like '%huff%' then 'HUFFINGTON POST'
          when lower(s.referrer) like '%mattressf%' then 'MATTRESS FIRM'
          when lower(s.referrer) like '%outbrain%' then 'OUTBRAIN'
          when s.UTM_medium = 'IR' then 'AFFILIATE'
          when s.referrer is null then null
          else 'OTHER' end) referrer
          ,case when lower(s.utm_medium) = 'sr' or lower(s.utm_medium) = 'search' or lower(s.utm_medium) = 'cpc' or qsp.search = 1 then 'search'
          when lower(s.utm_medium) = 'so' or s.utm_medium ilike '%social%' or s.referrer ilike '%fb%' or s.referrer ilike '%facebo%' or s.referrer ilike '%insta%' or s.referrer ilike '%l%nk%din%' or s.referrer ilike '%pinteres%' or s.referrer ilike '%snapch%' then 'social'
          when s.utm_medium ilike 'vi' or s.utm_medium ilike 'video' or s.referrer ilike '%y%tube%' then 'video'
          when s.utm_medium ilike 'nt' or s.utm_medium ilike 'native' then 'native'
          when s.utm_medium ilike 'ds' or s.utm_medium ilike 'display' or s.referrer ilike '%outbrain%' or s.referrer ilike '%doubleclick%' or s.referrer ilike '%googlesyndica%' then 'display'
          when s.utm_medium ilike 'sh' or s.utm_medium ilike 'shopping' then 'shopping'
          when s.utm_medium ilike 'af' or s.utm_medium ilike 'ir' or s.utm_medium ilike '%affiliate%' then 'affiliate'
          when s.utm_medium ilike 'em' or s.utm_medium ilike 'email' or s.referrer ilike '%mail.%' or s.referrer ilike '%outlook.live%' then 'email'
          when s.utm_medium is null and (s.referrer ilike '%google%' or s.referrer ilike '%bing%' or s.referrer ilike '%yahoo%' or s.referrer ilike '%ask%' or s.referrer ilike '%aol%' or s.referrer ilike '%msn%' or s.referrer ilike '%yendex%' or s.referrer ilike '%duckduck%') then 'organic'
          when s.utm_medium ilike 'rf' or s.utm_medium ilike 'referral' or s.utm_medium ilike '%partner platfo%' or lower(referrer) not like '%purple%' then 'referral'
          when (s.referrer ilike '%purple%' and s.utm_medium is null) or s.referrer is null then 'direct' else 'undefined' end CHANNEL
          ,case when lower(s.UTM_source) like '%youtub%' then 'YOUTUBE'
          when s.UTM_medium like '%native%' then 'NATIVE'
          when upper(s.UTM_medium) like 'REFERRAL' then 'IR' else upper(s.UTM_medium) end medium
          ,case when length(s.utm_source) < 4 then us.marketing_source else s.utm_source end source
          ,count(*) over (partition by s.user_id) sessions
          ,row_number() over (partition by s.user_id order by s.time) session_number
          ,case when row_number() over (partition by s.user_id order by s.time) = 1 then LTV else null end first_touch
          ,case when p.session_id = s.session_id then LTV else null end last_touch
          ,round(LTV/sessions,0) all_touch
        from
            (select user_id
                    ,session_id
                    ,time purch_time
                    ,LTV
            from
              (select user_id
        ,row_number() over (partition by user_id order by time) order_number
        ,session_id
        ,time
        ,subtotal_price
        ,sum(subtotal_price) over (partition by user_id) LTV
from ANALYTICS.HEAP.CART_ORDERS_SHOPIFY_CONFIRMED_ORDER
order by 1,6)
            where order_number = 1) p
        left join heap.sessions s on p.user_id = s.user_id and s.time <= p.purch_time
        left join analytics.utm_lookup.UTM_SOURCE us on us.source_code = s.utm_source
        left join
          (select session_id
                  ,case when search > 0 then 1 else 0 end search
          from
            (select session_id
                    ,sum(case when query like '%gclid%' or query like '%msclkid%' then 1 else 0 end) search
            from heap.pageviews
            group by 1)
          ) QSP on s.session_id = qsp.session_id
      order by 1,10)
  group by 1,2,3,4,5  ;; }

  dimension_group: date {
    label: "Date"
    description:  "Purch Date from Heap"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.purch_date ;; }

  dimension: referrer {
    label: "Referrer site"
    description: "Referrer website for any given session"
    type: string
    sql: ${TABLE}.referrer ;; }

  dimension: channel {
    label: "UTM Medium"
    description: "UTM medium or channel for any given session"
    type: string
    sql: ${TABLE}.channel ;; }

  dimension: source {
    label: "UTM Source"
    description: "UTM source or channel for any given session"
    type: string
    sql: ${TABLE}.source ;; }

  dimension: ch_so {
    label: "Channel|Source"
    description: "Channel and source for any given session"
    type: string
    sql: ${TABLE}.ch_so ;; }

  measure: first_touch {
    label: "Total First Touch Revenue"
    description: "Attributable revenue based on first website session"
    type:  sum
    sql: ${TABLE}.first_touch ;; }

  measure: last_touch {
    label: "Total Last Touch Revenue"
    description: "Attributable revenue based on initial purchase session"
    type:  sum
    sql: ${TABLE}.last_touch ;; }

  measure: all_touch {
    label: "Total All Touch Revenue"
    description: "Attributable revenue spread across all unique sessions"
    type:  sum
    sql: ${TABLE}.all_touch ;;  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.date_date,${TABLE}.ch_so,${TABLE}.all_touch) ;;
  }

}
