#-------------------------------------------------------------------
# Owner - Scott Clark
# Customer Acquisition Cost
#-------------------------------------------------------------------

view: cac {
  derived_table: {
  sql: select spend.date
    , new_cust.new_customers
    , brand_spend + prospecting_spend + affiliate_spend + retargeting_spend + other_spend as allocated_spend
    , LTV
  from(
    select date
      ,sum(case when campaign_type = 'BRAND' then brand_search_spend else 0 end) brand_spend
      ,sum(case when campaign_type = 'PROSPECTING' then brand_search_spend else 0 end) prospecting_spend
      ,sum(case when campaign_type = 'AFFILIATE' then brand_search_spend else 0 end) affiliate_spend
      ,sum(case when campaign_type = 'RETARGETING' then brand_search_spend else 0 end) retargeting_spend
      ,sum(case when campaign_type = 'OTHER' then brand_search_spend else 0 end) other_spend
    from (
      select date
        , campaign_type
        , spend
        , round(sum(spend) over (partition by campaign_type order by date rows between 44 preceding and current row)/45,0) prospecting_spend
        , round(sum(spend) over (partition by campaign_type order by date rows between 14 preceding and current row)/15,0) retargeting_spend
        , round(sum(spend) over (partition by campaign_type order by date rows between 6 preceding and current row)/7,0) brand_search_spend
        , round(sum(spend) over (partition by campaign_type order by date rows between 29 preceding and current row)/30,0) other_spend
        , round(sum(spend) over (partition by campaign_type order by date rows between 2 preceding and current row)/3,0) affiliate_spend
      from (
        select date
          , campaign_type
          , sum(spend) spend
        from marketing.adspend
        --where date between '2018-07-01' and '2018-09-25'
        group by 1,2
      )
    )
    group by 1
    order by 1 desc
  ) spend
    join (
    select date
      , sum(new_customers) new_customers
      , sum(LTV) LTV
    from (
      select date
        , count(*) new_customers
        , sum(LTV) LTV
      from (
        select to_date(convert_timezone('America/Denver',time)) date
          , row_number() over (partition by user_id order by time) purch_num
          , sum(dollars) over (partition by user_id) LTV
        from heap.purchase
      )
      where purch_num = 1
      group by 1

      union all

      select date
        , count(*) new_customers
        , sum(LTV) LTV
      from (
        select buyer_email
          , to_date(convert_timezone('America/Denver',purchase_Date)) date
          , row_number() over (partition by buyer_email order by purchase_date) order_num
          , sum(item_price*quantity_shipped) over (partition by buyer_email) LTV
        from analytics_stage.amazon_stg.amazon_shipping
        where purchase_date > '2018-01-01'
      )
      where order_num = 1
      group by 1

      union all

      select '2018-07-04' as "date"
        , 1100 as "new_customers"
        , 1320000 as "LTV"
      from dual

      union all

      select '2018-07-05' as "date"
        , 750 as "new_customers"
        , 900000 as "LTV"
      from dual
    )
    group by 1
  ) new_cust on spend.date = new_cust.date
  where spend.date >= '2018-01-01'
  order by 1 ;; }

  dimension_group: date {
    #label: "Date" #Static?
    description:  "A static date with the spend of that day and purchases from that day joined"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;  }

  measure: new_customers {
    label: "Total New Customers"
    description: "Total New Customers from specified time period"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.new_customers ;;  }

  measure: allocated_spend {
    label: "Total Allocated Spend"
    description: "Total Allocated Spend from specified time period"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.allocated_spend ;;  }

  measure: CAC {
    #label: "CAC"
    description: "Customer Acqusition Cost - Spend/New Customers"
    type:  number
    value_format_name: decimal_0
    sql: ${allocated_spend}/${new_customers} ;;  }

  measure: total_LTV {
    label: "Total LVT"
    description: "Total of all sales based on first purchase day"
    hidden:  yes
    type: sum
    sql:  ${TABLE}.LTV ;;  }

  measure: LTV {
    label: "LTV"
    description: "Total of all sales based on first purchase day / total new customers"
    type: number
    value_format_name: decimal_0
    sql:  ${total_LTV}/${new_customers} ;;  }

}
