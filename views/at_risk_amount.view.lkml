view: at_risk_amount {
  derived_table: {
    sql:
      select a.date
    , z.*
from util.warehouse_date a
left join (
  select
    sol.order_id
    , sol.item_id
    , sum(sol.gross_amt) as total_amount
    , min(sol.created::date) as created
    , min(dateadd('day',14,sol.created::date)) as created14
    , max(coalesce(sol.fulfilled, dateadd('day',1,current_date))) as ff
  from sales.sales_order_line sol
  where sol.created >= '2019-01-01'
  group by 1,2
) z on z.created14 <= a.date and z.ff > a.date
where a.date between '2019-01-01' and current_date
order by 1,2
    ;;
  }

  dimension_group: date {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.date ;;
  }

  dimension: order_id {
    hidden: yes
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: item_id {
    hidden: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension_group: created14 {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created14 ;;
  }

  dimension_group: ff {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.ff ;;
  }

  measure: total_amount {
    label: "At Risk Amount"
    group_label: "Sales Order"
    type: sum
    sql: ${TABLE}.total_amount ;;
  }

}
