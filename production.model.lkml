
# include all the views
connection: "analytics_warehouse"

include: "*.view"
#include: "main.model.lkml"

# include all the dashboards
#include: "*.dashboard"

datagroup: temp_ipad_database_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: temp_ipad_database_default_datagroup

week_start_day: sunday

explore: production_report {
  label: "iPad Production Data"
  description: "Connection to the iPad database owned by IT, Machine level production data is stored here"
}

explore: current_oee {
  hidden:  yes
  label: "Current OEE Table"
  description: "Automatic OEE Dataset in Snowflake"

  join: iPad_Machine_Table {
    sql_on: ${iPad_Machine_Table.machine_id} = ${current_oee.machine_id} ;;
    relationship: many_to_one
  }
}


explore: oee {
  hidden:  yes
  label: "Historical OEE Table"
  description: "Static OEE Dataset in Snowflake"
}

explore: dispatch_info{
  hidden:  no
  group_label: "Production"
  label: "L2L Dispatch Data"
  description: "The log of all L2L dispatches"
}


explore: assembly_build {
  hidden: no
  label: "Production Assembly Data"
  description: "NetSuite Header Level Assembly Data"


  always_filter: {
    filters: {
      field: scrap
      value: "0"
    }
    filters: {
      field: item.merchandise
      value: "0"
    }
    }

   join: item {
    type: left_outer
    sql_on: ${assembly_build.item_id} = ${item.item_id} ;;
    relationship: many_to_one
    }

  join: warehouse_location {
    sql_on: ${assembly_build.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one
  }

}

explore: max_machine_capacity {
  hidden: yes
  label: "Max Machine Capacity"
  description: "Total capacity of Max machines by day and machine. Sourced from Engineering based on ideal cycle times"
}

explore: project_config {
  label: "Engineering Projects"
  description: "Status of engineering projects"
  hidden: yes

  join: project_report {
    type: inner
    relationship: one_to_many
    sql_on: ${project_config.project_id} = ${project_report.project_id} ;;
  }
}
explore: workorder_reconciliation {
  label: "Assembly Build Reconcilation"
  hidden: yes
  description: "NetSuite Assembly Build consumed parts checked against the ideal consumption"

  join: item {
    type: left_outer
    view_label: "Part Item Information"
    relationship: many_to_one
    sql_on: ${workorder_reconciliation.part_item_id} = ${item.item_id} ;;
  }

  join: assembly_build {
    type: left_outer
    relationship: many_to_one
    sql_on: ${workorder_reconciliation.assembly_build_id} = ${assembly_build.assembly_build_id} ;;
  }


  }
explore: warehouse_transfer {
  label: "Warehouse Transactions"
    description: "Transactions by warehousing for bin and inventory transfers"

  join: warehouse_transfer_line {
    type: inner
    relationship: one_to_many
    sql_on: ${warehouse_transfer.warehouse_transfer_id} = ${warehouse_transfer_line.warehouse_transfer_id} ;;
  }

  join: warehouse_location {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer.SHIPPING_LOCATION_ID} = ${warehouse_location.location_id} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer_line.item_id} = ${item.item_id} ;;
  }
}

explore: inventory {
  #-------------------------------------------------------------------
  #  Invetory--------------------
  #       \           \          \
  #      Item      Warehouse     Stock
  #                 Locatoin     Level
  #-------------------------------------------------------------------
  group_label: "Production"
  label: "Current Inventory"
  description: "Inventory positions, by item by location"
  always_filter: {
    filters: {field: warehouse_location.location_Active      value: "No"}}
  join: item {
    type: left_outer
    sql_on: ${inventory.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: warehouse_location {
    sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one}
}

explore: inventory_snap {
  #-------------------------------------------------------------------
  #  Invetory Snaphot-----------------------
  #               \             \            \
  #              Item        Warehouse      Stock
  #                           Location      Level
  #-------------------------------------------------------------------
  group_label: "Production"
  label: "Historical Inventory"
  description: "Inventory positions, by item by location over time"
  always_filter: {
    filters: {field: warehouse_location.location_Active      value: "No"}}
  join: item {
    type: left_outer
    sql_on: ${inventory_snap.item_id} = ${item.item_id} ;;
    relationship: many_to_one}
  join: warehouse_location {
    sql_on: ${inventory_snap.location_id} = ${warehouse_location.location_id} ;;
    relationship: many_to_one}
}



    explore: purcahse_and_transfer_ids {
      #-------------------------------------------------------------------
      #                     transfers-----purchases
      #                        /            \      \
      #                   order_line    purchase    vendor
      #                 /      /    \      line
      #                /      /      \     /   \
      #       receiving  fulfilling   items    bills
      #        location    location
      #-------------------------------------------------------------------
      label: "Transfer and Purchase Orders"
      group_label: "Operations"
      description: "Netsuite data on Transfer and purchase orders"
      hidden: no
      join: purchase_order {
        view_label: "Purchase Order"
        type: left_outer
        sql_on: ${purchase_order.purchase_order_id} = ${purcahse_and_transfer_ids.id} ;;
        relationship: one_to_one}
      join: purchase_order_line {
        view_label: "Purchase Order"
        type: left_outer
        sql_on: ${purchase_order.purchase_order_id} = ${purchase_order_line.purchase_order_id} ;;
        relationship: one_to_many}
      join: bills {
        view_label: "Bills"
        type:  left_outer
        sql_on: ${purchase_order.purchase_order_id} = ${bills.purchase_order_id} ;;
        relationship: one_to_many}
      join: transfer_order {
        view_label: "Transfer Order"
        type:  left_outer
        sql_on: ${transfer_order.transfer_order_id} = ${purcahse_and_transfer_ids.id} ;;
        relationship: one_to_one}
      join: transfer_order_line {
        view_label: "Transfer Order"
        type:  full_outer
        sql_on: ${transfer_order_line.transfer_order_id} = ${transfer_order.transfer_order_id} ;;
        relationship: one_to_many}
      join: Receiving_Location{
        from:warehouse_location
        type:  left_outer
        sql_on:  ${Receiving_Location.location_id} = coalesce(${transfer_order.receiving_location_id},${purchase_order.location_id}) ;;
        relationship: many_to_one}
      join: Transfer_Fulfilling_Location{
        from:warehouse_location
        type:  left_outer
        sql_on: ${transfer_order.shipping_location_id} = ${Transfer_Fulfilling_Location.location_id} ;;
        relationship: many_to_one}
      join: item {
        view_label: "Item"
        type:  left_outer
        sql_on: ${item.item_id} = coalesce(${purchase_order_line.item_id},${transfer_order_line.item_id});;
        relationship: many_to_one}
      join: vendor {
        type:  left_outer
        sql_on: ${purchase_order.entity_id} = ${vendor.vendor_id} ;;
        relationship: many_to_one}}
