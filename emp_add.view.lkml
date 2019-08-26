#-------------------------------------------------------------------
# Owner - Scott Clark
# Employee Addresses
#-------------------------------------------------------------------

view: emp_add {
  sql_table_name: CSV_UPLOADS.EMP_ADD ;;

  dimension: emp_loc {
    description: "Lattitude and Longitude for employee address"
    label: "Lat & Long"
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lat2} ;;

  }

  dimension: lat {
    hidden: yes
    type: string
    sql: ${TABLE}.lat ;;
  }

  dimension: lat2 {
    hidden: yes
    type: string
    sql: ${TABLE}.lat2 ;;
  }

  dimension: address {
    label: "Address"
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    label: "State"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    label: "Zip"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: location {
    label: "Location"
    description: "Main employment location"
    type: string
    sql: ${TABLE}.location ;;
    primary_key: yes
  }

  dimension: title {
    description: "Job Title"
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: type {
    label: "Type"
    description: "Employee type"
    type: string
    sql: ${TABLE}.type ;;
  }



  measure: count {
    type: count
  }

}
