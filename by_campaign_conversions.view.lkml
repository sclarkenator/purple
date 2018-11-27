#-------------------------------------------------------------------
# Owner - Tim Schultz
# Created by Aditya in snowflake on an aggregation and calculations
#-------------------------------------------------------------------

view: conversions_by_campaign {
  derived_table: {
    sql:
      SELECT campaign_id, date, platform, source, device, attribution_window_days, conversions
      FROM marketing.conversions_by_campaign
      WHERE attribution_window_days = 1
      );;
  }

  dimension: campaign_id {
    label: "Campaign ID"
    #hidden: yes
    type: string
    sql: ${TABLE}.campaign_id;; }

  dimension_group: date {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;; }

  dimension: platform{
    label: "Platform"
    type: string
    sql: ${TABLE}.platform ;; }

  dimension: source {
    label: "Source"
    type: string
    sql: ${TABLE}.source ;; }

  dimension: device{
    label: "Device"
    type: string
    sql: ${TABLE}.device ;; }

  measure: conversions {
    label: "Total Conversions"
    type: sum
    sql: ${TABLE}.conversions ;;  }


}
