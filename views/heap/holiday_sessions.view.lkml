view: holiday_sessions {

   derived_table: {
     sql: select session_id
        ,utm_medium
        ,utm_source
        ,referrer
from heap_data.heap.sessions s
where s.time >= dateadd(d,-1,current_date)
       ;;
   }

  dimension: session_id {
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: referrer {
    hidden: yes
    label: " Referrer"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.referrer ;; }

  dimension: referrer_2 {
    group_label: "Session details"
    label: " Referrer (grouped)"
    description: "Source: looker calculation"
    type: string
    sql: case when ${TABLE}.referrer ilike ('%purple.com%') then 'https://purple.com/*'
          when ${TABLE}.referrer ilike ('%google.%') then 'https://google.com/*'
          when ${TABLE}.referrer ilike ('%facebook%') then 'https://facebook.com/*'
          when ${TABLE}.referrer ilike ('%youtube%') then 'https://youtube.com/*'
          when ${TABLE}.referrer ilike ('%msn.%') then 'https://msn.com/*'
          when ${TABLE}.referrer ilike ('%bing.%') then 'https://bing.com/*'
          when ${TABLE}.referrer ilike ('%yahoo.%') then 'https://yahoo.com/*'
          when ${TABLE}.referrer ilike ('%myslumberyard%') then 'https://myslumberyard.com/*'
          when ${TABLE}.referrer ilike ('%tuck%') then 'https://tuck.com/*'
          when ${TABLE}.referrer ilike ('%pinterest.%') then 'https://pinterest.com/*'
          when ${TABLE}.referrer ilike ('%affirm%') then 'https://affirm.com/*'
          when ${TABLE}.referrer ilike ('%sleepopolis%') then 'https://sleepopolis.com/*'
          when ${TABLE}.referrer ilike ('%mattressclarity%') then 'https://mattressclarity.com/*'
          when ${TABLE}.referrer ilike ('%narvar.%') then 'https://narvar.com/*'
          when ${TABLE}.referrer ilike ('%instagram%') then 'https://instagram.com/*'
          else left(${TABLE}.referrer,16)||'*' end ;; }

  dimension: utm_medium {
    group_label: "Session details"
    label: "UTM Medium"
    description: "Source: HEAP.sessions"
    type: string
    sql: lower(${TABLE}.utm_medium) ;; }

  dimension: channel {
    type: string
    group_label: "Session details"
    hidden:  no
    label: " Channel"
    description: "Channel that current session came from. Source: looker calculation"
    sql: case when ${utm_medium} = 'sr' or ${utm_medium} = 'search' or ${utm_medium} = 'cpc' /*or qsp.search = 1*/ then 'search'
          when ${utm_medium} = 'so' or ${utm_medium} ilike '%social%' or ${referrer} ilike '%fb%' or ${referrer} ilike '%facebo%' or ${referrer} ilike '%insta%' or ${referrer} ilike '%l%nk%din%' or ${referrer} ilike '%pinteres%' or ${referrer} ilike '%snapch%' then 'social'
          when ${utm_medium} ilike 'vi' or ${utm_medium} ilike 'video' or ${referrer} ilike '%y%tube%' then 'video'
          when ${utm_medium} ilike 'nt' or ${utm_medium} ilike 'native' then 'native'
          when ${utm_medium} ilike 'ds' or ${utm_medium} ilike 'display' or ${referrer} ilike '%outbrain%' or ${referrer} ilike '%doubleclick%' or ${referrer} ilike '%googlesyndica%' then 'display'
          when ${utm_medium} ilike 'sh' or ${utm_medium} ilike 'shopping' then 'shopping'
          when ${utm_medium} ilike 'af' or ${utm_medium} ilike 'ir' or ${utm_medium} ilike '%affiliate%' then 'affiliate'
          when ${utm_medium} ilike 'em' or ${utm_medium} ilike 'email' or ${referrer} ilike '%mail.%' or ${referrer} ilike '%outlook.live%' then 'email'
          when ${utm_medium} is null and (${referrer} ilike '%google%' or ${referrer} ilike '%bing%' or ${referrer} ilike '%yahoo%' or ${referrer} ilike '%ask%' or ${referrer} ilike '%aol%' or ${referrer} ilike '%msn%' or ${referrer} ilike '%yendex%' or ${referrer} ilike '%duckduck%') then 'organic'
          when ${utm_medium} ilike 'rf' or ${utm_medium} ilike 'referral' or ${utm_medium} ilike '%partner platfo%' or lower(${referrer}) not like '%purple%' then 'referral'
          when (${referrer} ilike '%purple%' and ${utm_medium} is null) or ${referrer} is null then 'direct' else 'undefined' end ;;
  }

  dimension: medium_bucket {
    label: "Medium"
    group_label: "Session details"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: case when ${utm_medium} in ('sr','search','cpc') then 'search'
          when ${utm_medium} = 'so' or ${utm_medium} ilike '%social%' or ${utm_medium} ilike '%facebook%' or ${utm_medium} ilike '%instagram%' or ${utm_medium} ilike 'twitter' then 'social'
          when ${utm_medium} = 'vi' or ${utm_medium} ilike 'video' or ${utm_source} = 'youtube' then 'video'
          when ${utm_medium} = 'af' or ${utm_medium} ilike 'affiliate' then 'affiliate'
          when ${utm_medium} = 'ds' or ${utm_medium} ilike 'display' then 'display'
          when ${utm_medium} = 'lc' then 'local'
          when ${utm_medium} = 'nt' or ${utm_medium} in ('native','nativeads') then 'native'
          when ${utm_medium} = 'rf' or ${utm_medium} ilike 'referral' then 'referral'
          when ${utm_medium} = 'sh'
          or ${utm_medium} = 'feed'
          or ${utm_medium} ilike '%shopping%' then 'pla'
           when ${utm_medium} = 'em' or ${utm_medium} ilike '%email%' then 'email'
          when ${utm_medium} in( 'sms', 'tx') then 'SMS'
          when ${utm_medium} in ('au','tv','podcast' ,'radio','cinema', 'print','linear') then 'traditional'
          else 'other' end ;;
  }

  dimension: utm_source {
    hidden: no
    group_label: "Session details"
    label: "UTM Source"
    description: "Source: HEAP.sessions"
    type: string
    sql: lower(${TABLE}.utm_source) ;; }

  dimension: source_bucket {
    label: "Source"
    group_label: "Session details"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: case when ${utm_source} ilike '%go%' or ${utm_source} ilike '%google%' or ${utm_source} ilike '%gco%'then 'GOOGLE'
              when ${utm_source} in ('ac') then 'ACUITY'
              when ${utm_source} in ('adme') then 'ADMEDIA'
              when ${utm_source} in ('adm') then 'ADMARKETPLACE'
              when ${utm_source} ilike '%bg%' then 'BING'
              when ${utm_source} in ('bra') then 'BRAVE'
              when ${utm_source} in ('co') then 'CORDLESS'
              when ${utm_source} in ('cn') then 'CONDE NASTE'
              when ${utm_source} in ('ex') then 'VDX'
              when ${utm_source} ilike '%fb%' or ${utm_source} ilike '%faceboo%'
              or ${utm_source} in ('instagram')  then 'FB/IG'
              when ${utm_source} in ('em') then 'Email'
              when ${utm_source} in ('findkeeplove') then 'fkl'
              when ${utm_source} ilike '%yahoo%' then 'YAHOO'
              when ${utm_source} ilike '%yt%' or ${utm_source} ilike '%youtube%' then 'YOUTUBE'
              when ${utm_source} ilike '%snapchat%' then 'SNAPCHAT'
              when ${utm_source} ilike '%adwords%' then 'ADWORDS'
              when ${utm_source} in ('pinterest', 'pt') then 'PINTEREST'
              when ${utm_source} in ('ir') then 'IMPACT RADIUS'
              when ${utm_source} in ('md') then 'MODUS'
              when ${utm_source} in ('nd') then 'NEXTDOOR'
              when ${utm_source} in ('om','tv') then 'OCEAN MEDIA'
              when ${utm_source} ilike '%ob%' then 'OUTBRAIN'
              when ${utm_source} ilike '%bing%' then 'BING'
              when ${utm_source} ilike '%gemini%' then 'YAHOO'
              when ${utm_source} ilike '%vrz%' or ${utm_source} ilike '%oa%' then 'VERIZON MEDIA'
              when ${utm_source} in ('rk') then 'RAKUTEN'
              when ${utm_source} in ('si') then 'SIMPLIFI'
              when ${utm_source} in ('sn') then 'SNAPCHAT'
              when ${utm_source} in ('sl') then 'SLICK'
              when ${utm_source} ilike '%tab%' then 'TABOOLA'
              when ${utm_source} in ('talkable','ta') then 'TALKABLE'
              when ${utm_source} in ('tk') then 'TIKTOK'
              when ${utm_source} ilike '%twitter%' then 'TWITTER'
              when ${utm_source} in ('vr') then 'VERITONE'
              when ${utm_source} in ('ye') then 'YELP'
              when ${utm_source} in ('wa') then 'WAZE'
              when ${utm_source} in ('ze', 'zeta') then 'ZETA'
              else 'OTHER' end ;;
  }

}
