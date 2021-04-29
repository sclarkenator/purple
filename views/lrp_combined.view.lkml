view: lrp_combined {
  sql_table_name: "SALES"."FORECAST_LRP"
    ;;

  dimension: account {
    type: string
    sql: ${TABLE}."ACCOUNT" ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  measure: discount_sales {
    type: sum
    group_label: "Amount"
    value_format: "$#,##0"
    sql: ${TABLE}."DISCOUNT_SALES" ;;
  }

  measure: discount_units {
    group_label: "Amount"
    value_format: "#,##0"
    sql: ${TABLE}."DISCOUNT_UNITS" ;;
  }

  dimension_group: forecast {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FORECAST" ;;
  }

  measure: gross_sales {
    type: sum
    group_label: "Amount"
    value_format: "$#,##0"
    sql: ${TABLE}."GROSS_SALES" ;;
  }


  measure: promo_units {
    group_label: "Amount"
    value_format: "#,##0"
    sql: ${TABLE}."PROMO_UNITS" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  measure: total_sales {
    type: sum
    group_label: "Amount"
    value_format: "$#,##0"
    sql: ${TABLE}."TOTAL_SALES" ;;
  }

  measure: total_units {
    group_label: "Amount"
    value_format: "#,##0"sql: ${TABLE}."TOTAL_UNITS" ;;
  }

  measure: units {
    group_label: "Amount"
    value_format: "#,##0"
    sql: ${TABLE}."UNITS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
