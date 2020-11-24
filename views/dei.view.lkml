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
    sql: coalesce(${TABLE}."ETHNICITY",'I do not wish to self-identify') ;;
  }

  dimension: gender {
    description: "Source: hr_excel_file.dei"
    type: string
    sql: case when ${TABLE}."GENDER" = 'I do not wish to self-identify' then 'Unspecified' else ${TABLE}."GENDER" end ;;
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
    sql: coalesce(${TABLE}."VP",'C-Level') ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
