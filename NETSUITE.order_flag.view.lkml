view: order_flag {

derived_table: {
  sql:
    SELECT ORDER_ID
      ,case when MATTRESS_FLG >0 then 1 else 0 end mattress_flg
      ,case when CUSHION_FLG >0 then 1 else 0 end cushion_flg
      ,case when SHEETS_FLG >0 then 1 else 0 end sheets_flg
      ,case when PROTECTOR_FLG >0 then 1 else 0 end protector_flg
      ,case when BASE_FLG >0 then 1 else 0 end base_flg
      ,case when POWERBASE_FLG >0 then 1 else 0 end powerbase_flg
      ,case when PLATFORM_FLG >0 then 1 else 0 end platform_flg
      ,case when PILLOW_FLG >0 then 1 else 0 end pillow_flg
      ,case when BLANKET_FLG >0 then 1 else 0 end blanket_flg
      ,CASE WHEN MATTRESS_ORDERED > 1 THEN 1 ELSE 0 END MM_FLG
      ,case when split_king > 0 then 1 else 0 end sk_flg
    FROM(
      select order_id
        ,sum(case when product_line_name_LKR = 'MATTRESS' THEN 1 ELSE 0 END) MATTRESS_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'CUSHION' THEN 1 ELSE 0 END) CUSHION_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
        ,SUM(CASE WHEN MODEL_NAME_LKR = 'POWERBASE' THEN 1 ELSE 0 END) POWERBASE_FLG
        ,SUM(CASE WHEN MODEL_NAME_LKR = 'PLATFORM' THEN 1 ELSE 0 END) PLATFORM_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
        ,SUM(CASE WHEN PRODUCT_description_LKR like '%BLANKET%' THEN 1 ELSE 0 END) BLANKET_FLG
        ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'MATTRESS' THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
        ,sum(case when product_description_LKR like '%POWERBASE - SPLIT KING%' then 1 else 0 end) split_king
      from sales_order_line sol
      left join item on item.item_id = sol.item_id
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

  measure: base_orders {
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

  dimension: mattress_flg {
    group_label: "Orders has:"
    label: "a Mattress"
    description: "1/0; 1 if there is a mattress in this order"
    type:  number
    sql: ${TABLE}.mattress_flg ;; }

  dimension: cushion_flg {
    group_label: "Orders has:"
    label: "a Cushion"
    description: "1/0; 1 if there is a cushion in this order"
    type:  number
    sql: ${TABLE}.cushion_flg ;; }

  dimension: sheets_flg {
    group_label: "Orders has:"
    label: "Sheets"
    description: "1/0; 1 if there are sheets in this order"
    type:  number
    sql: ${TABLE}.sheets_flg ;; }

  dimension: protector_flg {
    group_label: "Orders has:"
    label: "a Mattress Protector"
    description: "1/0; 1 if there is a mattress protector in this order"
    type:  number
    sql: ${TABLE}.protector_flg ;; }

  dimension: base_flg {
    group_label: "Orders has:"
    label: "a Base"
    description: "1/0; 1 if there is a base in this order"
    type:  number
    sql: ${TABLE}.base_flg ;; }

  dimension: powerbase_flg {
    group_label: "Orders has:"
    label: "a Powerbase"
    description: "1/0; 1 if there is a powerbase in this order"
    type:  number
    sql: ${TABLE}.powerbase_flg ;; }

  dimension: platform_flg {
    group_label: "Orders has:"
    label: "a Platform Base"
    description: "1/0; 1 if there is a platform base in this order"
    type:  number
    sql: ${TABLE}.platform_flg ;; }

  dimension: pillow_flg {
    group_label: "Orders has:"
    label: "a Pillow"
    description: "1/0; 1 if there is a pillow in this order"
    type:  number
    sql: ${TABLE}.pillow_flg ;; }

  dimension: blanket_flg {
    group_label: "Orders has:"
    label: "a Blanket"
    description: "1/0; 1 if there is a blanket in this order"
    type:  number
    sql: ${TABLE}.blanket_flg ;; }

  dimension: split_flg {
    group_label: "Orders has:"
    label: "a Split King"
    description: "1/0; 1 if there is are multiple twin XL mattresses purchased in this order"
    type: yesno
    sql: ${TABLE}.sk_flg > 0 ;; }

  dimension: mm_orders_flg {
    group_label: "Orders has:"
    label: "Multiple Mattresses"
    description: "1/0; 1 if there is more than 1 mattress in the order"
    type:  number
    sql:  ${TABLE}.mm_flg ;; }

}
