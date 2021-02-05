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
    group_label: "Product Hierarchy"
    label: "1. Category"
    view_label: "Product"
    sql: coalesce (${item.category_name},${TABLE}."PRODUCT_CATEGORY") ;;
  }

  dimension: product_line {
    type: string
    group_label: "Product Hierarchy"
    label: "2. Line"
    view_label: "Product"
    sql: coalesce (${item.line_raw},${TABLE}."PRODUCT_LINE") ;;
  }

  dimension: product_model {
    type: string
    group_label: "Product Hierarchy"
    label: "3. Model"
    view_label: "Product"
    sql: coalesce (${item.model_raw}, ${TABLE}."PRODUCT_MODEL") ;;
  }

  dimension: sku_id {
    type: string
    label: "SKU ID"
    group_label: "Advanced"
    sql: coalesce (${item.sku_id}, ${TABLE}."SKU_ID") ;;
  }

  dimension: sku_name {
    type: string
    hidden:  yes
    sql: ${TABLE}."SKU_NAME" ;;
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
