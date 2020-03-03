view: c3_roa {
  sql_table_name: marketing.c3_conversion_adspend_cohort ;;

  dimension: analytics_order_id {
    type: number
    sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
    primary_key: yes
  }

  dimension: PLATFORM {
    type: string
    sql: case when ${TABLE}.PLATFORM = 'YOUTUBE' then 'YOUTUBE'
      else ${TABLE}.PLATFORM end ;;
  }

  dimension: SOURCE {
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: CAMPAIGN_TYPE {
    type: string
    sql: ${TABLE}.CAMPAIGN_TYPE ;;
  }

  dimension_group: SPEND_DATE {
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
    sql: ${TABLE}.SPEND_DATE ;;
  }

  dimension: CAMPAIGN_NAME {
    type: string
    sql: ${TABLE}.CAMPAIGN_NAME ;;
  }

  measure: SPEND_AMOUNT {
    type: sum
    sql:  ${TABLE}.SPEND_AMOUNT ;;
  }

  measure: ATTRIBUTION_AMOUNT {
    type: sum
    sql:  ${TABLE}.ATTRIBUTION_AMOUNT ;;
  }

  measure: TRENDED_AMOUNT {
    type: sum
    sql:  ${TABLE}.TRENDED_AMOUNT ;;
  }

  dimension: medium {
    label: "  Medium"
    description: "Calculated based on source and platform"
    type: string
    case: {
      when: {sql: ${PLATFORM} in ('FACEBOOK','PINTEREST','SNAPCHAT','QUORA','TWITTER')
                or ${SOURCE} ilike ('%social media%') ;; label:"social"}
      when: {sql: ${PLATFORM} in ('YOUTUBE')
                or ${SOURCE} = 'VIDEO'
                or ${SOURCE} = 'YOUTUBE VIDEOS'
                or ${SOURCE} = 'YOUTUBE'
                or ${SOURCE} = 'YOUTUBE.COM'
                or (${PLATFORM} = 'EXPONENTIAL') ;; label:"video" }
      when: {sql: ${SOURCE} ilike ('%ispla%')
                or ${PLATFORM} in ('ACUITY')
                or (${PLATFORM} = 'GOOGLE' and ${SOURCE} = 'CROSS-NETWORK')
                or ${CAMPAIGN_NAME} ilike '%displa%'  ;; label:"display" }
      when: {sql: ${PLATFORM} in ('TV','RADIO','SMS','HULU') ;; label:"traditional"}
      when: {sql: ${CAMPAIGN_NAME} ilike '%ative%'
                or ${SOURCE} = 'NATIVE';; label: "native" }
      when: {sql: ${PLATFORM} = 'AFFILIATE' ;; label: "affiliate" }
      when: {sql:  ${SOURCE} ilike 'seo%'
                or ${SOURCE} ilike ('%organic%')
                or ${PLATFORM} in ('BLOG');; label:"organic"}
      when: {sql: ${SOURCE} ilike ('%earc%')
                or ${SOURCE} ilike '%rand%'
                or ${CAMPAIGN_NAME} ilike 'NB%'
                or ${PLATFORM} in ('BING','YAHOO')
                or ${SOURCE} in ('SHOPPING') ;; label:"search"}
      else: "other" } }

}
