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
    description: "This should only be used if you're filtering attribution window to a single value"
    type:  sum
    sql:${TABLE}.spend ;; }

  measure: clicks {
    label: "Total Clicks"
    description: "This should only be used if you're filtering attribution window to a single value"
    type:  sum
    sql:${TABLE}.clicks ;; }

  measure: impressions {
    label: "Total Impressions"
    description: "This should only be used if you're filtering attribution window to a single value"
    type:  sum
    sql:${TABLE}.impressions ;; }

  measure: spend_2 {
    label: "Total Spend (multi window)"
    description: "This should only be used if you're NOT filtering attribution window down"
    type:  sum
    sql:${TABLE}.spend/${conversions_by_campaign.count_window} ;; }

  measure: clicks_2 {
    label: "Total Clicks (multi window)"
    description: "This should only be used if you're NOT filtering attribution window down"
    type:  sum
    sql:${TABLE}.clicks/${conversions_by_campaign.count_window} ;; }

  measure: impressions_2 {
    label: "Total Impressions (multi window)"
    description: "This should only be used if you're NOT filtering attribution window down"
    type:  sum
    sql:${TABLE}.impressions/${conversions_by_campaign.count_window} ;; }

}
