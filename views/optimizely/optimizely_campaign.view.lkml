view: optimizely_campaign {
  sql_table_name: analytics.optimizely.campaign
    ;;

  dimension: campaign_id {
    primary_key: yes
    hidden: yes
    view_label: "Optimizely"
    description: "Source: optimizely.experiment"
    type: number
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: campaign_name {
    view_label: "Optimizely"
    description: "Source: optimizely.campaign"
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

}
