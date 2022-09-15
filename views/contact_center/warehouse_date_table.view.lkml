include: "/views/_period_comparison.view.lkml"
view: warehouse_date_table {
  extends: [_period_comparison]
  sql_table_name: "UTIL"."WAREHOUSE_DATE"
    ;;

  set: default_fields {
    fields: [
      date_date,
      date_month,
      date_week,
      date_quarter,
      date_year
    ]
  }

  set: dynamic_fields {
    fields: [
      dynamic_date,
      dynamic_date_granularity
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  parameter: dynamic_date_granularity {
    description: "This parameter changes the date range visualized."
    type: unquoted
    allowed_value: {label:"Day" value:"day"}
    allowed_value: {label:"Week" value:"week"}
    allowed_value: {label:"Month" value:"month"}
    allowed_value: {label:"Quarter" value:"quarter"}
    # allowed_value: {label:"Year" value:"year"}
  }

  dimension: dynamic_date {
    label_from_parameter: dynamic_date_granularity
    type: date
    sql:
    {% if dynamic_date_granularity._parameter_value == 'day' %}
      ${date_date}
    {% elsif dynamic_date_granularity._parameter_value == 'week' %}
      ${date_week}
    {% elsif dynamic_date_granularity._parameter_value == 'month' %}
      ${first_day_of_month}
    {% elsif dynamic_date_granularity._parameter_value == 'quarter' %}
      ${quarter}
    --{% elsif dynamic_date_granularity._parameter_value == 'year' %}
    --  ${date_year} || '-01-01'
    {% else %}
      NULL
    {% endif %};;
  }

  dimension: day_in_month {
    type: number
    sql: ${TABLE}."DAY_IN_MONTH" ;;
  }

  dimension: day_in_week_of_month {
    type: number
    sql: ${TABLE}."DAY_IN_WEEK_OF_MONTH" ;;
  }

  dimension: day_name {
    type: string
    sql: ${TABLE}."DAY_NAME" ;;
  }

  dimension: day_of_quarter {
    type: number
    sql: ${TABLE}."DAY_OF_QUARTER" ;;
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}."DAY_OF_WEEK" ;;
  }

  dimension: day_of_year {
    type: number
    sql: ${TABLE}."DAY_OF_YEAR" ;;
  }

  dimension: is_us_holiday {
    type: number
    sql: ${TABLE}."IS_US_HOLIDAY" ;;
  }

  dimension: first_day_of_month {
    type: date
    sql: ${TABLE}."FIRST_DAY_OF_MONTH" ;;
  }

  # dimension: month {
  #   type: number
  #   sql: ${TABLE}."MONTH" ;;
  # }

  dimension: month_name {
    type: string
    sql: ${TABLE}."MONTH_NAME" ;;
  }

  dimension: quarter {
    type: number
    sql: ${TABLE}."QUARTER" ;;
  }

  dimension: us_holiday {
    type: string
    sql: ${TABLE}."US_HOLIDAY" ;;
  }

  # dimension: week_of_month {
  #   type: number
  #   sql: ${TABLE}."WEEK_OF_MONTH" ;;
  # }

  # dimension: week_of_quarter {
  #   type: number
  #   sql: ${TABLE}."WEEK_OF_QUARTER" ;;
  # }

  # dimension: week_of_year {
  #   type: number
  #   sql: ${TABLE}."WEEK_OF_YEAR" ;;
  # }

  # dimension: year {
  #   type: number
  #   sql: ${TABLE}."YEAR" ;;
  # }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: CAST(${TABLE}."DATE" AS TIMESTAMP_NTZ);;
  }

  dimension_group: date {
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
    sql: ${TABLE}."DATE" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: date_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."DATE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [month_name, day_name]
  }
}
