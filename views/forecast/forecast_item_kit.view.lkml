## This is used to break our the kits FP&A are forecasting for.
view: forecast_item_kit {
  derived_table: {
    sql:
      with a as (
        select
           i.item_id as parent_kit_id,
           i.sku_id as parent_kit_sku_id,
           i.product_description,
           ic.item_id as child_id,
           ic.sku_id as child_sku_id,
           bom.quantity
        from analytics.sales.item i
         join analytics.production.build_of_materials bom on i.item_id = bom.component_id
         join analytics.sales.item ic on bom.child_id = ic.item_id
         join analytics.sales.item ip on bom.parent_id = ip.item_id
        where i.type = 'Kit/Package'
         and bom.component_id = bom.parent_id
         and ic.classification = 'FG'
        order by 1,2,3
       )
       select *
       from a
       where parent_kit_id in (select parent_kit_id from a group by 1 having count(*) = 1)
    ;;
  }

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.parent_kit_id||'-'||${TABLE}.child_id ;;
  }

  dimension: parent_kit_id {
    hidden: yes
    type: number
    sql: ${TABLE}.parent_kit_id ;;
  }

  dimension: parent_kit_sku_id {
    hidden: yes
    type: string
    sql: ${TABLE}.parent_kit_sku_id ;;
  }

  dimension: child_id {
    hidden: yes
    description: "Item ID that makes "
    type: number
    sql: ${TABLE}.child_id ;;
  }

  dimension: child_sku_id {
    hidden: yes
    description: "The total number of orders for each user"
    type: string
    sql: ${TABLE}.child_sku_id ;;
  }

  dimension: quantity {
    hidden: yes
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.quantity ;;
  }

  measure: qty {
    hidden: yes
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${quantity} ;;
  }

  measure: kit_qty {
    hidden: yes
    type: number
    sql: ${qty}*${sales_order_line.total_units} ;;
  }
}
