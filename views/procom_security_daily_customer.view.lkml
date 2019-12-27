view: procom_security_daily_customer {
  sql_table_name: RETAIL.PROCOM_SECURITY_DAILY_CUSTOMER ;;

  dimension: area {
    type: string
    hidden:  yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension: camera {
    type: string
    hidden:  yes
    sql: ${TABLE}."CAMERA" ;;
  }

  dimension: store_name {
    type:  string
    description: "Store location"
    label: "Store location"
    sql: ${TABLE}.store ;;
  }

  dimension: store_id {
    type:  string
    description: "Store identifier (to link to sales)"
    label: "Store ID"
    sql: ${TABLE}.showroom_name ;;
  }


  dimension_group: created {
    type: time
    label: "Visit"
    description: "Day customer visited store"
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
