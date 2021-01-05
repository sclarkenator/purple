view: standard_cost {
  derived_table: {
    sql:
      select
    coalesce(b.item_id, a.item_id) as ac_item_id,
    a.item_id,
    max(standard_cost) as cost
from sales.item_standard_cost a
left join
    (select
    right(a.sku_id,11) as clean_sku_id,
    max(case when a.sku_id like 'AC-%' then a.item_id else null end) as ac_item_id,
    min(case when length(a.sku_id) = 11 then a.item_id else null end) as item_id
from sales.item a
group by 1) b on b.ac_item_id = a.item_id
group by 1,2 ;;
  }

  dimension: item_id {
    type:  string
    hidden:  yes
    sql:${TABLE}.item_id ;; }

  dimension: ac_item_id {
    primary_key: yes
    type:  string
    hidden:  yes
    sql:${TABLE}.ac_item_id ;; }

  dimension: standard_cost {
    hidden: no
    label: "Standard Cost"
    type:  number
    value_format: "$#,##0"
    sql:${TABLE}.cost ;; }

}
