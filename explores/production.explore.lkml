#-------------------------------------------------------------------
#
# Production Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: production_report {
    label: "iPad Production Data"
    group_label: "Production"
    description: "Connection to the iPad database owned by IT, Machine level production data is stored here"
  }

  explore: current_oee {
    hidden:  yes
    group_label: "Production"
    label: "Current OEE Table"
    description: "Automatic OEE Dataset in Snowflake"
    join: iPad_Machine_Table {
      sql_on: ${iPad_Machine_Table.machine_id} = ${current_oee.machine_id} ;;
      relationship: many_to_one
    }
  }

  explore: dispatch_info{
    hidden:  yes
    group_label: "Production"
    label: "L2L Dispatch Data"
    description: "The log of all L2L dispatches"
    join: ltol_line {
      type: left_outer
      sql_on: ${ltol_line.line_id} = ${dispatch_info.MACHINE_LINE_ID} ;;
      relationship: many_to_one
    }
  }

  explore: ltol_pitch {
    hidden: yes
    label: "L2L Production Pitch Data"
    group_label: "Production"
    description: "The Pitch hourly data from L2L"
    join: ltol_line {
      type: left_outer
      sql_on: ${ltol_line.line_id} = ${ltol_pitch.line} ;;
      relationship: many_to_one
    }
  }

  explore: assembly_build {
    hidden: no
    group_label: "Production"
    label: "Production Assembly Data"
    description: "NetSuite Header Level Assembly and Unbuild Data. Adding in the Unbuilds provides a better final number of what is produced."
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
      type: left_outer
    }
    join: production_goal_by_item {
      type: left_outer
      sql_on: ${assembly_build.item_id} = ${production_goal_by_item.item_id} and ${assembly_build.produced_date} = ${production_goal_by_item.forecast_date} ;;
      relationship: many_to_one
    }
  }

  explore: project_config {
    group_label: "Production"
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
    hidden: yes
    group_label: "Production"
    label: "Assembly Build Reconcilation"
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
    join: warehouse_location {
      sql_on: ${assembly_build.location_id} = ${warehouse_location.location_id} ;;
      relationship: many_to_one
      type: left_outer
    }
  }

  explore: warehouse_transfer {
    label: "Warehouse Transactions"
    group_label: "Production"
    description: "Transactions by warehousing for bin and inventory transfers"
    hidden: yes
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
    group_label: "Production"
    label: "Current Inventory"
    description: "Inventory positions, by item by location"
    always_filter: {
      filters: {field: warehouse_location.location_Active      value: "No"}
      filters: [item.sku_id: "-%AC-%"]
      }
    join: item {
      type: left_outer
      sql_on: ${inventory.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
    join: warehouse_location {
      sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
      relationship: many_to_one}
    join: mainfreight_inventory {
      type: left_outer
      sql_on: ${item.sku_id} = ${mainfreight_inventory.sku_id} ;;
      relationship: one_to_many
    }
  }

  explore: inventory_snap {
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
    join: standard_cost {
      view_label:  "Item"
      type: left_outer
      sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
      relationship: one_to_one}
    join: mainfreight_inventory_snapshot {
      type: left_outer
      sql_on: ${item.sku_id} = ${mainfreight_inventory_snapshot.sku_id} ;;
      relationship: one_to_many
    }
  }

  explore: mainfreight_inventory{
    hidden: yes
    group_label:"Production"
    label: "Mainfreight Inventory"
    always_filter: {
      filters: [item.sku_id: "-%AC-%"]}
    join: item {
      type: left_outer
      sql_on: ${mainfreight_inventory.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one}
    }

  explore: mainfreight_inventory_snapshot{
    hidden: yes
    group_label:"Production"
    label: "Historical Mainfreight Inventory"
    join: item {
      type: left_outer
      sql_on: ${mainfreight_inventory_snapshot.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one}
    }

  explore: production_goal {
    hidden: yes
    group_label: "Production"
    label: "Production Goals"
    description: "Production goals by forecast date, item, etc"
    join: production_goal_by_item {
      type: left_outer
      sql_on: ${production_goal.pk} = ${production_goal_by_item.forecast_date} ;;
      relationship: one_to_many}
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${production_goal_by_item.item_id} = ${item.item_id} and ${production_goal_by_item.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one }
  }

  explore: inventory_available_report {
    hidden: yes
    group_label: "Production"
    label: "Invnetory Available Report"
    description: "A Inventory Available Report created for Mike S./Andrew C."
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${inventory_available_report.sku_id} = ${item.sku_id} ;;
      relationship: many_to_one }
  }

  explore: inventory_adjustment {
    group_label: "Production"
    label: "Inventory Adjustment"
    description: "Inventory Adjustment by Item, Line, etc"
    join: inventory_adjustment_line {
      type: left_outer
      sql_on: ${inventory_adjustment.inventory_adjustment_id} = ${inventory_adjustment_line.inventory_adjustment_id} ;;
      relationship: one_to_many }
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on:  ${inventory_adjustment_line.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }
  }

  explore: bom_demand_matrix {
    hidden:  yes
    group_label: "Production"
    label: "Bom Demand Matrix"
    description: "Number of products we can currently build with remaining components/resources"
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${bom_demand_matrix.item_id} = ${item.item_id} ;;
      relationship: one_to_one
    }
  }

  explore: buildable_quantity {
    hidden: yes
    group_label: "Production"
    label: "Buildable Quantity"
    description: "Number of products we can currently build with remaining components/resources"
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${buildable_quantity.item_id} = ${item.item_id} ;;
      relationship: one_to_one
    }
    join: bom_demand_matrix {
      view_label: "Buildable Quantity"
      type: left_outer
      sql_on: ${buildable_quantity.item_id} = ${bom_demand_matrix.component_id} ;;
      relationship: one_to_one
    }
  }
  explore: v_demand_planning {
    hidden: yes
    group_label: "Production"
    view_label: "Demand Planning"
    label: "Demand Planning"
    description: ""
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${v_demand_planning.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }
    join: inventory {
      type: left_outer
      sql_on: ${v_demand_planning.item_id} = ${inventory.item_id} ;;
      relationship: many_to_one
    }
    join: warehouse_location {
      sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
      relationship: many_to_one
    }
  }

  explore: machine {
    hidden: yes
    group_label: "Production"
    join: l2l_machine_downtime {
      type: left_outer
      sql_on: ${machine.machine_id} = ${l2l_machine_downtime.machine_id} ;;
      relationship: one_to_many
    }
  }

  explore:  area {
    hidden: no
    group_label: "Production"
    label: "L2L"
    description: "A combination of reports pulled from L2L (Leading2Lean) including Machine Downtime, Dispatch, Pitch, etc."
    view_label: "Area"
    join: ltol_line {
      view_label: "Line"
      type: left_outer
      sql_on: ${area.site_id} = ${ltol_line.site} and ${area.area_id} = ${ltol_line.area} and ${area.name} = ${ltol_line.areacode} ;;
      relationship: one_to_many
    }
    join: machine {
      view_label: "Machine"
      type: left_outer
      sql_on:  ${ltol_line.site} = ${machine.site_id} and ${ltol_line.area} = ${machine.area_id} and ${ltol_line.line_id} = ${machine.line_id} ;;
      relationship: one_to_many
    }
    join: l2l_machine_downtime {
      view_label: "Machine"
      type: left_outer
      sql_on: ${machine.machine_id} = ${l2l_machine_downtime.machine_id} ;;
      relationship: one_to_many
    }
    join: machine_schedule {
      view_label: "Machine"
      type: left_outer
      sql_on: ${machine.machine_id} = ${machine_schedule.machine} and ${machine.site_id} = ${machine_schedule.site} ;;
      relationship: one_to_many
    }
    join: dispatch {
      view_label: "Dispatch"
      type: left_outer
      sql_on: ${machine.machine_id} = ${dispatch.machine_id} ;;
      relationship: one_to_many
    }
    join: dispatch_type {
      view_label: "Dispatch"
      type: left_outer
      sql_on: ${dispatch.dispatch_type_id} = ${dispatch_type.dispatch_type_id} ;;
      relationship: many_to_one
    }
    join: ltol_pitch {
      view_label: "Pitch"
      type: left_outer
      sql_on: ${ltol_line.site} = ${ltol_pitch.site} and ${ltol_line.area} = ${ltol_pitch.area} and ${ltol_line.line_id} = ${ltol_pitch.line} ;;
      relationship: one_to_many
    }
  }

  explore: v_dispatch {hidden: yes group_label: "Production" label: "L2L Dispatch Data" description: "The log of all L2L dispatches"}
  explore: oee {hidden:  yes group_label: "Production" label: "Historical OEE Table" description: "Static OEE Dataset in Snowflake"}
  explore: v_usertime_minutes {hidden: yes group_label: "Production" view_label: "Usertime" label: "Usertime" description: "Shows the amount of time and line an operator worked"}
  explore: jarom_location_data {hidden:  yes group_label: "Production"}
  explore: l2_l_checklist_answers {hidden: yes group_label: "L2L"}
  explore: l2_l_checklists {hidden: yes group_label: "L2L"}
  explore: l2l_qpc_mattress_audit {hidden: yes group_label: "L2L"}
  explore: l2l_quality_yellow_card {hidden: yes group_label: "L2L"}
  explore: l2l_shift_line_1_glue_process {hidden: yes group_label: "L2L"}
  explore: l2l_machine_downtime {hidden: yes group_label: "L2L"}
  explore: inventory_reconciliation { hidden: yes group_label: "Production"}
  explore: po_and_to_inbound {hidden: yes group_label: "Production"}
  explore: inventory_recon_sub_locations {hidden:yes group_label: "Production"}
  explore: change_mgmt {hidden:yes group_label: "Production"}
  explore: pilot_daily_report {hidden:yes group_label: "Production"}
  explore: v_fedex_to_xpo {hidden:  yes group_label: "Production"}
  explore: bin_location {hidden: yes group_label:"Production" label: "Highjump Bin Location"}
  explore: v_work_order_quality_checklist {hidden: yes group_label: "L2L"}
  explore: sfg_stock_level {hidden: yes label: "SFG Stock Level" group_label: "Production"}

  #  explore: fulfillment_snowflake{hidden:  yes from: fulfillment group_label: "Production"}
  # explore: mainchain_transaction_outwards_detail {hidden:yes
  #   join: sales_order{
  #     type: left_outer
  #     sql_on: ${sales_order.tranid} = ${mainchain_transaction_outwards_detail.tranid} ;;
  #     relationship: many_to_one}
  #   join: item {
  #     type: left_outer
  #     sql_on: ${item.sku_id} = ${mainchain_transaction_outwards_detail.sku_id} ;;
  #     relationship: one_to_many}
  #  join: sales_order_line {
  #    type: left_outer
  #    sql_on: ${item.item_id} = ${sales_order_line.item_id} and ${sales_order.order_id} = ${sales_order_line.order_id} and ${sales_order.system} = ${sales_order_line.system} ;;
  #    relationship:many_to_one}
  #  }
