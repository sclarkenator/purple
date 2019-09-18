view: c3_conversion_ft_lt {
  sql_table_name: MARKETING.C3_CONVERSION_FT_LT ;;

  dimension: analytics_order_id {
    type: number
    sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
    primary_key: yes
  }

  dimension: c3_sales_order_id {
    type: string
    sql: ${TABLE}."C3_SALES_ORDER_ID" ;;
  }

  dimension_group: first_touch {
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
    sql: ${TABLE}."FIRST_TOUCH_DATE" ;;
  }

  dimension: first_touch_platform {
    type: string
    sql: ${TABLE}."FIRST_TOUCH_PLATFORM" ;;
  }

  dimension: first_touch_source {
    type: string
    sql: ${TABLE}."FIRST_TOUCH_SOURCE" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: last_touch {
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
    sql: ${TABLE}."LAST_TOUCH_DATE" ;;
  }

  dimension: last_touch_platform {
    type: string
    sql: ${TABLE}."LAST_TOUCH_PLATFORM" ;;
  }

  dimension: last_touch_source {
    type: string
    sql: ${TABLE}."LAST_TOUCH_SOURCE" ;;
  }

  dimension: total_touches {
    type: number
    sql: ${TABLE}."TOTAL_TOUCHES" ;;
  }

  dimension_group: update_ts {
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
    drill_fields: []
  }
}
