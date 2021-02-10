view: email_order_flag {

  derived_table: {
    sql:

    --flag per category level (5 measures and 5 dimensions)
    --min and max date (2 dimensions)
    --if they have ever purchased (yes/no) (1 dimension and 1 measure)
    --does it make sense to keep measures at the category level?
    -- always group by email


    SELECT email
      ,case when MATTRESS_FLG > 0 then 1 else 0 end mattress_flg
      ,case when BEDDING_FLG > 0 then 1 else 0 end bedding_flg
      ,case when BASE_FLG > 0 then 1 else 0 end base_flg
      ,case when CUSHION_FLG > 0 then 1 else 0 end cushion_flg
    -- Room Set Completion
--      ,case when MATTRESS_FLG + SHEETS_FLG + PROTECTOR_FLG + BASE_FLG + PILLOW_FLG > 0 then MATTRESS_FLG + SHEETS_FLG + PROTECTOR_FLG + BASE_FLG + PILLOW_FLG else 0 end room_set

    -- For flagging an order based on UPT --
     ,case when total_orders > 0 then total_orders else 0 end total_order
     ,case when orders_in_past_6_months > 1 then orders_in_past_6_months else 0 end orders_in_past_6_month
     ,recent_order_date
     ,total_orders
     ,orders_in_past_6_months

    FROM(
      select LOWER(email) email
        ,sum(case when (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') THEN 1 ELSE 0 END) MATTRESS_FLG
        ,SUM(CASE WHEN category = 'BEDDING' THEN 1 ELSE 0 END) BEDDING_FLG
        ,SUM(CASE WHEN category = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
        ,SUM(CASE WHEN category = 'SEATING' THEN 1 ELSE 0 END) CUSHION_FLG
        ,SUM(CASE WHEN (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
        ,SUM(CASE WHEN category = 'BEDDING' THEN ORDERED_QTY ELSE 0 END) BEDDING_ORDERED
        ,SUM(CASE WHEN category = 'BASE' THEN ORDERED_QTY ELSE 0 END) BASE_ORDERED
        ,SUM(CASE WHEN category = 'SEATING' THEN ORDERED_QTY ELSE 0 END) SEATING_ORDERED
        ,MAX(s.CREATED) RECENT_ORDER_DATE

    -- For flagging an order based on orders --
      , COUNT(DISTINCT s.order_id) total_orders
      , COUNT(DISTINCT CASE WHEN s.CREATED > CURRENT_DATE - 183 THEN s.ORDER_ID ELSE 0 END) orders_in_past_6_months

      from analytics.sales.sales_order_line sol
      left join analytics.sales.item on item.item_id = sol.item_id
      left join analytics.sales.sales_order s on s.order_id = sol.order_id and s.system = sol.system
      GROUP BY 1
)


 ;;

    }

    dimension: email {
      primary_key: yes
      hidden: yes
      type:  number
      sql: ${TABLE}.email ;; }

    measure: mattress_orders {
      group_label: "Total Orders with:"
      label: "a Mattress"
      description: "1/0 per order; 1 if there was a mattress in the order. Source:looker.calculation"
      drill_fields: [sales_order_line.sales_order_details*]
      type:  sum
      sql:  ${TABLE}.mattress_flg ;; }

    measure: cushion_orders {
      group_label: "Total Orders with:"
      label: "a Cushion - Any"
      description: "1/0 per order; 1 if there was a cushion in the order. Source:looker.calculation"
      drill_fields: [sales_order_line.sales_order_details*]
      type:  sum
      sql:  ${TABLE}.cushion_flg ;; }

    measure: base_orders {
      hidden:  no
      group_label: "Total Orders with:"
      label: "a Base"
      description: "1/0 per order; 1 if there was a base in the order. Source:looker.calculation"
      drill_fields: [sales_order_line.sales_order_details*]
      type:  sum
      sql:  ${TABLE}.base_flg ;; }

  measure: total_orders {
    label: "Total Orders"
    description: "Totale orders for customer."
    type:  sum
    sql:  ${TABLE}.total_orders ;; }

  measure: total_orders_past_6_months {
    label: "Total Orders in past 6 months"
    description: "Totale orders for customer in past 6 months."
    type:  sum
    sql:  ${TABLE}.orders_in_past_6_months ;; }

    dimension: mattress_flg {
      group_label: "    * Customer has ordered:"
      label: "a Mattress"
      description: "1/0; 1 if customer has ordered a mattress. Source:looker.calculation"
      type:  yesno
      sql: ${TABLE}.mattress_flg = 1 ;; }

    dimension: cushion_flg {
      group_label: "    * Customer has ordered:"
      label: "a Cushion - Any"
      description: "1/0; 1 if there is a cushion in this order. Source:looker.calculation"
      type:  yesno
      sql: ${TABLE}.cushion_flg = 1 ;; }

    dimension: base_flg {
      hidden: no
      group_label: "    * Customer has ordered:"
      label: "a Base"
      description: "1/0; 1 if there is a base in this order. Source:looker.calculation"
      type:  yesno
      sql: ${TABLE}.base_flg = 1 ;; }

  dimension: bedding_flg {
    hidden: no
    group_label: "    * Customer has ordered:"
    label: "bedding"
    description: "1/0; 1 if there is bedding in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.bedding_flg = 1 ;; }


    dimension: mattress_count {
      group_label: " Advanced"
      description: "Number of mattresses in the order. Source: looker.calculation"
      type: number
      sql: ${TABLE}.mattress_ordered ;;
    }
  }
