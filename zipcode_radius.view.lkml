view: zipcode_radius {
  sql_table_name: CSV_UPLOADS.ZIPCODE_RADIUS ;;

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."ZIPCODE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
