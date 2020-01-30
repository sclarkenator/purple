view: order_flag {

  derived_table: {
    sql:
    SELECT ORDER_ID
      ,case when MATTRESS_FLG > 0 then 1 else 0 end mattress_flg
      ,case when CUSHION_FLG > 0 then 1 else 0 end cushion_flg
      ,case when SHEETS_FLG > 0 then 1 else 0 end sheets_flg
      ,case when PROTECTOR_FLG > 0 then 1 else 0 end protector_flg
      ,case when BASE_FLG > 0 then 1 else 0 end base_flg
      ,case when POWERBASE_FLG > 0 then 1 else 0 end powerbase_flg
      ,case when PLATFORM_FLG > 0 then 1 else 0 end platform_flg
      ,case when PILLOW_FLG > 0 then 1 else 0 end pillow_flg
      ,case when BLANKET_FLG > 0 then 1 else 0 end blanket_flg
      ,CASE WHEN MATTRESS_ORDERED > 1 THEN 1 ELSE 0 END MM_FLG
      ,case when split_king > 0 then 1 else 0 end sk_flg
      ,case when harmony > 0 then 1 else 0 end harmony_pillow_flg
      ,case when plush > 0 then 1 else 0 end plush_pillow_flg
      ,case when purple_pillow > 0 then 1 else 0 end purple_pillow_flg
      ,case when gravity_mask > 0 then 1 else 0 end gravity_mask_flg
      ,case when gravity_blanket > 0 then 1 else 0 end gravity_blanket_flg
      ,case when accordion_platform > 0 then 1 else 0 end accordion_platform_flg
      ,case when duvet > 0 then 1 else 0 end duvet_flg
      ,case when (ff_bundle_pt1 + ff_bundle_pt2 + ff_bundle_pt3 >= 3) OR ff_bundle_pt4 > 0 then 1 else 0 end ff_bundle_flg
      ,case when (pdULTpt1>=2 and pdANYpt2=1) then 1 else 0 end pdULT_flg
      ,case when (pdDELpt1>=2 and pdANYpt2=1) then 1 else 0 end pdDEL_flg
      ,case when (pdESSpt1>=2 and pdANYpt2=1) then 1 else 0 end pdESS_flg
      ,case when (weight2pt1=1 and weight2pt2 >=2) then 1 else 0 end weightedtwo_flg
      , mattress_ordered
    FROM(
      select sol.order_id
        ,sum(case when category = 'MATTRESS' THEN 1 ELSE 0 END) MATTRESS_FLG
        ,SUM(CASE WHEN category = 'SEATING' THEN 1 ELSE 0 END) CUSHION_FLG
        ,SUM(CASE WHEN line = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
        ,SUM(CASE WHEN line = 'SHEETS' THEN 1 ELSE 0 END) PROTECTOR_FLG
        ,SUM(CASE WHEN category = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
        ,SUM(CASE WHEN line = 'POWERBASE' THEN 1 ELSE 0 END) POWERBASE_FLG
        ,SUM(CASE WHEN line = 'PLATFORM' THEN 1 ELSE 0 END) PLATFORM_FLG
        ,SUM(CASE WHEN line = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
        ,SUM(CASE WHEN line = 'BLANKETS' THEN 1 ELSE 0 END) BLANKET_FLG
        ,SUM(CASE WHEN category = 'MATTRESS' THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
        ,sum(case when description like 'POWERBASE-SPLIT KING' then 1 else 0 end) split_king
        ,sum(case when sku_id in ('AC-10-31-12890','AC-10-31-12895','10-31-12890','10-31-12895') then 1 else 0 end) harmony
        ,sum(case when sku_id in ('AC-10-31-12860','AC-10-31-12857','10-31-12860','10-31-12857') then 1 else 0 end) plush
        ,sum(case when sku_id in ('AC-10-31-12854','AC-10-31-12855','10-31-12854','10-31-12855') then 1 else 0 end) purple_pillow
        ,sum(case when sku_id in ('AC-10-21-68268','10-21-68268') then 1 else 0 end) gravity_mask
        ,sum(case when sku_id in ('AC-10-38-13050') then 1 else 0 end) gravity_blanket
        ,sum(case when sku_id in ('AC-10-38-45867','AC-10-38-45866','AC-10-38-45865','AC-10-38-45864','AC-10-38-45863','AC-10-38-45862','AC-10-38-45868','AC-10-38-45869','AC-10-38-45870','AC-10-38-45871','AC-10-38-45872','AC-10-38-45873',
                                  '10-38-45867','10-38-45866','10-38-45865','10-38-45864','10-38-45863','10-38-45862','10-38-45868','10-38-45869','10-38-45870','10-38-45871','10-38-45872','10-38-45873') then 1 else 0 end) accordion_platform
        ,sum(case when sku_id in ('AC-10-38-13015','AC-10-38-13010','AC-10-38-13005','AC-10-38-13030','AC-10-38-13025','AC-10-38-13020',
                                  '10-38-13015','10-38-13010','10-38-13005','10-38-13030','10-38-13025','10-38-13020') then 1 else 0 end) duvet
        ,sum(case when (line = 'PROTECTOR' AND discount_amt=50*sol.ORDERED_QTY) THEN 1 ELSE 0 END) ff_bundle_pt1
        ,sum(case when (line = 'SHEETS' AND discount_amt=50*sol.ORDERED_QTY) then 1 else 0 end) ff_bundle_pt2
        ,sum(case when (line = 'PILLOW' AND discount_amt=50*sol.ORDERED_QTY) then 1 else 0 end) ff_bundle_pt3
        ,sum(case when s.memo ilike ('%flashbundle%') AND s.memo ilike ('%2019%') then 1 else 0 end) ff_bundle_pt4
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%harmony%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdULTpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%pillow 2.0%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdDELpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%plush%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdESSpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%duvet%' AND sol.ORDERED_QTY>=1 and sol.created::date between '2020-01-21' and '2020-02-15') THEN 1 ELSE 0 END) pdANYpt2
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%gravity%' AND line = 'BLANKETS' and sol.created::date between '2020-01-21' and '2020-02-15') THEN 1 ELSE 0 END) weight2pt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%gravity%' AND line = 'EYE MASK' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) weight2pt2
        from sales_order_line sol
      left join item on item.item_id = sol.item_id
      left join sales_order s on s.order_id = sol.order_id and s.system = sol.system
      GROUP BY 1) ;;

    }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;; }

  measure: mattress_orders {
    group_label: "Total Orders with:"
    label: "a Mattress"
    description: "1/0 per order; 1 if there was a mattress in the order"
    type:  sum
    sql:  ${TABLE}.mattress_flg ;; }

  measure: cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion"
    description: "1/0 per order; 1 if there was a cushion in the order"
    type:  sum
    sql:  ${TABLE}.cushion_flg ;; }

  measure: sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets"
    description: "1/0 per order; 1 if there were sheets in the order"
    type:  sum
    sql:  ${TABLE}.sheets_flg ;; }

  measure: protector_orders {
    group_label: "Total Orders with:"
    label: "a Mattress Protector"
    description: "1/0 per order; 1 if there was a mattress protector in the order"
    type:  sum
    sql:  ${TABLE}.protector_flg ;; }

  measure: pillow_orders {
    group_label: "Total Orders with:"
    label: "a Pillow"
    description: "1/0 per order; 1 if there was a pillow in the order"
    type:  sum
    sql:  ${TABLE}.pillow_flg ;; }

  measure: harmony_orders {
    group_label: "Total Orders with:"
    label: "a Harmony Pillow"
    hidden: yes
    description: "1/0 per order; 1 if there was a Harmony pillow in the order"
    type:  sum
    sql:  ${TABLE}.harmony_pillow_flg ;; }

  measure: plush_orders {
    group_label: "Total Orders with:"
    label: "a Plush Pillow"
    hidden: yes
    description: "1/0 per order; 1 if there was a Plush pillow in the order"
    type:  sum
    sql:  ${TABLE}.plush_pillow_flg ;; }

  measure: base_orders {
    hidden:  yes
    group_label: "Total Orders with:"
    label: "a Base"
    description: "1/0 per order; 1 if there was a base in the order"
    type:  sum
    sql:  ${TABLE}.base_flg ;; }

  measure: powerbase_orders {
    group_label: "Total Orders with:"
    label: "a Powerbase"
    description: "1/0 per order; 1 if there was a powerbase in the order"
    type:  sum
    sql:  ${TABLE}.powerbase_flg ;; }

  measure: platform_orders {
    group_label: "Total Orders with:"
    label: "a Platform Base"
    description: "1/0 per order; 1 if there was a platform base in the order"
    type:  sum
    sql:  ${TABLE}.platform_flg ;; }

  measure: blanket_orders {
    hidden:  yes
    group_label: "Total Orders with:"
    label: "a Blanket"
    description: "1/0 per order; 1 if there was a blanket in the order"
    type:  sum
    sql:  ${TABLE}.blanket_flg ;; }

  measure: mm_orders {
    group_label: "Total Orders with:"
    label: "Multiple Mattresses"
    description: "1/0 per order; 1 if there was more than 1 mattress in the order"
    type:  sum
    sql:  ${TABLE}.mm_flg ;; }

  measure: split_king_orders {
    group_label: "Total Orders with:"
    label: "a Split King"
    description: "1/0 per order; 1 if multiple twin XL mattresses purchased in this order"
    type: sum
    sql: ${TABLE}.sk_flg ;; }

  measure: duvet_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Duvet"
    description: "1/0 per order; 1 if there was a duvet in the order"
    type:  sum
    sql:  ${TABLE}.duvet_flg ;; }

  measure: gravity_blanket_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Gravity Blanket"
    description: "1/0 per order; 1 if there was a gravity blanket in the order"
    type:  sum
    sql:  ${TABLE}.gravity_blanket_flg ;; }

  measure: gravity_mask_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Gravity Mask"
    description: "1/0 per order; 1 if there was a gravity mask in the order"
    type:  sum
    sql:  ${TABLE}.gravity_mask_flg ;; }

  measure: accordion_platfrom_flg {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Accordion Platform"
    description: "1/0 per order; 1 if there was a accordion platform in the order"
    type:  sum
    sql:  ${TABLE}.accordion_platform_flg ;; }

  dimension: mattress_flg {
    group_label: "    * Orders has:"
    label: "a Mattress"
    description: "1/0; 1 if there is a mattress in this order"
    type:  yesno
    sql: ${TABLE}.mattress_flg = 1 ;; }

  dimension: cushion_flg {
    group_label: "    * Orders has:"
    label: "a Cushion"
    description: "1/0; 1 if there is a cushion in this order"
    type:  yesno
    sql: ${TABLE}.cushion_flg = 1 ;; }

  dimension: sheets_flg {
    group_label: "    * Orders has:"
    label: "Sheets"
    description: "1/0; 1 if there are sheets in this order"
    type:  yesno
    sql: ${TABLE}.sheets_flg = 1 ;; }

  dimension: protector_flg {
    group_label: "    * Orders has:"
    label: "a Mattress Protector"
    description: "1/0; 1 if there is a mattress protector in this order"
    type:  yesno
    sql: ${TABLE}.protector_flg = 1 ;; }

  dimension: base_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Base"
    description: "1/0; 1 if there is a base in this order"
    type:  number
    sql: ${TABLE}.base_flg = 1 ;; }

  dimension: powerbase_flg {
    group_label: "    * Orders has:"
    label: "a Powerbase"
    description: "1/0; 1 if there is a powerbase in this order"
    type:  yesno
    sql: ${TABLE}.powerbase_flg = 1 ;; }

  dimension: platform_flg {
    group_label: "    * Orders has:"
    label: "a Platform Base"
    description: "1/0; 1 if there is a platform base in this order"
    type:  yesno
    sql: ${TABLE}.platform_flg = 1 ;; }

  dimension: pillow_flg {
    group_label: "    * Orders has:"
    label: "a Pillow"
    description: "1/0; 1 if there is a pillow in this order"
    type:  yesno
    sql: ${TABLE}.pillow_flg = 1 ;; }

  dimension: blanket_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Blanket"
    description: "1/0; 1 if there is a blanket in this order"
    type:  number
    sql: ${TABLE}.blanket_flg = 1 ;; }

  dimension: split_flg {
    group_label: "    * Orders has:"
    label: "a Split King"
    description: "1/0; 1 if there is are multiple twin XL mattresses purchased in this order"
    type: yesno
    sql: ${TABLE}.sk_flg > 0 ;; }

  dimension: mm_orders_flg {
    group_label: "    * Orders has:"
    label: "Multiple Mattresses"
    description: "1/0; 1 if there is more than 1 mattress in the order"
    type:  yesno
    sql:  ${TABLE}.mm_flg = 1 ;; }

  dimension: mattress_count {
    group_label: " Advanced"
    description: "Number of mattresses in the order"
    type: number
    sql: ${TABLE}.mattress_ordered ;;
  }

  dimension: harmony_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Harmony Pillow"
    description: "1/0; 1 if there is a Harmony Pillow in this order"
    type: yesno
    sql: ${TABLE}.harmony_pillow_flg > 0 ;; }

  dimension: plush_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Plush Pillow"
    description: "1/0; 1 if there is a Plush Pillow in this order"
    type: yesno
    sql: ${TABLE}.plush_pillow_flg > 0 ;; }

  dimension: purple_pillow_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Purple Pillow"
    description: "1/0; 1 if there is a Purple Pillow (Purple 2.0, has only purple grid) in this order"
    type: yesno
    sql: ${TABLE}.purple_pillow_flg > 0 ;; }

  dimension: gravity_mask_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Gavity Mask"
    description: "1/0; 1 if there is a Gravity Mask in this order"
    type: yesno
    sql: ${TABLE}.gravity_mask_flg > 0 ;; }

  dimension: gravity_blanket_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Gravity Blanket"
    description: "1/0; 1 if there is a Gravity Blanket in this order"
    type: yesno
    sql: ${TABLE}.gravity_blanket_flg > 0 ;; }

  dimension: accordion_platform_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Accordion Base"
    description: "1/0; 1 if there is a Accordion Base in this order"
    type: yesno
    sql: ${TABLE}.accordion_platform_flg > 0 ;; }

  dimension: foundation_base_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Foundation Base"
    description: "1/0; 1 if there is a Foundation Base in this order"
    type: yesno
    sql: ${TABLE}.foundation_base_flg > 0 ;; }

  dimension: duvet_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Duvet"
    description: "1/0; 1 if there is a Duvet in this order"
    type: yesno
    sql: ${TABLE}.duvet_flg > 0 ;; }

  dimension: ff_bundle_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Fall Flash Bundle"
    description: "1/0; 1 if there is a Fall Flash BUndle in this order"
    type:  yesno
    sql: ${TABLE}.ff_bundle_flg = 1 ;; }

  dimension: pdULT_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet ultimate bundle in this order (1/21/2020-2/14/2020)"
    type:  yesno
    sql: ${TABLE}.pdULT_flg = 1 ;; }

  dimension: pdDEL_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet deluxe bundle in this order (1/21/2020-2/14/2020)"
    type:  yesno
    sql: ${TABLE}.pdDEL_flg = 1 ;; }

  dimension: pdESS_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet essential bundle in this order (1/21/2020-2/14/2020)"
    type:  yesno
    sql: ${TABLE}.pdESS_flg = 1 ;; }

  dimension: weightedtwo_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a discounted gravity blanket and 2 free masks in this order (1/21/2020-2/14/2020)"
    type:  yesno
    sql: ${TABLE}.weightedtwo_flg = 1 ;; }
}
