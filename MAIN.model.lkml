connection: "analytics_warehouse"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: gross_to_net_sales_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: gross_to_net_sales_default_datagroup

week_start_day: sunday

explore: sales_order_line {
  label:  "Sales"
  description:  "All sales orders for all channels"
  always_filter: {
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
  }

  join: item {
    view_label: "Product info"
    type: left_outer
    sql_on: ${sales_order_line.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }

  join: sales_order {
    view_label: "Order-level info"
    type: left_outer
    sql_on: ${sales_order_line.order_id} = ${sales_order.order_id} ;;
    relationship: many_to_one
  }

  join: return_order_line {
    view_label: "Returns info"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${return_order_line.item_order} ;;
    relationship: one_to_many
  }

  join: return_order {
    view_label: "Returns info"
    type: left_outer
    required_joins: [return_order_line]
    sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
    relationship: many_to_one
      }

  join: return_reason {
    view_label: "Returns info"
    type: left_outer
    sql_on: ${return_reason.list_id} = ${return_order.return_reason_id} ;;
    relationship: many_to_one
  }

  join: customer_table {
    view_label: "Customer info"
    type: left_outer
    sql_on: ${customer_table.customer_id} = ${sales_order.customer_id} ;;
    relationship: many_to_one
  }

  join: retroactive_discount {
    view_label: "Retro discounts"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${retroactive_discount.item_order} ;;
    relationship: one_to_many
  }

  join: discount_code {
    view_label: "Retro discounts"
    type:  left_outer
    sql_on: ${retroactive_discount.discount_code_id} = ${discount_code.discount_code_id} ;;
    relationship: many_to_one
  }

  join: cancelled_order {
    view_label: "Cancelled orders"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${cancelled_order.item_order} ;;
    relationship: one_to_many
  }

  join: NETSUITE_cancelled_reason {
    view_label: "Cancelled orders"
    type: left_outer
    sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.shopify_cancel_reason_id} ;;
    relationship: many_to_one
  }

  join: order_flag {
    view_label: "Summary details"
    type: left_outer
    sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
    relationship: one_to_one
  }


}
