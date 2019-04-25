#-------------------------------------------------------------------
# Owner - Scott Clark
# Daily Ad Spend
#-------------------------------------------------------------------

view: daily_adspend {
  sql_table_name: marketing.adspend ;;

  dimension: ad_date_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}.ad_id||'-'||${TABLE}.date;; }

  dimension_group: ad {
    label: "Ad"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;; }

  dimension: MTD_flg{
    label: "MTD Flag"
    description: "This field is for formatting on MTD (month to date) reports"
    type: yesno
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) and month(${TABLE}.date) = month(dateadd(day,-1,current_date)) and year(${TABLE}.date) = year(current_date) ;;  }

  dimension: last_30{
    label: "Last 30 Days"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.date > dateadd(day,-30,current_date);; }

  dimension: rolling_7day {
    label: "Rolling 7 Day Filter"
    description: "Yes = 7 most recent days ONLY"
    type: yesno
    sql: ${ad_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;  }

  measure: adspend {
    label: "Total Adspend ($)"
    description: "Total adspend for selected channels"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.spend ;;  }

  measure: avg_adspend {
    label: "Average Daily Spend"
    hidden:  yes
    description: "Hidden field to get average daily adspend for defined period"
    type: number
    sql: sum(${TABLE}.spend)/count(distinct(${ad_date})) ;;  }

  measure: impressions {
    label: "Total Impressions"
    description: "Total impressions for selected channels (online only)"
    type: sum
    sql: ${TABLE}.impressions ;; }

  measure: clicks {
    label: "Total Clicks"
    description: "Total clicks for selected channels (online only)"
    type: sum
    sql: ${TABLE}.clicks ;; }

  dimension: spend_platform {
    label: "Spend Platform"
    description: "What platform for spend (google, facebook, TV, etc.)"
    type:  string
    sql: ${TABLE}.platform ;; }

  dimension: Spend_platform_condensed {
    label: "Major Spend Platform"
    description: "What platform for spend, grouping smaller platforms into all other (Facebook,Google,TV,Amazon,Yahoo,Other)"
    type: string
    case: {
      when: {sql: ${TABLE}.platform = 'FACEBOOK' ;; label: "FACEBOOK" }
      when: {sql: ${TABLE}.platform = 'GOOGLE' ;; label: "GOOGLE"}
      when: {sql: ${TABLE}.platform = 'TV' ;; label: "TV" }
      when: {sql: ${TABLE}.platform = 'AMAZON MEDIA GROUP' ;;  label: "AMAZON" }
      when: {sql: ${TABLE}.platform = 'YAHOO' ;; label: "YAHOO" }
      else: "ALL OTHERS" } }

  dimension: ad_display_type {
    label: "Ad Display Type"
    description: "How ad was presented (Search, Display, Video, TV, etc.)"
    type:  string
    sql: ${TABLE}.source ;; }

  dimension: campaign_name {
    label: "Campaign Name"
    type:  string
    sql: ${TABLE}.campaign_name ;; }

  dimension: campaign_type {
    label: "Campaign Type"
    description: "Bucketing the Campaign type into Prospecting, Retargeting, Brand, and Other"
    type:  string
    case: {
      when: {sql:  ${TABLE}.campaign_type = 'BRAND' ;; label: "BRAND" }
      when: { sql:  ${TABLE}.campaign_type = 'PROSPECTING' ;;  label: "PROSPECTING" }
      when: { sql:  ${TABLE}.campaign_type = 'RETARGETING' ;;  label: "RETARGETING" }
      else: "OTHER" } }

  dimension: ad_device {
    label: "Ad Device"
    description: "What device was ad viewed on? (Mobile, Tablet, Desktop, Other)"
    type: string
    case: {
      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_SMARTPHONE','IPHONE','MOBILE DEVICES WITH FULL BROWSERS','SMARTPHONE') ;;
        label: "MOBILE" }
      when: { sql: upper(${TABLE}.device) in ('ANDROID_TABLET','IPAD','TABLETS WITH FULL BROWSERS','IPOD','TABLET') ;;
        label: "TABLET" }
      when: { sql: upper(${TABLE}.device) in ('COMPUTER','COMPUTERS','DESKTOP') ;;  label: "DESKTOP" }
      else: "OTHER"  } }

  dimension: platform_source_group {
    hidden:  no
    label:  "Platform Source Group"
    description: "Grouping of source, platform, and if the name has shop"
    type: string
    case: {
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.campaign_name) like '%shop%' ;; label: "Google-Shopping" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) = 'search network' ;; label: "Google-Search" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) = 'display network' ;; label: "Google-Display" }
      when: { sql: ${TABLE}.platform = 'GOOGLE' and lower(${TABLE}.SOURCE) like '%youtube%' ;; label: "Youtube" }
      when: { sql: ${TABLE}.platform = 'BING' ;; label: "BING" }
      when: { sql: ${TABLE}.platform = 'AMAZON MEDIA GROUP' ;; label: "Amazon Media Group" }
      when: { sql: ${TABLE}.platform = 'YAHOO' ;; label: "Verizon Media Group" }
      else: "Other" } }

}
