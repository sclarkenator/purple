#-------------------------------------------------------------------
# Owner - Tim Schultz
# Created by Aditya in snowflake on an aggregation and calculations
#-------------------------------------------------------------------

view: external_campaigns {
  sql_table_name: marketing.external_campaigns ;;

  dimension: campaign_id {
    hidden: yes
    type: string
    sql: ${TABLE}.campaign_id;; }

  dimension_group: start_date {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.start_date ;; }

  dimension: campaign_type {
    label: "Campaign Type"
    type: string
    sql: ${TABLE}.campaign_type ;; }

  dimension: platform {
    label: "Platform"
    type: string
    sql: ${TABLE}.source ;; }

}
