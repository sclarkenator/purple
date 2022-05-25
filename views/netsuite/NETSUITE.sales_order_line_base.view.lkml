include: "/views/_period_comparison.view.lkml"
view: sales_order_line_base {
  #sql_table_name: SALES.SALES_ORDER_LINE ;;
  derived_table: {
    sql:
    select
      sol.*,
      case when so.channel_id = 2 and co.cancelled is not NULL then TRUE else FALSE end as is_cancelled_wholesale
    from analytics.sales.sales_order_line sol
      left join analytics.sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
      left join analytics.sales.cancelled_order co on sol.order_id = co.order_id and sol.item_id = co.item_id and sol.system = co.system
    ;;
  }
  extends: [_period_comparison]

  dimension: is_cancelled_wholesale {
    label:  "     * Is Cancelled Wholesale"
    description: "Whether the Wholesale order was cancelled.
    Source: netsuite.cancelled_order"
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_cancelled_wholesale;; }

  dimension: item_order{
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;;
  }
#### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      month,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    sql: to_timestamp_ntz(${TABLE}.Created) ;;
  }

  measure: avg_cost {
    hidden: yes
    label:  "Avgerage Cost ($)"
    description:  "Average unit cost, only valid looking at item-level data. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    type: average
    value_format_name: decimal_2
    sql:  ${TABLE}.estimated_Cost ;;
  }

  measure: min_sales_amt {
    hidden: yes
    type: min
    value_format: "$#,##0.00"
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: max_sales_amt {
    hidden: yes
    type: max
    value_format: "$#,##0.00"
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: total_estimated_cost {
    hidden: yes
    label: "Estimated Costs ($)"
    description: "Estimated cost value from NetSuite for the cost of materials. Source: netsuite.sales_order_line"
    type: sum
    drill_fields: [order_details*]
    value_format: "$#,##0.00"
    sql: ${TABLE}.estimated_Cost;;
  }

  measure: total_gross_Amt {
    group_label: "Gross Sales"
    label:  "Gross Sales ($0.k)"
    description:  "Total the customer paid, excluding tax and freight, in $K. This also exludes wholesale cancelled orders. Source:netsuite.sales_order_line"
    type: sum
    drill_fields: [order_details*]
    filters: {field: is_cancelled_wholesale value: "No" }
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt ;;
  }
  measure: total_gross_Amt_raw {
    hidden: yes
    type: sum
    drill_fields: [order_details*]
    value_format: "$#,##0"
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: total_gross_Amt_non_rounded {
    group_label: "Gross Sales"
    label:  "Gross Sales ($)"
    description:  "Total the customer paid, excluding tax and freight, in $. This also excludes wholesale cancelled orders. Source:netsuite.sales_order_line"
    type: sum
    drill_fields: [order_details*]
    filters: {field: is_cancelled_wholesale value: "No" }
    value_format: "$#,##0"
    sql:  ${TABLE}.gross_amt ;;
  }

  measure: gross_gross_Amt {
    hidden:  yes
    label:  "Gross-Gross Sales ($0.k)"
    description:  "Total the customer paid plus value of discounts they received, excluding tax and freight. Source: netsuite.sales_order_line"
    type: sum
    drill_fields: [order_details*]
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt + ${TABLE}.discount_amt ;;
  }

  measure: total_discounts {
    label:  "Total Discounts ($)"
    value_format:"$#,##0"
    description:  "Total of all applied discounts when order was placed. Source:netsuite.sales_order_line"
    drill_fields: [order_details*]
    type: sum
    sql:  ${TABLE}.discount_amt ;;
  }

  measure: total_line_item {
    label: "Total Line Items"
    description: "Total line items to fulfill. Source: netsuite.sales_order_line"
    hidden: yes
    drill_fields: [order_details*]
    type: count_distinct
    sql:  ${item_order} ;;
  }

  measure: total_units {
    group_label: "Gross Sales"
    label:  "Gross Sales (units)"
    description: "Total units purchased, before returns and cancellations. This also exludes wholesale cancelled orders. Source:netsuite.sales_order_line"
    type: sum
    drill_fields: [order_details*]
   filters: {field: is_cancelled_wholesale value: "No" }
    sql:  ${TABLE}.ordered_qty ;;
  }

  dimension: total_units_raw {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.sales_order_line"
    type: number
    sql:  ${TABLE}.ordered_qty ;;
  }

  dimension: total_units_dem {
    group_label: " Advanced"
    label:  "Gross Sales (units) (dimension version)"
    description: "Dimension version: Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    type: number
    drill_fields: [order_details*]
    sql:  ${TABLE}.ordered_qty ;;
  }

  measure: dates{
    label: "Count of Days"
    hidden:  yes
    drill_fields: [order_details*]
    type: count_distinct
    sql: ${TABLE}.Created::date ;;
  }

  dimension: order_age_bucket_2 {
    label: "Order Age Orginal (bucket)"
    description: "Number of days between today and min ship date or when order was placed (1,2,3,4,5,6,7,14). Source: netsuite.sales_order_line"
    hidden: yes
    type:  tier
    tiers: [1,2,3,4,5,6,7,14]
    style: integer
    sql: datediff(day,${created_date},current_date) ;;
  }

  dimension: manna_order_age_bucket {
    view_label: "Fulfillment"
    label: "Manna Order Age (Bucket)"
    hidden: yes
    description: "Number of days between today and when order was placed for Manna (7,14,21,28,35,42). Source: netsuite.sales_order_line"
    type:  tier
    tiers: [7,14,21,28,35,42]
    style: integer
    sql: datediff(day,${created_date},current_date) ;;
  }

  dimension: before_today_flag {
    label:  "Is Before Today"
    hidden: yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date}  < current_date ;;
  }

  dimension: yesterday_flag {
    label:  "Was Yesterday"
    hidden:  yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;;
  }

  dimension: free_item {
    label: "     * Zero Dollar Items (promo/free)"
    description: "Yes if this item is free. Source:netsuite.sales_order_line" #with purchase of mattress
    type: yesno
    sql: ((${pre_discount_amt} = ${discount_amt}) and ${discount_amt} <> 0) or (${gross_amt} = 0 and ${discount_amt} > 30)  ;;
  }

  dimension: discounted_item {
    label: "     * Is Discounted"
    description: "Yes if this item had any discount, including if free. Source:netsuite.sales_order_line"
    type: yesno
    sql: (${discount_amt} > 0)  ;;
  }

  dimension: order_system {
    type: string
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: item_order_refund{
    type:  string
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: city {
    label: "City"
    group_label: "  Customer Address"
    view_label: "Customer"
    description: "Source: netsuite.sales_order_line"
    type: string
    sql: UPPER(${TABLE}.CITY) ;;
  }

  dimension: company_id {
    hidden: yes
    type: number
    sql: ${TABLE}.COMPANY_ID ;;
  }

  dimension: country {
    label: "Country"
    group_label: "  Customer Address"
    view_label: "Customer"
    hidden: yes
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
  }

  dimension: MTD_flg{
    group_label: "    Order Date"
    view_label: "Sales Order"
    label: "z - Is Before Today (mtd)"
    hidden:  yes
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: netsuite.sales_order_line"
    type: yesno
    sql: ${TABLE}.Created < current_date and month(${TABLE}.Created) = month(dateadd(day,-1,current_date)) and year(${TABLE}.Created) = year(current_date) ;;
  }

  dimension: Before_today{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Is Before Today (mtd)"
    #hidden:  yes
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: netsuite.sales_order_line"
    type: yesno
    sql: ${TABLE}.Created < current_date;;
  }

  dimension: week_bucket_old{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Week Bucket Old"
    hidden: yes
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: netsuite.sales_order_line"
    type: string
    sql:  CASE WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, current_date) THEN 'Current Week'
           WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
           WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
           WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
           WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
           WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;
  }

  dimension: week_bucket{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: netsuite.sales_order_line"
    type: string
     sql:  CASE WHEN ${created_week_of_year} = date_part (weekofyear,current_date) AND ${created_year} = date_part (year,current_date) THEN 'Current Week'
             WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -1 AND ${created_year} = date_part (year,current_date) THEN 'Last Week'
             WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -2 AND ${created_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
             WHEN ${created_week_of_year} = date_part (weekofyear,current_date) AND ${created_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
             WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -1 AND ${created_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
             WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -2 AND ${created_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;
  }

  dimension: Before_today_ly{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Is Before Today Last Year (mtd)"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.Created < dateadd('year',-1,current_date);;
  }

  dimension: last_30{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Last 30 Days"
    #hidden:  yes
    description: "Yes/No for if the date is in the last 30 days. Source: netsuite.sales_order_line"
    type: yesno
    sql: ${TABLE}.Created > dateadd(day,-30,current_date);;
  }

  dimension: current_week_num{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Before Current Week"
    #hidden:  yes
    description: "Yes/No for if the date is before the current week of the year. Source: netsuite.sales_order_line"
    type: yesno
    sql: date_trunc(week, ${TABLE}.Created::date) < date_trunc(week, current_date) ;;
  }

  dimension: current_day_filter{
    ###Edited on 1/12/21 by Scott Clark to align week for Y/Y daily
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Current Day"
    #hidden:  yes
    description: "Yes/No for if the date is on the current day of week and week of the year (for each year). Source: netsuite.sales_order_line"
    type: yesno
    sql: ${created_week_of_year} = ${current_week_of_year} and ${created_day_of_week} = ${current_day_of_week} ;;
  }

  dimension: current_week_filter{
    ##Edited on 1/8/21 Scott Clark tweaked SQL to accomodate week shift. old code: sql: EXTRACT(WEEK FROM ${TABLE}.Created::date) = EXTRACT(WEEK FROM current_date::date) ;;
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Current Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the current week of the year (for each year). Source: netsuite.sales_order_line"
    type: yesno
    sql: ${created_week_of_year} = ${current_week_of_year}  ;;
  }

  dimension: current_month_filter{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Current Month"
    #hidden:  yes
    description: "Yes/No for if the date is in the current month of the year (for each year). Source: netsuite.sales_order_line"
    type: yesno
    sql: EXTRACT(month FROM ${TABLE}.Created::date) = EXTRACT(month FROM current_date::date) ;;
  }

  dimension: current_quarter_filter{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Current Quarter"
    #hidden:  yes
    description: "Yes/No for if the date is in the current quarter. Source: netsuite.sales_order_line"
    type: yesno
    sql: ${created_quarter}=${current_quarter} ;;
  }

  dimension: current_quarter_of_year_filter{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Current Quarter of Year"
    #hidden:  yes
    description: "Yes/No for if the date is in the current quarter of the year (for each year). Source: netsuite.sales_order_line"
    type: yesno
    sql: ${created_quarter_of_year} = ${current_quarter_of_year}  ;;
  }


  dimension: prev_week{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Previous Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the last 30 days. Source: netsuite.sales_order_line"
    type: yesno
    sql: date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
  }

  dimension: promo_date_bucket {
    label: "Promo Date Buckets"
    description: "A manual bucketing of the major promos; Memorial Day, Labor day, and Thanksgiving. Source: netsuite.sales_order_line"
    group_label: " Advanced"
    hidden: yes
    sql: case
          when ${TABLE}.created::date between '2018-11-14' and '2018-11-17' then '18 TG 1 WB'
          when ${TABLE}.created::date between '2018-11-20' and '2018-11-21'
            or ${TABLE}.created::date between '2018-11-24' and '2018-11-25' then '18 TG 2 PM'
          when ${TABLE}.created::date = '2018-11-22' then '18 TG'
          when ${TABLE}.created::date = '2018-11-23' then '18 BF'
          when ${TABLE}.created::date = '2018-11-26' then '18 CM'
          when ${TABLE}.created::date between '2019-05-05' and '2019-05-10' then '19 MD WB'
          when ${TABLE}.created::date between '2019-05-20' and '2019-05-26' then '19 MD PM'
          when ${TABLE}.created::date = '2019-05-27' then '19 MD'
          when ${TABLE}.created::date between '2019-08-08' and '2019-08-14' then '19 LD WB'
          when ${TABLE}.created::date between '2019-08-25' and '2019-09-01' then '19 LD PM'
          when ${TABLE}.created::date = '2019-09-02' then '19 LD'
          when ${TABLE}.created::date between '2019-11-08' and '2019-11-14' then '19 TG WB'
          when ${TABLE}.created::date between '2019-11-23' and '2019-11-27'
            or ${TABLE}.created::date between '2019-11-30' and '2019-12-01' then '19 TG PM'
          when ${TABLE}.created::date = '2019-11-28' then '19 TG'
          when ${TABLE}.created::date = '2019-11-29' then '19 BF'
          when ${TABLE}.created::date = '2019-12-02' then '19 CM'
          else 'Other' end  ;;
  }

  dimension: promo_date_holiday {
    label: "Promo Date Holliday"
    description: "A manual bucketing of the major promos; Memorial Day, Labor day, and Thanksgiving. Source: netsuite.sales_order_line"
    group_label: " Advanced"
    hidden: yes
    sql: case
          when ${TABLE}.created::date between '2018-11-14' and '2018-11-17'
            or ${TABLE}.created::date between '2018-11-20' and '2018-11-26' then '18 Thanksgiving'
          when ${TABLE}.created::date between '2019-05-05' and '2019-05-10'
            or ${TABLE}.created::date between '2019-05-20' and '2019-05-27' then '19 Memorial Day'
          when ${TABLE}.created::date between '2019-08-08' and '2019-08-14'
            or ${TABLE}.created::date between '2019-08-25' and '2019-09-02' then '19 Labor Day'
          when ${TABLE}.created::date between '2019-11-08' and '2019-11-14'
            or ${TABLE}.created::date between '2019-11-23' and '2019-12-02' then '19 Thanksgiving'
          else 'Other' end  ;;
  }

  dimension: promo_date_type {
    label: "Promo Date Type"
    description: "A manual bucketing of the major promos in types; Week Before, Promo Period, Holliday. Source: netsuite.sales_order_line"
    group_label: " Advanced"
    hidden: yes
    sql: case
          when ${TABLE}.created::date between '2018-11-14' and '2018-11-17'
            or ${TABLE}.created::date between '2019-05-05' and '2019-05-10'
            or ${TABLE}.created::date between '2019-08-08' and '2019-08-14'
            or ${TABLE}.created::date between '2019-11-08' and '2019-11-14' then 'Week Before'
          when ${TABLE}.created::date between '2018-11-20' and '2018-11-21'
            or ${TABLE}.created::date between '2018-11-24' and '2018-11-25'
            or ${TABLE}.created::date between '2019-05-20' and '2019-05-26'
            or ${TABLE}.created::date between '2019-08-25' and '2019-09-01'
            or ${TABLE}.created::date between '2019-08-25' and '2019-09-01'
            or ${TABLE}.created::date = '2019-11-28'
            or ${TABLE}.created::date = '2018-11-22'
            or ${TABLE}.created::date between '2019-11-23' and '2019-11-27'
            or ${TABLE}.created::date between '2019-11-30' and '2019-12-01' then 'Promo'
          when ${TABLE}.created::date = '2018-11-23'
            or ${TABLE}.created::date = '2018-11-26'
            or ${TABLE}.created::date = '2019-05-27'
            or ${TABLE}.created::date = '2019-09-02'
            or ${TABLE}.created::date = '2019-11-29'
            or ${TABLE}.created::date = '2019-12-02' then 'Holliday'
          else 'Other' end  ;;
  }

  dimension: liquid_date {
    group_label: "Dynamic Date"
    label: "z - liquid date"
    description: "If > 365 days in the look, than month, if > 30 than week, else day"
    sql:
    CASE
      WHEN
        datediff(
                'day',
                cast({% date_start created_date %} as date),
                cast({% date_end created_date  %} as date)
                ) >365
      THEN cast(${created_month} as varchar)
      WHEN
        datediff(
                'day',
                cast({% date_start created_date %} as date),
                cast({% date_end created_date  %} as date)
                ) >30
      THEN cast(${created_week} as varchar)
      else ${created_date}
      END
    ;;
  }
  dimension: Shipping_Addresee{
    hidden:  yes
    description: "The name on the shipping address. Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.Ship_company;;
  }

  dimension_group: created {
    ## Scott Clark 1/8/21: Removed day_of_year for 2021 Y/Y adjustment. Add back final week of 2021.
    view_label: "Sales Order"
    label: "    Order"
    description:  "Time and date order was placed. Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, month, month_num, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;;
  }

  # dimension: created_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "Week of Year"
  #   view_label: "Sales Order"
  #   group_label: "    Order Date"
  #   description: "2021 adjusted week of year number"
  #   sql: case when ${created_date::date} >= '2020-12-28' and ${created_date::date} <= '2021-01-03' then 1
  #             when ${created_year::number}=2021 then date_part(weekofyear,${created_date::date}) + 1
  #             else date_part(weekofyear,${created_date::date}) end ;;
  # }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    view_label: "Sales Order"
    group_label: "    Order Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${created_date::date} >= '2020-12-28' and ${created_date::date} <= '2021-01-03' then 2021 else ${created_year::number} end   ;;
  }

  measure: last_sync_date  {
    ##added by Scott Clark 11/25/2020
    hidden: no
    group_label: " Sync"
    label: "Netsuite sync date"
    description: "Date of most recent Netsuite sync"
    type:  date
    sql: max(${created_raw}) ;;
  }

  measure: last_sync_time  {
    ##added by Scott Clark 11/25/2020
    hidden: no
    group_label: " Sync"
    label: "Netsuite sync time"
    description: "Time of most recent Netsuite sync"
    type:  date_time_of_day
    sql: max(${created_raw}) ;;
  }

  dimension: is_same_rolling_week {
    description: "Use this dimension to compare the current week to the same week in previous years. (Filters on the current week (last 7 days) and the same days previous years.) Source: looker calculation"
    type: yesno
    ## This dimension returns yes if the created_date is in the last 7 days OR is the same last 7 days for all previous years.
    ## To determine if it is the same week the previous year, we check the week_of_year and the day_of_week_index.
    ## Note SQL always returns 52 weeks in a year. (ie Sometimes dec 31 is marked week_of_year=1) That is why this works.
    sql:
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date)::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '1 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '1 day')::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '2 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '2 day')::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '3 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '3 day')::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '4 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '4 day')::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '5 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '5 day')::integer - 1 + 7, 7))
      OR
      (${created_week_of_year} = EXTRACT(WEEK FROM (current_date - interval '6 day'))::int
      AND ${created_day_of_week_index} = MOD(EXTRACT(DOW FROM current_date - interval '6 day')::integer - 1 + 7, 7))
    ;;
  }

  dimension: period_comparison {
    hidden: yes
    case: {
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '1 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE());;
        label: "current_week"
      }
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '53 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE() - interval '52 week') ;;
        label: "last_year_same_week"
      }
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '105 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE() - interval '104 week') ;;
        label: "two_years_ago_same_week"
      }
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '157 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE() - interval '156 week') ;;
        label: "three_years_ago_same_week"
      }
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '209 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE() - interval '208 week') ;;
        label: "four_years_ago_same_week"
      }
      when: {
        sql: ${created_date} > DATE_TRUNC('day', GETDATE() - interval '2 week')
          AND ${created_date} <= DATE_TRUNC('day', GETDATE() - interval '1 week') ;; # 8/06
        label: "last_week"
      }
      else: "unknown"
    }
  }

  dimension_group: shift_time{
    hidden: yes
    label: "Shift Timescale"
    description: "Adjusts the Produced time to make 0700 to 0000. This sets the beginning of the day as the beginning of the shift. 0000 - 0100 is the first hour of the AM shift.
      Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw, time, date,hour_of_day, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(Dateadd(hour,-7,${TABLE}.Created));;
  }

  dimension_group: current {
    view_label: "Sales Order"
    label: "    Current"
    description:  "Current Time/Date for calculations. Source: looker.calculation"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, month, month_num, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;;
  }

  # dimension: current_week_of_year {
  #   ## Jared Dyer 1/14/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "    Current Week of Year"
  #   view_label: "Sales Order"
  #   group_label: "    Order Date"
  #   description: "2021 adjusted - current week of year number"
  #   sql: case when ${current_year::number}=2021 then date_part(weekofyear,${current_date}::date) + 1
  #   else date_part(weekofyear,${current_date::date}) end;;
  # }


  dimension: before_day_of_year {
    hidden: yes
    type: yesno
    sql: dayofyear(${created_raw}) < dayofyear(current_timestamp(1)) ;;
  }

  measure: last_updated_date_sales {
    type: date
    hidden: yes
    label: "Last Updated Sales"
    drill_fields: [sales_order_line.sales_order_details*]
    sql: MAX(${created_date}) ;;
    convert_tz: no
  }

  dimension: day_of_week {
    hidden:  yes
    label:  "Day of Week"
    description: "Abbreviated day of week (Sun, Mon, Tue, etc). Source: netsuite.sales_order_line"
    type: string
    case: {
      when: { sql: ${created_day_of_week} = 'Monday' ;; label: "Mon" }
      when: { sql: ${created_day_of_week} = 'Tuesday' ;;  label: "Tue" }
      when: { sql: ${created_day_of_week} = 'Wednesday' ;; label: "Wed" }
      when: { sql: ${created_day_of_week} = 'Thursday' ;; label: "Thu" }
      when: { sql: ${created_day_of_week} = 'Friday' ;; label: "Fri" }
      when: { sql: ${created_day_of_week} = 'Saturday' ;; label: "Sat" }
      when: { sql: ${created_day_of_week} = 'Sunday' ;; label: "Sun" }}
  }

  dimension: dayofquarterindex {   #returns day of quarter index int 1-92
    type: number
    view_label: "Sales Order"
    description: "Returns a date's number position in its quarter. Ex. Jan 1 = 1; Feb 1 = 32. Source: netsuite.sales_order_line"
    group_label: "    Order Date"
    label: "Day of Quarter"
    sql: DATEDIFF('day',date_trunc('quarter',${created_raw}),${created_date}) + 1 ;;
  }

    dimension: current_dayofquarterindex {   #returns day of quarter index int 1-92
      type: number
      hidden: yes
      description: "Returns a date's number position in its quarter. Ex. Jan 1 = 1; Feb 1 = 32. Source: netsuite.sales_order_line"
      sql: DATEDIFF('day',date_trunc('quarter',current_date),current_date) + 1 ;;
    }


  parameter: timeframe_picker{
    label: "Date Granularity Sales"
    hidden: yes
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date"
  }

  dimension: dynamic_timeframe {
    type: date
    allow_fill: no
    hidden: yes
    sql:
      CASE
      When {% parameter timeframe_picker %} = 'Date' Then ${created_date}
      When {% parameter timeframe_picker %} = 'Week' Then ${created_week}
      When {% parameter timeframe_picker %} = 'Month'Then ${created_month}||'-01'
      END;;
  }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 7 ;;
  }

  dimension: 30_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 30 ;;
  }

  dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 60 ;;
  }

  dimension: 90_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 90 ;;
  }

  measure: 7_day_sales {
    label: "7 Day Average (units)"
    description: "Units ordered in the last 7 days /7. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes" }
    sql: ${ordered_qty}/7 ;;
  }

  measure: 30_day_sales {
    label: "30 Day Average Sales (units)"
    description: "Units ordered in the last 30 days /30. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 30_day_window
      value: "yes" }
    sql: ${ordered_qty}/30 ;;
  }

  measure: 60_day_sales {
    label: "60 Day Average Sales (units)"
    description: "Units ordered in the last 60 days /60. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes" }
    sql: ${ordered_qty}/60 ;;
  }

  measure: 90_day_sales {
    label: "90 Day Average Sales (units)"
    description: "Units ordered in the last 90 days /90. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 90_day_window
      value: "yes" }
    sql: ${ordered_qty}/90 ;;
  }

    measure: 7_day_sales_dollar {
      label: "7 Day Average Sales ($)"
      description: "$ ordered in the last 7 days /7. Source: netsuite.sales_order_line"
      drill_fields: [order_details*]
      #view_label: "Time-slice totals"
      hidden: yes
      type: sum
      value_format_name: usd_0
      filters: {
        field: 7_day_window
        value: "yes" }
      sql: ${gross_amt}/7 ;;
    }

    measure: 30_day_sales_dollar {
      label: "30 Day Average Sales ($)"
      description: "$ ordered in the last 30 days /30. Source: netsuite.sales_order_line"
      drill_fields: [order_details*]
      #view_label: "Time-slice totals"
      hidden:  yes
      type: sum
      value_format_name: usd_0
      filters: {
        field: 30_day_window
        value: "yes" }
      sql: ${gross_amt}/30 ;;
    }


    measure: 90_day_sales_dollar {
      label: "90 Day Average Sales ($)"
      description: "$ ordered in the last 90 days /90. Source: netsuite.sales_order_line"
      drill_fields: [order_details*]
      #view_label: "Time-slice totals"
      hidden:  yes
      type: sum
      value_format_name: usd_0
      filters: {
        field: 90_day_window
        value: "yes" }
      sql: ${gross_amt}/90 ;;
    }

  dimension: rolling_7day {
    label: "Is in Last 7 Day"
    #view_label:  "x - report filters"
    hidden: yes
    description: "Filter to show just most recent 7 completed days. Source: netsuite.sales_order_line"
    type: yesno
    sql: ${created_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;;
  }

  dimension:  4_week_filter {
    label: "Is in Last 4 Weeks"
    #view_label:  "x - report filters"
    hidden: yes
    type:  yesno
    sql: ${created_date} >=
            case when dayofweek(current_date) = 6 then dateadd(day,-27,current_date)
              when dayofweek(current_date) = 5 then dateadd(day,-26,current_date)
              when dayofweek(current_date) = 4 then dateadd(day,-25,current_date)
              when dayofweek(current_date) = 3 then dateadd(day,-24,current_date)
              when dayofweek(current_date) = 2 then dateadd(day,-23,current_date)
              when dayofweek(current_date) = 1 then dateadd(day,-22,current_date)
              else dateadd(day,-21,current_date) end   ;;
  }

  dimension: department_id {
    hidden: yes
    description: "Internal department IDs (accounting). Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;;
  }

  dimension: discount_amt {
    hidden: yes
    description:  "Amount of discount to individual items applied at initial order. Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;;
  }

  dimension: discount_cancel_type {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;;
  }

  dimension: discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;;
  }

  dimension: estimated_cost {
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight. Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;;
  }

  dimension: retail_order_line_id {
    hidden:  yes
    label: "Shopify Order Line ID"
    description: "You can use this ID to look up orders in Shopify. Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension_group: fulfilled_old {
    view_label: "Fulfillment"
    label: "    Fulfilled1"
    hidden:  yes
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale. Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw,hour,date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FULFILLED ;;
  }

  dimension: fulfillment_method {
    label: "Fulfillment Method"
    description: "Use Shipping Provider instead. Source: netsuite.sales_order_line"
    view_label: "Fulfillment"
    hidden:  yes
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: location {
    label:  "Fulfillment Warehouse"
    group_label: " Advanced"
    description:  "Warehouse that order was fulfilled out of. Source:netsuite.sales_order_line"
    view_label: "Fulfillment"
    type: string
    sql: ${TABLE}.LOCATION ;;
  }

  dimension: memo {
    group_label: " Advanced"
    label:  "Memo"
    description:  "Notes field from the Shopify Draft Order Line. Source:netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.memo ;;
  }

  dimension: gross_amt {
    group_label: " Advanced"
    label: "Gross Sales Item Level ($)"
    description: "Gross sales is what the customer paid on initial order per sku, net of discounts, excluding tax, freight or other fees. Source:netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.gross_amt ;;
  }

  dimension: order_id {
    hidden: yes
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite. Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: ordered_qty {
    hidden: yes
    description: "Gross Sales (units). Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;;
  }

  dimension: pre_discount_amt {
    hidden:  yes
    label: "Pre-Discounted Price"
    description: "Price of item before any discounts or promotions are applied. Source: netsuite.sales_order_line"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;;
  }

  dimension: refund_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;;
  }

  dimension: street_address {
    view_label: "Customer"
    group_label: "  Customer Address"
    label: "Street Address"
    description: "Source: netsuite.sales_order_line"
    type: string
    sql: UPPER(${TABLE}.STREET_ADDRESS) ;;
    required_access_grants:[can_view_pii]
  }

  dimension: system {
    hidden: yes
    label: "Source System"
    description: "This is the system the data came from. Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  measure: Total_Average_Cost{
    hidden: yes
    type: sum
    description: "The average cost of the item at time of order creation. Source: netsuite.sales_order_line"
    drill_fields: [order_details*]
    value_format: "$#,##0"
    sql: ${TABLE}.AVERAGE_COST ;;
  }

  measure: Qty_Picked {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Picked (units)"
    type: sum
    drill_fields: [order_details*, sales_order_line.fulfill_details*]
    description: "The Qty of items that are in the picked state. Source:netsuite.sales_order_line"
    sql: ${TABLE}.PICKED ;;
  }

  measure: Qty_Committed {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Committed (units)"
    type: sum
    drill_fields: [order_details*, sales_order_line.fulfill_details*]
    description: "The Qty of items that are in the committed state. Source:netsuite.sales_order_line"
    sql: ${TABLE}.QUANTITY_COMMITTED ;;
  }

    dimension: is_committed {
      view_label: "Fulfillment"
      group_label: "By Status"
      label: "Is Committed"
      type: yesno
      drill_fields: [order_details*, sales_order_line.fulfill_details*]
      description: "Yes when committed units is > 0. Source:netsuite.sales_order_line"
      sql: ${TABLE}.QUANTITY_COMMITTED>0 ;;
    }

  measure: Qty_Packed {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Packed (units)"
    type: sum
    drill_fields: [order_details*, sales_order_line.fulfill_details*]
    description: "The Qty of items that are in the packed state. Source:netsuite.sales_order_line"
    sql: ${TABLE}.PACKED ;;
  }

  dimension:  is_packed {
    view_label: "Fulfillment"
    hidden: no
    type: yesno
    sql: ${TABLE}.PACKED=${TABLE}.ordered_qty ;;
  }

  dimension: state {
    view_label: "Customer"
    group_label: "  Customer Address"
    description: "Source: netsuite.sales_order_line"
    type: string
    map_layer_name: us_states
    sql: UPPER(${TABLE}.STATE) ;;
  }

  dimension: cntry {
    view_label: "Customer"
    group_label: "  Customer Address"
    description: "Source: netsuite.sales_order_line"
    label: "Country"
    type: string
    sql: ${TABLE}.COUNTRY ;;
  }

  dimension: zip {
    view_label: "Customer"
    group_label: "  Customer Address"
    label: "Zipcode (5)"
    description: "Source: netsuite.sales_order_line"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: split_part(${TABLE}.ZIP,'-',1) ;;
  }

  dimension: zip_1 {
    view_label: "Geography"
    label: "Zipcode (5)"
    group_label: "Advanced"
    description: "5-digit ship-to zipcode. Source:netsuite.sales_order_line"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: split_part(${TABLE}.ZIP,'-',1) ;;
  }

 dimension: carrier_raw {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Carrier (raw)"
    description: "Netsuite Carrier field. Source:netsuite.sales_order_line"
    #hidden: yes
    type: string
    sql: ${TABLE}.CARRIER ;;
  }

  dimension: carrier {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Carrier (expected)"
    description: "Derived field based on fulfillment location. Source:netsuite.sales_order_line"
    hidden: yes
    type: string
    sql: case
          when ${location} ilike '%mainfreight%' then 'MainFreight'
          when ${location} ilike '%xpo%' then 'XPO'
          when ${location} ilike '%pilot%' then 'Pilot'
          when ${location} is null then 'FBA'
          when ${location} ilike '%100-%' AND ${carrier_raw} ilike '%purple home%' then 'Purple Home Delivery'
          when ${location} ilike '%101-%' AND ${carrier_raw} ilike '%purple home%' then 'Purple Home Delivery'
          when ${location} ilike '%200-%' AND ${carrier_raw} ilike '%purple home%' then 'Purple Home Delivery'
          when ${location} ilike '%201-%' AND ${carrier_raw} ilike '%purple home%' then 'Purple Home Delivery'
          when ${location} ilike '%nehds%' then 'NEHDS'
          when ${location} ilike '%ryder%' then 'Ryder'
          when ${location} ilike  '%speedy%' then'Speedy Delivery'
          when ${location} ilike '%select%' then 'Select Express'
          when ${location} ilike '%crst%' then 'CRST'
          when ${location} ilike  '%fragilepak%' then 'FragilePak'
          when ${location} ilike '%101-%' AND ${carrier_raw} ilike '%fragilepak%' then 'FragilePak'
          when ${location} ilike '%100-%' then 'Purple'
          when ${location} ilike '%200-%' then 'Purple'
          when ${location} ilike '%le store%' or ${location} ilike '%howroom%' then 'Store take-with'
          else 'Other' end ;;
  }

  dimension: DTC_carrier {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Carrier (Grouping)"
    description: "From Netsuite sales order line, the carrier field grouped into Purple, XPO, and Pilot. Source:netsuite.sales_order_line"
    hidden: no
    type: string
    sql:  CASE WHEN upper(coalesce(${carrier_raw},'')) not in ('XPO','MANNA','PILOT','MAINFREIGHT','PURPLE HOME DELIVERY','SPEEDY DELIVERY','RYDER','FRAGILEPAK','NEHDS') THEN 'Purple' Else ${carrier} END;;
  }

  dimension: ship_flag {
    view_label: "Fulfillment"
    group_label: "Website SLAs"
    label: "Standard Shipping Flag"
    type: yesno
    sql: ${DTC_carrier} in ('Purple','Mainfreight','Will Call','Carry Out') ;;
  }

  dimension: week_2019_start {
    hidden: yes
    group_label: "Created Date"
    label: "z - Week Start 2019"
    description: "Looking at the week of year for grouping (including all time) but only showing 2019 week start date.  Source: netsuite.sales_order_line"
    type: string
    sql: to_char( ${TABLE}.created,'MON-DD');;
  }

  dimension: line_shipping_method {
    hidden: no
    group_label: " Advanced"
    view_label: "Fulfillment"
    description: "Shipping method from shopify. Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.line_shipping_method;;
  }

  dimension: IS_3PL_TRANSMIT_SUCCESS {
    hidden: no
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "3PL Transmitted Success"
    description: "Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.IS_3PL_TRANSMIT_SUCCESS;;
  }

  dimension: TRANSMITTED_TO_ID {
    hidden: no
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "3PL Transmitted To ID"
    description: "Source: netsuite.sales_order_line"
    type: string
    sql: ${TABLE}.TRANSMITTED_TO_ID;;
  }

  dimension_group: N_3PL_TRANSMITTED {
    hidden:  no
    view_label: "Fulfillment"
    label: "3PL Transmitted"
    description: "Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw,hour,date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.N_3PL_TRANSMITTED ;;
  }

    measure: kit_total_units {
      description: "This is used for the forecast_combined and actual_sales explore.  It is break the kits/packages back to their child items"
      type: sum
      hidden: no
      sql:
        case
          --BASE
          when ${item_id} in ('9809') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9816') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9824') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('10391') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('11511') then ${TABLE}.ordered_qty*2
          --BEDDING
          when ${item_id} in ('9783') then ${TABLE}.ordered_qty*4
          when ${item_id} in ('9800') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9813') then ${TABLE}.ordered_qty*2
          --KIT
          when ${item_id} in ('9781') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9782') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9785') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9790') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9791') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9794') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9795') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9796') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9798') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9799') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9801') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9802') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9804') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9805') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9806') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9807') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9810') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9814') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9821') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9822') then ${TABLE}.ordered_qty*1
          --MATTRESS
          when ${item_id} in ('9786') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9787') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9789') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9792') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9803') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9808') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9815') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9818') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('9820') then ${TABLE}.ordered_qty*2
          when ${item_id} in ('11262') then ${TABLE}.ordered_qty*2
          --SALES SUPPORT
          when ${item_id} in ('9793') then ${TABLE}.ordered_qty*50
          when ${item_id} in ('9811') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9817') then ${TABLE}.ordered_qty*10
          when ${item_id} in ('9823') then ${TABLE}.ordered_qty*25
          when ${item_id} in ('10281') then ${TABLE}.ordered_qty*60
          --SEATING
          when ${item_id} in ('9784') then ${TABLE}.ordered_qty*6
          when ${item_id} in ('9788') then ${TABLE}.ordered_qty*6
          when ${item_id} in ('9797') then ${TABLE}.ordered_qty*6
          when ${item_id} in ('9812') then ${TABLE}.ordered_qty*6
          when ${item_id} in ('9819') then ${TABLE}.ordered_qty*6
          when ${item_id} in ('9825') then ${TABLE}.ordered_qty*4
          --Z-MARKETING
          when ${item_id} in ('3502') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('3504') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('3429') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('3430') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('3497') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('3499') then ${TABLE}.ordered_qty*1
          --OTHER
          when ${item_id} in ('11107') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('5863') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('5862') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('5866','5869') then ${TABLE}.ordered_qty*1
          when ${item_id} in ('9077') then ${TABLE}.ordered_qty*1
          else ${TABLE}.ordered_qty end;;
    }


    dimension: is_locked {
      view_label: "Fulfillment"
      label: "     * Is Locked"
      group_label: " Advanced"
      description: "Identifies items on orders that are locked by fulfillment"
      type: yesno
      sql: ${TABLE}.LOCKED ;;
    }


  set: order_details {
    fields: [sales_order_line.sales_order_details*]
  }

}
