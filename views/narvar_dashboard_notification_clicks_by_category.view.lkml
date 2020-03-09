view: narvar_dashboard_notification_clicks_by_category {


 # sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_EMAILS_ACCEPTED_BY_CAMPAIGN ;; not sure why it was this before, but i'm changing it to the below:
  sql_table_name: CUSTOMER_CARE.narvar_dashboard_notification_clicks_by_category ;;

  dimension: week_of {
    type: date
    hidden: yes
    sql: ${TABLE}."WEEK_OF" ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  measure: footer {
    type: sum
    sql: ${TABLE}."FOOTER" ;;
  }

  measure: marketing {
    type: sum
    sql: ${TABLE}."MARKETING" ;;
  }

  measure: tracking {
    type: sum
    sql: ${TABLE}."TRACKING" ;;
  }



  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  measure: count {
    hidden: yes
    type: count
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${week_of},${campaign}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
