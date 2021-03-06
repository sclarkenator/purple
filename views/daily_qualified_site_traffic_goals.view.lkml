view: daily_qualified_site_traffic_goals {
   derived_table: {
     sql: with a as
(select concat(month(date),'-',year(date)) as monthdate , sum(dtc) as month_total
from CSV_UPLOADS.finance_targets
group by 1)
, b as
(select date, concat(month(date),'-',year(date)) as monthdate, dtc
  from CSV_UPLOADS.finance_targets ),
  -- the traffic goals below
  c as (
    select  d.date
    , t.goal
    , z.monthdate
    from csv_uploads.qualified_traffic_targets t
      left join (
      select  t.start_date
          , count(d.date) as days_in_window
      , concat(month(date),'-',year(date)) as monthdate
      from csv_uploads.qualified_traffic_targets t
      left join util.warehouse_date d on d.date >= t.start_date and d.date <= t.end_date
      group by 1,3
      ) z on z.start_date = t.start_date
   left join util.warehouse_date d on d.date >= t.start_date and d.date <= t.end_date
   order by 1,2)

select distinct(b.date),
--b.dtc,
--(b.dtc/a.month_total) as dailypercent,
(b.dtc/a.month_total)*c.goal as Traffic_Goal
--, c.goal, a.month_total
--,sum(dtc) as total_dtc, sum(traffic_goal) as total_traffic
from b left join a on b.monthdate = a.monthdate
left join c on b.monthdate = c.monthdate
       ;; }

   dimension: date {
     type: date
     label: "Target Date"
    description: "Use this date for filtering the Qualified Traffic Goal"
    group_label: "Advanced"
     sql: ${TABLE}.date ;;
    hidden: yes
    primary_key: yes
   }


  dimension_group: date_set {
    type: time
    label: "Traffic Target"
    description: "Use this date for filtering the Qualified Traffic Goal. Source: looker calculation"
    group_label: "Traffic Target"
    timeframes: [date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;;
  }

   measure: traffic_goal {
     label: "Qualified Traffic Goal"
     description: "Qualified Traffic needed to hit Sales; filter with 'Target Date'. Source: looker calculation"
     type: sum
     sql: ${TABLE}.Traffic_goal ;;
    value_format: "0"
   }
 }
