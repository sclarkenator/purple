view: order_flag {

derived_table: {
  sql: SELECT ORDER_ID
            ,case when MATTRESS_FLG >0 then 1 else 0 end mattress_flg
            ,case when CUSHION_FLG >0 then 1 else 0 end cushion_flg
            ,case when SHEETS_FLG >0 then 1 else 0 end sheets_flg
            ,case when PROTECTOR_FLG >0 then 1 else 0 end protector_flg
            ,case when BASE_FLG >0 then 1 else 0 end base_flg
            ,case when POWERBASE_FLG >0 then 1 else 0 end powerbase_flg
            ,case when PLATFORM_FLG >0 then 1 else 0 end platform_flg
            ,case when PILLOW_FLG >0 then 1 else 0 end pillow_flg
            ,CASE WHEN MATTRESS_ORDERED > 1 THEN 1 ELSE 0 END MM_FLG
            ,case when split_king > 1 then 1 else 0 end sk_flg
      FROM(
          select order_id
                  ,sum(case when product_line_name_LKR = 'MATTRESS' THEN 1 ELSE 0 END) MATTRESS_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'CUSHION' THEN 1 ELSE 0 END) CUSHION_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'M.PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
                  ,SUM(CASE WHEN MODEL_NAME_LKR = 'POWERBASE' THEN 1 ELSE 0 END) POWERBASE_FLG
                  ,SUM(CASE WHEN MODEL_NAME_LKR = 'PLATFORM' THEN 1 ELSE 0 END) PLATFORM_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
                  ,SUM(CASE WHEN PRODUCT_LINE_NAME_LKR = 'MATTRESS' THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
                  ,sum(case when product_line_name_LKR = 'MATTRESS' and SIZE = 'TWIN XL' then ordered_qty else 0 end) split_king
          from sales_order_line sol
          left join item on item.item_id = sol.item_id
          GROUP BY 1) ;;
    }

  measure: mattress_orders {
    label: "Total orders w/ a mattress"
    description: "Flag if there was a mattress in the order"
    type:  sum
    sql:  ${TABLE}.mattress_flg ;;
  }

  measure: cushion_orders {
    label: "Total orders w/ a cushion"
    description: "Flag if there was a cushion in the order"
    type:  sum
    sql:  ${TABLE}.cushion_flg ;;
  }

  measure: sheets_orders {
    label: "Total orders w/ sheets"
    description: "Flag if there were sheets in the order"
    type:  sum
    sql:  ${TABLE}.sheets_flg ;;
  }

  measure: protector_orders {
    label: "Total orders w/ a mattress protector"
    description: "Flag if there was a mattress protector in the order"
    type:  sum
    sql:  ${TABLE}.protector_flg ;;
  }

  measure: pillow_orders {
    label: "Total orders w/ a pillow"
    description: "Flag of there was a pillow in the order"
    type:  sum
    sql:  ${TABLE}.pillow_flg ;;
  }

  measure: base_orders {
    label: "Total orders w/ a base"
    description: "Flag of there was a base in the order"
    type:  sum
    sql:  ${TABLE}.base_flg ;;
  }

  measure: powerbase_orders {
    label: "Total orders w/ a powerbase"
    description: "Flag of there was a powerbase in the order"
    type:  sum
    sql:  ${TABLE}.powerbase_flg ;;
  }

  measure: platform_orders {
    label: "Total orders w/ a platform base"
    description: "Flag of there was a platform base in the order"
    type:  sum
    sql:  ${TABLE}.platform_flg ;;
  }

  measure: mm_orders {
    label: "Total orders w/ multiple mattresses"
    description: "Flag of there was more than 1 mattress in the order"
    type:  sum
    sql:  ${TABLE}.mm_flg ;;
  }

  measure: split_king_orders {
    label: "Split king order?"
    description: "Were multiple twin XL mattresses purchased on this order"
    type: sum
    sql: ${TABLE}.sk_flg ;;
  }

  dimension: mattress_flg {
    label: "Mattress order"
    description: "Was there a mattress in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.mattress_flg ;;
  }

  dimension: cushion_flg {
    label: "Cushion order"
    description: "Was there a cushion in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.cushion_flg ;;
  }

  dimension: sheets_flg {
    label: "Sheets order"
    description: "Were there sheets in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.sheets_flg ;;
  }

  dimension: protector_flg {
    label: "Protector order"
    description: "Was there a mattress protector in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.protector_flg ;;
  }

  dimension: base_flg {
    label: "Base order"
    description: "Was there a base in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.base_flg ;;
  }

  dimension: powerbase_flg {
    label: "Powerbase order"
    description: "Was there a powerbase in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.powerbase_flg ;;
  }

  dimension: platform_flg {
    label: "Platform base order"
    description: "Was there a platform base in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.platform_flg ;;
  }

  dimension: pillow_flg {
    label: "Pillow order"
    description: "Was there a pillow in this order (1 = Yes)"
    type:  number
    sql: ${TABLE}.pillow_flg ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;;
  }

  dimension: split_flg {
    label: "Split king order?"
    description: "Were multiple twin XL mattresses purchased on this order"
    type: yesno
    sql: ${TABLE}.sk_flg > 0 ;;
  }

  dimension: mm_orders_flg {
    label: "Total orders w/ multiple mattresses"
    description: "Flag of there was more than 1 mattress in the order"
    type:  number
    sql:  ${TABLE}.mm_flg ;;
  }

}
