view: v_scc_sales {
  sql_table_name: "WHOLESALE"."SLEEP_COUNTRY_CANADA_SALES"
    ;;

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
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

  measure: units {
    type: sum
    sql: ${TABLE}."NET_UNITS" ;;
  }

  measure: net_sales_cad {
    type: sum
    sql: ${TABLE}."NET_SALES_CAD" ;;
    value_format: "$#,##0.00"
  }

  measure: net_sales_usd {
    type: sum
    sql: ${TABLE}."NET_SALES_USD" ;;
    value_format: "$#,##0.00"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
