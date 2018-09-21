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

explore: production_report {}


explore: oee {
  label: "OEE Table"
  description: "Static OEE Dataset in Snowflake"
}

explore: assembly_build {
  label: "Production Assembly Data"
  description: "Main line assembly information"


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
