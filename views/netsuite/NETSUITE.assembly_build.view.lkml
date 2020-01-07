view: assembly_build {
  sql_table_name: PRODUCTION.BUILD ;;

  dimension: assembly_build_id {
    label: "  Assembly Build Id"
    primary_key: yes
    description: "Netsuites transaction ID, used to hyperlink directly to record"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    hidden:  no
    type: number

    sql: ${TABLE}.build_id ;;}

  dimension: accounting_period_id {
    hidden: yes
    type: number
    sql: ${TABLE}.accounting_period_id ;; }

  dimension: amount {
    hidden: yes
    type: number
    sql: ${TABLE}.amount ;; }

  dimension_group: created {
    label: "   Created"
    hidden: no
    description: "When in NetSuite the Transaction was created"
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension_group: deleted {
    hidden: yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.deleted ;; }

  dimension: description {
    label: "Description"
    hidden: yes
    type: string
    sql: ${TABLE}.description ;; }

  dimension: type {
    label: "  Transaction Type"
    description: "The build type. Assembly builds are positive and unbuilds are negative"
    hidden: no
    type: string
    sql: ${TABLE}.type ;; }

  dimension: created_by {
    label: "Created By"
    group_label: "Advanced"
    description: "What NetSuite account created the Transaction"
    type: string
    sql: ${TABLE}.CREATED_BY ;; }


  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.insert_ts ;; }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: location_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_id ;; }

  dimension: memo {
    label: "Memo"
    group_label: "Advanced"
    description: "Notes on the Assembly Transaction"
    type: string
    sql: ${TABLE}.memo ;; }

  dimension_group: modified {
    hidden: yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.modified ;;
  }

  dimension_group: produced {
    type: time
    description: "A mixed timestamp between created and when the iPad reported it created. iPad first then if no data created timestamp"
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql:  to_timestamp_ntz(${TABLE}.PRODUCED);;
 }

  dimension: Before_today{
    group_label: "Produced Date"

    label: "z - Is Before Today (mtd)"
    type: yesno
    sql: ${TABLE}.PRODUCED < current_date;; }

  dimension: last_30{
    group_label: "Produced Date"
    label: "z - Last 30 Days"
    type: yesno
    sql: ${TABLE}.PRODUCED > dateadd(day,-30,current_date);; }

  dimension: week_2019_start {
    group_label: "Produced Date"
    label: "z - Week Start 2019"
    description: "Looking at the week of year for grouping (including all time) but only showing 2019 week start date."
    type: string
    sql: to_char( ${TABLE}.week_start_2019,'MON-DD');; }

  dimension: current_week_num{
    group_label: "Produced Date"
    label: "z - Before Current Week"
    type: yesno
    sql: ${TABLE}.PRODUCED::date <= '2020-01-05' ;;}
    #sql: date_part('week',${TABLE}.PRODUCED) < date_part('week',current_date);; }
    #sql: date_part('week',${TABLE}.PRODUCED) < 53;; }

  dimension: prev_week{
    group_label: "Produced Date"
    label: "z - Previous Week"
    type: yesno
    sql:  ${TABLE}.PRODUCED::date >= '2019-12-30' and ${TABLE}.PRODUCED::date <= '2020-01-05' ;; }
    #sql: date_part('week',${TABLE}.PRODUCED) = date_part('week',current_date)-1;; }
    #sql: date_part('week',${TABLE}.PRODUCED) = 52;; }

  dimension: week_bucket{
    group_label: "Produced Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
#     sql:  CASE WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, current_date) THEN 'Current Week'
#             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
#             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
#             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(year, -1, current_date)) THEN 'Current Week LY'
#             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Last Week LY'
#             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(week, -2, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
#             ELSE 'Other' END ;; }
  sql: case
  when ${TABLE}.PRODUCED::date >= '2020-01-06' and ${TABLE}.PRODUCED::date <= '2020-01-12' then 'Current Week'
  when ${TABLE}.PRODUCED::date >= '2019-12-30' and ${TABLE}.PRODUCED::date <= '2020-01-05' then 'Last Week'
  when ${TABLE}.PRODUCED::date >= '2019-12-23' and ${TABLE}.PRODUCED::date <= '2019-12-29' then 'Two Weeks Ago'
  when ${TABLE}.PRODUCED::date >= '2019-01-07' and ${TABLE}.PRODUCED::date <= '2019-01-13' then 'Current Week LY'
  when ${TABLE}.PRODUCED::date >= '2018-12-31' and ${TABLE}.PRODUCED::date <= '2019-01-06' then 'Last Week LY'
  when ${TABLE}.PRODUCED::date >= '2018-12-24' and ${TABLE}.PRODUCED::date <= '2018-12-30' then 'Two Weeks Ago LY'
  else 'Other' end ;; }

#   case when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) then 'Current Week'
#         when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) -1 then 'Last Week'
#         when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
#         when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) then 'Current Week LY'
#         when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) -1 then 'Last Week LY'
#         when date_part('year', ${TABLE}.PRODUCED::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.PRODUCED::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
#         else 'Other' end;; }


  dimension_group: shift_time{
    label: "Shift Timescale"
    description: "Adjusts the Produced time to make 0700 to 0000. This sets the beginning of the day as the beginning of the shift. 0000 - 0100 is the first hour of the AM shift."
    type: time
    timeframes: [raw, time, date,hour_of_day, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(Dateadd(hour,-7,${TABLE}.created));;
 }

  dimension: shifts {
    label: "Shifts"
    group_label: "Advanced"
    description: "Buckets the Shift time into shift buckets"
    type: string
    sql: case
    when DATE_PART('hour', ${shift_time_raw}) < 13 and Dayname(${shift_time_raw}) in ('Mon', 'Tue', 'Wed') then 'M-W Day'
    when DATE_PART('hour', ${shift_time_raw}) < 13 and Dayname(${shift_time_raw}) in ('Thu', 'Fri', 'Sat') then 'Th-Sa Day'
    when DATE_PART('hour', ${shift_time_raw}) > 12 and Dayname(${shift_time_raw}) in ('Mon', 'Tue', 'Wed') then 'M-W Night'
    when DATE_PART('hour', ${shift_time_raw}) > 12 and Dayname(${shift_time_raw}) in ('Thu', 'Fri', 'Sat') then 'Th-Sa Night'
    else 'Sunday' end ;; }


  parameter: timeframe_picker{
    label: "Date Granularity Assembly Build"
    hidden: yes
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date" }

  dimension: dynamic_timeframe {
    hidden: yes
    type: date
    allow_fill: no
    sql:
      CASE
      When {% parameter timeframe_picker %} = 'Date' Then ${produced_date}
      When {% parameter timeframe_picker %} = 'Week' Then ${produced_week}
      When {% parameter timeframe_picker %} = 'Month' Then ${produced_month}||'-01'
      END;; }


  dimension: quantity {
    hidden: yes
    type: number
    sql: ${TABLE}.quantity ;; }

  dimension_group: sales_effective {
    label: "Sales Effective"
   hidden: yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.sales_effective ;;
  }

  dimension: scrap {
    hidden: yes
    type: number
    sql: ${TABLE}.scrap ;;
  }

  dimension_group: trandate {
    hidden:  yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.trandate ;; }

  dimension: tranid {
    label: "Transaction ID"
    hidden: yes
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{assembly_build_id._value}}&whence="}
    type: number
    value_format_name: id
    sql: ${TABLE}.tranid ;; }

  dimension: transaction_number {
    label: "  Transaction Number"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{assembly_build_id._value}}&whence="}
    type: string
    sql: ${TABLE}.transaction_number ;; }

  dimension_group: update_ts {
    hidden:  yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.update_ts ;; }

  measure: count {
    type: count
    hidden:  yes
    drill_fields: [assembly_build_id] }

  measure: Total_Quantity {
    label: "Total Quantity"
    type: sum
    drill_fields: [transaction_number, sales_order.tranid, created_date,  item.product_description, sales_order.source, Total_Quantity,Total_amount]
    sql: ${TABLE}.QUANTITY ;;
  }

  measure: Ave_Quantity {
    hidden: yes
    label: "Average Quantity"
    type: average
    sql: ${TABLE}.QUANTITY ;;
  }


  measure: Total_amount {
    label: "Total Amount ($)"
    type: sum
    sql: ${TABLE}.AMOUNT ;;
  }
}
