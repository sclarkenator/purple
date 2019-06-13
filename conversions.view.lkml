view: conversions {

  derived_table: {
    sql:
      ----------- FACEBOOK -------------------------------------
      with facebook_campaigns as(
          select  id as campaign_id,
                  name as campaign_name
          from    ANALYTICS_STAGE.FACEBOOK.CAMPAIGN a
          group by 1,2
      )
      --(snapchat temp table)
      , campaign_info as (
          select  id as campaign_id,
                  name as campaign_name
          from ANALYTICS_STAGE.SNAPCHAT_ADS.CAMPAIGN_HISTORY c
          group by 1,2
      )
      select
              date as DATE,
              f.campaign_name as CAMPAIGN_NAME,
              publisher_platform as PLATFORM,
              DEVICE_PLATFORM,
              IMPRESSION_DEVICE,
              round(sum(coalesce(value,0)),2) as WEBSITE_PURCHASE_CONVERSION_VALUE
      from ANALYTICS_STAGE.FACEBOOK.FB_CONVERSIONS_ACTION_VALUES a join facebook_campaigns f
                      on a.campaign_id = f.campaign_id
      where action_type in ( 'offsite_conversion.fb_pixel_purchase','offsite_conversion','offline_conversion.purchase')
        and date < current_date
      group by 1,2,3,4,5

      union all
      ------------- Pinterest ------------------------------------------------------
      select  to_date(report_start_date) as DATE,
              CAMPAIGN_NAME,
              'pinterest' as platform,
              null,null,
              sum(cast(translate(p.order_value,'$,:','') as number(20,2))) as CONVERSION_PURCHASE_VALUE
      from ANALYTICS_STAGE.MARKETING_STAGE.PINTEREST_DATA p
      where date is not null
      group by 1,2

      union all
      ------------- SNAPCHAT ------------------------------------------------------
      select  to_date(date) as DATE,
              c.CAMPAIGN_name as CAMPAIGN_NAME,
              'snapchat' as platform,
              null,null,
              round(sum(CONVERSION_PURCHASES_VALUE/1000000),2) as CONVERSION_PURCHASE_VALUE
      from ANALYTICS_STAGE.SNAPCHAT_ADS.CAMPAIGN_HOURLY_REPORT r join campaign_info c
                  on r.campaign_id = c.campaign_id
      where to_date(date) < current_date
      group by 1,2
      order by 1 desc
    ;;
  }

  dimension: date {
    type:  date
    hidden:  yes
    sql:${TABLE}.date ;; }

  dimension_group: created {
    label: "Created"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;; }

  dimension: CAMPAIGN_NAME {
    type:  string
    sql:${TABLE}.CAMPAIGN_NAME ;; }

  dimension: platform {
    type:  string
    sql:${TABLE}.platform ;; }

  dimension: IMPRESSION_DEVICE {
    type:  string
    sql:${TABLE}.IMPRESSION_DEVICE ;; }

  measure: CONVERSION_VALUE {
    type:  sum
    value_format: "$#,##0,\" K\""
    sql:${TABLE}.WEBSITE_PURCHASE_CONVERSION_VALUE ;; }


}
