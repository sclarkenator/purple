view: wholesale_customer_warehouses {
  sql_table_name: SALES.WHOLESALE_CUSTOMER_WAREHOUSES ;;

  dimension: Primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."customer_id" - ${TABLE}."street_address" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: companyname {
    type: string
    sql: ${TABLE}."companyname" ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}."state" ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}."street_address" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."zip" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [companyname]
  }
}
