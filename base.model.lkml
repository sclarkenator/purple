connection: "analytics_warehouse"

include: "*.view.lkml"

week_start_day: sunday


explore: daily_adspend_base {
  #-------------------------------------------------------------------
  # Daily Spend
  #-------------------------------------------------------------------
  from:  daily_adspend
  hidden: yes
  join: temp_attribution {
    type: left_outer
    sql_on: ${temp_attribution.ad_date} = ${daily_adspend_base.ad_date} and ${temp_attribution.partner} = ${daily_adspend_base.Spend_platform_condensed} ;;
    relationship: many_to_one}
}
