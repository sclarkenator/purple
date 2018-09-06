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
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
    }
    sql: ${TABLE}.PRODUCT_DESCRIPTION ;;
  }

  dimension: model_name {
    label:  "Model"
    description: "Model or style of item (model of cushion, mattress, etc)"
    type: string
    case: {
      when: {
        sql: ${TABLE}.model_name = 'ORIGINAL' ;;
        label: "ORIGINAL"
      }

      when: {
        sql: ${TABLE}.model_name = 'PURPLE.2' ;;
        label: "PURPLE.2"
      }

      when: {
        sql: ${TABLE}.model_name = 'PURPLE.3' ;;
        label: "PURPLE.3"
      }

      when: {
        sql: ${TABLE}.model_name = 'PURPLE.4' ;;
        label: "PURPLE.4"
      }
    }
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

  dimension: product_line_model_name {
    label: "Product/model combo"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    case: {
      when: {
        sql: ${model_name} = 'ORIGINAL' ;;
        label: "ORIGINAL"
      }

      when: {
        sql: ${model_name} = 'PURPLE.2' ;;
        label: "PURPLE.2"
      }

      when: {
        sql:  ${model_name} = 'PURPLE.3' ;;
        label: "PURPLE.3"
      }

      when: {
        sql:  ${model_name} = 'PURPLE.4' ;;
        label: "PURPLE.4"
      }

      when: {
        sql: ${product_line_name} = 'PILLOW' ;;
        label: "PILLOW"
      }

#      when: {
#        sql: ${product_line_name} = 'CUSHION' ;;
#        label: "CUSHION"
#      }

#      when: {
#        sql: ${product_line_name} = 'SHEETS' ;;
#        label: "SHEETS"
#      }
        else: "OTHER"
    }
  }

  dimension: manna_fulfilled {
    view_label: "Fulfillment details"
    label: "Fulfilled by Manna?"
    description: "Is item fulfilled by Manna (currently any new-model mattress)"
    type: yesno
    sql: ${is_original_New_mattress} = 'New' or ${TABLE}.model_name = 'POWERBASE' ;;
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
    case: {
            when: {
              sql: ${TABLE}.SIZE = 'TWIN XL' ;;
              label: "TWIN XL"
            }

            when: {
              sql: ${TABLE}.SIZE = 'FULL' ;;
              label: "FULL"
            }

            when: {
              sql: ${TABLE}.SIZE = 'QUEEN' ;;
              label: "QUEEN"
            }

            when: {
              sql: ${TABLE}.SIZE = 'KING' ;;
              label: "KING"
            }

            when: {
              sql: ${TABLE}.SIZE = 'CAL KING' ;;
              label: "CAL KING"
            }
          }
  }

  dimension: sku_id {
    hidden: no
    type: string
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: update_ts {
  hidden: yes
  type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

}
