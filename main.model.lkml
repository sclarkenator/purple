connection: "analytics_warehouse"

# include all the views
include: "*.view"

# include all the dashboards
#include: "*.dashboard"

datagroup: gross_to_net_sales_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: gross_to_net_sales_default_datagroup

week_start_day: sunday

explore: hotjar_data {
  hidden:  yes
  label: "Hotjar survey results"
  description: "Results form Hotjar post-purchase survey"

  join: sales_order {
    type:  left_outer
    sql_on: ${hotjar_data.related_tranid} = ${sales_order.related_tranid} ;;
    relationship: many_to_one
  }
}

explore: shopify_orders {
  hidden:  yes
  label: "Shopify sales simple"
  description: "Shopify header level information"
}

explore: orphan_orders {
  hidden:  yes
  label: "Orphan orders"
  description: "Orders that exist in Shopify that aren't yet in Netsuite"
}

explore: daily_adspend {
  label: "Adspend"
  description: "Daily adspend details, including channel, clicks, impressions, spend, device, platform, etc."
}

explore: refund {
  label: "Accounting Refunds"
  description: "Refunds on sales at an order level, for accounting."
}

explore: inventory {
  label: "Inventory"
  description: "Inventory positions, by item by location"

  join: item {
    type: left_outer
    sql_on: ${inventory.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }

  join: warehouse_location {
    sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one
  }

  join: stock_level {
    type: full_outer
    sql_on: ${inventory.item_id} = ${stock_level.item_id} and ${inventory.location_id} = ${stock_level.location_id} ;;
    relationship: many_to_one
  }
}

explore: sales_targets {
  hidden:  no
  label: "Finance targets"
  description: "Monthly finance targets, spread by day"
}

#explore: daily_summary {
#  label: "Daily net cash report"
#  description: "This aggregates net cash position for the day"
#}

explore: sales_order_line {
  label:  "DTC sales"
  description:  "All sales orders for all channels"
  always_filter: {
    filters: {
      field: sales_order.channel_id
      value: "1"
    }
  }

  join: sf_zipcode_facts {
    view_label: "Customer info"
    type:  left_outer
    sql_on: ${sales_order_line.zip} = ${sf_zipcode_facts.zipcode} ;;
    relationship: many_to_one
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
    sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
    relationship: many_to_one
  }

  join: shopify_orders {
    view_label: "Shopify-RAW"
    type:  left_outer
    sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    relationship:  one_to_one
  }

  join: return_order_line {
    view_label: "Returns info"
    type: full_outer
    sql_on: ${sales_order_line.item_order} = ${return_order_line.item_order} ;;
    relationship: one_to_many
  }

  join: return_order {
    view_label: "Returns info"
    type: full_outer
    required_joins: [return_order_line]
    sql_on: ${return_order_line.return_order_id} = ${return_order.return_order_id} ;;
    relationship: many_to_one
      }

  join: return_reason {
    view_label: "Returns info"
    type: full_outer
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
    sql_on: ${sales_order_line.item_order} = ${retroactive_discount.item_order_refund} ;;
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

  join: dtc_fulfill_sla {
    view_label: "SLA achievement"
    type: left_outer
    sql_on: ${sales_order.order_id} = ${dtc_fulfill_sla.order_id} ;;
    relationship: one_to_one
  }
}

### replicates DTC explore, with filters for wholesale
  explore: wholesale {
    from: sales_order_line
    label:  "Wholesale"
    description:  "All sales orders for wholesale channel"
    always_filter: {
      filters: {
        field: sales_order.channel_id
        value: "2"
      }
    }

    join: sf_zipcode_facts {
      view_label: "Customer info"
      type:  left_outer
      sql_on: ${wholesale.zip} = ${sf_zipcode_facts.zipcode} ;;
      relationship: many_to_one
    }

    join: item {
      view_label: "Product info"
      type: left_outer
      sql_on: ${wholesale.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }

    join: sales_order {
      view_label: "Order-level info"
      type: left_outer
      sql_on: ${wholesale.order_system} = ${sales_order.order_system} ;;
      relationship: many_to_one
    }

    join: return_order_line {
      view_label: "Returns info"
      type: left_outer
      sql_on: ${wholesale.item_order} = ${return_order_line.item_order} ;;
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
      sql_on: ${wholesale.item_order_refund} = ${retroactive_discount.item_order_refund} ;;
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
      sql_on: ${wholesale.item_order} = ${cancelled_order.item_order} ;;
      relationship: one_to_many
    }

    join: NETSUITE_cancelled_reason {
      view_label: "Cancelled orders"
      type: left_outer
      sql_on: ${NETSUITE_cancelled_reason.list_id} = ${cancelled_order.shopify_cancel_reason_id} ;;
      relationship: many_to_one
    }

  }

explore: Mattress_Firm {
  from: mattress_firm_store_details

  join: mattress_firm_sales {
    type: left_outer
    sql_on:   ${Mattress_Firm.store_id} = ${mattress_firm_sales.store_id} and ${mattress_firm_sales.finalized_date_date} is not null ;;
    relationship: one_to_many
  }

  join: mattress_firm_item {
    type:  left_outer
    sql_on: ${mattress_firm_item.mf_sku} = ${mattress_firm_sales.mf_sku} ;;
    relationship:  many_to_one
  }

  join: mattress_firm_master_store_list {
    type:  full_outer
    sql_on: ${Mattress_Firm.store_id} = ${mattress_firm_master_store_list.store_id} ;;
    relationship:  one_to_one
  }

  join: item {
    type:  left_outer
    sql_on: ${mattress_firm_item.item_id} = ${item.item_id} ;;
    relationship:  many_to_one
  }
}

explore: warranty {
  from: warranty_order
  description: "Current warranty information (not tied back to original sales orders yet)"

  join: warranty_reason {
    type: left_outer
    sql_on: ${warranty.warranty_reason_code_id} = ${warranty_reason.list_id} ;;
    relationship: many_to_one
  }

  join: warranty_order_line {
    type:  left_outer
    sql_on: ${warranty.warranty_order_id} = ${warranty_order_line.warranty_order_id};;
    relationship: one_to_many
  }

  join: item {
    type:  left_outer
    sql_on: ${warranty_order_line.item_id} = ${item.item_id} ;;
    relationship: many_to_one
  }
}
