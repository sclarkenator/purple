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

  dimension: product_line_name_with_bases_breakout {
    label: "Product type with Bases Breakout"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${TABLE}.MODEL_NAME = 'POWERBASE' then 'POWERBASE'
              when ${TABLE}.MODEL_NAME = 'PLATFORM' then 'PLATFORM'
              else ${TABLE}.PRODUCT_LINE_NAME end;;
  }

  dimension: is_mattress {
    label: "Mattress?"
    description: "Is this product a mattress"
    type: yesno
    sql: ${product_line_name} = 'MATTRESS' ;;
  }

  dimension: is_original_New_mattress {
    label: "Original or New Mattress?"
    description: "Is this product a mattress"
    type: string
    sql: case when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name = 'ORIGINAL'  then 'Original'
              when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name in ('PURPLE.2', 'PURPLE.3', 'PURPLE.4')  then 'New' end;;
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
