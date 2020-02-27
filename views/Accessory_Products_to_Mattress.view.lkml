view: accessory_products_to_mattress {

  derived_table: {
    sql: select a.created::date as order_date
    , to_char(a.created, 'YYYY-MM') as created_month
    , a.customer_id
    , a.system
    , a.channel_id
    , a.source
    , b.*
    , c.first_mattress
    , c.last_mattress
    , case when c.first_mattress < a.created then 1 else 0 end as prev_mattress
    , case when c.last_mattress > a.created then 1 else 0 end as later_mattress
    , case when b.mattress_flg = 1 then 1 else 0 end as with_mattress
    , case when b.mattress_flg = 1 then 'With Mattress'
          when c.first_mattress < a.created then 'Previous Mattress Purchase'
          when c.last_mattress > a.created then 'Later Mattress Purchase'
          else 'No Mattress Purchase' end as mattress_purchase_category
    , d.id as promo_id
    , d.name as promo_name
    , d.description as promo_desc
    , d.promo_type
  from (
    select s.order_id
        , s.customer_id
        , s.created
        , s.system
        , s.channel_id
        , s.source
        , s.status
    from sales.sales_order s
    left join sales.cancelled_order c on c.order_id = s.order_id and c.system = s.system
    left join sales.return_order r on r.order_id = s.order_id and r.system = s.system
    left join sales.warranty_order w on w.order_id = s.order_id and w.system = s.system
    where c.CANCELLED is null
        and r.created is null
        and w.created is null
        and s.created >= '2019-06-01'
  ) a
  left join (
    select sol.order_id
      ,max(case when product_line_name_LKR = 'MATTRESS' THEN 1 ELSE 0 END) mattress_flg
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'CUSHION' THEN 1 ELSE 0 END) cushion_flg
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'SHEETS' THEN 1 ELSE 0 END) sheets_flg
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PROTECTOR' THEN 1 ELSE 0 END) protector_flg
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'BASE' THEN 1 ELSE 0 END) base_flg
      ,max(CASE WHEN MODEL_NAME_LKR = 'POWERBASE' THEN 1 ELSE 0 END) powerbase_flg
      ,max(CASE WHEN MODEL_NAME_LKR = 'PLATFORM' THEN 1 ELSE 0 END) platform_flg
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PILLOW' THEN 1 ELSE 0 END) pillow_flg
      ,max(CASE WHEN PRODUCT_description_LKR like '%BLANKET%' THEN 1 ELSE 0 END) blanket_flg
      ,max(case when product_description_LKR like '%POWERBASE - SPLIT KING%' then 1 else 0 end) split_king_flg
      ,max(case when sku_id in ('AC-10-31-12890','AC-10-31-12895','10-31-12890','10-31-12895') then 1 else 0 end) harmony_pillow_flg
      ,max(case when sku_id in ('AC-10-31-12860','AC-10-31-12857','10-31-12860','10-31-12857') then 1 else 0 end) plush_pillow_flg
      ,max(case when sku_id in ('AC-10-31-12854','AC-10-31-12855','10-31-12854','10-31-12855') then 1 else 0 end) purple_pillow_flg
      ,max(case when sku_id in ('AC-10-21-68268','10-21-68268') then 1 else 0 end) gravity_mask_flg
      ,max(case when sku_id in ('AC-10-38-13050') then 1 else 0 end) gravity_blanket_flg
      ,max(case when sku_id in ('AC-10-38-45867','AC-10-38-45866','AC-10-38-45865','AC-10-38-45864','AC-10-38-45863','AC-10-38-45862','AC-10-38-45868','AC-10-38-45869','AC-10-38-45870','AC-10-38-45871','AC-10-38-45872','AC-10-38-45873',
                                '10-38-45867','10-38-45866','10-38-45865','10-38-45864','10-38-45863','10-38-45862','10-38-45868','10-38-45869','10-38-45870','10-38-45871','10-38-45872','10-38-45873') then 1 else 0 end) accordion_platform_flg
      ,max(case when sku_id in ('AC-10-38-13015','AC-10-38-13010','AC-10-38-13005','AC-10-38-13030','AC-10-38-13025','AC-10-38-13020',
                                '10-38-13015','10-38-13010','10-38-13005','10-38-13030','10-38-13025','10-38-13020') then 1 else 0 end) duvet_flg
    from sales.sales_order_line sol
    left join sales.item on item.item_id = sol.item_id
    group by 1
  ) b on b.order_id = a.order_id
  left join (
    select so.customer_id
        , min (s.created) first_mattress
        , max (s.created) last_mattress
    from sales.sales_order_line s
    left join sales.sales_order so on so.order_id = s.order_id
    left join sales.item i on i.item_id = s.item_id
    where i.product_line_name_LKR = 'MATTRESS'
    group by 1
  ) c on c.customer_id = a.customer_id
  left join (
    select
        wd.date,
        listagg(p.id, ', ') as id,
        listagg(p.name, ', ') as name,
        listagg(p.description, '; ') as description,
        listagg(p."TYPE", ', ') as promo_type
    from analytics.util.warehouse_date wd
    inner join analytics.marketing.promotion p on p."START" <= wd.date AND p."END" >= wd.date
    group by 1
    order by wd.date
  ) d on d.date = a.created::date ;;
  }

dimension: order_date {
  label: "Order Date"
  description: "Customer Order Date"
  type: date
  sql: ${TABLE}.order_date ;;
}

dimension: mattress_flg {
  label: "a Mattress"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a mattress in this order"
  type: yesno
  sql: case when ${TABLE}.mattress_flg = 1 ;;
}

dimension: cushion_flg {
  label: "a Cushion"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a cushion in this order"
  type: yesno
   sql: case when ${TABLE}.cushion_flg = 1 ;;
}

dimension: sheets_flg {
  label: "Sheets"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a sheets in this order"
  type: yesno
  sql: case when ${TABLE}.sheets_flg = 1 ;;
}

dimension: protector_flg {
  label: "a Protector"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a protector in this order"
  type: yesno
  sql: case when ${TABLE}.protector_flg = 1 ;;
}

dimension: base_flg {
  label: "a Base"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a base in this order"
  type: yesno
  sql: case when ${TABLE}.base_flg = 1 ;;
}

dimension: powerbase_flg {
  label: "a Powerbase"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a powerbase in this order"
  type: yesno
  sql: case when ${TABLE}.powerbase_flg = 1 ;;
}

dimension: platform_flg {
  label: "a Platform"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a platform in this order"
  type: yesno
  sql: case when ${TABLE}.platform_flg = 1 ;;
}

dimension: pillow_flg {
  label: "a Pillow"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a pillow in this order"
  type: yesno
  sql: case when ${TABLE}.pillow_flg = 1 ;;
}

dimension: blanket_flg {
  label: "a Blanket"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a blanket in this order"
  type: yesno
  sql: case when ${TABLE}.blanket_flg = 1 ;;
}

dimension: split_king_flg {
  label: "a Split King Powerbase"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a split king powerbase in this order"
  type: yesno
  sql: case when ${TABLE}.split_king_flg = 1 ;;
}

dimension: harmony_pillow_flg {
  label: "a Harmony Pillow"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a harmony pillow in this order"
  type: yesno
  sql: case when ${TABLE}.harmony_pillow_flg = 1 ;;
}

dimension: plush_pillow_flg {
  label: "a Cushion"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a plush pillow in this order"
  type: yesno
  sql: case when ${TABLE}.plush_pillow_flg = 1 ;;
}

dimension: purple_pillow_flg {
  label: "a Purple Pillow"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a purple pillow in this order"
  type: yesno
  sql: case when ${TABLE}.purple_pillow_flg = 1 ;;
}

dimension: gravity_mask_flg {
  label: "a Gravity Mask"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a gravity mask in this order"
  type: yesno
  sql: case when ${TABLE}.gravity_mask_flg = 1 ;;
}

dimension: gravity_blanket_flg {
  label: "a Gravity Blanket"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a gravity blanket in this order"
  type: yesno
  sql: case when ${TABLE}.gravity_blanket_flg = 1 ;;
}

dimension: accordion_platform_flg {
  label: "a Accordion Platform"
  view_label: ""
  group_label: "Order has:"
  description: "1/0; 1 if there is a accordion platform in this order"
  type: yesno
  sql: case when ${TABLE}.accordion_platform_flg = 1 ;;
}

dimension: duvet_flg {
  label: "a Duvet"
  group_label: "Order has:"
  description: "1/0; 1 if there is a duvet in this order"
  type: yesno
  sql: case when ${TABLE}.duvet_flg = 1 ;;
}

dimension: first_mattress {
  label: "First Mattress"
  view_label: ""
  group_label: "Mattress Purchase Date"
  description: "First mattress purchase date"
  type: date
  sql: ${TABLE}.first_mattress ;;
}

dimension: last_mattress {
  label: "Lst Mattress"
  group_label: "Mattress Purchase Date"
  description: "Last mattress purchase date"
  type: date
  sql: ${TABLE}.last_mattress ;;
}

dimension: prev_mattress {
  label: "Previoulsy"
  group_label: "Mattress Purchased:"
  description: "Customers purchasesed a mattress previously"
  hidden: yes
  type: yesno
  sql: ${TABLE}.prev_mattress = 1 ;;
}

dimension: later_mattress {
  label: "Later"
  group_label: "Mattress Purchased:"
  description: "Customers purchasesed a mattress later"
  hidden: yes
  type: yesno
  sql: ${TABLE}.later_mattress = 1 ;;
}

dimension: with_mattress {
  label: "With"
  group_label: "Mattress Purchased:"
  description: "Customers purchasesed with a mattress"
  hidden: yes
  type: yesno
  sql: ${TABLE}.with_mattress = 1 ;;
}

dimension: mattress_purchase_category {
  label: "Mattress Purchase Category"
  description: "Customers who purchase a mattress (Previously, With, Later)"
  type: string
  sql: ${TABLE}.mattress_purchase_category ;;
}

dimension: promo_id {
  label: "Promotion ID"
  group_label: "Promotion Info"
  description: "Promotion ID"
  type: string
  sql: ${TABLE}.promo_id ;;
}

dimension: promo_name {
  label: "Promotion Name"
  group_label: "Promotion Info"
  description: "Promotion name"
  type: string
  sql: ${TABLE}.promo_name ;;
}

dimension: promo_desc {
  label: "Promotion Description"
  group_label: "Promotion Info"
  description: "Promotion description"
  type: string
  sql: ${TABLE}.promo_desc ;;
}

dimension: promo_type {
  label: "Promotion Type"
  group_label: "Promotion Info"
  description: "Type of promotion (free, percentage, etc.)  "
  type: string
  sql: ${TABLE}.promo_type ;;
}

measure: count {
  view_label: "Measures"
  type: count
}


















}
