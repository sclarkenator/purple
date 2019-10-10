view: c3_roa {
  sql_table_name: marketing.c3_conversion_adspend_cohort ;;

  dimension: analytics_order_id {
    type: number
    sql: ${TABLE}."ANALYTICS_ORDER_ID" ;;
    primary_key: yes
  }

  dimension: PLATFORM {
    type: string
    sql: ${TABLE}.PLATFORM ;;
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

}
