view: narvar_dashboard_emails_accepted_by_campaign {

  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_EMAILS_ACCEPTED_BY_CAMPAIGN ;;

  dimension: week_of {
    type: date
    sql: ${TABLE}."WEEK_OF" ;;
  }

  dimension: day {
    type: date
    sql: ${TABLE}."DAY" ;;
    primary_key: yes
  }

  measure: delay_overdue {
    type: sum
    sql: ${TABLE}."DELAY_OVERDUE" ;;
  }

  measure: delivered_standard {
    type: sum
    sql: ${TABLE}."DELIVERED_STANDARD" ;;
  }

  measure: delivery_anticipation_standard {
    type: sum
    sql: ${TABLE}."DELIVERY_ANTICIPATION_STANDARD" ;;
  }

  measure: just_shipped {
    type: sum
    sql: ${TABLE}."JUST_SHIPPED" ;;
  }

  measure: shipment_confirmation_standard {
    type: sum
    sql: ${TABLE}."SHIPMENT_CONFIRMATION_STANDARD" ;;
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
