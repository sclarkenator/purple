#-------------------------------------------------------------------
# Owner - Scott Clark
# Mattress firm sales
#-------------------------------------------------------------------

view: mattress_firm_sales {
  sql_table_name: mattress_firm.sales_data ;;

  dimension: key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.product_id||'-'|| ${TABLE}.store||'-'||${TABLE}.finalized_date;; }


  dimension: mf_sku{
    hidden:  yes
    type:  string
    sql:  ${TABLE}.mf_Sku ;; }

  dimension_group: finalized{
    label: "Order date"
    description: "When order was placed @ Mattress Firm"
    type:  time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.finalized_date ;; }

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
    group_label: " Advanced"
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
    label: "Promo Date Holliday"
    description: "A manual bucketing of the major promos; Memorial Day, Labor day, and Thanksgiving"
    group_label: " Advanced"
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
    group_label: " Advanced"
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
