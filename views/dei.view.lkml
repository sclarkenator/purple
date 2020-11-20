view: dei {
  sql_table_name: ANALYTICS.HR.DEI
    ;;

  dimension: department {
    description: "Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: ethnicity {
    description: "Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."ETHNICITY" ;;
  }

  dimension: gender {
    description: "Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: location {
    description: "Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: supervisor {
    description: "Primary Supervisor Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."SUPERVISOR" ;;
  }

  dimension: vp {
    label: "VP"
    description: "Source: hr_excel_file.dei"
    type: string
    sql: ${TABLE}."VP" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
