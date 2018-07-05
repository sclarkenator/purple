connection: "analytics_warehouse"

# include all the views

include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: temp_ipad_database_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: temp_ipad_database_default_datagroup

explore: production_report {}
