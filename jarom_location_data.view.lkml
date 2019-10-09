view: jarom_location_data {
  derived_table: {
    sql:with list_items as (
  select i.item_id,
         upper(i.sub_category_name),
         c.item_product_name,
         cast(c.weight as number(15,2)) as weight
  from analytics.sales.item i
          join analytics_stage.correction.skus_150lb c
                  on trim(i.sku_id) = trim(c.item_sku)
  group by 1,2,3,4
  order by 4 desc
)
select  coalesce(sl.city,'NA') as CITY,
        coalesce(sl.STATE,'NA') as STATE,
        coalesce(sl.zip,'NA') as ZIPCODE,
        coalesce(sl.COUNTRY,'NA') as COUNTRY,
        CASE
            when s.channel_id = 1 and upper(i.sub_category_name) = 'MATTRESS' then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as DTC_ALL_MATTRESS_UNITS,
        CASE
            when s.channel_id = 2 and upper(i.sub_category_name) = 'MATTRESS' then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as WHOLESALE_ALL_MATTRESS_UNITS,
       CASE
            when s.channel_id = 1 and to_number(coalesce(sk.weight,0)) <= 150 then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as DTC_UNITS_UNDER_150,
        CASE
            when s.channel_id = 2 and to_number(coalesce(sk.weight,0)) <= 150 then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as WHOLESALE_UNITS_UNDER_150,
       CASE
            when s.channel_id = 1 and to_number(coalesce(sk.weight,0)) >= 150 then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as DTC_UNITS_OVER_150,
        CASE
            when s.channel_id = 2 and to_number(coalesce(sk.weight,0)) >= 150 then  sum(coalesce(sl.ORDERED_QTY,0))
            else 0
       END as WHOLESALE_UNITS_OVER_150
from analytics.sales.sales_order s
            join analytics.sales.sales_order_line sl
                    on s.order_id = sl.order_id
                        and s.system = sl.system
            join analytics.sales.item i
                    on i.item_id = sl.item_id
            left join list_items sk
                    on sl.item_id = sk.item_id
where s.channel_id in (1,2)
    and to_date(s.created) >= current_date - 365
    and to_date(s.created) < current_date
    and upper(trim(i.sub_category_name)) in ('MATTRESS','BASE','POWERBASE')
group by 1,2,3,4,s.channel_id,sk.weight,i.sub_category_name
order by 1
 ;;
  }
  dimension:dtc_all_mattress_units   {
    type: number
    value_format: "0"
    sql: ${TABLE}.dtc_all_mattress_units;;  }

  dimension:wholesale_all_mattress_units   {
    type: number
    value_format: "0"
    sql: ${TABLE}.wholesale_all_mattress_units;;  }

  dimension:dtc_units_under_150   {
    type: number
    value_format: "0"
    sql: ${TABLE}.dtc_units_under_150  ;;  }

  dimension:wholesale_units_under_150  {
    type: number
    value_format: "0"
    sql: ${TABLE}.wholesale_units_under_150 ;;  }

  dimension:dtc_units_over_150   {
    type: number
    value_format: "0,\" K\""
    sql: ${TABLE}.dtc_units_over_150  ;;  }

  dimension:wholesale_units_over_150  {
    type: number
    value_format: "0"
    sql: ${TABLE}.wholesale_units_over_150 ;;  }

  dimension:wholesale_units  {
    type: number
    value_format: "0"
    sql: ${TABLE}.wholesale_units ;;  }

  dimension: zip {
    label: "Zip Codes"
    map_layer_name: us_zipcode_tabulation_areas
    type: string
    sql: ${TABLE}.ZIPCODE ;; }

  dimension: state {
    label: "States"
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.country ;; }
}
