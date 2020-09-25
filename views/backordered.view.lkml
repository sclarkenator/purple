view: back_ordered {
  derived_table: {
    sql:
      with a as (
          Select item_ID,order_ID,Sum(quantity) as fulfilled_qty
          From ANALYTICS.SALES.FULFILLMENT
          where (fulfilled <= {% parameter back_ordered.date_filter %})
          group by 1,2
      ), c as (
          Select item_ID,order_ID,min(cancelled) as cancelled
          From ANALYTICS.SALES.CANCELLED_ORDER
          group by 1,2
      )
      Select so.tranid,SKU_ID, PRODUCT_DESCRIPTION, SOURCE, sol.ORDERED_QTY, coalesce (a.fulfilled_qty,0)as Fulfulled_Qty,so.created,
      case when it.model = 'KIDS BED' or it.model = 'HYBRID 2' or it.model = 'HYBRID 2H'
              or it.model = 'THE PURPLE MATTRESS' or it.model = 'ORIGINAL PURPLE MATTRESS' or it.model = 'THE PURPLE MATTRESS W/ OG COVER'
              or it.model = 'PURPLE PLUS'  or it.model = 'LIFELINE MATTRESS' then '2"'
            when it.model = 'HYBRID PREMIER 3' or it.model = 'REST MATTRESS' then '3"'
            when it.model = 'HYBRID PREMIER 4' then '4"'
            else NULL end as Grid_height
      From ANALYTICS.SALES.SALES_ORDER_LINE as sol
            left join ANALYTICS.SALES.SALES_ORDER as so on sol.order_id=so.order_id
            left join ANALYTICS.SALES.ITEM as it on it.item_id=sol.item_id
            left join c on sol.order_id=c.order_id and sol.item_id=c.item_ID
            left join a on sol.order_id=a.order_id and sol.item_id=a.item_ID
      where CATEGORY_NAME = 'MATTRESS' and CLASSIFICATION_NEW = 'FG'
          and coalesce(so.SHIP_BY,sol.created) <= {% parameter back_ordered.date_filter %} and c.cancelled is null
          and so.transaction_type != 'Cash Sale' and so.source not in ('Amazon-FBA-US','Amazon-FBA-CA','Shopify - Canada')
          AND so.CREATED > '2019-12-31' and sol.ORDERED_QTY != coalesce (a.fulfilled_qty,0)
      ;;
  }

  parameter: date_filter {
    type: date
  }

  dimension_group: created {
    label: "    Order"
    description:  "Time and date order was placed. Source: netsuite.sales_order_line"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: tranid {
    label: "Transaction ID"
    description: "Netsuite's Sale Order Number. Source: netsuite.sales_order"
    type: string
    sql: ${TABLE}.TRANID ;;
  }

  dimension: sku_id {
    label: "SKU ID"
    description: "SKU ID for item (XX-XX-XXXXXX). Source: netsuite.item"
    type: string
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: product_description_raw {
    label: "Product Description"
    description: "Product Description. Source:netsuite.item"
    sql: ${TABLE}.product_description ;;
  }

  dimension: source {
    label:  "Order Source"
    description: "System where order was placed. Source: netsuite.sales_order"
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: grid_height {
    label: "Grid Height"
    description: "Source: Looker calculation"
    sql: ${TABLE}.Grid_height ;;
  }

  measure: total_units {
    label:  "Gross Sales (units)"
    description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
    type: sum
    sql:  ${TABLE}.ordered_qty ;;
  }

  measure: Fulfulled_Qty {
    label: "Units Fulfilled"
    description: "Count of items fulfilled. Source:netsuite.fulfillment"
    type: sum
    sql:  ${TABLE}.Fulfulled_Qty ;;
  }
}
