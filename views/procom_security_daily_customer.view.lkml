view: procom_security_daily_customer {
  sql_table_name: RETAIL.PROCOM_SECURITY_DAILY_CUSTOMER ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: camera {
    type: string
    sql: ${TABLE}."CAMERA" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw,hour,time,date,day_of_month,week,month,quarter,quarter_of_year,year]
    sql: ${TABLE}."CREATED" ;;
  }

  measure: enter {
    label: "Total entering"
    description: "Total count of people entering store"
    type: sum
    sql: ${TABLE}."ENTER" ;;
  }

  measure: exit {
    description: "Total count of people leaving store"
    label: "Total leaving"
    type: sum
    sql: ${TABLE}."EXIT" ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
