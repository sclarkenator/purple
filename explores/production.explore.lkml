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

  # explore: dispatch_info{
  #   #hidden:  yes
  #   group_label: "Production"
  #   label: "L2L Dispatch Data"
  #   description: "The log of all L2L dispatches"
  #   join: ltol_line {
  #     type: left_outer
  #     sql_on: ${ltol_line.line_id} = ${dispatch_info.MACHINE_LINE_ID} ;;
  #     relationship: many_to_one
  #   }
  # }

  # explore: ltol_pitch {
  #   hidden: yes
  #   label: "L2L Production Pitch Data"
  #   group_label: "Production"
  #   description: "The Pitch hourly data from L2L"
  #   join: ltol_line {
  #     type: left_outer
  #     sql_on: ${ltol_line.line_id} = ${ltol_pitch.line} ;;
  #     relationship: many_to_one
  #   }
  # }

  # explore: assembly_build {
  #   hidden: no
  #   group_label: "Production"
  #   label: "Production Assembly Data"
  #   description: "NetSuite Header Level Assembly and Unbuild Data. Adding in the Unbuilds provides a better final number of what is produced."
  #   always_filter: {
  #     filters: {
  #       field: scrap
  #       value: "0"
  #     }
  #     filters: {
  #       field: item.merchandise
  #       value: "0"
  #     }
  #   }
  #   join: item {
  #     type: left_outer
  #     sql_on: ${assembly_build.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: warehouse_location {
  #     sql_on: ${assembly_build.location_id} = ${warehouse_location.location_id} ;;
  #     relationship: many_to_one
  #     type: left_outer
  #   }
  #   join: production_goal {
  #     type: left_outer
  #     sql_on: ${assembly_build.produced_date} = ${production_goal.forecast_date} ;;
  #     relationship: many_to_one
  #   }
  #   join: production_goal_by_item {
  #     type: left_outer
  #     sql_on: ${production_goal.pk} = ${production_goal_by_item.forecast_date} ;;
  #     relationship: one_to_many
  #   }
  # }

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
    hidden: yes
    label: "Current Inventory"
    description: "Inventory positions, by item by location"
    always_filter: {
      filters: {field: warehouse_location.location_Active      value: "No"}
      filters: [item.sku_id: "-%AC-%"]
      filters: [warehouse_location.warehouse_bucket: "Purple, White Glove"]}
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
      relationship: one_to_many}
    join: standard_cost {
      view_label: "Item"
      type: left_outer
      sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
      relationship: one_to_one}
    join: bin_location {
      type: left_outer
      view_label: "Inventory"
      fields: [bin_location.quantity]
      sql_on: ${bin_location.warehouse_id} = ${warehouse_location.location_id} and ${bin_location.sku} = ${item.sku_id};;
      relationship:many_to_many}

 ##   join: derived_inventory {
##      type: left_outer
##      sql_on: ${derived_inventory.location_id} = ${inventory.location_id} and ${derived_inventory.item_id} = ${inventory.item_id} ;;
##      relationship: one_to_one
##    }

  }


  # explore: inventory_snap {
  #   group_label: "Production"
  #   hidden: yes
  #   label: "Historical Inventory"
  #   description: "Inventory positions, by item by location over time"
  #   always_filter: {
  #     filters: {field: warehouse_location.location_Active      value: "No"}
  #     filters: [warehouse_location.warehouse_bucket: "Purple, White Glove"]}
  #   join: item {
  #     type: left_outer
  #     sql_on: ${inventory_snap.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one}
  #   join: warehouse_location {
  #     sql_on: ${inventory_snap.location_id} = ${warehouse_location.location_id} ;;
  #     relationship: many_to_one}
  #   join: standard_cost {
  #     view_label:  "Item"
  #     type: left_outer
  #     sql_on: ${standard_cost.item_id} = ${item.item_id} or ${standard_cost.ac_item_id} = ${item.item_id};;
  #     relationship: one_to_one}
  #   join: mainfreight_inventory_snapshot {
  #     type: left_outer
  #     sql_on: ${item.sku_id} = ${mainfreight_inventory_snapshot.sku_id} ;;
  #     relationship: one_to_many}
  # }

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

  # explore: inventory_adjustment {
  #   group_label: "Production"
  #   hidden: yes
  #   label: "Inventory Adjustment"
  #   description: "Inventory Adjustment by Item, Line, etc"
  #   join: inventory_adjustment_line {
  #     type: left_outer
  #     sql_on: ${inventory_adjustment.inventory_adjustment_id} = ${inventory_adjustment_line.inventory_adjustment_id} ;;
  #     relationship: one_to_many }
  #   join: item {
  #     view_label: "Product"
  #     type: left_outer
  #     sql_on:  ${inventory_adjustment_line.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one
  #   }
  # }

  # explore: bom_demand_matrix {
  #   hidden:  yes
  #   group_label: "Production"
  #   label: "Bom Demand Matrix"
  #   description: "Number of products we can currently build with remaining components/resources"
  #   join: item {
  #     view_label: "Product"
  #     type: left_outer
  #     sql_on: ${bom_demand_matrix.item_id} = ${item.item_id} ;;
  #     relationship: one_to_one
  #   }
  # }

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
  # explore: v_demand_planning {
  #   hidden: yes
  #   group_label: "Production"
  #   view_label: "Demand Planning"
  #   label: "Demand Planning"
  #   description: ""
  #   join: item {
  #     view_label: "Product"
  #     type: left_outer
  #     sql_on: ${v_demand_planning.item_id} = ${item.item_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: inventory {
  #     type: left_outer
  #     sql_on: ${v_demand_planning.item_id} = ${inventory.item_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: warehouse_location {
  #     sql_on: ${inventory.location_id} = ${warehouse_location.location_id} ;;
  #     relationship: many_to_one
  #   }
  # }

  # explore: machine {
  #   hidden: yes
  #   group_label: "Production"
  #   join: l2l_machine_downtime {
  #     type: left_outer
  #     sql_on: ${machine.machine_id} = ${l2l_machine_downtime.machine_id} ;;
  #     relationship: one_to_many
  #   }
  # }

  # explore:  area {
  #   #hidden: yes
  #   group_label: "Production"
  #   label: "L2L"
  #   description: "A combination of reports pulled from L2L (Leading2Lean) including Machine Downtime, Dispatch, Pitch, etc."
  #   view_label: "Area"
  #   join: ltol_line {
  #     view_label: "Line"
  #     type: left_outer
  #     sql_on: ${area.site_id} = ${ltol_line.site} and ${area.area_id} = ${ltol_line.area} and ${area.name} = ${ltol_line.areacode} ;;
  #     relationship: one_to_many
  #   }
  #   join: machine {
  #     view_label: "Machine"
  #     type: left_outer
  #     sql_on:  ${ltol_line.site} = ${machine.site_id} and ${ltol_line.area} = ${machine.area_id} and ${ltol_line.line_id} = ${machine.line_id} ;;
  #     relationship: one_to_many
  #   }
  #   join: l2l_machine_downtime {
  #     view_label: "Machine"
  #     type: left_outer
  #     sql_on: ${machine.machine_id} = ${l2l_machine_downtime.machine_id};;
  #     relationship: one_to_many
  #   }
  #   join: machine_schedule {
  #     view_label: "Machine"
  #     type: left_outer
  #     sql_on: ${machine.machine_id} = ${machine_schedule.machine} and ${machine.site_id} = ${machine_schedule.site} ;;
  #     relationship: one_to_many
  #   }
  #   join: dispatch {
  #     view_label: "Dispatch"
  #     type: left_outer
  #     sql_on: ${machine.machine_id} = ${dispatch.machine_id} ;;
  #     relationship: one_to_many
  #   }
  #   join: dispatch_type {
  #     view_label: "Dispatch"
  #     type: left_outer
  #     sql_on: ${dispatch.dispatch_type_id} = ${dispatch_type.dispatch_type_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: ltol_pitch {
  #     view_label: "Pitch"
  #     type: left_outer
  #     sql_on: ${ltol_line.site} = ${ltol_pitch.site} and ${ltol_line.area} = ${ltol_pitch.area} and ${ltol_line.line_id} = ${ltol_pitch.line} ;;
  #     relationship: one_to_many
  #   }
  #   join: scrap_detail {
  #     view_label: "Pitch"
  #     type: left_outer
  #     sql_on: ${ltol_pitch.pitch_id} = ${scrap_detail.pitch} ;;
  #     relationship: one_to_many
  #   }
  #   join: scrap_category {
  #     view_label: "Pitch"
  #     type: left_outer
  #     sql_on: ${scrap_detail.category} = ${scrap_category.id} ;;
  #     relationship: one_to_one
  #   }
  #   join: product {
  #     view_label: "Pitch"
  #     type: left_outer
  #     sql_on: ${ltol_pitch.actual_product} = ${product.product_id};;
  #     relationship: one_to_many
  #   }
  #   ##join: v_dispatch_with_downtime_minutes {
  #     ##view_label: "Dispatch by Date"
  #     ##type: left_outer
  #     ##sql_on: ${dispatch.dispatch_id} = ${v_dispatch_with_downtime_minutes.dispatch_id} ;;
  #     ##relationship: one_to_many
  #   ##}
  #   join: reason {
  #     view_label: "Dispatch"
  #     type: left_outer
  #     sql_on: ${dispatch.reason_code} = ${reason.code} and ${machine.site_id} = ${reason.site};;
  #     relationship: one_to_many
  #   }
  #   join: dispatch_technician {
  #     view_label: "Dispatch"
  #     type: left_outer
  #     sql_on: ${dispatch.dispatch_id} = ${dispatch_technician.dispatch_id} and ${dispatch.dispatch_number} = ${dispatch_technician.dispatch_number} ;;
  #     relationship: one_to_many
  #   }
  #   join: resource_shift {
  #     view_label: "Shift"
  #     type: left_outer
  #     sql_on: ${ltol_pitch.shift} = ${resource_shift.id} and ${ltol_pitch.site} = ${resource_shift.site} ;;
  #     relationship: one_to_one
  #   }
  # }

  explore: bill_of_materials {
    hidden: yes
    join: bill_of_materials_p {
      from: bill_of_materials
      type: left_outer
      relationship: one_to_one
      sql_on: ${bill_of_materials_p.child_id} = ${bill_of_materials.parent_id} and ${bill_of_materials.component_id} = ${bill_of_materials_p.component_id} ;;
      view_label: "Parent Item Quantity"
    }
    join: p_item {
      from: item
      view_label: "Parent Item"
      type: left_outer
      relationship: many_to_one
      sql_on: ${bill_of_materials.parent_id} = ${p_item.item_id} ;;
    }
    join: c_item {
      from: item
      view_label: "Child Item"
      relationship: many_to_one
      sql_on: ${bill_of_materials.child_id} = ${c_item.item_id} ;;
    }
    join: com_item {
      from: item
      view_label: "Component Item"
      relationship: many_to_one
      sql_on: ${bill_of_materials.component_id} = ${com_item.item_id} ;;
    }
  }


  explore: expeditors { hidden: yes
    join:item {
      type: left_outer
      relationship: many_to_one
      sql_on: ${expeditors.item_number} = ${item.sku_id} ;;
    }
  }
  explore: v_dispatch {hidden: yes group_label: "Production" label: "L2L Dispatch Data" description: "The log of all L2L dispatches"}
  explore: oee {hidden:  yes group_label: "Production" label: "Historical OEE Table" description: "Static OEE Dataset in Snowflake"}
  explore: v_usertime_minutes {hidden: yes group_label: "Production" view_label: "Usertime" label: "Usertime" description: "Shows the amount of time and line an operator worked"}
  explore: jarom_location_data {hidden:  yes group_label: "Production"}
  explore: inventory_reconciliation { hidden: yes group_label: "Production"}
  explore: po_and_to_inbound {hidden: yes group_label: "Production"}
  explore: inventory_recon_sub_locations {hidden:yes group_label: "Production"}
  explore: change_mgmt {hidden:yes group_label: "Production"}
  explore: pilot_daily_report {hidden:yes group_label: "Production"}
  explore: v_fedex_to_xpo {hidden:  yes group_label: "Production"}
  explore: v_work_order_quality_checklist {hidden: yes group_label: "L2L"}
  ##explore: desired_stock_level {hidden: yes label: "Peak Bed Desired Stock Level" group_label: "Production"}
  explore: vendor {hidden:yes}
  explore: l2_l_checklist_answers {hidden: yes group_label: "L2L"}
  explore: l2_l_checklists {hidden: yes group_label: "L2L"}
  explore: l2l_qpc_mattress_audit {hidden: yes group_label: "L2L"}
  explore: l2l_quality_yellow_card {hidden: yes group_label: "L2L"}
  explore: l2l_shift_line_1_glue_process {hidden: yes group_label: "L2L"}
  explore: l2l_machine_downtime {hidden: yes group_label: "L2L"}
  explore: v_quality_mrb_cores_final_disposition {hidden: yes label: "Quality MRB Cores Final Disposition" group_label: "L2L"}
  explore: v_quality_mrb_rework_finished_bed {hidden: yes label: "Quality MRB Rework Finished Bed" group_label: "L2L"}
  explore: v_quality_mrb_cover {hidden: yes label: "Quality MRB Cover" group_label: "L2L"}
  explore: v_quality_mrb_return_bed_qc {hidden: yes label: "Quality MRB Return Bed QC" group_label: "L2L"}
  explore: v_incoming_inspection_form {hidden: yes label: "Incoming Inspection Form" group_label: "L2L"}
  explore: v_quality_mrb_core_stock_check {hidden: yes label: "Quality MRB Core Stock Check" group_label: "L2L"}
  explore: v_refurb_pillows_wm {hidden: yes label:"Refurb Pillows WM" group_label: "L2L"}
  explore: v_waste_management_waste_recycling {hidden:yes label:"Waste Management Waste/Recycling" group_label:"L2L"}
  explore: incoming_inspection_form {
    from:  date_meta
    group_label: "L2L Inspection Form"
    label: "Incoming Inspection Form"
    view_label: "Inspection Date"
    hidden: yes
    join: incoming_inspection_form_cores {
      type: left_outer
      sql_on: ${incoming_inspection_form.date} = ${incoming_inspection_form_cores.inspection_date} ;;
      relationship: one_to_one
    }
    join: incoming_inspection_form_covers {
      type: left_outer
      sql_on: ${incoming_inspection_form.date} = ${incoming_inspection_form_covers.inspection_date} ;;
      relationship: one_to_one
    }
    join: incoming_inspection_form_rails {
      type: left_outer
      sql_on: ${incoming_inspection_form.date} = ${incoming_inspection_form_rails.inspection_date} ;;
      relationship: one_to_one
    }
    join: incoming_inspection_form_other {
      type: left_outer
      sql_on: ${incoming_inspection_form.date} = ${incoming_inspection_form_other.inspection_date} ;;
      relationship: one_to_one
    }
  }

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
