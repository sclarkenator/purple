include: "/views/_period_comparison.view.lkml"
view: assembly_build {
  # sql_table_name: analytics.production.v_assembly_build ;;
  sql_table_name: analytics.production.v_work_order ;;
  extends: [_period_comparison]

  parameter: see_data_by {
    description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
    hidden: yes
    type: unquoted
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
    allowed_value: {
      label: "Warehouse Location"
      value: "warehouse_location"
    }
    allowed_value: {
      label: "Product Model"
      value: "model"
    }
  }

  dimension: see_data {
    label: "See Data By"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${produced_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${produced_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${produced_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${produced_quarter}
    {% elsif see_data_by._parameter_value == 'year' %}
      ${produced_year}
    {% elsif see_data_by._parameter_value == 'warehouse_location' %}
      ${warehouse_location.location_name}
    {% elsif see_data_by._parameter_value == 'model' %}
      ${item.model_raw}
    {% else %}
      ${produced_date}
    {% endif %};;
  }

#### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,week,
      month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.produced ;;
  }

  dimension: assembly_build_id {
    label: "  ID"
    primary_key: yes
    description: "Netsuites transaction ID, used to hyperlink directly to record"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    hidden:  no
    type: number

    sql: ${TABLE}.id ;;}

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
    timeframes: [raw, hour, hour_of_day, date, day_of_week, week_of_year, day_of_month, week, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created::date ;; }

  dimension_group: current {
    label: "Current"
    description:  "Current Time/Date for calculations"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: current_date ;; }

  dimension_group: created_time {
    label: "   Created"
    hidden: no
    description: "When in NetSuite the Transaction was created"
    type: time
    timeframes: [raw, time]
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

  # dimension: type {
  #   label: "  Transaction Type"
  #   description: "The build type. Assembly builds are positive and unbuilds are negative"
  #   hidden: no
  #   type: string
  #   sql: ${TABLE}.type ;; }

  dimension: created_by {
    label: "Created By"
    group_label: "Advanced"
    description: "What NetSuite account created the Transaction"
    type: string
    sql: ${TABLE}.CREATED_BY ;; }

  dimension: source {
    label: "Source"
    description: "Where the transaction originated: Assembly Build vs Work Order"
    type: string
    sql: ${TABLE}.SOURCE ;; }


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
    ##Scott Clark 1/8/21 removed week_of_year for 2021 adjustment. need to rollback last week in 2021
    type: time
    description: "A mixed timestamp between created and when the iPad reported it created. iPad first then if no data created timestamp"
    timeframes: [raw, hour, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, month, month_num, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: timestamp
    sql:  to_timestamp_ntz(${TABLE}.PRODUCED);;
 }

  # dimension: produced_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "Week of Year"
  #   group_label: "Produced Date"
  #   description: "2021 adjusted week of year number"
  #   sql: case when ${produced_date::date} >= '2020-12-28' and ${produced_date::date} <= '2021-01-03' then 1
  #             when ${produced_year::number}=2021 then date_part(weekofyear,${produced_date::date}) + 1
  #             else date_part(weekofyear,${produced_date::date}) end ;;
  # }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "Produced Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${produced_date::date} >= '2020-12-28' and ${produced_date::date} <= '2021-01-03' then 2021 else ${produced_year::number} end   ;;
  }



  measure: last_updated_date_produced {
    type: date
    label: "Last Updated Produced"
    sql: MAX(${produced_date}) ;;
    convert_tz: no
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
    sql: date_trunc(week, ${TABLE}.PRODUCED::date) < date_trunc(week, current_date) ;;}

  dimension: prev_week{
    group_label: "Produced Date"
    label: "z - Previous Week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.PRODUCED::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: week_bucket_old{
    group_label: "Produced Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.PRODUCED::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: week_bucket{
    group_label: "Produced Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) AND ${produced_year} = date_part (year,current_date) THEN 'Current Week'
             WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) -1 AND ${produced_year} = date_part (year,current_date) THEN 'Last Week'
             WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) -2 AND ${produced_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
             WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) AND ${produced_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
             WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) -1 AND ${produced_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
             WHEN ${produced_week_of_year} = date_part (weekofyear,current_date) -2 AND ${produced_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;
  }


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
