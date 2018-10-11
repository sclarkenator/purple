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

explore: retail_stores {
  hidden:  yes
  label: "list of retail outlets as of Nov 1, 2018"
}

explore: agg_check {
  hidden: yes
  label: "data accuracy"
}

explore: cac {
  group_label: "Marketing analytics"
  hidden: yes
  label: "CAC"
}

explore: attribution {
  hidden: yes
  label: "HEAP attribution"
  group_label: "Marketing analytics"
}

explore: progressive {
  label: "Progressive"
  group_label: "x - Accounting"
  description: "Progressive lease information."
}

explore: hotjar_data {
  hidden:  no
  group_label: "Marketing analytics"
  label: "Hotjar survey results"
  description: "Results form Hotjar post-purchase survey"

  join: hotjar_whenheard {
    type:  left_outer
    sql_on: ${hotjar_data.token} = ${hotjar_whenheard.token} ;;
    relationship: many_to_one
  }

  join: shopify_orders {
    type: inner
    sql_on: ${hotjar_data.token} = ${shopify_orders.checkout_token} ;;
    relationship: many_to_one
  }

  join: sales_order {
    type:  left_outer
    sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
    relationship: one_to_one
  }

  join: order_flag {
    type: left_outer
    sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
    relationship:  one_to_one
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
  group_label: "Marketing analytics"
  label: "Adspend"
  description: "Daily adspend details, including channel, clicks, impressions, spend, device, platform, etc."
}

explore: refund {
  group_label: "x - Accounting"
  label: "Accounting Refunds"
  description: "Refunds on sales at an order level, for accounting."
}

explore: inventory {
  group_label: "Operations"
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
  hidden:  yes
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
    filters: {
      field: item.merchandise
      value: "0"
    }
    filters: {
      field: item.finished_good_flg
      value: "1"
    }
    filters: {
      field: item.modified
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

  join: fulfillment {
    view_label: "Fulfillment details"
    type: left_outer
    sql_on: ${sales_order_line.item_order} = ${fulfillment.item_id}||'-'||${fulfillment.order_id}||'-'||${fulfillment.system} ;;
    relationship: many_to_many
  }

  join: sales_order {
    view_label: "Order-level info"
    type: left_outer
    sql_on: ${sales_order_line.order_system} = ${sales_order.order_system} ;;
    relationship: many_to_one
  }

  join: shopify_orders {
    view_label: "Sales info"
    type:  left_outer
    fields: [shopify_orders.call_in_order_Flag]
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

#  join: dtc_fulfill_sla {
#    view_label: "SLA achievement"
#    type: left_outer
#    sql_on: ${sales_order.order_id} = ${dtc_fulfill_sla.order_id} ;;
#    relationship: one_to_one
#  }
}

### replicates DTC explore, with filters for wholesale
  explore: wholesale {
    from: sales_order_line
    group_label: "Wholesale"
    label:  "Wholesale"
    description:  "All sales orders for wholesale channel"
    always_filter: {
      filters: {
        field: sales_order.channel_id
        value: "2"
      }
      filters: {
        field: item.merchandise
        value: "0"
      }
      filters: {
        field: item.finished_good_flg
        value: "1"
      }
      filters: {
        field: item.modified
        value: "1"
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
  group_label: "Wholesale"

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

explore: orphaned_shopify_warranties {
  group_label: "x - Accounting"
  label: "Orphaned Warranties"
  description: "Current warranty information for orphaned NetSuite warranty orders (i.e. warranty replacement orders placed in Shopify for orders that don't exist in NetSuite)"
}

explore: netsuite_warranty_exceptions {
  group_label: "x - Accounting"
  label: "Warranty ModCode Cleanup"
  description: "Provides a list of suspected warranty orders in NetSuite with incorrect references to the original order and/or that are missing a modification code"
}

explore: item {
  label: "Transfer and Purchase Orders"
  group_label: "Operations"
  description: "Netsuite data on Transfer and purchase orders"

  join: purchase_order_line {
    view_label: "Purchase Order"
    type:  full_outer
    sql_on: ${purchase_order_line.item_id} = ${item.item_id} ;;
    relationship: one_to_many
  }

  join: purchase_order {
    view_label: "Purchase Order"
    type:  left_outer
    required_joins: [purchase_order_line]
    sql_on: ${purchase_order.purchase_order_id} = ${purchase_order_line.purchase_order_id} ;;
    relationship: many_to_one
  }

  join: transfer_order_line {
    view_label: "Transfer Order"
    type:  full_outer
    sql_on: ${transfer_order_line.item_id} = ${item.item_id} ;;
    relationship: one_to_many
  }

  join: transfer_order {
    view_label: "Transfer Order"
    type:  left_outer
    required_joins: [transfer_order_line]
    sql_on: ${transfer_order.transfer_order_id} = ${transfer_order_line.transfer_order_id} ;;
    relationship: many_to_one
  }
join: Receiving_Location{
  from:warehouse_location
    type:  left_outer
    sql_on: ${transfer_order.receiving_location_id} = ${Receiving_Location.location_id} or ${purchase_order.location_id} = ${Receiving_Location.location_id};;
    relationship: many_to_one
  }
  join: Transfer_Fulfilling_Location{
    from:warehouse_location
    type:  left_outer
    sql_on: ${transfer_order.shipping_location_id} = ${Transfer_Fulfilling_Location.location_id} ;;
    relationship: many_to_one
  }
  join: vendor {
    type:  left_outer
    sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;;
    relationship: many_to_one
  }
}
