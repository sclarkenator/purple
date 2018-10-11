view: retail_stores {
  sql_table_name: CSV_UPLOADS.RETAIL_STORES ;;

  dimension: address {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: beds {
    hidden: yes
    type: string
    sql: ${TABLE}."BEDS" ;;
  }

  dimension: city {
    hidden: yes
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: retailer {
    type: string
    sql: ${TABLE}."RETAILER" ;;
  }

  dimension: state {
    hidden: yes
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
