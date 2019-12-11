view: conversions_by_campaign_agg {

  derived_table: {
    sql: -- selecting the lowest zip code per city
      SELECT campaign_id, date, platform
      , sum (conversion_value) as conversions
      FROM marketing.conversions_by_campaign
      WHERE attribution_window_days = 1
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

  measure: conversions {
    label: "Total Conversions"
    type:  sum
    sql:${TABLE}.conversions ;; }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${campaign_id}, ${date},${conversions}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
