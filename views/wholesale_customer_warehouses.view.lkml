view: wholesale_customer_warehouses {
  sql_table_name: SALES.V_WHOLESALE_CUSTOMER_WAREHOUSES ;;

  dimension: Primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."customer_id" || ${TABLE}."street_address" ;;
  }

  dimension: city {
    view_label: "Fulfillment"
    group_label: "Wholesale receiving warehouse"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: companyname {
    view_label: "Fulfillment"
    label: " Company name"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    group_label: "Wholesale receiving warehouse"
    type: string
    sql: ${TABLE}."companyname" ;;
  }

  dimension: customer_id {
    view_label: "Fulfillment"
    group_label: "Wholesale receiving warehouse"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    hidden: yes
    type: string
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: state {
    view_label: "Fulfillment"
    group_label: "Wholesale receiving warehouse"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}."state" ;;
  }

  dimension: street_address {
    view_label: "Fulfillment"
    group_label: "Wholesale receiving warehouse"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    type: string
    sql: ${TABLE}."street_address" ;;
  }

  dimension: zip {
    view_label: "Fulfillment"
    group_label: "Wholesale receiving warehouse"
    description: "Source: netsuite. v_wholesale_customer_warehouses"
    type: zipcode
    sql: ${TABLE}."zip" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [companyname]
  }
}
