view: store_locations_3_mar2020 {
  sql_table_name: "CSV_UPLOADS"."STORE_LOCATIONS_3MAR2020"
    ;;

  dimension: account_description {
    type: string
    sql: ${TABLE}."ACCOUNT_DESCRIPTION" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."ACCOUNT_NAME" ;;
  }

  dimension: account_type {
    type: string
    sql: ${TABLE}."ACCOUNT_TYPE" ;;
  }

  dimension: assortment {
    type: string
    sql: ${TABLE}."ASSORTMENT" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: full_address {
    type: string
    sql: ${TABLE}."FULL_ADDRESS" ;;
  }

  dimension: interal_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."INTERAL_ID" ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}."LATITUDE";;
    sql_longitude:${TABLE}."LONGITUED" ;;
  }

  dimension: latitude {
    type: string
    hidden: yes
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: string
    hidden: yes
    sql: ${TABLE}."LONGITUED" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: sales_rep {
    type: string
    sql: ${TABLE}."SALES_REP" ;;
  }

  dimension: salesforce_id {
    type: string
    sql: ${TABLE}."SALESFORCE_ID" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: store_number {
    type: string
    sql: ${TABLE}."STORE_NUMBER" ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}."STREET" ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    drill_fields: [account_name]
  }
}
