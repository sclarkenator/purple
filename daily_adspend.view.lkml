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
    sql: ${TABLE}.spend ;;
  }

  measure: avg_adspend {
    label: "Average daily spend"
    description: "Total adspend for selected channels"
    type: average
    sql: ${TABLE}.spend ;;
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

  dimension: ad_display_type {
    description: "How ad was presented (search, display, video, TV, etc.)"
    #hidden:  yes
    type:  string
    sql: ${TABLE}.source ;;
  }

  dimension: ad_device {
    description: "What device was ad viewed on? (smartphone, desktop, tablet, TV, etc.)"
    #hidden:  yes
    type: string
    case: {
      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_SMARTPHONE','IPHONE','MOBILE DEVICES WITH FULL BROWSER','SMARTPHONE') ;;
        label: "MOBILE"
      }

      when: {
        sql: upper(${TABLE}.device) in ('ANDROID_TABLET','IPAD','TABLETS WITH FULL BROWSER','IPOD','TABLET') ;;
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
