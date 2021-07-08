view: campaign_name_lookup {

  derived_table: {
    sql:
      select
        campaign_id
        , campaign_name
        ,ad_id
        ,ad_name
      from(
        select campaign_id
            , campaign_name
            ,ad_id
            ,ad_name
            , date
            , row_number () over (partition by campaign_id order by date desc) as row_num
        from marketing.adspend
        where campaign_id not in ('0','1','NA','N/A','11','111','111111','10')
          and campaign_name not in ('NA','N/A')
        order by 1,3 desc
      ) z
      where row_num = 1
    ;;
  }

dimension: campaign_id{
  type:string
  primary_key: yes
  hidden: yes
  sql: ${TABLE}.campaign_id ;;
  }
dimension: campaign_name {
  type:string
  description: "Campaign name from adspend table matched by id"
  view_label: "Sessions"
  group_label: "UTM Tags"
  sql: nvl(${TABLE}.campaign_name,${ecommerce.utm_campaign_raw});;
  }

  dimension: ad_id{
    type:string
    hidden: yes
    sql: ${TABLE}.ad_id ;;
  }
  dimension: ad_name {
    type:string
    description: "Campaign name from adspend table matched by id"
    view_label: "Sessions"
    group_label: "UTM Tags"
    sql: nvl(${TABLE}.ad_name,${heap_page_views.utm_ad});;
  }

}
