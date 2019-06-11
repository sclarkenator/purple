view: conversions {

  derived_table: {
    sql:
    with facebook_campaigns as(
    select  id as campaign_id,
            name as campaign_name
    from    ANALYTICS_STAGE.FACEBOOK.CAMPAIGN a
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
    order by 1 desc
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

  dimension: IMPRESSION_DEVICE {
    type:  string
    sql:${TABLE}.IMPRESSION_DEVICE ;; }

  measure: CONVERSION_VALUE {
    type:  sum
    sql:${TABLE}.WEBSITE_PURCHASE_CONVERSION_VALUE ;; }


}
