#-------------------------------------------------------------------
# Owner - Scott Clark
# Bucketing touches from marketing channel through Heap
#-------------------------------------------------------------------

view: attribution {
  derived_table: {
    sql: select purch_date
      ,medium
      ,referrer
      ,sum(nvl(first_touch,0)) first_touch
      ,sum(nvl(last_touch,0)) last_touch
      ,sum(nvl(all_touch,0)) all_touch
    from (
    select p.user_id
      , p.session_id purch_session
      , to_date(convert_timezone('America/Denver',purch_time)) purch_date
      , LTV
      , s.session_id
      , to_date(convert_timezone('America/Denver',s.time)) session_date
      , case when lower(s.referrer) like '%purple.com%' then 'PURPLE'
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
        else 'OTHER' end referrer
      , case when lower(s.UTM_source) like '%youtub%' then 'YOUTUBE'
        when s.UTM_medium like '%native%' then 'NATIVE'
        when upper(s.UTM_medium) like 'REFERRAL' then 'IR' else upper(s.UTM_medium) end medium
      , count(*) over (partition by s.user_id) sessions
      , row_number() over (partition by s.user_id order by s.time) session_number
      , case when row_number() over (partition by s.user_id order by s.time) = 1 then LTV else null end first_touch
      , case when p.session_id = s.session_id then LTV else null end last_touch
      , round(LTV/sessions,0) all_touch
      from (
        select user_id
          ,session_id
          ,time purch_time
          ,LTV
        from (
            select user_id
            ,row_number() over (partition by user_id order by time) order_number
            ,session_id
            ,time
            ,dollars
            ,sum(dollars) over (partition by user_id) LTV
          from heap.purchase
          order by 1,6
        )
        where order_number = 1
      ) p
      left join heap.sessions s on p.user_id = s.user_id and s.time <= p.purch_time
      order by 1,10
    )
    group by 1,2,3  ;; }

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

  dimension: medium {
    label: "UTM Medium"
    description: "UTM medium for any given session"
    type: string
    sql: ${TABLE}.medium ;; }

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

}
