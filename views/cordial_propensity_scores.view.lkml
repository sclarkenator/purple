view: cordial_propensity_scores {
  sql_table_name: marketing.email.cordial_propensity_scores ;;


  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: PROPENSITY_TO_PURCHASE {
    type: number
    label: "Propensity to Purchase"
    sql: ${TABLE}.PROPENSITY_TO_PURCHASE ;;
  }

  dimension: ENGAGEMENT_SCORE_30D {
    type: number
    label: "Engagement Score - 30 Days"
    sql: ${TABLE}.ENGAGEMENT_SCORE_30D ;;
  }

  dimension: ENGAGEMENT_SCORE_60D {
    type: number
    label: "Engagement Score - 60 Days"
    sql: ${TABLE}.ENGAGEMENT_SCORE_60D ;;
  }

  dimension: ENGAGEMENT_SCORE_90D {
    type: number
    label: "Engagement Score - 90 Days"
    sql: ${TABLE}.ENGAGEMENT_SCORE_90D ;;
  }

  dimension: ENGAGEMENT_SCORE_180D {
    type: number
    label: "Engagement Score - 180 Days"
    sql: ${TABLE}.ENGAGEMENT_SCORE_180D ;;
  }


  dimension_group: LAST_ENGAGEMENT_DATE {
    type: time
    label: "Last Engagement Date"
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.LAST_ENGAGEMENT_DATE ;;
  }

  dimension_group: ENGAGEMENT_SCORE_LAST_EDIT {
    type: time
    label: "Last Edit Date"
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.ENGAGEMENT_SCORE_LAST_EDIT ;;
  }

}
