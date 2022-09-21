view: item {
  sql_table_name: SALES.ITEM ;;

  dimension: item_id {
    primary_key: yes
    label: "Item ID"
    group_label: "Advanced"
    description: "Internal Netsuite ID. Source:netsuite.item"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item_id._value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
    type: number
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: finished_good_flg {
    label: " Is Finished Good Filter"
    view_label: "Filters"
    # hidden:  yes
    type: yesno
    sql: ${classification} = 'FG' ;;}

  dimension: classification {
    label: "NetSuite Item Classification"
    group_label: "Advanced"
    description: "What stage is this item in production?. Source:looker.calculation"
    hidden:  no
    sql: ${TABLE}.classification_new ;;
  }

  dimension: classification1 {
    label: "Inventory type"
    group_label: "Advanced"
    description: "What stage is this item in production?. Source:looker.calculation"
    hidden:  yes
    case: {
            when: { sql: ${classification} = 'RM' ;; label: "RAW MATERIAL"}
            when: { sql: ${classification} = 'CM' ;; label: "RAW MATERIAL"}
            when: { sql: ${classification} = 'SA' ;; label: "WIP"}
            when: { sql: ${classification} = 'FG' ;; label: "FINISHED GOOD"}
            when: { sql: ${classification} = 'FS' ;; label: "FACTORY SECOND"}
            else: "OTHER"}
  }


 dimension: classification_raw {
    hidden:  yes
    type: string
    sql:  ${TABLE}.classification_new ;;
  }

  dimension: UPC_code {
    label: "UPC Code"
    group_label: "Advanced"
    description: "What UPC code has been assigned. Source: netsuite.item"
    hidden:  no
    type: string
    sql: ${TABLE}.UPC_CODE ;;
  }

  dimension: type {
    group_label: "Advanced"
    label: "Type"
    hidden: no
    description: "Item Type. Source: netsuite.item"
    type: string
    sql: ${TABLE}.type ;;
  }

##changed to a dimension because of aggregation issues when trying to sum as a measure.
  dimension: Weight {
    label: "Unit Weight"
    hidden: no
    value_format: "#,##0"
    type: number
    sql: ${TABLE}.WEIGHT ;;
  }

  dimension: BASE_UNIT {
    label: "NetSuite Base Unit"
    group_label: "Advanced"
    description: "Used to show what unit non-each items are stored in. Source:netsuite.item"
    type: string
    sql: ${TABLE}.base_unit ;;
  }

  dimension: merchandise {
    label: "Is Merchandising Filter"
    view_label: "Filters"
    # hidden:  yes
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;;
  }

  dimension: merchandise2 {
    label: "   * Is Merchandising"
    description: "Yes is a merchandising product for wholesale. Source: netsuite.item"
    type: yesno
    sql: ${TABLE}.merchandise = 1 ;;
  }

  dimension: modified {
    label: "Includes Modifications Filter"
    view_label: "Filters"
    # hidden: yes
    type: yesno
    #sql: ${TABLE}.bi_update = 1 ;;
    sql:  1 ;;
  }

  dimension: modified2 {
    label: "Includes Modifications"
    hidden: yes
    description: "Yes is indicating product attributes have been manually set by BI. Source: analytics.item"
    type: yesno
    #sql: ${TABLE}.bi_update = 1 ;;
    sql:  1 ;;
  }

  dimension: product_description {
    label:  "  Product Name"
    description: "from Netsuite, with a hyperlink to the product. Source: netsuite.item"
    type: string
##    link: {
##      label: "NetSuite"
##      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
##      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
    sql: ${product_description_raw} ;;
  }

  dimension: product_description_legacy {
    hidden: yes
    label:  "  Product Name Legacy"
    description: "from Netsuite, with a hyperlink to the product. Source: netsuite.item"
    type: string
##    link: {
##      label: "NetSuite"
##      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
##      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;;}

  dimension: product_name {
    label:  "3. Name"
    hidden: yes
    group_label: "Forecast Product Hierarchy"
    description: "from Netsuite, with a hyperlink to the product. Source: netsuite.item"
    type: string
   # link: {
   #  label: "NetSuite"
   #  url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
   #  icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
    sql: ${product_description_raw} ;;
  }

  dimension: product_name_legacy {
    hidden: yes
    label:  "3. Name Legacy"
    group_label: "Forecast Product Hierarchy"
    description: "from Netsuite, with a hyperlink to the product. Source: netsuite.item"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
    sql: ${TABLE}.PRODUCT_DESCRIPTION_LKR ;; }

  dimension: model_name {
    hidden:  no
    label:  " Model"
    description: "Original, H2, H3, H4, or Other. Source: netsuite.item"
    drill_fields: [product_description]
    type: string
    sql: ${model_raw} ;;
    }

  dimension: mattress_model_name {
    hidden:  yes
    label:  " Mattress Model Name"
    description: "4, 3, 2, Original. Source: looker calculation"
    drill_fields: [product_description]
    type: string
    case: {
      when: { sql: ${TABLE}.model = 'HYBRID PREMIER 4' ;; label: "4" }
      when: { sql: ${TABLE}.model = 'HYBRID PREMIER 3' ;; label: "3" }
      when: { sql: ${TABLE}.model = 'HYBRID 2' ;; label: "2" }
      when: { sql: ${TABLE}.model = 'THE PURPLE MATTRESS' OR ${TABLE}.model = 'ORIGINAL PURPLE MATTRESS' ;; label: " ORIGINAL" }
      else: "Other" } }

  dimension: model_name_legacy {
    hidden:  yes
    label:  " Mattress Model Legacy"
    description: "Original, P2, P3, P4, Powerbase, or Other. Source: looker calculation"
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
    description: "Type of product (mattress, pillow, cushion, etc.). Source: netsuite.item"
    type: string
    sql: ${line_raw} ;;
  }

  dimension: product_line_name_legacy {
    hidden: yes
    label: "   Production buckets Legacy"
    description: "Type of product (mattress, pillow, cushion, etc.). Source: netsuite.item"
    type: string
    sql: ${TABLE}.PRODUCT_LINE_NAME_lkr ;; }

  dimension: product_bucket {
    label: "1. Buckets"
    hidden: yes
    group_label: "Forecast Product Hierarchy"
    description: "Grouping the type of products into Mattress, Bedding, Bases, and Other. Source: looker calculation"
    type: string
    case: {
      when: { sql:  ${category_raw} = 'MATTRESS' ;; label: "Mattress" }
      when: { sql:  ${line_raw} in ('PILLOW','SHEETS','PROTECTORS') ;; label: "Bedding" }
      when: { sql:  ${line_raw} in ('PLATFORM', 'FOUNDATION', 'POWERBASE') ;; label: "Bases" }
      else: "Other" } }

  dimension: product_bucket_legacy {
    hidden: yes
    label: "1 Buckets Legacy"
    group_label: "Forecast Product Hierarchy Legacy"
    description: "Grouping the type of products into Mattress, Top, Bottom, and Other. Source: looker calculation"
    type: string
    case: {
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' ;; label: "Mattress" }
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PILLOW','SHEETS','PROTECTOR') ;; label: "Top of Bed" }
      when: { sql:  ${TABLE}.PRODUCT_LINE_NAME_lkr in ('PLATFORM','POWERBASE') ;; label: "Bottom of Bed" }
      else: "Other" } }

  dimension: type_2 {
    label: "2. Type"
    hidden: yes
    group_label: "Forecast Product Hierarchy"
    description: "Type of product (hybrid, original mattress, pillow, cushion, etc.). Source: looker calculation"
    type: string
    sql: case when  ${category_raw} = 'MATTRESS' and ${line_raw} = 'FOAM' then 'Original'
           when  ${category_raw} = 'MATTRESS' and ${line_raw} <> 'FOAM' and ${line_raw} <> 'COIL' then 'Hybrid'
           else ${line_raw} end;;
  }

  dimension: type_2_legacy {
    hidden: yes
    label: "2. Type"
    group_label: "Forecast Product Hierarchy Legacy"
    description: "Type of product (new mattress, original mattress, pillow, cushion, etc.). Source: looker calculation"
    type: string
    sql: case when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr = '%ORIGINAL%'  then 'Original'
     when ${TABLE}.PRODUCT_LINE_NAME_lkr = 'MATTRESS' and ${TABLE}.model_name_lkr <> 'ORIGINAL' and ${TABLE}.model_name_lkr <> 'NEW ORIGINAL' then 'New Mattress'
     else ${TABLE}.PRODUCT_LINE_NAME_lkr end;; }

  dimension: product_line_name_with_bases_breakout {
    hidden: yes
    label: "Product Type with Bases Breakout Legacy"
    description: "Type of product (mattress, pillow, cushion, etc.). Source: looker calculation"
    type: string
    sql: case when ${line_raw} = 'POWERBASE' then 'POWERBASE'
              when ${line_raw} = 'PLATFORM' then 'PLATFORM'
              else ${line_raw} end;;
  }

  dimension: product_line_name_with_bases_breakout_legacy {
    hidden: yes
    label: "Product Type with Bases Breakout Legacy"
    description: "Type of product (mattress, pillow, cushion, etc.). Source: looker calculation"
    type: string
    sql: case when ${TABLE}.MODEL_NAME_lkr = 'POWERBASE' then 'POWERBASE'
              when ${TABLE}.MODEL_NAME_lkr = 'PLATFORM' then 'PLATFORM'
              else ${TABLE}.PRODUCT_LINE_NAME_lkr end;; }

  dimension: product_line_model_name {
    hidden: yes
    label: "Product/Model (bucket)"
    description: "Pillow, Powerbase, Original, P2, P3, P4, or Other. Source: looker calculation"
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
    description: "Pillow, Powerbase, Original, P2, P3, P4, or Other. Source: looker calculation"
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
    description: "Yes is an item normally fulfilled by Manna (hybrid or powerbase). Source: looker calculation"
    type: yesno
    sql: ${is_original_New_mattress} = 'Hybrid' or ${line_raw} = 'POWERBASE' ;;
  }

  dimension: manna_fulfilled_legacy {
    hidden: yes
    view_label: "Fulfillment"
    label: "* Is Fulfilled by Manna Legacy"
    description: "Yes is an item normally fulfilled by Manna (new mattress or powerbase). Source: looker calculation"
    type: yesno
    sql: ${is_original_New_mattress} = 'New Mattress' or ${TABLE}.model_name_lkr = 'POWERBASE' ;; }

  dimension: is_mattress {
    hidden: yes
    label: "* Is Mattress"
    description: "Yes is a mattress. Source: looker calculation"
    type: yesno
    sql:  ${category_raw} = 'MATTRESS' ;;
  }

  dimension: is_mattress_legacy {
    hidden: yes
    label: "Is Mattress"
    description: "Yes is a mattress Legacy. Source: looker calculation"
    type: yesno
    sql: ${product_line_name} = 'MATTRESS' ;; }

  dimension: is_original_New_mattress {
    label: "Original or Hybrid"
    hidden: yes
    description: "Buckets with an option of Original, Hybrid or Other. Source: looker calculation"
    type: string
    sql: case
      when  ${category_raw} = 'MATTRESS' and ${line_raw} = 'FOAM' then 'Original'
      when  ${category_raw} = 'MATTRESS' and ${model_raw} in ('HYBRID 2', 'HYBRID PREMIER 3', 'HYBRID PREMIER 4')  then 'Hybrid'
      else 'Other' end;;
  }

  dimension: is_original_New_mattress_legacy {
    label: "Original or New Mattress Legacy"
    hidden: yes
    description: "Buckets with an option of Original, New Mattress or Other. Source: looker calculation"
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
    #hidden: yes
    group_label: "Product Hierarchy"
    label: "1. Category"
    description:  "Mattress/Bedding/Bases/Seating/Other. Source: netsuite.item"
    type: string
    sql: ${category_raw} ;;
  }

  dimension: category_name_legacy {
    hidden: yes
    label: "Category Legacy"
    description:  "Sit / Sleep / Stand. Source: netsuite.item"
    type: string
    sql: ${TABLE}.CATEGORY_NAME_lkr ;; }

  dimension: category_raw { hidden: yes sql: ${TABLE}.category ;;
  }
  dimension: line_raw {
    group_label: "Product Hierarchy"
    label: "2. Line"
    description: "Original/Hybird, Pillow/Bedding, Platform/Powerbase, etc. Source:netsuite.item"
    #hidden: yes
    sql: ${TABLE}.line ;;
  }
  dimension: model_raw {
    group_label: "Product Hierarchy"
    label: "3. Model"
    description: "Original/Hybird, Harmony/Plush, etc. Source: netsuite.item"
    sql: ${TABLE}.model ;;
    order_by_field: model_raw_order
  }
  dimension: model_raw_order {
    hidden:  yes
    group_label: "Product Hierarchy"
    label: "3. Model"
    description: "Original/Hybird, Harmony/Plush, etc. Source: netsuite.item"
    case: {
      when: {sql: ${TABLE}.model = 'KID BED';; label: "1"}
      when: {sql: ${TABLE}.model = 'PURPLE MATTRESS';; label: "2"}
      when: {sql: ${TABLE}.model = 'PURPLE PLUS CANADA';; label: "2.1"}
      when: {sql: ${TABLE}.model = 'PURPLE PLUS US';; label: "2.2"}
      when: {sql: ${TABLE}.model = 'HYBRID 2';; label: "3"}
      when: {sql: ${TABLE}.model = 'HYBRID PREMIER 3';; label: "4"}
      when: {sql: ${TABLE}.model = 'HYBRID PREMIER 4';; label: "5"}
      else: "6"

    }
  }

  dimension: version_raw {
    group_label: "Product Hierarchy"
    label: "4. Version"
    description: "Harmony/Harmony Vita, Clip Metal/Metal, OG/NOG rolling up into Harmony, Metal, Purple Mattress etc. Source:netsuite.item"
    sql: ${TABLE}.version ;;
  }

  dimension: product_description_raw {
    group_label: "Product Hierarchy"
    label: "5. Name"
    description: "Product Description. Source:netsuite.item"
    sql: ${TABLE}.product_description ;;
  }

  dimension: grid_height {
    group_label: "Advanced"
    label: "Grid Height"
    description: "2, 3, or 4 inch grid height. Source: Looker calculation"
    sql:
      case
        when ${TABLE}.model in ('KID BED','HYBRID 2','PURPLE MATTRESS','PURPLE PLUS CANADA','PURPLE PLUS US','LIFELINE MATTRESS') OR ${TABLE}.version in ('KID BED SCRIM PEAK','PURPLE/HYBRID 2 SCRIM PEAK','PURPLE MATTRESS SCRIM PEAK') then '2"'
        when ${TABLE}.model in ('HYBRID PREMIER 3','REST MATTRESS') OR ${TABLE}.version in ('HYBRID PREMIER 3 SCRIM PEAK','REST MATTRESS SCRIM PEAK') then '3"'
        when ${TABLE}.model = 'HYBRID PREMIER 4' OR ${TABLE}.version = 'HYBRID PREMIER 4 SCRIM PEAK' then '4"'
        else NULL
      end ;;
  }

  dimension: color {
    label: " Product Color"
    description: "Gives color for Products with an Assigned Color (Grey, Charchoal, Slate, Sand, etc). Source: NetSuite"
    type: string
    sql: ${TABLE}.color
     -- commented out by Jared Nov 18 in favor of new NS field
     -- case when ${TABLE}.color is not null then ${TABLE}.color
     --  when ${product_description_raw} ilike '%GREY%' AND ${product_description_raw} not ilike '%STORMY%' AND ${product_description_raw} not ilike '%NATURAL%' then 'Grey'
     --  when ${product_description_raw} ilike '%CHARCL%' then 'Charcoal'
     --  when ${product_description_raw} ilike '%SLATE%' then 'Slate'
     --  when ${product_description_raw} ilike '%SAND%' then 'Sand'
     --  when ${product_description_raw} ilike '%WHITE%' AND ${product_description_raw} not ilike '%TRUE%' then 'White'
     --  when ${product_description_raw} ilike '%TRUE WHITE%' then 'True White'
     --  when ${product_description_raw} ilike '%PURPLE' AND ${product_description_raw} not ilike '%DEEP%' then 'Purple'
     --  when ${product_description_raw} ilike '%NATURAL OAT%' then 'Natural Oat'
     --  when ${product_description_raw} ilike '%NATURAL GREY%' then 'Natural Grey'
     --  when ${product_description_raw} ilike '%STORMY%' then 'Stormy Grey'
     --  when ${product_description_raw} ilike '%SOFT LILAC%' then 'Soft Lilac'
     --  when ${product_description_raw} ilike '%MORNING%' then 'Morning Mist'
     --  when ${product_description_raw} ilike '%DEEP PURPLE%' then 'Deep Purple'
     --  when ${product_description_raw} ilike '%CLOUD WHITE%' then 'Cloud White'
     --  when ${product_description_raw} ilike '%BLUSH PINK%' then 'Blush Pink'
     --  when ${product_description_raw} ilike '%DUSKY NAVY%' then 'Dusky Navy'
     --  when ${product_description_raw} ilike '%MISTY BLUE%' then 'Misty Blue'
     --  else null end
     ;; }

  dimension_group: created_ts {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.CREATED_TS ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: size {
    label: " Product Size"
    description:  "Size of product from Netsuite (Twin, Full/ Full XL / Queen, Small, etc.). Source: looker calculation"
    type: string
    order_by_field: size_order
    sql: case when ${TABLE}.size = 'NA' OR ${TABLE}.size is null then 'OTHER'
              when ${product_description_raw} ilike '%SPLIT KING%' then 'SPLIT KING'
              else ${TABLE}.size end ;; }

  dimension: size_order {
    hidden:  yes
    case: {
      when: {sql: ${TABLE}.size = 'Twin';; label: "1"}
      when: {sql: ${TABLE}.size = 'Twin XL';; label: "2"}
      when: {sql: ${TABLE}.size = 'Full';; label: "3"}
      when: {sql: ${TABLE}.size = 'Queen';; label: "4"}
      when: {sql: ${TABLE}.size = 'King';; label: "5"}
      when: {sql: ${TABLE}.size = 'Cal King';; label: "6"}
      else: "7"

    }
  }

  dimension: sku_id {
    label: "SKU ID"
    group_label: "Advanced"
    description: "SKU ID for item (XX-XX-XXXXXX). Source: netsuite.item"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item_id._value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"}
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
        --TPM FLR FS
        when ${sku_clean} in ('10-21-90026','10-21-90005') then '10-21-12960'
        when ${sku_clean} in ('10-21-23521','10-21-90025','10-21-90004') then '10-21-12632'
        when ${sku_clean} in ('10-21-23520','10-21-90024','10-21-90003' ) then '10-21-12625'
        when ${sku_clean} = '10-21-90023' then '10-21-12620'
        when ${sku_clean} in ('10-21-90022','10-21-23630') then '10-21-12618'
        when ${sku_clean} in ('10-21-90021','10-21-90000') then '10-21-12617'
        when ${sku_clean} = '10-21-90027' then '10-21-60524'
        --H2 FLR FS
        when ${sku_clean} = '10-21-90010' then '10-21-60008'
        when ${sku_clean} in ('10-21-90009','10-21-60521') then '10-21-60007'
        when ${sku_clean} in ('10-21-90008','10-21-60506') then '10-21-60006'
        when ${sku_clean} = '10-21-90007' then '10-21-60018'
        when ${sku_clean} in ('10-21-90006','10-21-60506') then '10-21-60005'
        --H3 FLR FS
         when ${sku_clean} = '10-21-90015' then '10-21-60012'
        when ${sku_clean} in ('10-21-90014','10-21-60522') then '10-21-60011'
        when ${sku_clean} in ('10-21-90013','10-21-60510','10-21-22985') then '10-21-60010'
        when ${sku_clean} = '10-21-90012' then '10-21-60019'
        when ${sku_clean} in ('10-21-90011','10-21-60509') then '10-21-60009'
        --H4 FLR FS
         when ${sku_clean} = '10-21-90020' then '10-21-60016'
        when ${sku_clean} in ('10-21-90019','10-21-60523') then '10-21-60015'
        when ${sku_clean} in ('10-21-90018','10-21-60514') then '10-21-60014'
        when ${sku_clean} = '10-21-90017' then '10-21-60020'
        when ${sku_clean} in ('10-21-90016','10-21-60513') then '10-21-60013'
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
        --Pillow 2.0
        when ${sku_clean} = '10-31-12863' then '10-31-12855'
        when ${sku_clean} = '10-31-12870' then '10-31-12855'
        when ${sku_clean} = '10-31-12875' then '10-31-12855'
        when ${sku_clean} = '10-31-12874' then '10-31-12855'

        --Plush Pillow
        when ${sku_clean} = '10-31-12862' then '10-31-12857'
        --Duvet Washable
        when ${sku_clean} = '10-38-13016' then '10-38-13015'
        when ${sku_clean} = '10-38-13011' then '10-38-13010'
        when ${sku_clean} = '10-38-13031' then '10-38-13030'
        when ${sku_clean} = '10-38-13006' then '10-38-13005'
        --NOG with OG Cover
        when ${sku_clean} = '10-21-12970' then '10-21-12960'
        when ${sku_clean} = '10-21-12967' then '10-21-12620'
        when ${sku_clean} = '10-21-12969' then '10-21-12632'
        when ${sku_clean} = '10-21-12968' then '10-21-12625'
        when ${sku_clean} = '10-21-12965' then '10-21-12617'
        when ${sku_clean} = '10-21-12966' then '10-21-12618'
        --Harmony
        when ${sku_clean} in ('10-31-12891','10-31-12900') then '10-31-12890'
        when ${sku_clean} in ('10-31-12896','10-31-12905') then '10-31-12895'
        --Booster Back Up
        when ${sku_clean} = '10-31-13102' then '10-31-13100'
        else ${sku_clean} end ;;
  }

  dimension: ecommerce_categories {
    type: string
    description: "Custom Product Bucketing for the eCommerce team's reporting. Bucketed by SKUs.
    Source:netsuite.item"
    group_label: "Advanced"
    hidden: no
    sql:
      case
        --Bedding--
        when ${sku_clean} = '10-38-13050' then 'Weighted Blanket'
        when ${sku_clean} in ('10-38-13025','10-38-13030','10-38-13020','10-38-13010','10-38-13011','10-38-13015','10-38-13005','10-38-13016') then 'Duvet'
        when ${sku_clean} in ('10-38-22823','10-38-12850','10-38-12793','10-38-12809','10-38-12786','10-38-12849','10-38-12823',
          '10-38-12816','10-38-12779','10-38-12790','10-38-12789','10-38-12787','10-38-12788','10-38-12848','10-38-12830','10-38-12847','10-38-12762') then 'Purple Sheets'
        when ${sku_clean} in ('10-38-23000', '10-38-23001', '10-38-23002', '10-38-23003', '10-38-23004', '10-38-23005', '10-38-23006', '10-38-23007', '10-38-23008', '10-38-23009',
          '10-38-23010', '10-38-23011', '10-38-23012', '10-38-23013', '10-38-23014', '10-38-23015', '10-38-23016', '10-38-23017', '10-38-23018', '10-38-23019', '10-38-23020',
          '10-38-23021', '10-38-23022', '10-38-23023', '10-38-23024', '10-38-23025', '10-38-23026', '10-38-23027') then 'Complete Comfort Sheets'
        when ${sku_clean} in ('10-38-22846','10-38-22856','10-38-22851','10-38-22836','10-38-22841','10-38-22831','10-38-22848','10-38-22858','10-38-22853','10-38-22838',
          '10-38-22843','10-38-22833','10-38-22847','10-38-22857','10-38-22852','10-38-22837','10-38-22842','10-38-22832','10-38-22849','10-38-22859','10-38-22854','10-38-22839',
          '10-38-22844','10-38-22834','10-38-22845','10-38-22855','10-38-22850','10-38-22835','10-38-22840','10-38-22830') then 'SoftStretch Sheets'
        when ${sku_clean} in ('10-38-23030', '10-38-23031', '10-38-23032', '10-38-23034', '10-38-23035', '10-38-23036', '10-38-23037', '10-38-23039') then 'Complete Comfort Pillowcase'
        when ${sku_clean} in ('10-38-22870','10-38-22864','10-38-22871','10-38-22865','10-38-22866','10-38-22860','10-38-22869','10-38-22863','10-38-22867','10-38-22861',
          '10-38-22868','10-38-22862') then 'SoftStretch Pillowcase'
        when ${sku_clean} in ('10-38-12717','10-38-12748','10-38-12755','10-38-12694','10-38-12700','10-38-12731','10-38-12724','10-38-13919','10-38-13731',
          '10-38-13748','10-38-13900','10-38-13917','10-38-13918','10-38-13924','10-38-13994') then 'Protector'
        when ${sku_clean} in ('10-38-13051', '10-38-13052', '10-38-13053', '10-38-13054', '10-38-13055') then 'Bearaby'

        --Pillow--
        when ${sku_clean} in ('10-31-12890','10-31-12895','10-31-12891','10-31-12896') then 'Harmony Pillow'
        when ${sku_clean} in ('10-31-12860','10-31-12857','10-31-12862') then 'Plush Pillow'
        when ${sku_clean} in ('10-31-12855','10-31-12854','10-31-12863') then 'Purple Pillow'
        when ${sku_clean} in ('10-31-12919', '10-31-12920', '10-31-12923', '10-31-12924') then 'Twincloud Pillow'
        when ${sku_clean} in ('10-31-12921', '10-31-12922') then 'Cloud Pillow'
    --    when ${sku_clean} = '10-31-12863' then 'Pillow Booster'

        --Cushions--
        when ${sku_clean} in ('10-41-12585','10-41-12378','10-41-12582','10-41-12540','10-41-12574','10-41-12583','10-41-12572','10-41-12496',
          '10-41-12573','10-41-12533','10-41-12584','10-41-12576','10-41-12519','10-41-12564','10-41-12557','10-41-12526') then 'Cushion'
        when ${sku_clean} in ('40-41-42065','40-41-42064','40-41-42033','40-41-42035','40-41-42019','40-41-42020','40-41-42096','40-41-42097','40-41-42601',
        '40-41-42002','40-41-42003','10-41-12502','40-41-42072','40-41-42071','40-41-42602','40-41-42040','40-41-42605','40-41-42041') then 'Cushion Cover'

        --Other--
        when ${sku_clean} in ('10-46-10096','10-46-10751','10-46-10089','10-46-10737','10-46-10072','10-46-10102') then 'Non-Brand'
        when ${sku_clean} in ('10-21-68268','40-21-68262') then 'Eye Mask'
        when ${sku_clean} in ('10-38-12894','10-22-10220','10-22-10330','10-22-10110','10-38-12897','10-38-12896',
          '10-38-12876','10-38-12875','10-38-12878','10-31-12856','10-31-13100','10-38-12904','10-38-12905','10-38-12906','10-38-73826',
          '10-38-73828','10-38-73829','10-38-73832','10-38-73833','10-38-73834','10-38-73835','10-38-73843','10-38-73844','10-38-73845',
          '10-38-73846','10-38-73851','10-38-73852','10-38-73825','10-38-73849','10-38-73850','10-38-73840','10-38-73839','10-38-73838',
          '10-38-73836','10-38-73831','10-38-73830','10-38-73827','10-38-73853','40-21-42180','40-21-42265','40-21-42155','40-21-42170',
          '40-21-42160','40-21-42150','40-21-42220','40-21-42195','40-21-42210','40-21-42200','40-21-42190','40-21-42260','40-21-42235',
          '40-21-42250','40-21-42240','40-21-42230','40-21-42130','40-21-42277','40-21-42060','40-21-42748','40-21-42032','40-21-42025',
          '40-21-42018','40-22-00030','40-22-00020','40-22-00010','40-31-41855','10-31-13102','10-21-13064','10-38-12907','10-38-82889',
          '40-21-62060','40-21-62748','40-21-62032','40-21-62025','40-21-62017','40-21-62018') then 'Replacement Parts and Hardware'
        when ${sku_clean} in ('10-11-18300','10-38-12554','10-38-12554','10-38-13764','10-38-13779','10-38-13780','10-38-13781',
          '10-38-13786','10-38-13787','10-38-13788','10-38-13794','10-38-13795','10-38-13809','10-38-13810','10-38-13811','10-38-13816',
          '10-38-13818','10-38-13824','10-38-13825','10-38-13832','10-38-13847','10-38-13849','10-38-13892','10-38-13956','10-38-13957','10-38-13959','10-38-13960','10-38-13001') then 'Misc'
        when ${sku_clean} = '10-31-12910' then 'Harmony Spare'
        when ${sku_clean} in ('10-25-18265','10-50-18265','10-11-18264','10-11-18273','10-11-18429') then 'Purple Squishy'
        when ${sku_clean} in ('10-47-20000','10-47-20001','10-47-20002','10-47-20004','10-47-20005',
          '10-47-20001 (OLD)','10-47-20000 (OLD)','10-47-20002 (OLD)') then 'Face Mask'

        --Beds--
        when ${sku_clean} in ('10-21-60008','10-21-60018','10-21-60003','10-21-60002','10-21-60001','10-21-60007','10-21-70007',
          '10-21-60006','10-21-70006','10-21-60028','10-21-60005') then 'Hybrid 2'
        when ${sku_clean} in ('10-21-60012','10-21-60019','10-21-60011','10-21-60010','10-21-60038','10-21-60009') then 'Hybrid 3'
        when ${sku_clean} in ('10-21-60016','10-21-60020','10-21-60015','10-21-60014','10-21-60058','10-21-60013') then 'Hybrid 4'
        when ${sku_clean} in ('10-21-12638','10-21-12617','10-21-12960','10-21-23960','10-21-12620','10-21-23620','10-21-12632',
          '10-21-23632','10-21-12625','10-21-23625','10-21-23638','10-21-23617','10-21-12618','10-21-23618','10-21-12968',
          '10-21-12969','10-21-12967','10-21-12966','10-21-12970','10-21-12965','10-21-12971') then 'Purple Mattress'
        when ${sku_clean} in ('10-22-10300','10-22-10200','10-22-10100') then 'Pet Bed'

       --Bases--
        when ${sku_clean} in ('10-38-45862','10-38-45864','10-38-45865','10-38-45866','10-38-45867','10-38-45868','10-38-45869',
          '10-38-45870','10-38-45871','10-38-45872','10-38-45873','10-38-45869','10-38-45863') then 'Foundation Base'
        when ${sku_clean} in ('10-38-52822','10-38-52893','10-38-52815','10-38-52846','10-38-52892','10-38-82822',
          '10-38-82893','10-38-82895','10-38-82815','10-38-82846','10-38-82891','10-38-72889','10-38-82892',
          '10-38-92892','10-38-82890','10-38-12822','10-38-12893','10-38-12815','10-38-12846','10-38-12892','10-38-52891','10-38-52891') then 'Platform Base'
        when ${sku_clean} in ('10-38-12959','10-38-12958','10-38-12957','10-38-12956','10-21-13027','10-38-12946','10-38-12939',
        '10-38-12948','10-38-12955','10-38-12952') then 'Adjustable Base'

        --Kid's Corner--
        when ${sku_clean} in ('10-21-60524') then 'Kid Mattress'
        when ${sku_clean} in ('10-38-12854','10-38-12852','10-38-12855') then 'Kid Sheets'
        when ${sku_clean} in ('10-31-12871','10-31-12873','10-31-12872','10-31-12869') then 'Kid Pillow'

      --Canada Mattress--
        when ${sku_clean} in ('10-21-22617','10-21-22618','10-21-22620','10-21-22625','10-21-22632','10-21-22960') then 'Canada'

      --Pajamas--
        when ${sku_clean} in ('10-90-10072','10-90-10071','10-90-10073','10-90-10074','10-90-10076','10-90-10075','10-90-10077',
        '10-90-10078','10-90-10080','10-90-10079','10-90-10082','10-90-10083','10-90-10086','10-90-10085','10-90-10084','10-90-10081') then 'Sleepy Jones'

        else 'unspecified' end ;;
  }

  dimension: ecommerce_categories_breakout {
    type: string
    description: "Custom Product Bucketing for the eCommerce team's reporting. Bucketed by SKUs, with Cushions broken out.
    Source:netsuite.item"
    group_label: "Advanced"
    hidden: yes
    sql:
      case
        --Bedding--
        when ${sku_clean} = '10-38-13050' then 'Weighted Blanket'
        when ${sku_clean} in ('10-38-13025','10-38-13030','10-38-13020','10-38-13010','10-38-13011','10-38-13015','10-38-13005','10-38-13016') then 'Duvet'
        when ${sku_clean} in ('10-38-22823','10-38-12850','10-38-12793','10-38-12809','10-38-12786','10-38-12849','10-38-12823',
          '10-38-12816','10-38-12779','10-38-12790','10-38-12789','10-38-12787','10-38-12788','10-38-12848','10-38-12830','10-38-12847','10-38-12762') then 'Purple Sheets'
        when ${sku_clean} in ('10-38-22846','10-38-22856','10-38-22851','10-38-22836','10-38-22841','10-38-22831','10-38-22848','10-38-22858','10-38-22853','10-38-22838',
          '10-38-22843','10-38-22833','10-38-22847','10-38-22857','10-38-22852','10-38-22837','10-38-22842','10-38-22832','10-38-22849','10-38-22859','10-38-22854','10-38-22839',
          '10-38-22844','10-38-22834','10-38-22845','10-38-22855','10-38-22850','10-38-22835','10-38-22840','10-38-22830') then 'SoftStretch Sheets'
        when ${sku_clean} in ('10-38-23000', '10-38-23001', '10-38-23002', '10-38-23003', '10-38-23004', '10-38-23005', '10-38-23006', '10-38-23007', '10-38-23008', '10-38-23009',
          '10-38-23010', '10-38-23011', '10-38-23012', '10-38-23013', '10-38-23014', '10-38-23015', '10-38-23016', '10-38-23017', '10-38-23018', '10-38-23019', '10-38-23020',
          '10-38-23021', '10-38-23022', '10-38-23023', '10-38-23024', '10-38-23025', '10-38-23026', '10-38-23027') then 'Complete Comfort Sheets'
        when ${sku_clean} in ('10-38-22870','10-38-22864','10-38-22871','10-38-22865','10-38-22866','10-38-22860','10-38-22869','10-38-22863','10-38-22867','10-38-22861',
          '10-38-22868','10-38-22862') then 'SoftStretch Pillowcase'
        when ${sku_clean} in ('10-38-23030', '10-38-23031', '10-38-23032', '10-38-23034', '10-38-23035', '10-38-23036', '10-38-23037', '10-38-23039') then 'Complete Comfort Pillowcase'
        when ${sku_clean} in ('10-38-12717','10-38-12748','10-38-12755','10-38-12694','10-38-12700','10-38-12731','10-38-12724','10-38-13919','10-38-13731',
          '10-38-13748','10-38-13900','10-38-13917','10-38-13918','10-38-13924','10-38-13994') then 'Protector'
        when ${sku_clean} in ('10-38-13051', '10-38-13052', '10-38-13053', '10-38-13054', '10-38-13055') then 'Bearaby'

        --Pillow--
        when ${sku_clean} in ('10-31-12890','10-31-12895','10-31-12891','10-31-12896') then 'Harmony Pillow'
        when ${sku_clean} in ('10-31-12860','10-31-12857','10-31-12862') then 'Plush Pillow'
        when ${sku_clean} in ('10-31-12855','10-31-12854','10-31-12863') then 'Purple Pillow'
        when ${sku_clean} in ('10-31-12919', '10-31-12920', '10-31-12923', '10-31-12924') then 'Twincloud Pillow'
        when ${sku_clean} in ('10-31-12921', '10-31-12922') then 'Cloud Pillow'
    --    when ${sku_clean} = '10-31-12863' then 'Pillow Booster'

        --Cushions--
        when ${sku_clean} in ('10-41-12585','10-41-12378') then 'Back Cushion'
        when ${sku_clean} in ('10-41-12582','10-41-12540') then 'Double Cushion'
        when ${sku_clean} = '10-41-12574' then 'Everywhere Cushion'
        when ${sku_clean} in ('10-41-12583','10-41-12572','10-41-12496') then 'Portable Cushion'
        when ${sku_clean} in ('10-41-12573','10-41-12533') then 'Royal Cushion'
        when ${sku_clean} in ('10-41-12584','10-41-12576','10-41-12519') then 'Simply Cushion'
        when ${sku_clean} = '10-41-12564' then 'Ultimate Cushion'
        when ${sku_clean} = '10-41-12557' then 'Deep Cushion'
        when ${sku_clean} = '10-41-12526' then 'Lite Cushion'
        when ${sku_clean} in ('40-41-42065','40-41-42064','40-41-42033','40-41-42035','40-41-42019','40-41-42020','40-41-42096','40-41-42097','40-41-42601',
        '40-41-42002','40-41-42003','10-41-12502','40-41-42072','40-41-42071','40-41-42602','40-41-42040','40-41-42605','40-41-42041') then 'Cushion Cover'

        --Other--
        when ${sku_clean} in ('10-46-10096','10-46-10751','10-46-10089','10-46-10737','10-46-10072','10-46-10102') then 'Non-Brand'
        when ${sku_clean} in ('10-21-68268','40-21-68262') then 'Eye Mask'
        when ${sku_clean} in ('10-38-12894','10-22-10220','10-22-10330','10-22-10110','10-38-12897','10-38-12896',
          '10-38-12876','10-38-12875','10-38-12878','10-31-12856','10-31-13100','10-38-12904','10-38-12905','10-38-12906','10-38-73826',
          '10-38-73828','10-38-73829','10-38-73832','10-38-73833','10-38-73834','10-38-73835','10-38-73843','10-38-73844','10-38-73845',
          '10-38-73846','10-38-73851','10-38-73852','10-38-73825','10-38-73849','10-38-73850','10-38-73840','10-38-73839','10-38-73838',
          '10-38-73836','10-38-73831','10-38-73830','10-38-73827','10-38-73853','40-21-42180','40-21-42265','40-21-42155','40-21-42170',
          '40-21-42160','40-21-42150','40-21-42220','40-21-42195','40-21-42210','40-21-42200','40-21-42190','40-21-42260','40-21-42235',
          '40-21-42250','40-21-42240','40-21-42230','40-21-42130','40-21-42277','40-21-42060','40-21-42748','40-21-42032','40-21-42025',
          '40-21-42018','40-22-00030','40-22-00020','40-22-00010','40-31-41855','10-31-13102','10-21-13064','10-38-12907','10-38-82889',
          '40-21-62060','40-21-62748','40-21-62032','40-21-62025','40-21-62017','40-21-62018') then 'Replacement Parts and Hardware'
        when ${sku_clean} in ('10-11-18300','10-38-12554','10-38-12554','10-38-13764','10-38-13779','10-38-13780','10-38-13781',
          '10-38-13786','10-38-13787','10-38-13788','10-38-13794','10-38-13795','10-38-13809','10-38-13810','10-38-13811','10-38-13816',
          '10-38-13818','10-38-13824','10-38-13825','10-38-13832','10-38-13847','10-38-13849','10-38-13892','10-38-13956','10-38-13957','10-38-13959','10-38-13960','10-38-13001') then 'Misc'
        when ${sku_clean} = '10-31-12910' then 'Harmony Spare'
        when ${sku_clean} in ('10-25-18265','10-50-18265','10-11-18264','10-11-18273','10-11-18429') then 'Purple Squishy'
        when ${sku_clean} in ('10-47-20000','10-47-20001','10-47-20002','10-47-20004','10-47-20005',
          '10-47-20001 (OLD)','10-47-20000 (OLD)','10-47-20002 (OLD)') then 'Face Mask'

        --Beds--
        when ${sku_clean} in ('10-21-60008','10-21-60018','10-21-60003','10-21-60002','10-21-60001','10-21-60007','10-21-70007',
          '10-21-60006','10-21-70006','10-21-60028','10-21-60005') then 'Hybrid 2'
        when ${sku_clean} in ('10-21-60012','10-21-60019','10-21-60011','10-21-60010','10-21-60038','10-21-60009') then 'Hybrid 3'
        when ${sku_clean} in ('10-21-60016','10-21-60020','10-21-60015','10-21-60014','10-21-60058','10-21-60013') then 'Hybrid 4'
        when ${sku_clean} in ('10-21-12638','10-21-12617','10-21-12960','10-21-23960','10-21-12620','10-21-23620','10-21-12632',
          '10-21-23632','10-21-12625','10-21-23625','10-21-23638','10-21-23617','10-21-12618','10-21-23618','10-21-12968',
          '10-21-12969','10-21-12967','10-21-12966','10-21-12970','10-21-12965','10-21-12971') then 'Purple Mattress'
        when ${sku_clean} in ('10-22-10300','10-22-10200','10-22-10100') then 'Pet Bed'

       --Bases--
        when ${sku_clean} in ('10-38-45862','10-38-45864','10-38-45865','10-38-45866','10-38-45867','10-38-45868','10-38-45869',
          '10-38-45870','10-38-45871','10-38-45872','10-38-45873','10-38-45863') then 'Foundation Base'
        when ${sku_clean} in ('10-38-52822','10-38-52893','10-38-52815','10-38-52846','10-38-52892','10-38-82822',
          '10-38-82893','10-38-82895','10-38-82815','10-38-82846','10-38-82891','10-38-72889','10-38-82892',
          '10-38-92892','10-38-82890','10-38-12822','10-38-12893','10-38-12815','10-38-12846','10-38-12892','10-38-52891') then 'Platform Base'
        when ${sku_clean} in ('10-38-12959','10-38-12958','10-38-12957','10-38-12956','10-21-13027','10-38-12946','10-38-12939',
        '10-38-12948','10-38-12955','10-38-12952') then 'Adjustable Base'

                --Kid's Corner--
        when ${sku_clean} in ('10-21-60524') then 'Kid Mattress'
        when ${sku_clean} in ('10-38-12854','10-38-12852','10-38-12855') then 'Kid Sheets'
        when ${sku_clean} in ('10-31-12871','10-31-12873','10-31-12872','10-31-12869') then 'Kid Pillow'

      --Canada Mattress--
        when ${sku_clean} in ('10-21-22617','10-21-22618','10-21-22620','10-21-22625','10-21-22632','10-21-22960') then 'Canada'

      --Pajamas--
        when ${sku_clean} in ('10-90-10072','10-90-10071','10-90-10073','10-90-10074','10-90-10076','10-90-10075','10-90-10077',
        '10-90-10078','10-90-10080','10-90-10079','10-90-10082','10-90-10083','10-90-10086','10-90-10085','10-90-10084','10-90-10081') then 'Sleepy Jones'

        else 'unspecified' end ;;
  }

  dimension: kit_item_id {
    description: "This is used for the forecast_combined and actual_sales explore.  It is break the kits/packages back to their child items"
    type: string
    hidden: yes
    sql:
      case
        --BASE
        when ${item_id} in ('9809') then '5749'
        when ${item_id} in ('9816') then '5194'
        when ${item_id} in ('9824') then '5750'
        when ${item_id} in ('10391') then '5947'
        when ${item_id} in ('11511') then '11508'
        when ${item_id} in ('14598') then '5949'
        when ${item_id} in ('14599') then '5950'
        when ${item_id} in ('14600') then '5951'
        when ${item_id} in ('14601') then '5953'
        when ${item_id} in ('14602') then '5952'
        when ${item_id} in ('14603') then '5954'
        when ${item_id} in ('14604') then '6000'
        when ${item_id} in ('14605') then '6001'
        when ${item_id} in ('14606') then '6002'
        when ${item_id} in ('14607') then '6003'
        when ${item_id} in ('14608') then '6004'
        when ${item_id} in ('14609') then '6005'
        --BEDDING
        when ${item_id} in ('9783') then '7580'
        when ${item_id} in ('9800') then '5923'
        when ${item_id} in ('9813') then '5174'
        --KIT
        when ${item_id} in ('9781') then '5194'
        when ${item_id} in ('9782') then '5557'
        when ${item_id} in ('9785') then '7576'
        when ${item_id} in ('9790') then '5175'
        when ${item_id} in ('9791') then '7782'
        when ${item_id} in ('9794') then '5192'
        when ${item_id} in ('9795') then '7678'
        when ${item_id} in ('9796') then '7884'
        when ${item_id} in ('9798') then '5196'
        when ${item_id} in ('9799') then '5186'
        when ${item_id} in ('9801') then '5176'
        when ${item_id} in ('9802') then '5195'
        when ${item_id} in ('9804') then '5177'
        when ${item_id} in ('9805') then '5195'
        when ${item_id} in ('9806') then '7784'
        when ${item_id} in ('9807') then '7789'
        when ${item_id} in ('9810') then '7786'
        when ${item_id} in ('9814') then '5190'
        when ${item_id} in ('9821') then '5174'
        when ${item_id} in ('9822') then '7777'
        --MATTRESS
        when ${item_id} in ('9786') then '7877'
        when ${item_id} in ('9787') then '7877'
        when ${item_id} in ('9789') then '7782'
        when ${item_id} in ('9792') then '7880'
        when ${item_id} in ('9803') then '7782'
        when ${item_id} in ('9808') then '7880'
        when ${item_id} in ('9815') then '7780'
        when ${item_id} in ('9818') then '7883'
        when ${item_id} in ('9820') then '7883'
        when ${item_id} in ('11262') then '11097'
        --SALES SUPPORT
        when ${item_id} in ('9793') then '6993'
        when ${item_id} in ('9811') then '6993'
        when ${item_id} in ('9817') then '6993'
        when ${item_id} in ('9823') then '6993'
        when ${item_id} in ('10281') then '7376'
        --SEATING
        when ${item_id} in ('9784') then '7576'
        when ${item_id} in ('9788') then '7581'
        when ${item_id} in ('9797') then '7578'
        when ${item_id} in ('9812') then '7376'
        when ${item_id} in ('9819') then '7577'
        when ${item_id} in ('9825') then '7579'
        --Z-MARKETING
        when ${item_id} in ('3502') then '3491'
        when ${item_id} in ('3504') then '3492'
        when ${item_id} in ('3429') then '3427'
        when ${item_id} in ('3430') then '3427'
        when ${item_id} in ('3497') then '3491'
        when ${item_id} in ('3499') then '3492'
        --FACE MASK
        when ${item_id} in ('11092') then '11720'
        when ${item_id} in ('11093') then '11721'
        when ${item_id} in ('11094') then '11723'
        --OTHER
        when ${item_id} in ('11107') then '8793'
        when ${item_id} in ('5863') then '5186'
        when ${item_id} in ('5862') then '5192'
        when ${item_id} in ('5866','5869') then '5195'
        when ${item_id} in ('9077') then '7887'
        else ${item_id} end ;;
  }

  dimension: kit_sku_id {
    description: "This is used for the forecast_combined and actual_sales explore.  It is break the kits/packages back to their child items"
    type: string
    hidden: yes
    sql:
      case
        --BASE
        when ${sku_clean} in ('10-38-12951') then '10-38-12948'
        when ${sku_clean} in ('10-21-13027') then '10-38-12939'
        when ${sku_clean} in ('10-38-12955') then '10-38-12952'
        when ${sku_clean} in ('10-38-52894') then '10-38-52846'
        when ${sku_clean} in ('10-38-12959') then '10-38-12956'
        when ${sku_clean} in ('10-38-45896') then '10-38-45862'
        when ${sku_clean} in ('10-38-45897') then '10-38-45863'
        when ${sku_clean} in ('10-38-45898') then '10-38-45864'
        when ${sku_clean} in ('10-38-45899') then '10-38-45865'
        when ${sku_clean} in ('10-38-45900') then '10-38-45866'
        when ${sku_clean} in ('10-38-45901') then '10-38-45867'
        when ${sku_clean} in ('10-38-45902') then '10-38-45868'
        when ${sku_clean} in ('10-38-45903') then '10-38-45869'
        when ${sku_clean} in ('10-38-45904') then '10-38-45870'
        when ${sku_clean} in ('10-38-45905') then '10-38-45871'
        when ${sku_clean} in ('10-38-45906') then '10-38-45872'
        when ${sku_clean} in ('10-38-45907') then '10-38-45873'
        --BEDDING
        when ${sku_clean} in ('10-31-72855') then '10-31-12855'
        when ${sku_clean} in ('10-38-13918') then '10-38-13924'
        when ${sku_clean} in ('10-38-13919') then '10-38-12724'
        --KIT
        when ${sku_clean} in ('10-38-13939') then '10-38-12939'
        when ${sku_clean} in ('10-38-13850') then '10-38-12850'
        when ${sku_clean} in ('10-41-13533') then '10-41-12533'
        when ${sku_clean} in ('10-38-13717') then '10-38-12717'
        when ${sku_clean} in ('10-21-13618') then '10-21-12618'
        when ${sku_clean} in ('10-38-13846') then '10-38-12846'
        when ${sku_clean} in ('10-31-13855') then '10-31-12854'
        when ${sku_clean} in ('10-21-60017') then '10-21-60018'
        when ${sku_clean} in ('10-38-13946') then '10-38-12946'
        when ${sku_clean} in ('10-38-13815') then '10-38-12815'
        when ${sku_clean} in ('10-38-13700') then '10-38-12700'
        when ${sku_clean} in ('10-38-13892') then '10-38-12892'
        when ${sku_clean} in ('10-38-13694') then '10-38-12694'
        when ${sku_clean} in ('10-21-13064') then '10-38-12892'
        when ${sku_clean} in ('10-21-13625') then '10-21-12625'
        when ${sku_clean} in ('10-21-13960') then '10-21-12960'
        when ${sku_clean} in ('10-21-13632') then '10-21-12632'
        when ${sku_clean} in ('10-38-13822') then '10-38-12822'
        when ${sku_clean} in ('10-38-13724') then '10-38-12724'
        when ${sku_clean} in ('10-21-12621') then '10-21-12620'
        --MATTRESS
        when ${sku_clean} in ('10-21-60058') then '10-21-60013'
        when ${sku_clean} in ('10-21-12964') then '10-21-60013'
        when ${sku_clean} in ('10-21-12961') then '10-21-12618'
        when ${sku_clean} in ('10-21-60028') then '10-21-60005'
        when ${sku_clean} in ('10-21-12638') then '10-21-12618'
        when ${sku_clean} in ('10-21-12962') then '10-21-60005'
        when ${sku_clean} in ('10-21-23638') then '10-21-23618'
        when ${sku_clean} in ('10-21-60038') then '10-21-60009'
        when ${sku_clean} in ('10-21-12963') then '10-21-60009'
        when ${sku_clean} in ('10-21-12971') then '10-21-12966'
        --SALES SUPPORT
        when ${sku_clean} in ('10-50-18265') then '10-11-18264'
        when ${sku_clean} in ('10-02-18265') then '10-11-18264'
        when ${sku_clean} in ('10-10-18265') then '10-11-18264'
        when ${sku_clean} in ('10-25-18265') then '10-11-18264'
        when ${sku_clean} in ('10-41-13610') then '10-41-12571'
        --SEATING
        when ${sku_clean} in ('10-41-72533') then '10-41-12533'
        when ${sku_clean} in ('10-41-72540') then '10-41-12540'
        when ${sku_clean} in ('10-41-72519') then '10-41-12519'
        when ${sku_clean} in ('10-41-72571') then '10-41-12571'
        when ${sku_clean} in ('10-41-72502') then '10-41-12502'
        when ${sku_clean} in ('10-41-72564') then '10-41-12564'
        --Z-MARKETING
        when ${sku_clean} in ('(OLD)10-11-18404') then '10-21-12601'
        when ${sku_clean} in ('(OLD)10-11-18405') then '10-21-12602'
        when ${sku_clean} in ('10-60-19000') then '10-60-10000'
        when ${sku_clean} in ('10-60-29000') then '10-60-10000'
        when ${sku_clean} in ('10-11-18401') then '10-21-12601'
        when ${sku_clean} in ('10-11-18402') then '10-21-12602'
        --FACE MASK
        when ${sku_clean} in ('10-47-20000 (OLD)') then '10-47-20000'
        when ${sku_clean} in ('10-47-20001 (OLD)') then '10-47-20001'
        when ${sku_clean} in ('10-47-20002 (OLD)') then '10-47-20002'
        --OTHER
        when ${sku_clean} in ('10-31-12891') then '10-31-12890'
        when ${sku_clean} in ('10-38-82815') then '10-38-12815'
        when ${sku_clean} in ('10-38-82846') then '10-38-12846'
        when ${sku_clean} in ('10-38-82890','10-38-92892') then '10-38-12892'
        when ${sku_clean} in ('10-21-70007') then '10-21-60007'

        else ${sku_clean} end ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: Inactive {
    label: "   * Inactive Item?"
    description: "Source: netsuite.item"
    hidden: no
    type: yesno
    sql: Case when ${TABLE}.inactive = 1 Then true else false End ;;
  }

  dimension: Classification_Groups{
    label: "Classification (buckets)"
    group_label: "Advanced"
    description: "Designates the item type (Finished Good, Factory Second, Purchased Component, Semi Finished Goods, Raw Materials, Kit, Other).
      Source: looker calculation"
    type: string
    #sql: ${TABLE}.classification ;;
    case: {
      when: { sql: ${classification} = 'FG' ;; label: "Finished Good" }
      when: { sql: ${classification} = 'FS' ;;label: "Factory Second" }
      when: { sql: ${classification} = 'CM' ;;label: "Purchased Component" }
      when: { sql: ${classification} = 'SA' ;; label: "Semi Finished Goods" }
      when: { sql: ${classification} = 'RM' ;; label: "Raw Materials" }
      when: { sql: ${classification} = 'KIT' ;; label: "Kit" }
      else: "Other" } }

  dimension: Product_Dimensions {
    hidden: yes
    label: "Product Dimensions"
    description: "Product size dimensions for cushions. Ex: 24 inches x 18 Inches. Source: netsuite.item"
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

  dimension: lifecycle_status {
    hidden: no
    group_label: "Advanced"
    type: string
    sql: ${TABLE}."LIFECYCLE_STATUS" ;;
  }

  dimension: wms_classification {
    label: "WMS Classification"
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.wms_classification ;;
  }

  dimension: height {
    group_label: "Advanced"
    type: number
    sql: ${TABLE}.height ;;
  }

  dimension: length {
    group_label: "Advanced"
    type: number
    sql: ${TABLE}.length ;;
  }

  dimension: width {
    group_label: "Advanced"
    type: number
    sql: ${TABLE}.width ;;
  }

  dimension: image_url {
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.image_url ;;
  }

}
