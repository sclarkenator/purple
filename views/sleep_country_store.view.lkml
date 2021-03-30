view: sleep_country_canada_store {
  sql_table_name: "WHOLESALE"."SLEEP_COUNTRY_STORE"
    ;;

  dimension: address {
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: postal {
    type: string
    sql: ${TABLE}."POSTAL" ;;
  }

  dimension: prov {
    type: string
    sql: ${TABLE}."PROV" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}."STORE_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
