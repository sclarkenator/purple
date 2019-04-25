view: return_form_reason {
  sql_table_name: CUSTOMER_CARE.RETURN_FORM_REASON ;;

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: entry_id {
    type: number
    sql: ${TABLE}."ENTRY_ID" ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: pk {
    type: string
    primary_key: yes
    sql: ${category} || ${entry_id} || ${reason} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
