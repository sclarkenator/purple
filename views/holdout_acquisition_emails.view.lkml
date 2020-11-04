view: holdout_acquisition_emails {
  sql_table_name: "CSV_UPLOADS"."HOLDOUT_ACQUISITION_EMAILS"
    ;;

  dimension: email {
    type: string
    primary_key: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: variation {
    type: string
    sql: ${TABLE}."VARIATION" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
