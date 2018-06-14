view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: product_description {
    type: string
    sql: ${TABLE}.PRODUCT_DESCRIPTION ;;
  }

  dimension: model_name {
    description:  "Model (Original, Purple.2, Purple.3, etc."
    type: string
    sql: ${TABLE}.MODEL_NAME ;;
  }

  dimension: product_line_name {
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME ;;
  }

  dimension: sub_category_name {
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME ;;
  }
  dimension: category_name {
    description: "Sit / Sleep / Stand"
    type: string
    sql: ${TABLE}.CATEGORY_NAME ;;
  }

  dimension: color {
    description: "Color of sheets"
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
    label: "Size of Mattress"
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
