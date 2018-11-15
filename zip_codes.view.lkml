#-------------------------------------------------------------------
# Owner - Tim Schultz
# Static table with 1 row per US Zip Code
#-------------------------------------------------------------------

view: zip_codes {
  sql_table_name: analytics.csv_uploads.zip_codes ;;

  dimension: zip_string {
    label: "Zip Code"
    description: "Text Value (for leading zeros) limited to 5 characters"
    hidden:  yes
    type: string
    sql: ${TABLE}.zip_string ;;
  }

  dimension: zip {
    label: "Zip Num"
    description: "Numeric value of zip, dropped leading zeros"
    hidden:  yes
    type: string
    sql: ${TABLE}.zip ;;
  }

  dimension: city {
    label: "City"
    description: "A single city for the zipcode"
    hidden:  yes
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    label: "State"
    description: "State of zipcode"
    hidden:  yes
    type: string
    sql: ${TABLE}.state ;;
  }

  measure: count {
    type: count
    hidden: yes
  }

}
