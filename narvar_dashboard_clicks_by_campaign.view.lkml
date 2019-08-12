view: narvar_dashboard_clicks_by_campaign {

  sql_table_name: CUSTOMER_CARE.NARVAR_DASHBOARD_CLICKS_BY_CAMPAIGN ;;

  dimension: week_of {
    type: date
    sql: ${TABLE}."WEEK_OF" ;;
  }

  dimension: day {
    type: date
    sql: ${TABLE}."DAY" ;;
    primary_key: yes
  }

  dimension: delay_overdue {
    type: number
    sql: ${TABLE}."DELAY_OVERDUE" ;;
  }

  dimension: delivered_standard {
    type: number
    sql: ${TABLE}."DELIVERED_STANDARD" ;;
  }

  dimension: delivery_anticipation_standard {
    type: number
    sql: ${TABLE}."DELIVERY_ANTICIPATION_STANDARD" ;;
  }
  dimension: shipment_confirmation_standard {
    type: number
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
