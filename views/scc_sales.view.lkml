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

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
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
    sql: ${TABLE}."UNITS" ;;
  }

  measure: amount {
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  measure: gross_margin {
    type: sum
    sql: ${TABLE}."GROSS_MARGIN" ;;
  }

  measure: gross_profit {
    type: sum
    sql: ${TABLE}."GROSS_PROFIT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
