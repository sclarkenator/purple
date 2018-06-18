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
    label:  "Mattress model"
    type: string
      case: {
        when: {
          sql:  ${TABLE}.MODEL_NAME = 'The Purple Mattress' ;;
          label: "Original"
        }
        when: {
          sql:  ${TABLE}.MODEL_NAME = 'Purple.2' ;;
          label: "Purple.2"
        }
          when: {
            sql:  ${TABLE}.MODEL_NAME = 'Purple.3' ;;
            label: "Purple.3"
          }
        when: {
          sql:  ${TABLE}.MODEL_NAME = 'Purple.4' ;;
          label: "Purple.4"
              }
        when: {
          sql:  ${TABLE}.MODEL_NAME is null ;;
          label: "non-mattress"
              }
      }
  }

  dimension: product_line_name {
    label: "Product line"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME ;;
  }

  dimension: sub_category_name {
    hidden: yes
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME ;;
  }
  dimension: category_name {
    label: "Sit / Sleep / Stand"
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
    label: "Mattress size"
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
