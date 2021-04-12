view: paycom_labor_hours {
  sql_table_name: analytics.hr.paycom_labor_hours
    ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: string
    ##sql: ${TABLE}.employee_code||${TABLE}.clocked_in||${TABLE}.punch_type||${TABLE}.department ;;
    sql: ${TABLE}.employee_code||${TABLE}.clocked_in||${TABLE}.punch_type||${TABLE}.department ;;

  }
  dimension: email_join {
    hidden: yes
    type: string
    sql: lower(${TABLE}.email) ;;
  }

  dimension_group: clocked_in {
    label: ""
    hidden: no
    description: "Source: paycom.paycom_labor_hours"
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
    description: "Department that hours were clocked-in with. Source: paycom.paycom_labor_hours"
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

  dimension: department_filter {
    type: string
    hidden: yes
    sql: ${department} ;;
  }

  dimension: location_code {
    label: "Location"
    description: "Location where hours were clocked-in at. Source: paycom.paycom_labor_hours"
    type: string
    hidden:  yes
    sql: ${TABLE}."LOCATION_CODE" ;;
  }

  dimension: punch_type {
    description: "Method of clocking in. Source: paycom.paycom_labor_hours"
    hidden: no
    type: string
    sql: ${TABLE}."PUNCH_TYPE" ;;
  }

  measure: hours {
    label: "Hours Worked"
    description: "Total hours worked, by clocked-in day. Source: paycom.paycom_labor_hours"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."HOURS" ;;
  }

  dimension_group: clocked_in_or {
    view_label: "Owned Retail"
    group_label: "Hours Worked"
    label: "Clocked In"
    hidden: no
    description: "Source: paycom.paycom_labor_hours"
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

  dimension: location_code_or {
    view_label: "Owned Retail"
    group_label: "Hours Worked"
    label: "Location"
    hidden: yes
    description: "Location where hours were clocked-in at for retail agents. Source: paycom.paycom_labor_hours"
    type: string
    sql: case when ${department_filter} = 'Showrooms' then ${TABLE}."LOCATION_CODE" else null end;;
  }

  measure: hours_or {
    view_label: "Owned Retail"
    group_label: "Hours Worked"
    label: "Hours Worked"
    description: "Total hours worked, by clocked-in day, for owned retail agents. Source: paycom.paycom_labor_hours"
    type: sum
##    filters: [department_filter: "Showrooms"]
    value_format: "#,##0"
    sql: ${TABLE}."HOURS" ;;
  }

}
