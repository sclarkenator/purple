view: c3_conversion_ft_lt {
  sql_table_name: MARKETING.C3_CONVERSION_FT_LT ;;

  dimension: analytics_order_id {
    type: number
    sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
    primary_key: yes
    hidden: yes
  }

  dimension: has_touch {
    type: yesno
    label: "  * Has Marketing Touch"
    sql: case when  ${TABLE}."ANALYTICS_ORDER_ID" is null then 'No' else 'Yes' end;;
  }

  dimension: c3_sales_order_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."C3_SALES_ORDER_ID" ;;
  }

  dimension_group: first_touch {
    label: "  First Touch"
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
    label: " First Touch Platform"
    type: string
    sql: ${TABLE}."FIRST_TOUCH_PLATFORM" ;;
  }

  dimension: ANY_TOUCH_GOOGLE {
    label: "Includes a Google Touch"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."ANY_TOUCH_GOOGLE" ;;
  }

  dimension: ANY_TOUCH_FACEBOOK {
    label: "Includes a Facebook Touch"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."ANY_TOUCH_FACEBOOK" ;;
  }

  dimension: ANY_TOUCH_TV {
    label: "Includes a TV Touch"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."ANY_TOUCH_TV" ;;
  }

  dimension: ANY_TOUCH_YAHOO {
    label: "Includes a Yahoo Touch"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."ANY_TOUCH_YAHOO" ;;
  }

  dimension: ANY_TOUCH_PINTEREST {
    label: "Includes a Pinterest Touch"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."ANY_TOUCH_PINTEREST" ;;
  }

  dimension: first_touch_source {
    label: " First Touch Source"
    type: string
    sql: ${TABLE}."FIRST_TOUCH_SOURCE" ;;
  }

  dimension_group: last_touch {
    label: "  Last Touch"
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
    label: " Last Touch Platform"
    type: string
    sql: ${TABLE}."LAST_TOUCH_PLATFORM" ;;
  }

  dimension: last_touch_source {
    label: " Last Touch Source"
    type: string
    sql: ${TABLE}."LAST_TOUCH_SOURCE" ;;
  }

  dimension: total_touches {
    type: number
    group_label: "Advanced"
    sql: ${TABLE}."TOTAL_TOUCHES" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    hidden: yes
    type: count
    drill_fields: []
  }
}
