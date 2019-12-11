#-------------------------------------------------------------------
# Owner - Aditya Kannan
# Use pulling the sales amounts from netsuite and comparing to our
#   sales dataset
#-------------------------------------------------------------------
view: agg_check_wholesale {
  derived_table: {
    sql: select to_date(ful.created) as DATE
    , sum (l.gross_amt) as ANALYTICS_FULFILLED_WHOLESALE
    , max (f.amount) as NETSUITE_FULFILLED_WHOLESALE
    from analytics.sales.sales_order s
    join analytics.sales.sales_order_line l on s.order_id = l.order_id
    LEFT JOIN sales.fulfillment ful ON l.order_id = ful.order_id AND l.item_id = ful.item_id AND l.system = ful.system
    join (
    select  a.date as date,
    max(a.amount) as amount
    from analytics.agg_check.DAILY_CHANNEL_SALES_CHECK  a
    where a.CHANNEL_NAME = '2-Wholesale'
    and to_date(a.date) = dateadd(day,-2,current_date)
    and a.extracted_system = 'NETSUITE'
    group by 1
    ) f on to_date(ful.created) = to_date(f.date)
    where s.system = 'NETSUITE'
    and s.channel_id = 2
    and to_date(ful.created) = dateadd(day,-2,current_date)
    group by 1;; }

  measure:DATE   {
    sql: ${TABLE}.DATE ;;  }

  measure:ANALYTICS_FULFILLED_WHOLESALE   {
    sql: ${TABLE}.ANALYTICS_FULFILLED_WHOLESALE ;;  }

  measure:NETSUITE_FULFILLED_WHOLESALE   {
    sql: ${TABLE}.NETSUITE_FULFILLED_WHOLESALE ;;  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${DATE}, ${ANALYTICS_FULFILLED_WHOLESALE}, ${NETSUITE_FULFILLED_WHOLESALE}) ;;
  }

 }
