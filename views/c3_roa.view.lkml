# view: c3_roa {
#   Deprecated on 7/26 after discussion with Savannah G. We terminated our relationship with the agency, C3 over a year ago.
#   sql_table_name: marketing.c3_conversion_adspend_cohort ;;

#   dimension: analytics_order_id {
#     type: number
#     sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
#     primary_key: yes
#   }

#   dimension: PLATFORM {
#     type: string
#     sql: case when ${TABLE}.PLATFORM = 'YOUTUBE' then 'YOUTUBE'
#       else ${TABLE}.PLATFORM end ;;
#   }

#   dimension: SOURCE {
#     type: string
#     sql: ${TABLE}.SOURCE ;;
#   }

#   dimension: CAMPAIGN_TYPE {
#     type: string
#     sql: ${TABLE}.CAMPAIGN_TYPE ;;
#   }

#   dimension_group: SPEND_DATE {
#     type: time
#     timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
#     sql: ${TABLE}.SPEND_DATE ;;
#   }

#   dimension: CAMPAIGN_NAME {
#     type: string
#     sql: ${TABLE}.CAMPAIGN_NAME ;;
#   }

#   measure: SPEND_AMOUNT {
#     type: sum
#     sql:  ${TABLE}.SPEND_AMOUNT ;;
#   }

#   measure: ATTRIBUTION_AMOUNT {
#     type: sum
#     sql:  ${TABLE}.ATTRIBUTION_AMOUNT ;;
#   }

#   measure: TRENDED_AMOUNT {
#     type: sum
#     sql:  ${TABLE}.TRENDED_AMOUNT ;;
#   }

#   dimension: medium {
#     label: "  Medium"
#     description: "Calculated based on source and platform"
#     type: string
#     case: {
#       when: {sql: ${PLATFORM} in ('YOUTUBE.COM')
#         or ${SOURCE} = 'VIDEO'
#         or ${SOURCE} = 'YOUTUBE VIDEOS'
#         or ${SOURCE} = 'YOUTUBE'
#         or ${SOURCE} = 'YOUTUBE.COM'
#         or (${PLATFORM} = 'EXPONENTIAL') ;; label:"video" }
#       when: {sql: ${PLATFORM} in ('FACEBOOK','PINTEREST','SNAPCHAT','QUORA','TWITTER','FB/IG')
#                 or ${SOURCE} ilike ('%social media%') ;; label:"social"}
#       when: {sql: ${SOURCE} ilike ('%ispla%')
#                 or ${PLATFORM} in ('ACUITY')
#                 or (${PLATFORM} = 'GOOGLE' and ${SOURCE} = 'CROSS-NETWORK')
#                 or ${CAMPAIGN_NAME} ilike '%displa%'  ;; label:"display" }
#       when: {sql: ${PLATFORM} in ('TV','RADIO','SMS','HULU') ;; label:"traditional"}
#       when: {sql: ${CAMPAIGN_NAME} ilike '%ative%'
#                 or ${SOURCE} = 'NATIVE';; label: "native" }
#       when: {sql: ${PLATFORM} = 'AFFILIATE'
#                 or ${PLATFORM} = 'EMAIL' or ${SOURCE} = 'EMAIL';; label: "affiliate" }
#       when: {sql:  ${SOURCE} ilike 'seo%'
#                 or ${SOURCE} ilike ('%organic%')
#                 or ${PLATFORM} in ('BLOG');; label:"organic"}
#       when: {sql: ${SOURCE} ilike ('%earc%')
#                 or ${SOURCE} ilike '%rand%'
#                 or ${CAMPAIGN_NAME} ilike 'NB%'
#                 or ${PLATFORM} in ('BING','YAHOO')
#                 or ${SOURCE} in ('SHOPPING') ;; label:"search"}
#       else: "other" } }

#   dimension_group: current {
#     label: "  Ad"
#     hidden: yes
#     type: time
#     timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
#     sql: current_date ;; }

#   dimension: ytd {
#     group_label: "Spend Date"
#     label: "z - YTD"
#     description: "Yes/No for Ad Date Day of Year is before Current Date Day of Year"
#     type: yesno
#     sql:  ${SPEND_DATE_day_of_year} < ${current_day_of_year} ;; }

# }
