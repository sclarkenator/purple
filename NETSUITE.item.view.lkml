view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    label: "Item ID"
    description: "Internal Netsuite ID"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: classification {
    label: "Item Classification"
    description: "What stage is this item in production?"
    hidden:  yes
    type: string
    sql: ${TABLE}.classification ;; }

  dimension: type {
    label: "Type"
    hidden: yes
    description: "Item Type"
    type: string
    sql: ${TABLE}.type ;; }

  dimension: BASE_UNIT {
    label: "NetSuite Base Unit"
    description: "Used to show what unit non-each items are stored in"
    type: string
    sql: ${TABLE}.base_unit ;; }

  dimension: merchandise {
    label: "Is Merchandising Filter"
    view_label: "Filters"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;; }

  dimension: merchandise2 {
    label: "Is Merchandising"
    description: "Yes is a merchandising product for wholesale"
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;; }

  dimension: modified {
    label: "Includes Modifications Filter"
    view_label: "Filters"
    hidden: yes
    type: yesno
    sql: ${TABLE}.bi_update = 1 ;;}

  dimension: modified2 {
    label: "Includes Modifications"
    hidden: yes
    description: "Yes is indicating product attributes have been manually set by BI"
    type: yesno
    sql: ${TABLE}.bi_update = 1 ;;}

  dimension: finished_good_flg {
    label: " Is Finished Good Filter"
    view_label: "Filters"
    hidden:  yes
    type: yesno
    sql: ${classification} = 'FG' ;;}

  dimension: product_description {
    label:  "Product Name"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;; }

  dimension: product_name {
    label:  "3. Name"
    group_label: "Forecast Tier"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;; }

  dimension: model_name {
    hidden:  no
    label:  "Mattress Model"
    description: "Original, P2, P3, P4, Powerbase, or Other"
    drill_fields: [product_description]
    type: string
    case: {
      when: { sql: ${TABLE}.model_name_lkr = 'ORIGINAL' ;; label: "ORIGINAL" }
      when: { sql: ${TABLE}.model_name_lkr = 'SCC' ;; label: "SCC" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.2' ;; label: "PURPLE.2" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.3' ;; label: "PURPLE.3" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.4' ;; label: "PURPLE.4" }
      when: { sql: ${TABLE}.model_name_lkr = 'POWERBASE' ;; label: "POWERBASE" }
      else: "Other" } }

  dimension: product_line_name {
    label: "Production buckets"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME_lkr ;; }

  dimension: product_bucket {
    label: "1 Buckets"
    group_label: "Forecast Tier"
    description: "Grouping the type of products into Mattress, Top, Bottom, and Other"
    type: string
        case: {
          when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' ;; label: "Mattress" }
          when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PILLOW','SHEETS','PROTECTOR') ;; label: "Top of Bed" }
          when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PLATFORM','POWERBASE') ;; label: "Bottom of Bed" }
          else: "Other" } }

  dimension: type_2 {
    label: "2. Type"
    group_label: "Forecast Tier"
    description: "Type of product (new mattress, original mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr = 'ORIGINAL'  then 'Original'
     when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr <> 'ORIGINAL'  then 'New Mattress'
     else ${TABLE}.PRODUCT_LINE_NAME_lkr end;; }

  dimension: product_line_name_with_bases_breakout {
    hidden: yes
    label: "Product Type with Bases Breakout"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${TABLE}.MODEL_NAME_lkr = 'POWERBASE' then 'POWERBASE'
              when ${TABLE}.MODEL_NAME_lkr = 'PLATFORM' then 'PLATFORM'
              else ${TABLE}.PRODUCT_LINE_NAME_lkr end;; }

  dimension: product_line_model_name {
    hidden: yes
    label: "Product/Model (bucket)"
    description: "Pillow, Powerbase, Original, P2, P3, P4, or Other"
    type: string
    case: {
      when: { sql: ${model_name} = 'ORIGINAL' ;; label: "ORIGINAL" }
      when: { sql: ${model_name} = 'PURPLE.2' ;; label: "PURPLE.2" }
      when: { sql: ${model_name} = 'PURPLE.3' ;; label: "PURPLE.3" }
      when: { sql: ${model_name} = 'PURPLE.4' ;; label: "PURPLE.4" }
      when: { sql: ${product_line_name} = 'PILLOW' ;; label: "PILLOW" }
      when: { sql: ${product_line_name} = 'POWERBASE' ;; label: "POWERBASE" }
      #when: { sql: ${product_line_name} = 'SHEETS' ;; label: "SHEETS" }
      else: "OTHER" } }

  dimension: manna_fulfilled {
    hidden: yes
    view_label: "Fulfillment"
    label: "Is Fulfilled by Manna"
    description: "Yes is an item normally fulfilled by Manna (new mattress or powerbase)"
    type: yesno
    sql: ${is_original_New_mattress} = 'New Mattress' or ${TABLE}.model_name_lkr = 'POWERBASE' ;; }

  dimension: is_mattress {
    hidden: yes
    label: "Is Mattress"
    description: "Yes is a mattress"
    type: yesno
    sql: ${product_line_name} = 'MATTRESS' ;; }

  dimension: is_original_New_mattress {
    label: "Original or New Mattress"
    hidden: yes
    description: "Buckets with an option of Original, New Mattress or Other"
    type: string
    sql: case
      when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name_lkr = 'ORIGINAL'  then 'Original'
      when ${product_line_name} = 'MATTRESS' and ${TABLE}.model_name_lkr in ('PURPLE.2', 'PURPLE.3', 'PURPLE.4')  then 'New Mattress'
      else 'Other' end;; }

  dimension: sub_category_name {
    hidden: yes
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME_lkr ;; }

  dimension: category_name {
    hidden: yes
    label: "Category"
    description:  "Sit / Sleep / Stand"
    type: string
    sql: ${TABLE}.CATEGORY_NAME_lkr ;; }

  dimension: color {
    label: "Sheets Color"
    description: "Only sheets have color assigned"
    type: string
    sql: ${TABLE}.COLOR ;; }

  dimension: created_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED_TS ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: size {
    label: "Mattress Size"
    description:  "TwinXL, Full, Queen, King, Cal-King or Other"
    type: string
    case: {
        when: { sql: ${TABLE}.SIZE_lkr = 'TWIN' ;; label: "TWIN" }
        when: { sql: ${TABLE}.SIZE_lkr = 'TWIN XL' ;; label: "TWIN XL" }
        when: { sql: ${TABLE}.SIZE_lkr = 'FULL' ;; label: "FULL" }
        when: { sql: ${TABLE}.SIZE_lkr = 'QUEEN' ;; label: "QUEEN" }
        when: { sql: ${TABLE}.SIZE_lkr = 'KING' ;; label: "KING" }
        when: { sql: ${TABLE}.SIZE_lkr = 'CAL KING' ;; label: "CAL KING" }
        else: "Other" } }

  dimension: sku_id {
    label: "SKU ID"
    description: "SKU ID for item (XX-XX-XXXXXX)"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    type: string
    sql: ${TABLE}.SKU_ID ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: Classification_Groups{
    label: "Classification (buckets)"
    description: "Designates the item type (Finished Good, Factory Second, FG Component, Production Component, Semi Finished Goods, Raw Materials, Discounts, Other)"
    type: string
    sql: ${TABLE}.classification ;;
    case: {
      when: { sql: ${TABLE}.classification = 'FG' ;; label: "Finished Good" }
      when: { sql: ${TABLE}.classification = 'FS' ;;label: "Factory Second" }
      when: { sql: ${TABLE}.classification = 'FGC' ;; label: "Finished Goods Component" }
      when: { sql: ${TABLE}.classification = 'DSC' ;; label: "Discounts" }
      when: { sql: ${TABLE}.classification = 'SFG' ;; label: "Semi Finished Goods" }
      when: { sql: ${TABLE}.classification = 'RAW' ;; label: "Raw Materials" }
      when: { sql: ${TABLE}.classification = 'PRC' ;; label: "Production Components" }
      else: "Other" } }

    dimension: Product_Dimensions {
      hidden: yes
      label: "Product Dimensions"
      description: "Product size dimensions for cushions. Ex: 24 inches x 18 Inches"
      type: string
      sql: ${TABLE}.DIMENSIONS ;; }

}
