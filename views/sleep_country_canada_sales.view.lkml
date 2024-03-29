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
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      month_name,
      quarter_of_year,
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
    label: "Net Sales USD"
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."NET_SALES_USD" ;;
  }

  measure: net_sales_cad {
    label: "Net Sales CAD"
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."NET_SALES_CAD" ;;
  }

  measure: net_sales_no_format {
    type: sum
    hidden: yes
    value_format: "###0"
    sql: ${TABLE}."NET_SALES_USD" ;;
  }

  measure: roas_sales {
    type:  sum
    description: "50% of Retail Sales, 100% of Online Sales USD"
    value_format: "$#,##0"
    sql: case when ${sleep_country_canada_store.source} = 'RETAIL' then ${TABLE}."NET_SALES_USD"*0.5 else ${TABLE}."NET_SALES_USD" end ;;
  }

  dimension: net_units {
    type: number
    value_format: "#,##0"
    sql: ${TABLE}."NET_UNITS" ;;
  }

  measure: total_net_units {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."NET_UNITS" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: phone_home {
    type: string
    sql: SPLIT_PART(${TABLE}."PHONE_HOME",'.',0) ;;
  }

  dimension: phone_mobile {
    type: string
    sql: SPLIT_PART(${TABLE}."PHONE_MOBILE",'.',0) ;;
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
    sql: ${TABLE}."NET_SALES_USD" ;;
  }
}
