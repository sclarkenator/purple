view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: product_description {
    label:  "Product name"
    description: "Product name"
    type: string
    sql: ${TABLE}.PRODUCT_DESCRIPTION ;;
  }

  dimension: model_name {
    label:  "Model"
    description: "Model or style of item (model of cushion, mattress, etc)"
    type: string
    sql: ${TABLE}.MODEL_NAME ;;
      }

  dimension: product_line_name {
    label: "Product type"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME ;;
  }

  dimension: sub_category_name {
    hidden: yes
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME ;;
  }
  dimension: category_name {
    label: "Category"
    description:  "Sit / Sleep / Stand"
    type: string
    sql: ${TABLE}.CATEGORY_NAME ;;
  }

  dimension: color {
    description: "Only sheets have color assigned"
    type: string
    sql: ${TABLE}.COLOR ;;
  }

  dimension: created_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED_TS ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: size {
    label: "Mattress size"
    description:  "TwinXL|Full|Queen|King|Cal-king"
    type: string
    sql: ${TABLE}.SIZE ;;
  }

  dimension: sku_id {
    hidden: yes
    type: string
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: update_ts {
  hidden: yes
  type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

}
