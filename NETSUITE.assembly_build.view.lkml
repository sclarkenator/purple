view: assembly_build {
  sql_table_name: PRODUCTION.ASSEMBLY_BUILD ;;

  dimension: assembly_build_id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}.assembly_build_id ;;}

  dimension: accounting_period_id {
    hidden: yes
    type: number
    sql: ${TABLE}.accounting_period_id ;; }

  dimension: amount {
    hidden: yes
    type: number
    sql: ${TABLE}.amount ;; }

  dimension_group: created {
    hidden: no
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
    type: string
    sql: ${TABLE}.description ;; }

  dimension: created_by {
    label: "Created By"
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
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql:  to_timestamp_ntz(${TABLE}.PRODUCED);;
 }

  dimension_group: shift_time{
    label: "Shift Timescale"
    description: "Adjusts the Produced time to make 0700 to 0000. This sets the beginning of the day as the beginning of the shift. 0000 - 0100 is the first hour of the AM shift."
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(Dateadd(hour,-7,${TABLE}.created));;
 }


  parameter: timeframe_picker{
    label: "Date Granularity Assembly Build"
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date" }

  dimension: dynamic_timeframe {
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
    description: "Netsuites transaction ID, used to hyperlink directly to record"
    type: number
    value_format_name: id
    sql: ${TABLE}.tranid ;; }

  dimension: transaction_number {
    label: "Transaction Number"
    type: string
    sql: ${TABLE}.transaction_number ;; }

  dimension_group: update_ts {
    hidden:  yes
    type: time
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.update_ts ;; }

  measure: count {
    type: count
    drill_fields: [assembly_build_id] }

  measure: Total_Quantity {
    label: "Total Quantity"
    type: sum
    sql: ${TABLE}.QUANTITY ;;
  }

  measure: Total_amount {
    label: "Total Amount ($)"
    type: sum
    sql: ${TABLE}.AMOUNT ;;
  }
}
