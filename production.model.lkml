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


explore: oee {
  hidden:  yes
  label: "OEE Table"
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
