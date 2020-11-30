######################################################
#   Spend
#   Link to dashboard at final table
######################################################
view: adspend_ndt {
  derived_table: {
    explore_source: daily_adspend {
      column: ad_date {}
      column: campaign_name {}
      column: campaign_id {}
      column: medium {}
      column: spend_platform {}
      column: campaign_type {}
      column: adspend_raw {}
      column: clicks {}
      filters: { field: daily_adspend.ad_date value: "1 years" }
      filters: { field: daily_adspend.Before_today value: "Yes" }
    }
  }
  dimension: ad_date { type: date }
  dimension: campaign_name { type:  string }
  dimension: campaign_id { type:  string }
  dimension: medium {type:  string }
  dimension: spend_platform {type:  string }
  dimension: campaign_type {type:  string }
  dimension: adspend_raw { type: number }
  dimension: clicks { type: number}
}


######################################################
#   Sessions
#   Link to dashboard at final table
######################################################

view: sessions_ndt {
  derived_table: {
    explore_source: all_events {
      column: count { field: sessions.count }
      column: time_date { field: sessions.time_date }
      column: utm_campaign { field: sessions.utm_campaign_raw }
      column: utm_content { field: sessions.utm_content }
      column: utm_medium { field: sessions.utm_medium }
      column: utm_source { field: sessions.utm_source }
      column: utm_term { field: sessions.utm_term }
      column: term_bucket { field: sessions.term_bucket }
      column: medium_bucket { field: sessions.medium_bucket }
      column: source_bucket { field: sessions.source_bucket }
      filters: {
        field: sessions.time_date
        value: "1 years"
      }
    }
  }
  dimension: time_date { type: date }
  dimension: utm_campaign { type: string }
  dimension: utm_content {type: string }
  dimension: utm_medium {type: string }
  dimension: utm_source {type: string }
  dimension: utm_term {type: string }
  dimension: term_bucket {type: string }
  dimension: medium_bucket {type: string }
  dimension: source_bucket {type: string }
  dimension: count { type: number }
}




######################################################
#   CREATING FINAL TABLE
#   https://purple.looker.com/dashboards/3475
######################################################
view: spend_sessions_ndt {
  derived_table: {
    sql:
      select coalesce(spend.ad_date,sessions.time_date) as date
        , coalesce(spend.medium,sessions.medium_bucket) as merged_medium
        , coalesce(spend.campaign_type,sessions.term_bucket) as merged_type
        , coalesce(spend.spend_platform,sessions.source_bucket) as merged_platform

        , sessions.utm_campaign
        , sessions.utm_content
        , sessions.utm_medium
        , sessions.utm_source
        , sessions.utm_term
        , sessions.term_bucket
        , sessions.medium_bucket
        , sessions.source_bucket
        , sessions.count

        , spend.campaign_name
        , spend.campaign_id
        , spend.medium
        , spend.spend_platform
        , spend.campaign_type
        , spend.adspend_raw
        , spend.clicks

      from ${adspend_ndt.SQL_TABLE_NAME} spend
      full outer join ${sessions_ndt.SQL_TABLE_NAME} sessions
        on sessions.time_date::date = spend.ad_date::date
        and (sessions.utm_campaign = spend.campaign_id or sessions.utm_campaign = spend.campaign_name)
    ;;
    datagroup_trigger: pdt_refresh_6am
  }

  dimension: date {type: date hidden:yes}

  dimension_group: date {
    label: "   Created"
    type: time
    timeframes: [date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${date}) ;;
  }

  dimension: merged_medium{
    label: " Medium"
    type: string
    sql: ${TABLE}.merged_medium;;
  }

  dimension: merged_type{
    label: " Type"
    type: string
    sql: ${TABLE}.merged_type;;
  }

  dimension: merged_platform{
    label: " Platform"
    type: string
    sql: ${TABLE}.merged_platform;;
  }

  dimension: merged_name{
    label: " Campaign"
    type: string
    sql: coalesce(${TABLE}.utm_campaign,${TABLE}.campaign_name);;
  }

  dimension: utm_campaign{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.utm_campaign;;
  }

  dimension: utm_content{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.utm_content;;
  }

  dimension: utm_medium{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.utm_medium;;
  }

  dimension: utm_source{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.utm_source;;
  }

  dimension: utm_term{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.utm_term;;
  }

  dimension: term_bucket{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.term_bucket;;
  }

  dimension: source_bucket{
    group_label: "Sessions"
    type: string
    sql: ${TABLE}.source_bucket;;
  }

  measure: sessions {
    type: sum
    sql: ${TABLE}.count;;
  }

  dimension: campaign_name{
    group_label: "Spend"
    type: string
    sql: ${TABLE}.campaign_name;;

  }
  dimension: campaign_id{
    group_label: "Spend"
    type: string
    sql: ${TABLE}.campaign_id;;
  }

  dimension: medium{
    group_label: "Spend"
    type: string
    sql: ${TABLE}.medium;;
  }

  dimension: spend_platform{
    group_label: "Spend"
    type: string
    sql: ${TABLE}.spend_platform;;
  }

  dimension: campaign_type{
    group_label: "Spend"
    type: string
    sql: ${TABLE}.campaign_type;;
  }

  measure: adspend_raw{
    type: sum
    sql: ${TABLE}.adspend_raw;;
  }

  measure: clicks{
    type: sum
    sql: ${TABLE}.clicks;;
  }

  dimension: linked {
    label: " Campaign Matches"
    type: yesno
    #sql: ${TABLE}.utm_campaign is not null and ${TABLE}.campaign_name is not null ;;
    sql: ${TABLE}.utm_campaign = ${TABLE}.campaign_name ;;
  }

  dimension: linked_id {
    label: " Campaign ID Matches"
    type: yesno
    #sql: ${TABLE}.utm_campaign is not null and ${TABLE}.campaign_id is not null ;;
    sql: ${TABLE}.utm_campaign = ${TABLE}.campaign_id  ;;
  }
  dimension: organic_session {
    label: " Organic (no tags)"
    type: yesno
    sql: ${TABLE}.utm_campaign is null;;
  }

  measure: campaign_count {
    label: "Row Count"
    type: count
  }

}
