view: zipcode_radius {
  sql_table_name: CSV_UPLOADS.ZIPCODE_RADIUS ;;

  dimension: salt_lake_city_10_miles {
    type: string
    sql: ${TABLE}."SALT_LAKE_CITY_10_MILES" ;;
  }

  dimension: salt_lake_city_15_miles {
    type: string
    sql: ${TABLE}."SALT_LAKE_CITY_15_MILES" ;;
  }

  dimension: salt_lake_city_5_miles {
    type: string
    sql: ${TABLE}."SALT_LAKE_CITY_5_MILES" ;;
  }

  dimension: san_diego_10_miles {
    type: string
    sql: ${TABLE}."SAN_DIEGO_10_MILES" ;;
  }

  dimension: san_diego_15_miles {
    type: string
    sql: ${TABLE}."SAN_DIEGO_15_MILES" ;;
  }

  dimension: san_diego_5_miles {
    type: string
    sql: ${TABLE}."SAN_DIEGO_5_MILES" ;;
  }

  dimension: san_jose_10_miles {
    type: string
    sql: ${TABLE}."SAN_JOSE_10_MILES" ;;
  }

  dimension: san_jose_15_miles {
    type: string
    sql: ${TABLE}."SAN_JOSE_15_MILES" ;;
  }

  dimension: san_jose_5_miles {
    type: string
    sql: ${TABLE}."SAN_JOSE_5_MILES" ;;
  }

  dimension: santa_monica_10_miles {
    type: string
    sql: ${TABLE}."SANTA_MONICA_10_MILES" ;;
  }

  dimension: santa_monica_15_miles {
    type: string
    sql: ${TABLE}."SANTA_MONICA_15_MILES" ;;
  }

  dimension: santa_monica_5_miles {
    type: string
    sql: ${TABLE}."SANTA_MONICA_5_MILES" ;;
  }

  dimension: seattle_10_miles {
    type: string
    sql: ${TABLE}."SEATTLE_10_MILES" ;;
  }

  dimension: seattle_15_miles {
    type: string
    sql: ${TABLE}."SEATTLE_15_MILES" ;;
  }

  dimension: seattle_5_miles {
    type: string
    sql: ${TABLE}."SEATTLE_5_MILES" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
