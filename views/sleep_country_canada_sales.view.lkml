view: sleep_country_canada_sales {
  sql_table_name: "WHOLESALE"."SLEEP_COUNTRY_CANADA_SALES"
    ;;

  dimension: address_city {
    type: string
    sql: ${TABLE}."ADDRESS_CITY" ;;
  }

  dimension: address_province {
    type: string
    sql: ${TABLE}."ADDRESS_PROVINCE" ;;
  }

  dimension_group: created {
    label: "Order Date"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  measure: net_sales {
    type: sum
    sql: ${TABLE}."NET_SALES" ;;
  }

  dimension: net_units {
    type: number
    sql: ${TABLE}."NET_UNITS" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: phone_home {
    type: string
    sql: ${TABLE}."PHONE_HOME" ;;
  }

  dimension: phone_mobile {
    type: string
    sql: ${TABLE}."PHONE_MOBILE" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}."STORE_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, last_name]
  }

  dimension: pk {
    type: string
    primary_key:  yes
    sql: ${order_id}||${sku} ;;

  }

  dimension: net_sales_dim {
    type: number
    sql: ${TABLE}."NET_SALES" ;;
  }
}
