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
    hidden: yes
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
    timeframes: [raw, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql:to_timestamp_ntz(${TABLE}.PRODUCED) ;; }

#---------------------------------------------------
  parameter: timeframe_picker{
    label: "Date Granularity Assembly Build"
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date"
  }

  dimension: dynamic_timeframe {
    type: date
    allow_fill: no
    sql:
      CASE
      When {% parameter timeframe_picker %} = 'Date' Then ${produced_date}
      When {% parameter timeframe_picker %} = 'Week' Then ${produced_week}
      When {% parameter timeframe_picker %} = 'Month' Then ${produced_month}||'-01'
      END;;
  }


  dimension: quantity {
    hidden: yes
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension_group: sales_effective {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SALES_EFFECTIVE" ;;
  }

  dimension: scrap {
    hidden: yes
    type: number
    sql: ${TABLE}."SCRAP" ;;
  }

  dimension_group: trandate {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."TRANDATE" ;;
  }

  dimension: tranid {
    type: number
    value_format_name: id
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension_group: update_ts {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: [assembly_build_id]
  }

  measure: Total_Quantity {
    type: sum
    description: "Number of items"
    sql: ${TABLE}."QUANTITY" ;;
  }

  measure: Total_amount {
    type: sum
    description: "Dollar value of the items"
    sql: ${TABLE}."AMOUNT" ;;
  }
}
