view: cac {
  derived_table: {
  sql:
        select spend.date
              ,new_cust.new_customers
              ,brand_spend + prospecting_spend + affiliate_spend + retargeting_spend + other_spend as allocated_spend
              ,LTV
              ,initial_purchase
        from
            (select date
                    ,sum(case when campaign_type = 'BRAND' then brand_search_spend else 0 end) brand_spend
                    ,sum(case when campaign_type = 'PROSPECTING' then brand_search_spend else 0 end) prospecting_spend
                    ,sum(case when campaign_type = 'AFFILIATE' then brand_search_spend else 0 end) affiliate_spend
                    ,sum(case when campaign_type = 'RETARGETING' then brand_search_spend else 0 end) retargeting_spend
                    ,sum(case when campaign_type = 'OTHER' then brand_search_spend else 0 end) other_spend
            from
                (
                select date
                        ,campaign_type
                        ,spend
                        ,round(sum(spend) over (partition by campaign_type order by date rows between 44 preceding and current row)/45,0) prospecting_spend
                        ,round(sum(spend) over (partition by campaign_type order by date rows between 14 preceding and current row)/15,0) retargeting_spend
                        ,round(sum(spend) over (partition by campaign_type order by date rows between 6 preceding and current row)/7,0) brand_search_spend
                        ,round(sum(spend) over (partition by campaign_type order by date rows between 29 preceding and current row)/30,0) other_spend
                        ,round(sum(spend) over (partition by campaign_type order by date rows between 2 preceding and current row)/3,0) affiliate_spend

                from
                    (select date
                            ,campaign_type
                            ,sum(spend) spend
                    from marketing.adspend
                    --where date between '2018-07-01' and '2018-09-25'
                    group by 1,2
                    ))
            group by 1
            order by 1 desc) spend
        join
            (select date
                    ,sum(LTV) LTV
                    ,sum(dollars) initial_purchase
                    ,count(*) new_customers
            from
                (select user_id
                        ,to_date(convert_timezone('America/Denver',time)) date
                        ,sum(dollars) over (partition by user_id) LTV
                        ,dollars
                        ,row_number() over (partition by user_id order by time) purch_num
                from analytics.heap.purchase
                )
            where purch_num = 1
            group by 1) new_cust
        on spend.date = new_cust.date
        where spend.date >= '2018-01-01'
        order by 1 ;;
  }

  dimension_group: date {
    description:  "Date"
    type: time
    timeframes: [
      month_name,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  measure: new_customers {
    description: "New customers"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.new_customers ;;
  }

  measure: allocated_spend {
    description: "allocated spend"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.allocated_spend ;;
  }

  measure: CAC {
    description: "Customer acqusition cost"
    label: "CAC"
    type:  number
    value_format_name: decimal_0
    sql: ${allocated_spend}/${new_customers} ;;
  }

  measure: total_LTV {
    description: "sum total of all sales based on first purchase day"
    hidden:  yes
    type: sum
    sql:  ${TABLE}.LTV ;;
  }

  measure: LTV {
    description: "sum total of all sales based on first purchase day"
    type: number
    value_format_name: decimal_0
    sql:  ${total_LTV}/${new_customers} ;;
  }


}
