#-------------------------------------------------------------------
# Owner - Tim Schultz
# Created by Aditya in snowflake on an aggregation and calculations
#-------------------------------------------------------------------

view: conversions_by_campaign {
  derived_table: {
    sql:
      with zz as (
        select campaign_id, date, platform, source, device
          , max(attribution_window_days) as max_window, count (campaign_id) as count_window
        from marketing.conversions_by_campaign
        where attribution_window_days <= 7
        group by campaign_id, date, platform, source, device
      )
      select a.campaign_id, a.date, a.platform, a.source, a.device, a.attribution_window_days, a.conversion_value
          , zz.max_window, zz.count_window
      from marketing.conversions_by_campaign a
      left join zz on zz.campaign_id = a.campaign_id and zz.date = a.date and zz.platform = a.platform
          and zz.source = a.source and zz.device = a.device ;; }

  dimension: campaign_id {
    label: "Campaign ID"
    #hidden: yes
    type: string
    sql: ${TABLE}.campaign_id;; }

  dimension_group: date {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;; }

  dimension: platform {
    label: "Platform"
    type: string
    sql: ${TABLE}.platform ;; }

  dimension: source {
    label: "Source"
    type: string
    sql: ${TABLE}.source ;; }

  dimension: device {
    label: "Device"
    type: string
    sql: ${TABLE}.device ;; }

  dimension: attribution_window_days {
    label: "Attribution Window Days"
    type: string
    sql: ${TABLE}.attribution_window_days ;; }

  dimension: max_window {
    label: "Max Window"
    description: "Max window of 7 or less"
    type: number
    sql: ${TABLE}.max_window ;; }

  dimension: count_window {
    label: "Window Duplications"
    description: "Count of how many times the data is duplicated by a different attribution window"
    type: number
    sql: ${TABLE}.count_window ;; }

  dimension: only_max {
    label: "Only Max Window"
    description: "Using the ax window of 7 or less"
    type: yesno
    sql: ${TABLE}.max_window=${TABLE}.attribution_window_days ;; }

  measure: max_window_measure {
    label: "Max Window"
    type: max
    sql: ${TABLE}.max_window ;; }

  measure: conversions {
    label: "Total Conversions"
    type: sum
    sql: ${TABLE}.conversion_value ;;  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.campaign_id, ${TABLE}.date_date,${TABLE}.conversions) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }


}
