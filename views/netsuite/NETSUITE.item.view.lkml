view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    label: "Item ID"
    group_label: "Advanced"
    description: "Internal Netsuite ID"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: classification {
    label: "Item Classification"
    description: "What stage is this item in production?"
    hidden:  yes
    type: string
    sql: ${TABLE}.classification ;;
  }

  dimension: UPC_code {
    label: "UPC Code"
    group_label: "Advanced"
    description: "What UPC code has been assigned"
    hidden:  no
    type: string
    sql: ${TABLE}.UPC_CODE ;;
  }

  dimension: type {
    label: "Type"
    hidden: yes
    description: "Item Type"
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: Weight {
    label: "Total Item Weight"
    hidden: yes
    type: sum
    sql: ${TABLE}.WEIGHT ;;
  }

  dimension: BASE_UNIT {
    label: "NetSuite Base Unit"
    group_label: "Advanced"
    description: "Used to show what unit non-each items are stored in"
    type: string
    sql: ${TABLE}.base_unit ;;
  }

  dimension: merchandise {
    label: "Is Merchandising Filter"
    view_label: "Filters"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;;
  }

  dimension: merchandise2 {
    label: "   * Is Merchandising"
    description: "Yes is a merchandising product for wholesale"
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;;
  }

  dimension: modified {
    label: "Includes Modifications Filter"
    view_label: "Filters"
    hidden: yes
    type: yesno
    sql: ${TABLE}.bi_update = 1 ;;
  }

  dimension: modified2 {
    label: "Includes Modifications"
    hidden: yes
    description: "Yes is indicating product attributes have been manually set by BI"
    type: yesno
    sql: ${TABLE}.bi_update = 1 ;;
  }

  dimension: finished_good_flg {
    label: " Is Finished Good Filter"
    view_label: "Filters"
    hidden:  yes
    type: yesno
    sql: ${classification} = 'FG' ;;
  }

  dimension: product_description {
    label:  "  Product Name"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
##    link: {
##      label: "NetSuite"
##      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${product_description_raw} ;;
  }

  dimension: product_description_legacy {
    hidden: yes
    label:  "  Product Name Legacy"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
##    link: {
##      label: "NetSuite"
##      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;;}

  dimension: product_name {
    label:  "3. Name"
    group_label: "Forecast Product Heirarchy"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${product_description_raw} ;;
  }

  dimension: product_name_legacy {
    hidden: yes
    label:  "3. Name Legacy"
    group_label: "Forecast Product Heirarchy"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;; }

  dimension: model_name {
    hidden:  no
    label:  " Model"
    description: "Original, H2, H3, H4, or Other"
    drill_fields: [product_description]
    type: string
    sql: ${model_raw} ;;
    }

  dimension: model_name_legacy {
    hidden:  yes
    label:  " Mattress Model Legacy"
    description: "Original, P2, P3, P4, Powerbase, or Other"
    drill_fields: [product_description]
    type: string
    case: {
      when: { sql: ${TABLE}.model_name_lkr = 'ORIGINAL'
            or  ${TABLE}.model_name_lkr = 'NEW ORIGINAL'
            or ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr = 'NO MODEL';; label: "ORIGINAL" }
      when: { sql: ${TABLE}.model_name_lkr = 'SCC' ;; label: "SCC" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.2' ;; label: "PURPLE.2" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.3' ;; label: "PURPLE.3" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.4' ;; label: "PURPLE.4" }
      when: { sql: ${TABLE}.model_name_lkr = 'POWERBASE' ;; label: "POWERBASE" }
      else: "Other" } }

  dimension: product_line_name_raw {
    type: string
    hidden: yes
    sql: ${TABLE}.product_line_name ;;
  }

  dimension: product_line_name {
    label: "   Production buckets"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: ${line_raw} ;;
  }

  dimension: product_line_name_legacy {
    hidden: yes
    label: "   Production buckets Legacy"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME_lkr ;; }

  dimension: product_bucket {
    label: "1 Buckets"
    group_label: "Forecast Product Heirarchy"
    description: "Grouping the type of products into Mattress, Bedding, Bases, and Other"
    type: string
    case: {
      when: { sql:  ${category_raw} = 'MATTRESS' ;; label: "Mattress" }
      when: { sql:  ${line_raw} in ('PILLOW','SHEETS','PROTECTORS') ;; label: "Bedding" }
      when: { sql:  ${line_raw} in ('PLATFORM', 'FOUNDATION', 'POWERBASE') ;; label: "Bases" }
      else: "Other" } }

  dimension: product_bucket_legacy {
    hidden: yes
    label: "1 Buckets"
    group_label: "Forecast Product Heirarchy Legacy"
    description: "Grouping the type of products into Mattress, Top, Bottom, and Other"
    type: string
    case: {
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' ;; label: "Mattress" }
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PILLOW','SHEETS','PROTECTOR') ;; label: "Top of Bed" }
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PLATFORM','POWERBASE') ;; label: "Bottom of Bed" }
      else: "Other" } }

  dimension: type_2 {
    label: "2. Type"
    group_label: "Forecast Product Heirarchy"
    description: "Type of product (hybrid, original mattress, pillow, cushion, etc.)"
    type: string
    sql: case when  ${category_raw} = 'MATTRESS' and ${line_raw} = 'FOAM' then 'Original'
           when  ${category_raw} = 'MATTRESS' and ${line_raw} <> 'FOAM' and ${line_raw} <> 'COIL' then 'Hybrid'
           else ${line_raw} end;;
  }

  dimension: type_2_legacy {
    hidden: yes
    label: "2. Type"
    group_label: "Forecast Product Heirarchy Legacy"
    description: "Type of product (new mattress, original mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr = '%ORIGINAL%'  then 'Original'
     when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr <> 'ORIGINAL' and ${TABLE}.model_name_lkr <> 'NEW ORIGINAL' then 'New Mattress'
     else ${TABLE}.PRODUCT_LINE_NAME_lkr end;; }

  dimension: product_line_name_with_bases_breakout {
    hidden: yes
    label: "Product Type with Bases Breakout Legacy"
    description: "Type of product (mattress, pillow, cushion, etc.)"
    type: string
    sql: case when ${line_raw} = 'POWERBASE' then 'POWERBASE'
              when ${line_raw} = 'PLATFORM' then 'PLATFORM'
              else ${line_raw} end;;
  }

  dimension: product_line_name_with_bases_breakout_legacy {
    hidden: yes
    label: "Product Type with Bases Breakout Legacy"
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
      when: { sql: ${line_raw} = 'FOAM' ;; label: "ORIGINAL" }
      #when: { sql: ${line_raw} <> 'COIL' ;; label: "ORIGINAL" }
      #when: { sql: ${model_raw} = 'SCC' ;; label: "SCC" }
      when: { sql: ${model_raw} = 'HYBRID 2' ;; label: "HYBRID 2" }
      when: { sql: ${model_raw} = 'HYBRID PREMIER 3' ;; label: "HYBRID PREMIER 3" }
      when: { sql: ${model_raw} = 'HYBRID PREMIER 4' ;; label: "HYBRID PREMIER 4" }
      when: { sql: ${line_raw} = 'POWERBASE' ;; label: "POWERBASE" }
      else: "Other" } }

  dimension: product_line_model_name_legacy {
    hidden: yes
    label: "Product/Model (bucket) Legacy"
    description: "Pillow, Powerbase, Original, P2, P3, P4, or Other"
    type: string
    case: {
      when: { sql: ${TABLE}.model_name_lkr = 'ORIGINAL' ;; label: "ORIGINAL" }
      when: { sql: ${TABLE}.model_name_lkr = 'NEW ORIGINAL' ;; label: "NEW ORIGINAL" }
      when: { sql: ${TABLE}.model_name_lkr = 'SCC' ;; label: "SCC" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.2' ;; label: "PURPLE.2" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.3' ;; label: "PURPLE.3" }
      when: { sql: ${TABLE}.model_name_lkr = 'PURPLE.4' ;; label: "PURPLE.4" }
      when: { sql: ${TABLE}.model_name_lkr = 'POWERBASE' ;; label: "POWERBASE" }
      else: "Other" } }

  dimension: manna_fulfilled {
    hidden: yes
    view_label: "Fulfillment"
    label: "Is Fulfilled by Manna"
    description: "Yes is an item normally fulfilled by Manna (hybrid or powerbase)"
    type: yesno
    sql: ${is_original_New_mattress} = 'Hybrid' or ${line_raw} = 'POWERBASE' ;;
  }

  dimension: manna_fulfilled_legacy {
    hidden: yes
    view_label: "Fulfillment"
    label: "Is Fulfilled by Manna Legacy"
    description: "Yes is an item normally fulfilled by Manna (new mattress or powerbase)"
    type: yesno
    sql: ${is_original_New_mattress} = 'New Mattress' or ${TABLE}.model_name_lkr = 'POWERBASE' ;; }

  dimension: is_mattress {
    hidden: yes
    label: "Is Mattress"
    description: "Yes is a mattress"
    type: yesno
    sql:  ${category_raw} = 'MATTRESS' ;;
  }

  dimension: is_mattress_legacy {
    hidden: yes
    label: "Is Mattress"
    description: "Yes is a mattress Legacy"
    type: yesno
    sql: ${product_line_name} = 'MATTRESS' ;; }

  dimension: is_original_New_mattress {
    label: "Original or Hybrid"
    hidden: yes
    description: "Buckets with an option of Original, Hybrid or Other"
    type: string
    sql: case
      when  ${category_raw} = 'MATTRESS' and ${line_raw} = 'FOAM' then 'Original'
      when  ${category_raw} = 'MATTRESS' and ${model_raw} in ('HYBRID 2', 'HYBRID PREMIER 3', 'HYBRID PREMIER 4')  then 'Hybrid'
      else 'Other' end;;
  }

  dimension: is_original_New_mattress_legacy {
    label: "Original or New Mattress Legacy"
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
    sql: ${category_raw} ;;
  }

  dimension: sub_category_name_legacy {
    hidden: yes
    type: string
    sql: ${TABLE}.SUB_CATEGORY_NAME_lkr ;; }

  dimension: category_name {
    hidden: yes
    label: "Category"
    description:  "Sit / Sleep / Stand"
    type: string
    sql: ${category_raw} ;;
  }

  dimension: category_name_legacy {
    hidden: yes
    label: "Category Legacy"
    description:  "Sit / Sleep / Stand"
    type: string
    sql: ${TABLE}.CATEGORY_NAME_lkr ;; }

  dimension: category_raw { hidden: yes sql: ${TABLE}.category ;;
  }
  dimension: line_raw { hidden: yes sql: ${TABLE}.line ;;
  }
  dimension: model_raw { hidden: yes sql: ${TABLE}.model ;;
  }
  dimension: product_description_raw { hidden: yes sql: ${TABLE}.product_description ;;
  }

  dimension: color {
    label: " Product Color"
    description: "Gives Color for Products with an Assigned Color (Grey, Charchoal, Slate, Sand, etc)"
    type: string
    sql: case when ${product_description_raw} ilike '%GREY' then 'GREY'
      when ${product_description_raw} ilike '%CHARCL' then 'CHARCOAL'
      when ${product_description_raw} ilike '%SLATE' then 'SLATE'
      when ${product_description_raw} ilike '%SAND' then 'SAND'
      when ${product_description_raw} ilike '%WHITE' then 'WHITE'
      when ${product_description_raw} ilike '%PURPLE' then 'PURPLE'
      else null end ;; }

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
    label: " Mattress Size"
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
    group_label: "Advanced"
    description: "SKU ID for item (XX-XX-XXXXXX)"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    type: string
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: sku_clean {
    type: string
    hidden: yes
    sql: case when left(${sku_id},3) = 'AC-' then right(${sku_id},11) else ${sku_id} end ;;
  }

  dimension: sku_merged {
    type: string
    hidden: yes
    sql: --OG Mattress
      case when ${sku_clean} = '10-21-23960' then '10-21-12960'
        when ${sku_clean} = '10-21-23620' then '10-21-12620'
        when ${sku_clean} = '10-21-23632' then '10-21-12632'
        when ${sku_clean} = '10-21-23625' then '10-21-12625'
        when ${sku_clean} = '10-21-23617' then '10-21-12617'
        when ${sku_clean} = '10-21-23618' then '10-21-12618'
        --Platforms
        when ${sku_clean} in ('10-38-82822','10-38-52822') then '10-38-12822'
        when ${sku_clean} in ('10-38-82815','10-38-92892','10-38-92892','10-38-52815') then '10-38-12815'
        when ${sku_clean} in ('10-38-82846','10-38-52846') then '10-38-12846'
        when ${sku_clean} in ('10-38-82893','10-38-82895','10-38-82895','10-38-52893') then '10-38-12893'
        when ${sku_clean} in ('10-38-82890','10-38-82890','10-38-82892','10-38-52892') then '10-38-12892'
        when ${sku_clean} in ('10-38-52891') then '10-38-82891'
        --Cushions
        when ${sku_clean} = '10-41-12571' then '10-41-12378'
        when ${sku_clean} = '10-41-12533' then '10-41-12573'
        when ${sku_clean} = '10-41-12574' then '10-41-12502'
        when ${sku_clean} in ('10-41-12572','10-41-12583') then '10-41-12496'
        when ${sku_clean} = '10-41-12576' then '10-41-12519'
        --Protectors
        when ${sku_clean} = '10-38-13917' then '10-38-12717'
        when ${sku_clean} = '10-38-13994' then '10-38-12694'
        when ${sku_clean} = '10-38-13900' then '10-38-12700'
        when ${sku_clean} in ('10-38-13748','10-38-12755') then '10-38-12748'
        when ${sku_clean} = '10-38-13924' then '10-38-12724'
        when ${sku_clean} = '10-38-13731' then '10-38-12731'
        --powerbases
        when ${sku_clean} in ('10-38-12946','10-38-12949') then '10-38-12953'
        when ${sku_clean} = '10-38-12939' then '10-38-12948'
        else ${sku_clean} end ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: Inactive {
    label: "   * Inactive Item?"
    hidden: no
    type: yesno
    sql: Case when ${TABLE}.inactive = 1 Then true else false End ;;
  }

  dimension: Classification_Groups{
    label: "Classification (buckets)"
    group_label: "Advanced"
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
    sql: ${TABLE}.DIMENSIONS ;;
  }

  dimension: bucketed_item_id {
    hidden: yes
    type: string
    sql: case when ${TABLE}.ITEM_ID = '3797' then '1668'
            when ${TABLE}.ITEM_ID = '3800' then '2991'
            when ${TABLE}.ITEM_ID = '4410' then '4409'
            when ${TABLE}.ITEM_ID = '3798' then '1667'
            when ${TABLE}.ITEM_ID = '3799' then '1666'
            when ${TABLE}.ITEM_ID = '3802' then '3715'
            when ${TABLE}.ITEM_ID = '3801' then '1665'
            else ${TABLE}.ITEM_ID
            end ;;
  }

  dimension: bucketed_bases {
    hidden: yes
    type: string
    sql: case
             when ${type_2} IN ('PLATFORM', 'FOUNDATION') and ${line_raw} = 'FOUNDATION' then 'Foundations (accordion)'
             when ${type_2} IN ('PLATFORM', 'FOUNDATION') and ${line_raw} = 'PLATFORM' then 'Platforms (non-accordion)'
             when ${type_2} = 'POWERBASE'  then 'PowerBase'
             else 'Other'
             end ;;
  }

  dimension: bucketed_bases_legacy {
    hidden: yes
    type: string
     sql: case
           when ${type_2} = 'PLATFORM' and ${product_name} ilike ('%accordion%') then 'Foundations (accordion)'
           when ${type_2} = 'PLATFORM' and ${product_name} not ilike ('%accordion%') then 'Platforms (non-accordion)'
           when ${type_2} = 'POWERBASE'  then 'PowerBase'
           else 'Other'
           end ;;  }

}
