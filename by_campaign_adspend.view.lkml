view: adspend_by_campaign {

  derived_table: {
    sql:
      select campaign_id, date, platform
        , sum (spend) as spend
        , sum (clicks) as clicks
        , sum (impressions) as impressions
      from marketing.adspend_by_campaign
      group by campaign_id, date, platform
      ;;
  }

  dimension: campaign_id {
    hidden: yes
    type:  number
    sql:${TABLE}.campaign_id ;; }

  dimension: date {
    type:  date
    sql:${TABLE}.date ;; }

  dimension: platform {
    type:  string
    sql:${TABLE}.platform ;; }

  measure: spend {
    label: "Total Spend"
    type:  sum
    sql:${TABLE}.spend ;; }

  measure: clicks {
    label: "Total Clicks"
    type:  sum
    sql:${TABLE}.clicks ;; }

  measure: impressions {
    label: "Total Impressions"
    type:  sum
    sql:${TABLE}.impressions ;; }

}
