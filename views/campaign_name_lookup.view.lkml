view: campaign_name_lookup {

  sql_table_name: analytics.heap.v_ecommerce_campaign_name_lookup ;;


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
