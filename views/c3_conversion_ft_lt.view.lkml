# view: c3_conversion_ft_lt {
#   Deprecated on 7/26 after discussion with Savannah G. We terminated our relationship with the agency, C3 over a year ago.
#   sql_table_name: MARKETING.C3_CONVERSION_FT_LT ;;

#   dimension: analytics_order_id {
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: number
#     sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
#     primary_key: yes
#     hidden: yes
#   }

#   dimension: has_touch {
#     type: yesno
#     hidden: yes
#     label: "  * Has Marketing Touch (DEPRICATED)"
#     description: "If there is a marketing touch on the order.  Most blank will be orders made not on the website (wholesale/retail). Source:c3.c3_conversion_ft_lt"
#     sql: ${TABLE}."ANALYTICS_ORDER_ID" is not null;;
#   }

#   dimension: c3_sales_order_id {
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: string
#     hidden:  yes
#     sql: ${TABLE}."C3_SALES_ORDER_ID" ;;
#   }

#   dimension_group: first_touch {
#     label: "  First Touch (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: time
#     hidden: yes
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}."FIRST_TOUCH_DATE" ;;
#   }

#   dimension: first_touch_platform {
#     label: " First Touch Platform (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: string
#     hidden: yes
#     sql: ${TABLE}."FIRST_TOUCH_PLATFORM" ;;
#   }

#   dimension: ANY_TOUCH_GOOGLE {
#     label: "  * Includes a Google Touch (DEPRICATED)"
#     description: "If there is a google touch anywhere in the timeline. Source:c3.c3_conversion_ft_lt"
#     group_label: "Advanced"
#     type: yesno
#     hidden: yes
#     sql: ${TABLE}."ANY_TOUCH_GOOGLE" = 'YES' ;;
#   }

#   dimension: ANY_TOUCH_FACEBOOK {
#     label: "  * Includes a Facebook Touch (DEPRICATED)"
#     description: "If there is a facebook touch anywhere in the timeline. Source:c3.c3_conversion_ft_lt"
#     group_label: "Advanced"
#     type: yesno
#     hidden: yes
#     sql: ${TABLE}."ANY_TOUCH_FACEBOOK" = 'YES' ;;
#   }

#   dimension: ANY_TOUCH_TV {
#     label: "  * Includes a TV Touch (DEPRICATED)"
#     description: "If there is a tv touch anywhere in the timeline. Source:c3.c3_conversion_ft_lt"
#     group_label: "Advanced"
#     type: yesno
#     hidden: yes
#     sql: ${TABLE}."ANY_TOUCH_TV" = 'YES' ;;
#   }

#   dimension: ANY_TOUCH_YAHOO {
#     label: "  * Includes a Yahoo Touch (DEPRICATED)"
#     description: "If there is a yahoo touch anywhere in the timeline. Source:c3.c3_conversion_ft_lt"
#     group_label: "Advanced"
#     type: yesno
#     hidden: yes
#     sql: ${TABLE}."ANY_TOUCH_YAHOO" = 'YES' ;;
#   }

#   dimension: ANY_TOUCH_PINTEREST {
#     label: "  * Includes a Pinterest Touch (DEPRICATED)"
#     description: "If there is a google touch anywhere in the timeline. Source:c3.c3_conversion_ft_lt"
#     group_label: "Advanced"
#     type: yesno
#     hidden: yes
#     sql: ${TABLE}."ANY_TOUCH_PINTEREST" = 'YES' ;;
#   }

#   dimension: first_touch_source {
#     label: " First Touch Source (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: string
#     hidden: yes
#     sql: ${TABLE}."FIRST_TOUCH_SOURCE" ;;
#   }

#   dimension_group: last_touch {
#     label: "  Last Touch (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: time
#     hidden: yes
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}."LAST_TOUCH_DATE" ;;
#   }

#   dimension: last_touch_platform {
#     label: " Last Touch Platform (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: string
#     hidden: yes
#     sql: ${TABLE}."LAST_TOUCH_PLATFORM" ;;
#   }

#   dimension: last_touch_source {
#     label: " Last Touch Source (DEPRICATED)"
#     description: "Source: c3.c3_conversion_ft_lt"
#     type: string
#     hidden: yes
#     sql: ${TABLE}."LAST_TOUCH_SOURCE" ;;
#   }

#   dimension: total_touches {
#     type: number
#     hidden: yes
#     description: "Total touchpoints from all channels (not unique per channel). Source:c3.c3_conversion_ft_lt (DEPRICATED)"
#     group_label: "Advanced"
#     sql: ${TABLE}."TOTAL_TOUCHES" ;;
#   }

#   dimension_group: update_ts {
#     hidden: yes
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}."UPDATE_TS" ;;
#   }

#   measure: count {
#     hidden: yes
#     type: count
#     drill_fields: []
#   }
# }
