## Data Engineering is using this data to check adspend daily
view: adspend_by_platform {
  derived_table: {
    sql:
      with t as (
        select date, platform,sum(spend) as spend
        from analytics.marketing.adspend
        where date > add_months(current_date,-3)
        group by 1,2
      ), threshold as (
        select platform, min(spend) as threshold
        from t
        group by 1
      ), yesterday as (
        select platform, sum(spend) as adspend_amt
        from analytics.marketing.adspend
        where date = current_date - 1
        group by 1
      )
      select y.*
      from yesterday y
        join threshold th on y.platform = th.platform
      where y.adspend_amt < th.threshold
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  measure: adspend_amt {
    type: sum
    sql: ${TABLE}.adspend_amt ;;
  }
}
