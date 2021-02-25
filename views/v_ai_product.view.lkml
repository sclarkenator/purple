view: v_ai_product {
  sql_table_name: "FORECAST"."V_AI_PRODUCT"
    ;;

  dimension_group: insert_ts {
    type: time
    hidden:  yes
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

  dimension: product_category {
    type: string
    group_label: "Future SKU"
    label: "1. Category Special"
    description: "Use with other Future SKU dimensions to see product information for all products, including forecasts for future releases"
    view_label: "Product"
    sql: coalesce (${item.category_name},${TABLE}."PRODUCT_CATEGORY") ;;
  }

  dimension: product_line {
    type: string
    group_label: "Future SKU"
    label: "2. Line Special"
    description: "Use with other Future SKU dimensions to see product information for all products, including forecasts for future releases"
    view_label: "Product"
    sql: coalesce (${item.line_raw},${TABLE}."PRODUCT_LINE") ;;
  }

  dimension: product_model {
    type: string
    group_label: "Future SKU"
    label: "3. Model Special"
    description: "Use with other Future SKU dimensions to see product information for all products, including forecasts for future releases"
    view_label: "Product"
    sql: coalesce (${item.model_raw}, ${TABLE}."PRODUCT_MODEL") ;;
  }

  dimension: sku_id {
    type: string
    label: "SKU ID Special"
    description: "Use to see regular SKUs plus placeholder SKUs for future release products"
    group_label: "Future SKU"
    view_label: "Product"
    sql: coalesce (${item.sku_id}, ${TABLE}."SKU_ID") ;;
  }

  dimension: sku_name {
    type: string
    hidden:  yes
    sql: ${TABLE}."SKU_NAME" ;;
  }

  dimension: sku_raw {
    type: string
    hidden: yes
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension_group: update_ts {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    hidden:  yes
    drill_fields: [sku_name]
  }
}
