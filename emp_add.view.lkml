view: emp_add {
  sql_table_name: CSV_UPLOADS.EMP_ADD ;;

  dimension: emp_loc {
    description: "lat and long for employee address"
    label: "Lat. and long."
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lat2} ;;
  }

  dimension: lat {
    hidden: yes
    type: string
    sql: ${TABLE}."LAT" ;;
  }

  dimension: lat2 {
    hidden: yes
    label: "longitude"
    type: string
    sql: ${TABLE}."LAT2" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  dimension: location {
    description: "Main employment location"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: title {
    description: "Job title"
    type: string
    sql: ${TABLE}."TITLE" ;;
  }

  dimension: type {
    description: "Employee type"
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
