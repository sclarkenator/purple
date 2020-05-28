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
    label: "NetSuite Item Classification"
    group_label: "Advanced"
    description: "What stage is this item in production?"
    hidden:  no
    sql:
    case when
    --split king mattress kits and split king powerbase kits
        ${item_id} in ('9815','9824','9786','9792','9818','9803','4412','4413','4409','4410','4411','3573') -- then 'FG'
        -- adds metal frame bases to finished goods
        or ${line_raw} = 'FRAME' or ( ${category_raw} = 'SEATING' and (${product_description} ilike '%4 PK' or ${product_description} ilike '%6 PK')) then 'FG'
        else ${TABLE}.classification_new end ;;
  }

  dimension: classification_raw {
    hidden:  yes
    type: string
    sql:  ${TABLE}.classification_new ;;
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
    hidden: yes
    group_label: "Forecast Product Hierarchy"
    description: "from Netsuite, with a hyperlink to the product"
    type: string
   # link: {
   # label: "NetSuite"
    #  url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ item.item_id._value }}" }
    sql: ${product_description_raw} ;;
  }

  dimension: product_name_legacy {
    hidden: yes
    label:  "3. Name Legacy"
    group_label: "Forecast Product Hierarchy"
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

  dimension: mattress_model_name {
    hidden:  yes
    label:  " Mattress Model Name"
    description: "4, 3, 2, Original"
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
    label: "1. Buckets"
    hidden: yes
    group_label: "Forecast Product Hierarchy"
    description: "Grouping the type of products into Mattress, Bedding, Bases, and Other"
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
    description: "Grouping the type of products into Mattress, Top, Bottom, and Other"
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
    description: "Type of product (hybrid, original mattress, pillow, cushion, etc.)"
    type: string
    sql: case when  ${category_raw} = 'MATTRESS' and ${line_raw} = 'FOAM' then 'Original'
           when  ${category_raw} = 'MATTRESS' and ${line_raw} <> 'FOAM' and ${line_raw} <> 'COIL' then 'Hybrid'
           else ${line_raw} end;;
  }

  dimension: type_2_legacy {
    hidden: yes
    label: "2. Type"
    group_label: "Forecast Product Hierarchy Legacy"
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
    #hidden: yes
    group_label: "Product Hierarchy"
    label: "1. Category"
    description:  "Mattress/Bedding/Bases/Seating/Other"
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
  dimension: line_raw {
    group_label: "Product Hierarchy"
    label: "2. Line"
    description: "Original/Hybird, Pillow/Bedding, Platform/Powerbase, etc"
    #hidden: yes
    sql: ${TABLE}.line ;;
  }
  dimension: model_raw {
    group_label: "Product Hierarchy"
    label: "3. Model"
    description: "Original/Hybird, Harmony/Plush, etc"
    #hidden: yes
    sql: ${TABLE}.model ;;
  }
  dimension: product_description_raw {
    group_label: "Product Hierarchy"
    label: "4. Name"
    description: "Product Description"
    #hidden: yes
    sql: ${TABLE}.product_description ;;
  }

  dimension: color {
    label: " Product Color"
    description: "Gives Color for Products with an Assigned Color (Grey, Charchoal, Slate, Sand, etc)"
    type: string
    sql: case when ${product_description_raw} ilike '%GREY%' AND ${product_description_raw} not ilike '%STORMY%' AND ${product_description_raw} not ilike '%NATURAL%' then 'GREY'
      when ${product_description_raw} ilike '%CHARCL%' then 'CHARCOAL'
      when ${product_description_raw} ilike '%SLATE%' then 'SLATE'
      when ${product_description_raw} ilike '%SAND%' then 'SAND'
      when ${product_description_raw} ilike '%WHITE%' AND ${product_description_raw} not ilike '%TRUE%' then 'WHITE'
      when ${product_description_raw} ilike '%TRUE WHITE%' then 'TRUE WHITE'
      when ${product_description_raw} ilike '%PURPLE' AND ${product_description_raw} not ilike '%DEEP%' then 'PURPLE'
      when ${product_description_raw} ilike '%NATURAL OAT%' then 'NATURAL OAT'
      when ${product_description_raw} ilike '%NATURAL GREY%' then 'NATURAL GREY'
      when ${product_description_raw} ilike '%STORMY%' then 'STORMY GREY'
      when ${product_description_raw} ilike '%SOFT LILAC%' then 'SOFT LILAC'
      when ${product_description_raw} ilike '%MORNING%' then 'MORNING MIST'
      when ${product_description_raw} ilike '%DEEP PURPLE%' then 'DEEP PURPLE'
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
    label: " Product Size"
    description:  "Size of product from Netsuite (Twin, Full/ Full XL / Queen, Small, etc.)"
    type: string
    sql: case when ${TABLE}.SIZE_lkr = 'NA' OR ${TABLE}.SIZE_lkr is null then 'OTHER'
              when ${product_description_raw} ilike '%SPLIT KING%' then 'SPLIT KING'
              else ${TABLE}.SIZE_lkr end ;; }


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
        --Pillow 2.0
        when ${sku_clean} = '10-31-12863' then '10-31-12855'
        --Plush Pillow
        when ${sku_clean} = '10-31-12862' then '10-31-12857'
        else ${sku_clean} end ;;
  }

  dimension: ecommerce_categories {
    type: string
    description: "Custom Product Bucketing for the eCommerce team's reporting. Bucketed by SKUs.
    Source: netsuite.item"
    group_label: "Advanced"
    hidden: no
    sql:
      case
        --Bedding--
        when ${sku_clean} = '10-38-13050' then 'Gravity Blanket'
        when ${sku_clean} = '10-38-13001' then 'Purple Blanket'
        when ${sku_clean} in ('10-38-13025','10-38-13030','10-38-13020','10-38-13010','10-38-13015','10-38-13005') then 'Duvet'

        when ${sku_clean} = '10-31-12863' then 'Pillow Booster'
        when ${sku_clean} in ('10-31-12890','10-31-12895') then 'Harmony Pillow'
        when ${sku_clean} in ('10-31-12860','10-31-12857') then 'Plush Pillow'
        when ${sku_clean} in ('10-31-12855','10-31-12854') then 'Purple Pillow'
        when ${sku_clean} in ('10-38-22823','10-38-12850','10-38-12793','10-38-12809','10-38-12786','10-38-12849','10-38-12823',
          '10-38-12816','10-38-12779','10-38-12790','10-38-12789','10-38-12787','10-38-12788','10-38-12848','10-38-12830','10-38-12847','10-38-12762') then 'Purple Sheets'
        when ${sku_clean} in ('10-38-22846','10-38-22856','10-38-22851','10-38-22836','10-38-22841','10-38-22831','10-38-22848','10-38-22858','10-38-22853','10-38-22838',
          '10-38-22843','10-38-22833','10-38-22847','10-38-22857','10-38-22852','10-38-22837','10-38-22842','10-38-22832','10-38-22849','10-38-22859','10-38-22854','10-38-22839',
          '10-38-22844','10-38-22834','10-38-22845','10-38-22855','10-38-22850','10-38-22835','10-38-22840','10-38-22830') then 'SoftStretch Sheets'
        when ${sku_clean} in ('10-38-22870','10-38-22864','10-38-22871','10-38-22865','10-38-22866','10-38-22860','10-38-22869','10-38-22863','10-38-22867','10-38-22861',
          '10-38-22868','10-38-22862') then 'SoftStretch Pillowcase'
        when ${sku_clean} in ('10-38-12717','10-38-12748','10-38-12755','10-38-12694','10-38-12700','10-38-12731','10-38-12724','10-38-13919','10-38-13731',
          '10-38-13748','10-38-13900','10-38-13917','10-38-13918','10-38-13924','10-38-13994') then 'Protector'

        --Cushions--
        when ${sku_clean} in ('10-41-12585','10-41-12378','10-41-12582','10-41-12540','10-41-12574','10-41-12583','10-41-12572','10-41-12496',
          '10-41-12573','10-41-12533','10-41-12584','10-41-12576','10-41-12519','10-41-12564','10-41-12557') then 'Cushion'

        --Other--
        when ${sku_clean} in ('10-46-10096','10-46-10751','10-46-10089','10-46-10737','10-46-10072','10-46-10102') then 'Non-Brand'
        when ${sku_clean} = '10-21-68268' then 'Eye Mask'
        when ${sku_clean} in ('10-38-12894','10-22-10220','10-22-10330','10-22-10110','10-38-12897','10-38-12896',
          '10-38-12876','10-38-12875','10-38-12878','10-31-12856','10-31-13100','10-38-12904','10-38-12905','10-38-12906','10-38-73826',
          '10-38-73828','10-38-73829','10-38-73832','10-38-73833','10-38-73834','10-38-73835','10-38-73843','10-38-73844','10-38-73845',
          '10-38-73846','10-38-73851','10-38-73852') then 'Replacement Parts and Hardware'
        when ${sku_clean} in ('10-11-18300','10-38-12554','10-38-12554','10-38-13764','10-38-13779','10-38-13780','10-38-13781',
          '10-38-13786','10-38-13787','10-38-13788','10-38-13794','10-38-13795','10-38-13809','10-38-13810','10-38-13811','10-38-13816',
          '10-38-13818','10-38-13824','10-38-13825','10-38-13832','10-38-13847','10-38-13849','10-38-13892','10-38-13956','10-38-13957','10-38-13959','10-38-13960') then 'Misc'
        when ${sku_clean} = '10-31-12910' then 'Harmony Spare'
        when ${sku_clean} in ('10-25-18265','10-50-18265','10-11-18264','10-11-18273') then 'Purple Squishies'
        when ${sku_clean} in ('10-47-20000','10-47-20001','10-47-20002') then 'Face Mask'

        --Beds--
        when ${sku_clean} in ('10-21-60008','10-21-60018','10-21-60003','10-21-60002','10-21-60001','10-21-60007','10-21-70007',
          '10-21-60006','10-21-70006','10-21-60028','10-21-60005') then 'Hybrid 2'
        when ${sku_clean} in ('10-21-60012','10-21-60019','10-21-60011','10-21-60010','10-21-60038','10-21-60009') then 'Hybrid 3'
        when ${sku_clean} in ('10-21-60016','10-21-60020','10-21-60015','10-21-60014','10-21-60058','10-21-60013') then 'Hybrid 4'
        when ${sku_clean} in ('10-21-12638','10-21-12617','10-21-12960','10-21-23960','10-21-12620','10-21-23620','10-21-12632',
          '10-21-23632','10-21-12625','10-21-23625','10-21-23638','10-21-23617','10-21-12618','10-21-23618') then 'Purple Mattress'
        when ${sku_clean} in ('10-22-10300','10-22-10200','10-22-10100') then 'Pet Bed'

       --Bases--
        when ${sku_clean} in ('10-38-45862','10-38-45864','10-38-45865','10-38-45866','10-38-45867','10-38-45868','10-38-45869',
          '10-38-45870','10-38-45871','10-38-45872','10-38-45873') then 'Foundation'
        when ${sku_clean} in ('10-38-52822','10-38-52893','10-38-52815','10-38-52846','10-38-52892','10-38-82822',
          '10-38-82893','10-38-82895','10-38-73825','10-38-82815','10-38-82846','10-38-82891','10-38-72889','10-38-82892',
          '10-38-92892','10-38-82890','10-38-12822','10-38-12893','10-38-12815','10-38-12846','10-38-12892','10-38-52891') then 'Metal Platform'
        when ${sku_clean} in ('10-21-13027','10-38-12946','10-38-12939','10-38-12948','10-38-12955','10-38-12952') then 'Powerbase'

        else 'unspecified' end ;;
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
    #sql: ${TABLE}.classification ;;
    case: {
      when: { sql: ${classification} = 'FG' ;; label: "Finished Good" }
      when: { sql: ${classification} = 'FS' ;;label: "Factory Second" }
      when: { sql: ${classification} = 'FGC' ;; label: "Finished Goods Component" }
      when: { sql: ${classification} = 'DSC' ;; label: "Discounts" }
      when: { sql: ${classification} = 'SFG' ;; label: "Semi Finished Goods" }
      when: { sql: ${classification} = 'RAW' ;; label: "Raw Materials" }
      when: { sql: ${classification} = 'PRC' ;; label: "Production Components" }
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
