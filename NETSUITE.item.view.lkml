view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    description: "NetSuites internal Primary Key."
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: classification {
    description: "What stage is this item in production?"
    hidden:  yes
    label: "Item classification"
    type: string
    sql: ${TABLE}.classification ;;
  }

  dimension: merchandise {
    description: "Is this a merchandising product for wholesale?"
    label: "Merchandising flag"
    #hidden:  yes
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;;
  }

  dimension: modified {
    description: "Flag field indicating product attributes have been manually set"
    label: "Modified flag"
    hidden: yes
    type: yesno
    sql: ${TABLE}.bi_update = 1 ;;
  }

  dimension: finished_good_flg {
    description: "Is this item a finished good?"
    label: "Finished good flag"
    hidden:  yes
    type: yesno
    sql: ${classification} = 'FG' ;;
  }

  dimension: product_description {
    label:  "Product name"
    description: "Product name"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
    }
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;;
  }

  dimension: model_name {
    label:  "Model"
    description: "Model or style of item (model of cushion, mattress, etc)"
    drill_fields: [product_description]
    type: string
    case: {
      when: {
        sql: ${TABLE}.model_name_lkr = 'ORIGINAL' ;;
        label: "ORIGINAL"
      }

      when: {
        sql: ${TABLE}.model_name_lkr = 'PURPLE.2' ;;
        label: "PURPLE.2"
      }

      when: {
        sql: ${TABLE}.model_name_lkr = 'PURPLE.3' ;;
        label: "PURPLE.3"
      }

      when: {
        sql: ${TABLE}.model_name_lkr = 'PURPLE.4' ;;
        label: "PURPLE.4"
      }

      when: {
        sql: ${TABLE}.model_name_lkr = 'POWERBASE' ;;
        label: "POWERBASE"
      }



    }
  }

  dimension: product_line_name {
    label: "Product type"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME_lkr ;;
  }

  dimension: product_line_name_with_bases_breakout {
    label: "Product type with Bases Breakout"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${TABLE}.MODEL_NAME_lkr = 'POWERBASE' then 'POWERBASE'
              when ${TABLE}.MODEL_NAME_lkr = 'PLATFORM' then 'PLATFORM'
              else ${TABLE}.PRODUCT_LINE_NAME_lkr end;;
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

      when: {
        sql: ${product_line_name} = 'POWERBASE' ;;
        label: "POWERBASE"
      }

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
    sql: ${is_original_New_mattress} = 'New' or ${TABLE}.model_name_lkr = 'POWERBASE' ;;
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
    sql: case when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name_lkr = 'ORIGINAL'  then 'Original'
              when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name_lkr in ('PURPLE.2', 'PURPLE.3', 'PURPLE.4')  then 'New' end;;
  }

  dimension: sub_category_name {
    hidden: yes
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME_lkr ;;
  }
  dimension: category_name {
    hidden: yes
    label: "Category"
    description:  "Sit / Sleep / Stand"
    type: string
    sql: ${TABLE}.CATEGORY_NAME_lkr ;;
  }

  dimension: color {
    description: "Only sheets have color assigned"
    label: "Sheets color"
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
              sql: ${TABLE}.SIZE_lkr = 'TWIN XL' ;;
              label: "TWIN XL"
            }

            when: {
              sql: ${TABLE}.SIZE_lkr = 'FULL' ;;
              label: "FULL"
            }

            when: {
              sql: ${TABLE}.SIZE_lkr = 'QUEEN' ;;
              label: "QUEEN"
            }

            when: {
              sql: ${TABLE}.SIZE_lkr = 'KING' ;;
              label: "KING"
            }

            when: {
              sql: ${TABLE}.SIZE_lkr = 'CAL KING' ;;
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

  dimension: Classification_Groups{
    type: string
    description: "Designates the item type ex: 'Finished Good'"
    sql: ${TABLE}.classification ;;
    case: {
      when: {
        sql: ${TABLE}.classification = 'FG' ;;
        label: "Finished Good"
      }

      when: {
        sql: ${TABLE}.classification = 'FS' ;;
        label: "Factory Second"
      }

      when: {
        sql: ${TABLE}.classification = 'FGC' ;;
        label: "Finished Goods Component"
      }

      when: {
        sql: ${TABLE}.classification = 'DSC' ;;
        label: "Discounts"
      }

      when: {
        sql: ${TABLE}.classification = 'SFG' ;;
        label: "Semi Finished Goods"
      }

      when: {
        sql: ${TABLE}.classification = 'RAW' ;;
        label: "Raw Materials"
      }
      when: {
        sql: ${TABLE}.classification = 'PRC' ;;
        label: "Production Components"
      }
  }
}
    dimension: Product_Dimensions {
      description: "Product size dimensions for cushions. Ex: 24 inches x 18 Inches"
      hidden: no
      type: string
      sql: ${TABLE}.DIMENSIONS ;;
    }

}
