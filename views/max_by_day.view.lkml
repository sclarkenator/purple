view: max_by_day {
  derived_table: {
    sql:
    select created::date as created
    , item_id
    , sum (ordered_qty) over (partition by created::date, item_id order by item_id) as max_units
from analytics.sales.sales_order_line
order by 1,2 ;;
  }

  dimension: created_date {
    hidden: no
    label: "Order Date"
    description: "Date and item was purchased"
    type: date
    sql: ${TABLE}.created ;;
  }

  dimension: item_id {
    hidden: no
    label: "Item ID"
    description: "Item SKU number in NS"
    type: number
    sql: ${TABLE}.item_id ;;
  }

  measure: max_units {
    label: "Max Units per Day"
    description: "The Max units by SKU by day"
    type: max
    sql: ${TABLE}.max_units ;;
  }
 }
