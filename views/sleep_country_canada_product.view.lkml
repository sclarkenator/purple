view: sleep_country_canada_product {
  sql_table_name: "WHOLESALE"."SLEEP_COUNTRY_CANADA_PRODUCT"
    ;;

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: insert_ts {
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: purple_sku {
    type: string
    sql: ${TABLE}."PURPLE_SKU" ;;
  }

  dimension: scc_sku {
    type: string
    sql: ${TABLE}."SCC_SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
