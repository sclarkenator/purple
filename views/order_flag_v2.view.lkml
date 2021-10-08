view: order_flag_v2 {
  derived_table: {
    sql:
      select sol.order_id
        ,sum(sol.gross_amt) gross_sales
        --mattress
        ,sum(case when (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') then ordered_qty else 0 end) mattress
        ,sum(case when (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') then SOL.GROSS_AMT else 0 end) mattress_sales
        ,sum(case when description like 'POWERBASE-SPLIT KING' then ordered_qty else 0 end) split_king
        ,sum(case when line = 'COIL' or (description like '%HYBRID%' and line = 'KIT') then ordered_qty else 0 end) hybrid_mattress
        ,sum(case when line = 'COIL' and model ilike '%HYBRID%2%'  then 1 else 0 end) hybrid2
        ,sum(case when line = 'COIL' and model ilike '%HYBRID%3%'  then 1 else 0 end) hybrid3
        ,sum(case when line = 'COIL' and model ilike '%HYBRID%4%'  then 1 else 0 end) hybrid4
        ,sum(case when model in ('THE PURPLE MATTRESS W/ OG COVER','THE PURPLE MATTRESS','ORIGINAL PURPLE MATTRESS') then 1 else 0 end) purple_mattress
        ,sum(case when (model = 'KIDS BED' ) then ordered_qty else 0 end) kidbed
        ,sum(case when (model = 'PURPLE PLUS' ) then ordered_qty else 0 end) purpleplusbed
        ,sum(case when model in ('LIFELINE MATTRESS') then ordered_qty else 0 end) lifeline
        ,sum(case when category = 'MATTRESS' and item.size in ('Twin','Twin XL') then 1 else 0 end) small_mattress
        ,sum(case when category = 'MATTRESS' and item.size in ('Cal King','SPLIT KING','King','Queen','Full') and line <> 'COVER' then 1 else 0 end) large_mattress
        --pillow
        ,sum(case when line = 'PILLOW' then ordered_qty else 0 end) pillow
        ,sum(case when line = 'PILLOW' and model = 'HARMONY' then ordered_qty else 0 end) harmony
        ,sum(case when line = 'PILLOW' and model = 'PLUSH' then ordered_qty else 0 end) plush
        ,sum(case when line = 'PILLOW' and model = 'PILLOW 2.0' then ordered_qty else 0 end) purple_pillow
        ,sum(case when sku_id in ('10-31-12863','10-31-13100') then ordered_qty else 0 end) pillow_booster
        ,sum(case when (model = 'KID PILLOW' ) then ordered_qty else 0 end) kidpillow
        --sheets
        ,sum(case when line = 'SHEETS' then ordered_qty else 0 end) sheets
        ,sum(case when (model = 'ORIGINAL SHEETS') then ordered_qty else 0 end) original_sheets
        ,sum(case when (model = 'SOFTSTRETCH' ) then ordered_qty else 0 end) softstretch_sheets
        ,sum(case when (model = 'COMPLETE COMFORT' ) then ordered_qty else 0 end) complete_comfort_sheets
        ,sum(case when (model = 'KID SHEETS' ) then ordered_qty else 0 end) kidsheets
        --protector
        ,sum(case when line = 'PROTECTOR' then ordered_qty else 0 end) protector
        --blanket
        ,sum(case when line = 'BLANKET' then ordered_qty else 0 end) blanket
        ,sum(case when sku_id in ('AC-10-38-13015','AC-10-38-13010','AC-10-38-13005','AC-10-38-13030','AC-10-38-13025','AC-10-38-13020',
          '10-38-13015','10-38-13010','10-38-13005','10-38-13030','10-38-13025','10-38-13020') then ordered_qty else 0 end) duvet
        ,sum(case when (model = 'LIGHT DUVET' ) then ordered_qty else 0 end) light_duvet
        ,sum(case when (model = 'ALL SEASONS DUVET' ) then ordered_qty else 0 end) allseasons_duvet
        --base
        ,sum(case when category = 'BASE' then ordered_qty else 0 end) base
        ,sum(case when line = 'POWERBASE' then ordered_qty else 0 end) powerbase
        ,sum(case when model = 'METAL' or model = 'CLIP METAL' then ordered_qty else 0 end) platform
        ,sum(case when sku_id in ('10-38-12822','10-38-12815','10-38-12846','10-38-12893','10-38-12892') then ordered_qty else 0 end) sumo
        ,sum(case when model = 'FOUNDATION' then ordered_qty else 0 end) foundation
        --seating
        ,sum(case when category = 'SEATING' then ordered_qty else 0 end) cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%ultimate%cushion%') then ordered_qty else 0 end) ultimate_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%double%cushion%') then ordered_qty else 0 end) double_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%back%cushion%') then ordered_qty else 0 end) back_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%royal%') then ordered_qty else 0 end) royal_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%simply%') then ordered_qty else 0 end) simply_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%portable%') then ordered_qty else 0 end) portable_cushion
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%everywhere%cushion%') then ordered_qty else 0 end) everywhere_cushion
        ,sum(case when sku_id in ('10-41-12526') then ordered_qty else 0 end) lite_cushion
        ,sum(case when category = 'SEATING' and model not in ('BACK') then ordered_qty else 0 end) cushion_sansback
        --other
        ,sum(case when line = 'PET BED' then ordered_qty else 0 end) pet_bed
        ,sum(case when line = 'EYE MASK' then ordered_qty else 0 end) eye_mask
        ,sum(case when sku_id in ('AC-10-21-68268','10-21-68268') then ordered_qty else 0 end) gravity_mask
        ,sum(case when sku_id in ('10-38-13050') then ordered_qty else 0 end) gravity_blanket
        ,sum(case when sku_id in ('10-47-20000','10-47-20002','10-47-20001') then ordered_qty else 0 end) med_mask
        ,sum(case when sku_id in ('10-90-10072','10-90-10071','10-90-10073','10-90-10074','10-90-10076','10-90-10075','10-90-10077','10-90-10078','10-90-10080',
          '10-90-10079','10-90-10082','10-90-10083','10-90-10086','10-90-10085','10-90-10084','10-90-10081') then ordered_qty else 0 end) sj_pajamas
        --flagging an order based on UPT
        ,sum(case when (sol.ordered_qty>0) then ordered_qty else 0 end) qty

      from analytics.sales.sales_order_line sol
      left join analytics.sales.item on item.item_id = sol.item_id
      left join analytics.sales.sales_order s on s.order_id = sol.order_id and s.system = sol.system
      group by 1
    ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;; }

  measure: mattress_orders {
    group_label: "Total Orders with:"
    label: "a Mattress"
    description: "1/0 per order; 1 if there was a mattress in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.mattress > 0;; }

  dimension: gross_sales{
    hidden: yes
    sql: ${TABLE}.gross_sales  ;;
  }

  dimension: mattress_sales {
    hidden: yes
    sql: ${TABLE}.mattress_sales  ;;
  }

  measure: mattress_orders_non_zero_amt {
    hidden:  yes
    description: "1/0 per order; 1 if there was a mattress in the order and gross amt > 0. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${mattress_sales} > 0;; }

  measure: cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Any"
    description: "1/0 per order; 1 if there was a cushion in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.cushion > 0;; }

  measure: cushion_orders_sansback {
    group_label: "Total Orders with:"
    label: "a Cushion - Any except Back"
    description: "1/0 per order; 1 if there was a cushion other than a back cushion in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    hidden: yes
    sql: ${TABLE}.CUSHION_sansback > 0 ;; }

  measure: sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Any"
    description: "1/0 per order; 1 if there were sheets in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.sheets > 0;; }

  measure: protector_orders {
    group_label: "Total Orders with:"
    label: "a Mattress Protector"
    description: "1/0 per order; 1 if there was a mattress protector in the order. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.protector > 0 ;; }

  measure: pillow_orders {
    group_label: "Total Orders with:"
    label: "a Pillow"
    description: "1/0 per order; 1 if there was a pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.pillow > 0;; }

  measure: harmony_orders {
    group_label: "Total Orders with:"
    label: "a Harmony Pillow"
    hidden: no
    description: "1/0 per order; 1 if there was a Harmony pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.harmony_pillow > 0;; }

  measure: plush_orders {
    group_label: "Total Orders with:"
    label: "a Plush Pillow"
    hidden: yes
    description: "1/0 per order; 1 if there was a Plush pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.plush_pillow > 0;; }

  measure: base_orders {
    hidden:  no
    group_label: "Total Orders with:"
    label: "a Base"
    description: "1/0 per order; 1 if there was a base in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.base > 0;; }

  measure: powerbase_orders {
    group_label: "Total Orders with:"
    label: "a Powerbase"
    description: "1/0 per order; 1 if there was a powerbase in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.powerbase > 0 ;; }

  measure: platform_orders {
    group_label: "Total Orders with:"
    label: "a Platform Base"
    description: "1/0 per order; 1 if there was a platform base (Metal/Clip Metal) in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.platform > 0 ;; }

  measure: sumo_orders{
    group_label: "Total Orders with:"
    label: "a Sumo Metal Base"
    description: "1/0 per order; 1 if there was a platform base (Metal) in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.sumo > 0 ;; }

  measure: foundation_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Foundation"
    description: "1/0 per order; 1 if there was a Foundation in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.foundation > 0 ;; }

  measure: blanket_orders {
    hidden:  no
    group_label: "Total Orders with:"
    label: "a Blanket"
    description: "1/0 per order; 1 if there was a blanket in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.blanket_flg  > 0 ;; }

  measure: mm_orders {
    group_label: "Total Orders with:"
    label: "Multiple Mattresses"
    description: "1/0 per order; 1 if there was more than 1 mattress in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.mattress > 1 ;; }

  measure: split_king_orders {
    group_label: "Total Orders with:"
    label: "a Split King"
    description: "1/0 per order; 1 if multiple twin XL mattresses purchased in this order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${TABLE}.split_king > 0 ;; }

  measure: duvet_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Duvet"
    description: "1/0 per order; 1 if there was a duvet in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.duvet > 0 ;; }

  measure: gravity_blanket_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Gravity Blanket"
    description: "1/0 per order; 1 if there was a gravity blanket in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.gravity_blanket > 0 ;; }

  measure: gravity_mask_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Gravity Mask"
    description: "1/0 per order; 1 if there was a gravity mask in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.gravity_mask > 0 ;; }

  measure: kid_bed_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Bed"
    description: "1/0 per order; 1 if there was a kid bed in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.kid_bed > 0 ;; }

  measure: kid_pillow_orders{
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Pillow"
    description: "1/0 per order; 1 if there was a kid pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.kid_pillow > 0 ;; }

  measure: kid_sheets_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Sheet"
    description: "1/0 per order; 1 if there was a kid sheet in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.kid_sheets > 0 ;; }

  dimension: mattress_flg {
    group_label: "    * Orders has:"
    label: "a Mattress"
    description: "1/0; 1 if there is a mattress in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.mattress > 0 ;; }

  dimension: hybird_mattress_flg {
    group_label: "    * Orders has:"
    label: "a Hybrid Mattress"
    description: "1/0; 1 if there is a hybrid or hybrid premier mattress in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid_mattress > 0 ;; }

  dimension: cushion_flg {
    group_label: "    * Orders has:"
    label: "a Cushion - Any"
    description: "1/0; 1 if there is a cushion in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.cushion > 0 ;; }

  dimension: cushion_flag_sansback {
    group_label: "    * Orders has:"
    label: "a Cushion - Any except Back"
    description: "1/0; 1 if there is a cushion other than a back cushion in this order. Source:looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.CUSHION_flg_sansback > 0 ;; }

  dimension: sheets_flg {
    group_label: "    * Orders has:"
    label: "Sheets - Any"
    description: "1/0; 1 if there are sheets in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.sheets > 0 ;; }

  dimension: protector_flg {
    group_label: "    * Orders has:"
    label: "a Mattress Protector"
    description: "1/0; 1 if there is a mattress protector in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.protector > 0 ;; }

  dimension: base_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Base"
    description: "1/0; 1 if there is a base in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.base > 0 ;; }

  dimension: powerbase_flg {
    group_label: "    * Orders has:"
    label: "a Powerbase"
    description: "1/0; 1 if there is a powerbase in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.powerbase > 0 ;; }

  dimension: platform_flg {
    group_label: "    * Orders has:"
    label: "a Platform Base"
    description: "1/0; 1 if there is a platform base (Metal/Clip Metal) in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.platform > 0 ;; }

  dimension: foundation_flg {
    group_label: "    * Orders has:"
    label: "a Foundation Base"
    description: "1/0; 1 if there is a Foundation Base in this order. Source:looker.calculation"
    type: yesno
    sql: ${TABLE}.foundation > 0 ;; }

  dimension: pillow_flg {
    group_label: "    * Orders has:"
    label: "a Pillow"
    description: "1/0; 1 if there is a pillow in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pillow > 0 ;; }

  dimension: mp_orders_flg {
    group_label: "    * Orders has:"
    label: "Multiple Pillows"
    description: "1/0; 1 if there is more than 1 pillow in the order. Source: looker.calculation"
    hidden: no
    type:  yesno
    sql: ${TABLE}.pillow > 1 ;; }

  dimension: blanket_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Blanket"
    description: "1/0; 1 if there is a blanket in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.blanket > 0 ;; }

  dimension: split_flg {
    group_label: "    * Orders has:"
    label: "a Split King"
    description: "1/0; 1 if there is are multiple twin XL mattresses purchased in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.split_king > 0 ;; }

  dimension: mm_orders_flg {
    group_label: "    * Orders has:"
    label: "Multiple Mattresses"
    description: "1/0; 1 if there is more than 1 mattress in the order. Source:looker.calculation"
    type:  yesno
    sql:  ${TABLE}.mattress > 1 ;; }

  dimension: mattress_count {
    group_label: " Advanced"
    description: "Number of mattresses in the order. Source: looker.calculation"
    type: number
    sql: ${TABLE}.mattress_ordered ;;
  }

  dimension: pillow_count {
    group_label: " Advanced"
    hidden: yes
    description: "Number of pillows in the order. Source: looker.calculation"
    type: number
    sql: ${TABLE}.pillow ;;
  }

  dimension: harmony_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Harmony Pillow"
    description: "1/0; 1 if there is a Harmony Pillow in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.harmony > 0 ;; }

  dimension: plush_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Plush Pillow"
    description: "1/0; 1 if there is a Plush Pillow in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.plush > 0 ;; }

  dimension: purple_pillow_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Purple Pillow"
    description: "1/0; 1 if there is a Purple Pillow (Purple 2.0, has only purple grid) in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.purple_pillow > 0 ;; }

  dimension: gravity_mask_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Gavity Mask"
    description: "1/0; 1 if there is a Gravity Mask in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.gravity_mask > 0 ;; }

  dimension: gravity_blanket_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Gravity Blanket"
    description: "1/0; 1 if there is a Gravity Blanket in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.gravity_blanket > 0 ;; }

  dimension: duvet_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Duvet"
    description: "1/0; 1 if there is a Duvet in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.duvet > 0 ;; }

  dimension: eye_mask_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Eye Mask"
    description: "1/0; 1 if there is a Eye Mask in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.eye_mask > 0 ;; }

  dimension: pet_bed_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Pet Bed"
    description: "1/0; 1 if there is a Pet Bed in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.pet_bed > 0 ;; }

  dimension: ff_bundle_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Fall Flash Bundle"
    description: "1/0; 1 if there is a Fall Flash BUndle in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.ff_bundle > 0 ;; }

  dimension: pdULT_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet ultimate bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdULT > 0 ;; }

  dimension: pdDEL_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet deluxe bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdDEL > 0 ;; }

  dimension: pdESS_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet essential bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdESS > 0 ;; }

  dimension: weightedtwo_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a discounted gravity blanket and 2 free masks in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.weightedtwo > 0 ;; }

  dimension: buymoresavemore {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if the order qualifies for the 'Buy More Save More' promotion (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.buymsm > 0 ;; }

  dimension: medical_masks{
    group_label: "    * Orders has:"
    label: "a Face Mask"
    description: "1/0 per order; 1 if there was a Medical Face Mask in the order. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.medical_mask > 0 ;; }

  dimension: pillow_booster_flag{
    group_label: "    * Orders has:"
    label: "a Pillow Booster"
    description: "1/0 per order; 1 if there was a Pillow Booster in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.pillow_booster > 0 ;; }

  measure: average_mattress_order_size {
    label: "AMOV ($)"
    view_label: "Sales Order"
    description: "Average total mattress order amount, excluding tax. Source:looker.calculation"
    type: average
    sql_distinct_key: ${sales_order.order_system} ;;
    value_format: "$#,##0"
    sql: case when ${mattress_flg} = 1 AND ${sales_order.gross_amt}>0 then ${sales_order.gross_amt} end ;;
  }

  measure: average_accessory_order_size {
    label: "NAMOV ($)"
    view_label: "Sales Order"
    description: "Average total accessory order amount, excluding tax. Source:looker.calculation"
    type: average
    sql_distinct_key: ${sales_order.order_system} ;;
    value_format: "$#,##0"
    sql: case when ${mattress_flg} = 0 AND ${sales_order.gross_amt}>0 then ${sales_order.gross_amt} end ;;
  }

#creating AAAV - Jared
  measure: total_attached_accessory_value {
    hidden: yes
    description: "Amount of attached accessories (AMOV orders less the mattress $ amount), excluding tax. Source:looker.calculation"
    type: sum
    value_format: "$#,##0"
    sql: case when ${mattress_sales} > 0 then (${gross_sales}-${mattress_sales}) else 0 end;;
  }

  measure: average_attached_accessory_value {
    hidden: no
    label: "AAAV ($)"
    view_label: "Sales Order"
    description: "Average amount of attached accessories (AMOV orders less the mattress $ amount), excluding tax. Source:looker.calculation"
    type: number
    value_format: "$#,##0"
    sql: coalesce(${total_attached_accessory_value}/nullif(${mattress_orders_non_zero_amt},0),0);;
  }

  measure: ultimate_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Ultimate"
    description: "1/0 per order; 1 if the order contains an Ultimate Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.ultimate_cushion > 0  ;; }

  measure: double_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Double"
    description: "1/0 per order; 1 if the order contains a Double Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.double_cushion > 0 ;; }

  measure: back_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Back"
    description: "1/0 per order; 1 if the order contains a Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.back_cushion > 0 ;; }

  measure: original_sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Original"
    description: "1/0 per order; 1 if the order contains a set of Original Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.original_sheets > 0 ;; }

  measure: softstretch_sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Softstretch"
    description: "1/0 per order; 1 if the order contains a set of Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.softstretch_sheets > 0 ;; }

  measure: royal_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Royal"
    description: "1/0 per order; 1 if the order contains a Royal Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.royal_cushion > 0 ;; }

  measure: simply_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Simply"
    description: "1/0 per order; 1 if the order contains a Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.simply_cushion > 0 ;; }

  measure: portable_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Portable"
    description: "1/0 per order; 1 if the order contains a Portable Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.portable_cushion > 0 ;; }

  measure: everywhere_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Everywhere"
    description: "1/0 per order; 1 if the order contains an Everywhere Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.everywhere_cushion > 0 ;; }

  measure: lite_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Lite"
    description: "1/0 per order; 1 if the order contains a Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  count_distinct
    sql_distinct_key: ${order_id} ;;
    sql:  ${TABLE}.lite_cushion > 0 ;; }


  ################################
  dimension: ultimate_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Ultimate"
    description: "1/0 per order; 1 if the order contains an Ultimate Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.ultimate_cushion > 0 ;; }

  dimension: double_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Double"
    description: "1/0 per order; 1 if the order contains a Double Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.double_cushion > 0 ;; }

  dimension: back_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Back"
    description: "1/0 per order; 1 if the order contains a Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.back_cushion > 0 ;; }

  dimension: original_sheets_flag {
    group_label: "    * Orders has:"
    label: "Sheets - Original"
    description: "1/0 per order; 1 if the order contains a set of Original Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.original_sheets > 0;; }

  dimension: softstretch_sheets_flag {
    group_label: "    * Orders has:"
    label: "Sheets - Softstretch"
    description: "1/0 per order; 1 if the order contains a set of Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.softstretch_sheets > 0 ;; }

  dimension: complete_comfort_sheets_flag {
    group_label: "    * Orders has:"
    label: "Sheets - Complete Comfort"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.complete_comfort_sheets > 0 ;; }

  dimension: royal_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Royal"
    description: "1/0 per order; 1 if the order contains a Royal Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.royal_cushion > 0 ;; }

  dimension: simply_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Simply"
    description: "1/0 per order; 1 if the order contains a Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.simply_cushion > 0 ;; }

  dimension: portable_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Portable"
    description: "1/0 per order; 1 if the order contains a Portable Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.portable_cushion > 0 ;; }

  dimension: everywhere_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Everywhere"
    description: "1/0 per order; 1 if the order contains an Everywhere Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.everywhere_cushion > 0 ;; }

  dimension: lite_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Lite"
    description: "1/0 per order; 1 if the order contains a Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.lite_cushion > 0 ;; }

# Bundle flags and measures
  dimension: bundle1_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 1"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (1) Purple Sheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle1 > 0 ;; }

  dimension: bundle2_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 2"
    description: "1/0 per order; 1 if the order contains at least (1) Double Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle2 > 0;; }

  dimension: bundle3_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 3"
    description: "1/0 per order; 1 if the order contains at least (1) Double Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle3 > 0 ;; }

  dimension: bundle4_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 4"
    description: "1/0 per order; 1 if the order contains at least (1) Duvet (1) Plush Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle4 > 0 ;; }

  dimension: bundle5_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 5"
    description: "1/0 per order; 1 if the order contains at least (1) Weighted Blanket (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle5 > 0 ;; }

  dimension: bundle6_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 6"
    description: "1/0 per order; 1 if the order contains at least (1) Everywhere Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle6 > 0 ;; }

  dimension: bundle7_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 7"
    description: "1/0 per order; 1 if the order contains at least (2) Plush Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle7 > 0 ;; }

  dimension: bundle8_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 8"
    description: "1/0 per order; 1 if the order contains at least (1) Royal Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle8 > 0 ;; }

  dimension: bundle9_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 9"
    description: "1/0 per order; 1 if the order contains at least (1) Duvet  (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle9 > 0 ;; }

  dimension: bundle10_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 10"
    description: "1/0 per order; 1 if the order contains at least (1) Simply Cushion (1) Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle10 > 0 ;; }

  dimension: bundle11_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 11"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle11 > 0 ;; }

  dimension: bundle12_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 12"
    description: "1/0 per order; 1 if the order contains at least (2) Purple Pillows (1) Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle12 > 0 ;; }

  dimension: bundle13_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 13"
    description: "1/0 per order; 1 if the order contains at least (2) Purple Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle13 > 0 ;; }

  dimension: bundle14_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 14"
    description: "1/0 per order; 1 if the order contains at least (1) Foundation (1) Mattress Protector (1) SoftStretch Sheets (2) Harmony Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle14 > 0 ;; }

  dimension: bundle15_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 15"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (1) SoftstretchSheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle15 > 0 ;; }

  dimension: bundle16_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 16"
    description: "1/0 per order; 1 if the order contains at least (1) Purple Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle16 > 0 ;; }

  dimension: bundle17_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 17"
    description: "1/0 per order; 1 if the order contains at least (1) Purple Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle17 > 0 ;; }

  dimension: bundle18_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 18"
    description: "1/0 per order; 1 if the order contains at least (1) SoftStretch Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle18 > 0 ;; }

  dimension: bundle19_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 19"
    description: "1/0 per order; 1 if the order contains at least (1) SoftStretch Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle19 > 0 ;; }


  ###############################################################

# measures
  measure: bundle1_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 1"
    description: "Orders that contain at least (2) Harmony Pillows (1) Purple Sheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle1 > 0 ;; }

  measure: bundle2_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 2"
    description: "Orders that contain at least (1) Double Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle2 > 0 ;; }

  measure: bundle3_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 3"
    description: "Orders that contain at least (1) Double Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle3_flg ;; }

  measure: bundle4_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 4"
    description: "Orders that contain at least (1) Duvet (1) Plush Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle4_flg ;; }

  measure: bundle5_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 5"
    description: "Orders that contain at least (1) Weighted Blanket (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle5_flg ;; }

  measure: bundle6_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 6"
    description: "Orders that contain at least (1) Everywhere Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle6_flg ;; }

  measure: bundle7_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 7"
    description: "Orders that contain at least (2) Plush Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle7_flg ;; }

  measure: bundle8_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 8"
    description: "Orders that contain at least (1) Royal Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle8_flg ;; }

  measure: bundle9_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 9"
    description: "Orders that contain at least (1) Duvet  (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle9_flg ;; }

  measure: bundle10_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 10"
    description: "Orders that contain at least (1) Simply Cushion (1) Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle10_flg ;; }

  measure: bundle11_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 11"
    description: "Orders that contain at least (2) Harmony Pillows (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle11_flg ;; }

  measure: bundle12_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 12"
    description: "Orders that contain at least (2) Purple Pillows (1) Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle12_flg ;; }

  measure: bundle13_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 13"
    description: "Orders that contain at least (2) Purple Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle13_flg ;; }

  measure: bundle14_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 14"
    description: "Orders that contain at least (1) Foundation (1) Mattress Protector (1) SoftStretch Sheets (2) Harmony Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle14_flg ;; }

  measure: bundle15_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 15"
    description: "Orders that contain at least (2) Harmony Pillows (1) SoftstretchSheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle15_flg ;; }

  measure: bundle16_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 16"
    description: "Orders that contain at least (1) Purple Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle16_flg ;; }

  measure: bundle17_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 17"
    description: "Orders that contain at least (1) Purple Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle17_flg ;; }

  measure: bundle18_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 18"
    description: "Orders that contain at least (1) SoftStretch Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle18_flg ;; }

  measure: bundle19_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 19"
    description: "Orders that contain at least (1) SoftStretch Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle19_flg ;; }

  # BAR / BARB
  measure: bar_orders {
    group_label: "Total Orders with:"
    label: "a BAR Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress, 2+ pillows, sheets, and a protector;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bar_large +  ${TABLE}.bar_small ;; }

  dimension: bar_flag {
    group_label: "    * Orders has:"
    label: "a BAR Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress (including split king), 2+ pillows, sheets, and a protector;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bar_small + ${TABLE}.bar_large > 0  ;; }


  measure: barb_orders {
    group_label: "Total Orders with:"
    label: "a BARB Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress, 2+ pillows, sheets, a protector, and a base;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector, a base. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.barb_flg ;; }

  dimension: barb_flag {
    group_label: "    * Orders has:"
    label: "a BARB Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress (including split king), 2+ pillows, sheets, protector, and a base;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector, a base. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.barb_flg = 1  ;; }

  dimension: hybrid2_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 2"
    description: "1/0; 1 if there is a Hybrid 2 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid2_flg = 1 ;; }

  dimension: hybrid3_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 3"
    description: "1/0; 1 if there is a Hybrid 3 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid3_flg = 1 ;; }

  dimension: hybrid4_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 4"
    description: "1/0; 1 if there is a Hybrid 4 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid4_flg = 1 ;; }

  measure: hybird_mattress_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid Mattress"
    description: "Count of Orders with a Hybrid 3 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid_mattress_flg ;; }

  measure: hybrid2_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 2"
    description: "Count of Orders with a Hybrid 2 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid2_flg ;; }

  measure: hybrid3_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 3"
    description: "Count of Orders with a Hybrid 3 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid3_flg ;; }

  measure: hybrid4_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 4"
    description: "Count of Orders with a Hybrid 4 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid4_flg ;; }

  dimension: purple_mattress_flag {
    group_label: "    * Orders has:"
    label: "a Purple Mattress"
    description: "1/0; 1 if there is a The Purple Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.purple_mattres_flg = 1 ;; }

  measure: purple_mattress_orders {
    group_label: "Total Orders with:"
    label: "a Purple Mattress"
    description: "Count of Orders with a The Purple Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.purple_mattres_flg ;; }

  dimension: room_set_num {
    hidden: yes
    group_label: "    * Orders has:"
    label: "Bedset Completion Number"
    description: "1-5; 1 if there is 1 bedset category in this order, 5 if all bedset categories are in it (Mattress, Sheets, Protector, Base, Pillow). Source: looker.calculation"
    type:  number
    sql: ${TABLE}.room_set ;; }

  dimension: portcushtwobund_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 20"
    description: "1/0 per order; 1 if the order contains at least (2) Portable Cushions. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.portcushtwobund_flg=1 ;; }

  dimension: upt_filter {
    group_label: "    * Orders has:"
    label: " UPT - Filter "
    description: "Filters to a specific UPT. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  number
    sql:  ${TABLE}.upt_dim ;; }

  dimension: light_duvet_flag {
    group_label: "    * Orders has:"
    label: "a Light Duvet"
    description: "1/0; 1 if there is a Lightweight Duvet in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.light_duvet_flg = 1 ;; }


  dimension: kid_bed_flag {
    group_label: "    * Orders has:"
    label: "a Kid Bed"
    description: "1/0; 1 if there is a Kid Bed in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_bed_flg = 1 ;; }

  dimension: purple_plus_flag {
    group_label: "    * Orders has:"
    label: "a Purple Plus Mattress"
    description: "1/0; 1 if there is a Purple Plus Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.purple_plus_flg = 1 ;; }

  dimension: kid_pillow_flag {
    group_label: "    * Orders has:"
    label: "a Kid Pillow"
    description: "1/0; 1 if there is a Kid Pillow in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_pillow_flg = 1 ;; }

  dimension: all_seasons_duvet_flag {
    group_label: "    * Orders has:"
    label: "an All Seasons Duvet"
    description: "1/0; 1 if there is an All Seasons Duvet in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.all_seasons_duvet_flg = 1 ;; }

  dimension: kid_sheets_flag {
    group_label: "    * Orders has:"
    label: "a Kid Sheets"
    description: "1/0; 1 if there is a Kid Sheets in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_sheets_flg = 1 ;; }

  dimension: lifeline_flag {
    group_label: "    * Orders has:"
    label: "a Lifeline Mattress"
    description: "1/0; 1 if there is a Lifeline Mattress in this order. Source: looker.calculation"
    hidden: yes
    type:  yesno
    sql: ${TABLE}.lifeline_flg = 1 ;; }

  dimension: harmonytwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Harmony Pillows"
    description: "1/0; 1 if there are at least (2) Harmony Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.harmonytwobund_flg = 1 ;; }

  dimension: purplepillowtwobund_flg {
    group_label: "    * Orders has:"
    label: "multiple Purple Pillows"
    description: "1/0; 1 if there are at least (2) Purple Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.purplepillowtwobund_flg = 1 ;; }

  dimension: softstretchtwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Softstretch Sheets"
    description: "1/0; 1 if there are at least (2) Softstretch Sheets in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.softstretchtwobund_flg = 1 ;; }

  dimension: singleharmony_flag {
    group_label: "    * Orders has:"
    label: "a Single Harmony Pillow"
    description: "1/0; 1 if there is exactly 1 Harmony Pillow in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.singleharmony_flg = 1 ;; }

  dimension: sj_pajama_flag {
    group_label: "    * Orders has:"
    label: "a Sleepy Jones Pajamas"
    description: "1/0; 1 if there is at least 1 Sleepy Jones Pajamas in this order. Source: looker.calculation"
    type:  yesno
    hidden: no
    sql: ${TABLE}.sj_pajama_flg = 1 ;;
  }

  dimension: sj_pajama_two_flag {
    group_label: "    * Orders has:"
    label: "two Sleepy Jones Pajamas"
    description: "1/0; 1 if there is at least 2 Sleepy Jones Pajamas in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.sj_pajama_two_flg = 1 ;;
  }


  dimension: bmsm_flag {
    group_label: "eComm Bundle Flags"
    label: "Buy More Save More Tier"
    description: "Indicates the Buy More Save More tier of an order (2, 3, 4+ or null). Excludes mattress and base units. Source: looker.calculation"
    type:  string
    hidden: yes
    sql: case when ${TABLE}.bmsm_flg = 2 then 'Tier 2'
              when ${TABLE}.bmsm_flg = 3 then 'Tier 3'
              when ${TABLE}.bmsm_flg > 3 then 'Tier 4+' else null end ;; }

  dimension: purplepillowtwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Purple Pillows"
    description: "1/0; 1 if there are at least (2) Purple Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.purplepillowtwobund_flg = 1 ;; }


}
