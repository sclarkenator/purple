#-------------------------------------------------------------------
# Owner - Scott Clark
# Mattress firm sales
#-------------------------------------------------------------------

view: mattress_firm_sales {
  #sql_table_name: mattress_firm.sales_data ;;
  derived_table: {
    sql:
      --Adding sales
      select z.date as finalized_date
          , z.store
          , y.product_id
          , nvl(final_units,0) as final_units
          , z.open_date
          , z.close_date
      from (
        --list of stores by date (filling in blanks)
        select z.date, a.store, a.first_sale as open_date, a.last_sale as close_date
        from util.warehouse_date z
        left join (
          --store open and close dates
          select store
            , min(finalized_date::date) as first_sale
            , max(finalized_date::date) as last_sale
          from mattress_firm.sales_data
          group by 1
        ) a on a.first_sale <= z.date and case when dateadd('day',60,last_sale) > current_date then current_date else last_sale end >= z.date
        where z.date < current_date and a.store is not null
        order by 2,1
      ) z
      left join mattress_firm.sales_data y on y.store = z.store and y.finalized_date::date = z.date
    ;;
  }

  dimension: key {
    primary_key: yes
    hidden: yes
    type: string
    sql:${TABLE}.product_id ||'-'|| ${TABLE}.store ||'-'||${TABLE}.finalized_date;; }
# I removed the nvl wrapper on product_id above nvl(product_id,"000") because I was getting an error. I don't have time to fix this right now. Scott

  dimension: mf_sku{
    hidden:  yes
    type:  string
    sql:  ${TABLE}.mf_Sku ;; }

  dimension_group: finalized{
    label: "Order"
    description: "When order was placed @ Mattress Firm"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.finalized_date ;; }

  dimension_group: open_date{
    label: "Store Open"
    description: "When order was placed @ Mattress Firm"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.open_date ;; }

  dimension_group: close_date{
    label: "Store Close"
    description: "When order was placed @ Mattress Firm"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.close_date ;; }

  dimension: store {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.store ;; }

  dimension: product_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.product_id ;; }

  measure: final_units {
    label: "Units"
    description: "Total units sold (finalized) to customer"
    type:  sum
    sql:  ${TABLE}.final_units ;; }

dimension: promo_date_bucket {
    label: "Promo Date Buckets"
    description: "A manual bucketing of the major promos; Memorial Day, Labor day, and Thanksgiving"
    #hidden: yes
    sql: case
        when ${TABLE}.finalized_date::date between '2018-11-14' and '2018-11-17' then '18 TG 1 WB'
        when ${TABLE}.finalized_date::date between '2018-11-20' and '2018-11-21'
          or ${TABLE}.finalized_date::date between '2018-11-24' and '2018-11-25' then '18 TG 2 PM'
        when ${TABLE}.finalized_date::date = '2018-11-22' then '18 TG'
        when ${TABLE}.finalized_date::date = '2018-11-23' then '18 BF'
        when ${TABLE}.finalized_date::date = '2018-11-26' then '18 CM'
        when ${TABLE}.finalized_date::date between '2019-05-05' and '2019-05-10' then '19 MD WB'
        when ${TABLE}.finalized_date::date between '2019-05-20' and '2019-05-26' then '19 MD PM'
        when ${TABLE}.finalized_date::date = '2019-05-27' then '19 MD'
        when ${TABLE}.finalized_date::date between '2019-08-08' and '2019-08-14' then '19 LD WB'
        when ${TABLE}.finalized_date::date between '2019-08-25' and '2019-09-01' then '19 LD PM'
        when ${TABLE}.finalized_date::date = '2019-09-02' then '19 LD'
        when ${TABLE}.finalized_date::date between '2019-11-08' and '2019-11-14' then '19 TG WB'
        when ${TABLE}.finalized_date::date between '2019-11-23' and '2019-11-27'
          or ${TABLE}.finalized_date::date between '2019-11-30' and '2019-12-01' then '19 TG PM'
        when ${TABLE}.finalized_date::date = '2019-11-28' then '19 TG'
        when ${TABLE}.finalized_date::date = '2019-11-29' then '19 BF'
        when ${TABLE}.finalized_date::date = '2019-12-02' then '19 CM'
        else 'Other' end  ;; }

  dimension: promo_date_holliday {
    label: "Promo Date Holiday"
    description: "A manual bucketing of the major promos; Memorial Day, Labor day, and Thanksgiving"
    #hidden: yes
    sql: case
        when ${TABLE}.finalized_date::date between '2018-11-14' and '2018-11-17'
          or ${TABLE}.finalized_date::date between '2018-11-20' and '2018-11-26' then '18 Thanksgiving'
        when ${TABLE}.finalized_date::date between '2019-05-05' and '2019-05-10'
          or ${TABLE}.finalized_date::date between '2019-05-20' and '2019-05-27' then '19 Memorial Day'
        when ${TABLE}.finalized_date::date between '2019-08-08' and '2019-08-14'
          or ${TABLE}.finalized_date::date between '2019-08-25' and '2019-09-02' then '19 Labor Day'
        when ${TABLE}.finalized_date::date between '2019-11-08' and '2019-11-14'
          or ${TABLE}.finalized_date::date between '2019-11-23' and '2019-12-02' then '19 Thanksgiving'
        else 'Other' end  ;; }

    dimension: promo_date_type {
    label: "Promo Date Type"
    description: "A manual bucketing of the major promos in types; Week Before, Promo Period, Holliday"
    #hidden: yes
    sql: case
        when ${TABLE}.finalized_date::date between '2018-11-14' and '2018-11-17'
          or ${TABLE}.finalized_date::date between '2019-05-05' and '2019-05-10'
          or ${TABLE}.finalized_date::date between '2019-08-08' and '2019-08-14'
          or ${TABLE}.finalized_date::date between '2019-11-08' and '2019-11-14' then 'Week Before'
        when ${TABLE}.finalized_date::date between '2018-11-20' and '2018-11-21'
          or ${TABLE}.finalized_date::date between '2018-11-24' and '2018-11-25'
          or ${TABLE}.finalized_date::date between '2019-05-20' and '2019-05-26'
          or ${TABLE}.finalized_date::date between '2019-08-25' and '2019-09-01'
          or ${TABLE}.finalized_date::date between '2019-08-25' and '2019-09-01'
          or ${TABLE}.finalized_date::date = '2019-11-28'
          or ${TABLE}.finalized_date::date = '2018-11-22'
          or ${TABLE}.finalized_date::date between '2019-11-23' and '2019-11-27'
          or ${TABLE}.finalized_date::date between '2019-11-30' and '2019-12-01' then 'Promo'
        when ${TABLE}.finalized_date::date = '2018-11-23'
          or ${TABLE}.finalized_date::date = '2018-11-26'
          or ${TABLE}.finalized_date::date = '2019-05-27'
          or ${TABLE}.finalized_date::date = '2019-09-02'
          or ${TABLE}.finalized_date::date = '2019-11-29'
          or ${TABLE}.finalized_date::date = '2019-12-02' then 'Holliday'
        else 'Other' end  ;; }

  #measure: transaction_count {
  #  label: "Transaction Count"
  #  type: count }

}
