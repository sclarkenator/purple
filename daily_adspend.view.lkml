view: daily_adspend {
  sql_table_name: marketing.adspend ;;

  dimension: ad_date_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}.ad_id||'-'||${TABLE}.date;;
  }

  dimension_group: ad {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
  }

  dimension: MTD_flg{
    description: "This field is for formatting on MTD reports"
    type: yesno
    sql: ${TABLE}.date <= dateadd(day,-1,current_date) and month(${TABLE}.date) = month(dateadd(day,-1,current_date)) and year(${TABLE}.date) = year(current_date) ;;
  }

  dimension: rolling_7day {
    description: "Filter to show just most recent 7 completed days"
    type: yesno
    sql: ${ad_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;
  }

  measure: adspend {
    description: "Total adspend for selected channels"
    type: sum
    value_format: "$#,##0,\" K\""
    sql: ${TABLE}.spend ;;
  }

  measure: avg_adspend {
    label: "Average daily spend"
    description: "Total adspend for selected channels"
    type: number
    sql: sum(${TABLE}.spend)/count(distinct(${ad_date})) ;;
  }

  measure: impressions {
    description: "Total impressions for selected channels (online only)"
    type: sum
    sql: ${TABLE}.impressions ;;
  }

  measure: clicks {
    description: "Total clicks for selected channels (online only)"
    type: sum
    sql: ${TABLE}.clicks ;;
  }

  dimension: spend_platform {
    description: "What platform for spend (google, facebook, TV, etc.)"
    type:  string
    sql: ${TABLE}.platform ;;
  }

  dimension: Spend_platform_condensed {
    description: "What platform for spend, grouping smaller platforms into all other"
    label: "Major spend platforms"
    type: string
    case: {
      when: {
        sql: ${TABLE}.platform = 'FACEBOOK' ;;
        label: "FACEBOOK"
        }

      when: {
        sql: ${TABLE}.platform = 'GOOGLE' ;;
        label: "GOOGLE"
      }

      when: {
        sql: ${TABLE}.platform = 'TV' ;;
        label: "TV"
      }

      when: {
        sql: ${TABLE}.platform = 'AMAZON MEDIA GROUP' ;;
        label: "AMAZON"
      }

      when: {
        sql: ${TABLE}.platform = 'YAHOO' ;;
        label: "YAHOO"
      }

#      when: {
#        sql: ${TABLE}.platform = 'BING' ;;
#        label: "BING"
#      }

      else: "ALL OTHERS"
    }
  }

  dimension: ad_display_type {
    description: "How ad was presented (search, display, video, TV, etc.)"
    #hidden:  yes
    type:  string
    sql: ${TABLE}.source ;;
  }

  dimension: campaign_type {
    description: "Prospecting/Retargeting/Brand"
    #hidden:  yes
    type:  string
    case: {
      when: {
        sql:  ${TABLE}.campaign_type = 'BRAND' ;;
        label: "BRAND"
      }

      when: {
        sql:  ${TABLE}.campaign_type = 'PROSPECTING' ;;
        label: "PROSPECTING"
      }

      when: {
        sql:  ${TABLE}.campaign_type = 'RETARGETING' ;;
        label: "RETARGETING"
      }

      else: "OTHER"
    }
  }

  dimension: ad_device {
    description: "What device was ad viewed on? (smartphone, desktop, tablet, TV, etc.)"
    #hidden:  yes
    type: string
    case: {
      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_SMARTPHONE','IPHONE','MOBILE DEVICES WITH FULL BROWSERS','SMARTPHONE') ;;
        label: "MOBILE"
      }

      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_TABLET','IPAD','TABLETS WITH FULL BROWSERS','IPOD','TABLET') ;;
        label: "TABLET"
      }

      when: {
        sql: upper(${TABLE}.device) in ('COMPUTER','COMPUTERS','DESKTOP') ;;
        label: "DESKTOP"
      }

      else: "OTHER"
    }
  }
}
