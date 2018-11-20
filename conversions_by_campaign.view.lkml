#-------------------------------------------------------------------
# Owner - Tim Schultz
# Created by Aditya in snowflake on an aggregation and calculations
#-------------------------------------------------------------------

view: conversions_by_campaign {
  sql_table_name: marketing.conversions_by_campaign_history ;;

  dimension: campaign_id {
    hidden: yes
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

  dimension: attribution_window_days {
    label: "Attribution Window"
    type: string
    sql: ${TABLE}.attribution_window_days ;; }


  measure: conversions {
    label: "Total Conversions"
    type: sum
    sql: ${TABLE}.conversions ;;  }


}
