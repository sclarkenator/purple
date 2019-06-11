view: conversions {

  derived_table: {
    sql:
    with facebook_campaigns as(
      select  campaign_id,
              campaign_name,
              source as platform
      from    analytics.marketing.adspend a
      where platform = 'FACEBOOK'
      group by 1,2,3
    )
    select  X.DATE,
            X.CAMPAIGN_NAME,
            X.DEVICE,
            X.PLATFORM,
            X.ATTRIBUTION_WINDOW_DAYS,
            X.CONVERSION_VALUE
    from
    (
        select
                to_date(h.date) as DATE,
                f.campaign_name as CAMPAIGN_NAME,
                h.DEVICE_PLATFORM as DEVICE,
                f.platform as PLATFORM,
                1 as ATTRIBUTION_WINDOW_DAYS,
                sum(coalesce(value,0)) as CONVERSION_VALUE
        from analytics_stage.FACEBOOK.FB_CONVERSIONS_ACTION_VALUES h join facebook_campaigns f
                    on h.campaign_id = f.campaign_id
        where h.action_type = 'offsite_conversion.fb_pixel_purchase'
                and to_date(h.date) < '2018-11-03'
        group by 1,2,3,4,5
        union all
        select DATE as DATE,
               f.campaign_name as CAMPAIGN_NAME,
               DEVICE as DEVICE,
               f.platform as PLATFORM,
               ATTRIBUTION_WINDOW_DAYS,
               sum(CONVERSION_VALUE) as CONVERSION_VALUE
        from analytics.marketing.CONVERSIONS_BY_CAMPAIGN c join facebook_campaigns f
                    on c.campaign_id = f.campaign_id
        where to_date(date) >= '2018-11-03'
        and c.platform = 'FACEBOOK'
        group by 1,2,3,4,5
    ) X
      ;;
  }

  dimension: date {
    type:  date
    sql:${TABLE}.date ;; }

  dimension: CAMPAIGN_NAME {
    type:  string
    sql:${TABLE}.CAMPAIGN_NAME ;; }

  dimension: platform {
    type:  string
    sql:${TABLE}.platform ;; }

  dimension: DEVICE {
    type:  string
    sql:${TABLE}.DEVICE ;; }

  dimension: ATTRIBUTION_WINDOW_DAYS {
    type:  string
    sql:${TABLE}.ATTRIBUTION_WINDOW_DAYS ;; }

  measure: CONVERSION_VALUE {
    type:  sum
    sql:${TABLE}.CONVERSION_VALUE ;; }


}
