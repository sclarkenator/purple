view: narvar_dashboard_notification_clicks_by_category {


  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_EMAILS_ACCEPTED_BY_CAMPAIGN ;;

  dimension: week_of {
    type: date
    sql: ${TABLE}."WEEK_OF" ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: footer {
    type: number
    sql: ${TABLE}."FOOTER" ;;
  }

  dimension: marketing {
    type: number
    sql: ${TABLE}."MARKETING" ;;
  }

  dimension: tracking {
    type: number
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
    type: count
  }



}
