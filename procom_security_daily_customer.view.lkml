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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: enter {
    type: number
    sql: ${TABLE}."ENTER" ;;
  }

  dimension: exit {
    type: number
    sql: ${TABLE}."EXIT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
