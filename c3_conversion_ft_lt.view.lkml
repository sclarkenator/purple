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
    description: "If there is a marketing touch on the order.  Most blank will be orders made not on the website (wholesale/retail)"
    sql: ${TABLE}."ANALYTICS_ORDER_ID" is not null;;
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
    description: "If there is a google touch anywhere in the timeline"
    group_label: "Advanced"
    type: yesno
    sql: ${TABLE}."ANY_TOUCH_GOOGLE" = 'YES' ;;
  }

  dimension: ANY_TOUCH_FACEBOOK {
    label: "Includes a Facebook Touch"
    description: "If there is a facebook touch anywhere in the timeline"
    group_label: "Advanced"
    type: yesno
    sql: ${TABLE}."ANY_TOUCH_FACEBOOK" = 'YES' ;;
  }

  dimension: ANY_TOUCH_TV {
    label: "Includes a TV Touch"
    description: "If there is a tv touch anywhere in the timeline"
    group_label: "Advanced"
    type: yesno
    sql: ${TABLE}."ANY_TOUCH_TV" = 'YES' ;;
  }

  dimension: ANY_TOUCH_YAHOO {
    label: "Includes a Yahoo Touch"
    description: "If there is a yahoo touch anywhere in the timeline"
    group_label: "Advanced"
    type: yesno
    sql: ${TABLE}."ANY_TOUCH_YAHOO" = 'YES' ;;
  }

  dimension: ANY_TOUCH_PINTEREST {
    label: "Includes a Pinterest Touch"
    description: "If there is a google touch anywhere in the timeline"
    group_label: "Advanced"
    type: yesno
    sql: ${TABLE}."ANY_TOUCH_PINTEREST" = 'YES' ;;
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
    description: "Total touchpoints from all channels (not unique per channel)"
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
