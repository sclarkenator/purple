view: paycom_labor_hours {
  sql_table_name: "HR"."PAYCOM_LABOR_HOURS"
    ;;

  dimension_group: clocked_in {
    label: ""
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      day_of_month,
      day_of_week,
      hour_of_day,
      day_of_year,
      quarter,
      year
    ]
    sql: ${TABLE}."CLOCKED_IN" ;;
  }

  dimension: department {
    label: "Department"
    description: "Department that hours were clocked-in with"
    type: string
    case: {
      when: {
        sql: ${TABLE}."DEPARTMENT" like '121%' ;;
        label: "Mattress Production"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '350%'  ;;
        label: "Customer Care"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '113%' ;;
        label: "Warehouse"
      }
      when: {
        sql:${TABLE}."DEPARTMENT" like '114%' ;;
        label: "Fulfillment"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '122%' ;;
        label: "Pillow/Cushion Production"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '158%'  ;;
        label: "Maintenance"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '351%' ;;
        label: "Inside Sales"
      }
      when: {
        sql:${TABLE}."DEPARTMENT" like '153%' ;;
        label: "Fabrication"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '402%' ;;
        label: "Showrooms"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '160%'  ;;
        label: "Quality"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '820%'  ;;
        label: "Accounting"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '351%' ;;
        label: "Inside Sales"
      }
      when: {
        sql:${TABLE}."DEPARTMENT" like '152%' ;;
        label: "Maintenance"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '928%' ;;
        label: "Product Development"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '823%'  ;;
        label: "IT"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '155%' ;;
        label: "Electrical"
      }
      when: {
        sql: ${TABLE}."DEPARTMENT" like '401%'  ;;
        label: "Wholesale"
      }
      }
  }

  dimension: location_code {
    label: "Location"
    description: "Location where hours were clocked-in at"
    type: string
    sql: ${TABLE}."LOCATION_CODE" ;;
  }

  dimension: punch_type {
    description: "Method of clocking in"
    hidden: yes
    type: string
    sql: ${TABLE}."PUNCH_TYPE" ;;
  }

  measure: hours {
    label: "Hours Worked"
    description: "Total hours worked, by clocked-in day."
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."HOURS" ;;
    }
}
