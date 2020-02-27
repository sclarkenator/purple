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
          else 'No Mattress Purchase' end as mattress_category
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
      ,max(case when product_line_name_LKR = 'MATTRESS' THEN 1 ELSE 0 END) MATTRESS_FLG
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'CUSHION' THEN 1 ELSE 0 END) CUSHION_FLG
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
      ,max(CASE WHEN MODEL_NAME_LKR = 'POWERBASE' THEN 1 ELSE 0 END) POWERBASE_FLG
      ,max(CASE WHEN MODEL_NAME_LKR = 'PLATFORM' THEN 1 ELSE 0 END) PLATFORM_FLG
      ,max(CASE WHEN PRODUCT_LINE_NAME_LKR = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
      ,max(CASE WHEN PRODUCT_description_LKR like '%BLANKET%' THEN 1 ELSE 0 END) BLANKET_FLG
      ,max(case when product_description_LKR like '%POWERBASE - SPLIT KING%' then 1 else 0 end) split_king
      ,max(case when sku_id in ('AC-10-31-12890','AC-10-31-12895','10-31-12890','10-31-12895') then 1 else 0 end) harmony
      ,max(case when sku_id in ('AC-10-31-12860','AC-10-31-12857','10-31-12860','10-31-12857') then 1 else 0 end) plush
      ,max(case when sku_id in ('AC-10-31-12854','AC-10-31-12855','10-31-12854','10-31-12855') then 1 else 0 end) purple_pillow
      ,max(case when sku_id in ('AC-10-21-68268','10-21-68268') then 1 else 0 end) gravity_mask
      ,max(case when sku_id in ('AC-10-38-13050') then 1 else 0 end) gravity_blanket
      ,max(case when sku_id in ('AC-10-38-45867','AC-10-38-45866','AC-10-38-45865','AC-10-38-45864','AC-10-38-45863','AC-10-38-45862','AC-10-38-45868','AC-10-38-45869','AC-10-38-45870','AC-10-38-45871','AC-10-38-45872','AC-10-38-45873',
                                '10-38-45867','10-38-45866','10-38-45865','10-38-45864','10-38-45863','10-38-45862','10-38-45868','10-38-45869','10-38-45870','10-38-45871','10-38-45872','10-38-45873') then 1 else 0 end) accordion_platform
      ,max(case when sku_id in ('AC-10-38-13015','AC-10-38-13010','AC-10-38-13005','AC-10-38-13030','AC-10-38-13025','AC-10-38-13020',
                                '10-38-13015','10-38-13010','10-38-13005','10-38-13030','10-38-13025','10-38-13020') then 1 else 0 end) duvet
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

}

dimension: mattress_flg {
  view_label: ""
  label: ""
  group_label: ""
  description: ""
  type: yesno
  sql: case when  ;;
}

dimension: first_mattress {

}

dimension: last_mattress {

}

dimension: prev_mattress {

}

dimension: later_mattress {

}

dimension: with_mattress {

}

dimension: mattress_category {

}

dimension: promo_id {

}

dimension: promo_name {

}

dimension: promo_desc {

}

dimension: promo_type {

}

measure: count {

}


















}
