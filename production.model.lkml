connection: "analytics_warehouse"

# include all the views

include: "*.view"

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
  hidden:  no
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

explore: assembly_build {
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

  join: project_report {
    type: inner
    relationship: one_to_many
    sql_on: ${project_config.project_id} = ${project_report.project_id} ;;
  }
}

explore: warehouse_transfer {
  label: "Wharehouse Transactions"
  description: "Transactions by warehousing for bin and inventory transfers"

  join: warehouse_transfer_line {
    type: inner
    relationship: one_to_many
    sql_on: ${warehouse_transfer.warehouse_transfer_id} = ${warehouse_transfer_line.warehouse_transfer_id} ;;
  }

  join: warehouse_location {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer.location_id} = ${warehouse_location.location_id} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${warehouse_transfer_line.item_id} = ${item.item_id} ;;
  }
}
